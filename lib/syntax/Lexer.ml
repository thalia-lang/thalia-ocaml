(* Copyright (c) 2026 Stan Vlad <vstan02@protonmail.com>
 *
 * This file is part of Thalia.
 *
 * Thalia is free software: you can redistribute it and/or modify
 * it under the terms of the gnu general public license as published by
 * the free software foundation, either version 3 of the license, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but without any warranty; without even the implied warranty of
 * merchantability or fitness for a particular purpose. see the
 * gnu general public license for more details.
 *
 * You should have received a copy of the gnu general public license
 * along with this program. if not, see <https://www.gnu.org/licenses/>.
 *)

module Ascii = Char.Ascii

module Error = struct
  type t =
    | Unexpected_char of char * Span.t
    | Unterminated_comment of Span.t
    [@@deriving eq, show { with_path = false }]

  let report_of = function
    | Unexpected_char (c, span) ->
        Report.error
          (Printf.sprintf "unexpected character '%c'" c) span
    | Unterminated_comment span ->
        Report.error "unterminated block comment" span
end

module State = struct
  type item = char
  type t = {
    input : string;
    location : Location.t
  } [@@deriving eq, show { with_path = false }]

  let make input =
    { input; location = Location.default }

  let span_of s s' =
    Span.make s.location s'.location

  let first { input; location } =
    let index = Location.offset location in
    if index >= String.length input
      then None else Some input.[index]

  let rest s =
    match first s with
    | None -> s
    | Some c ->
      { s with
        location = Location.next ~is_eol:(c == '\n') s.location }
end

include Scanner.Make (Error) (State)

let scan_blank =
  let* s = get in
  let+ s' = skip_while Ascii.is_blank in
  Trivia.Blank, State.span_of s s'

let scan_comment =
  let* s = get in
  let+ s' = skip_while ((<>) '\n') in
  Trivia.Comment, State.span_of s s'

let rec scan_trivias acc =
  let* c = peek 0 in
  let* c' = peek 1 in
  match c with
  | Some c when Ascii.is_white c ->
    scan_blank >>=
      (fun t -> scan_trivias (t :: acc))
  | Some '/' when c' = Some '/' ->
    scan_comment >>=
      (fun t -> scan_trivias (t :: acc))
  | _ -> pure acc

let scan_id =
  let* s = get in
  let+ s' = skip_while ((==) '_') in
  Token.ISnake, State.span_of s s'
