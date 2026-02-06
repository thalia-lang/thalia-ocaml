(* Copyright (c) 2025 Stan Vlad <vstan02@protonmail.com>
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

module Base = struct
  type state = {
    input : string;
    offset : int;
    line : int;
    column : int
  }
end

include Base
include Automata.Make(Base)

type report = Unknown_char of char
type 'a result = ('a, report * Span.t) Result.t

let span s s' =
  Span.make
    (Location.make s.offset s.line s.column)
    (Location.make s'.offset s'.line s'.column)

let token s s' v = (v, span s s')

let is_empty s =
  s.offset >= String.length s.input

let rest s =
  match s.offset with
  | i when i >= String.length s.input -> s
  | i when s.input.[i] = '\n' ->
    { s with offset = s.offset + 1; line = s.line + 1; column = 1 }
  | _ ->
    { s with offset = s.offset + 1; column = s.column + 1 }

let rec advance s = function
  | 0 -> s
  | sz -> advance (rest s) (sz - 1)

let take size =
  let* state = get in
  let size' = min size ((String.length state.input) - state.offset) in
  let value = String.sub state.input state.offset size' in
  let+ _ = put (advance state size') in
  Result.pure value

let take_while pred =
  let rec aux s = function
    | i when i >= String.length s -> i
    | i when not (pred s.[i]) -> i
    | i -> aux s (i + 1)
  in
  let* state = get in
  let size = (aux state.input state.offset) - state.offset in
  let value = String.sub state.input state.offset size in
  let+ _ = put (advance state size) in
  Result.pure value

let is_digit = function
  | '0' .. '9' -> true
  | _ -> false

let is_alpha = function
  | 'a' .. 'z' | 'A' .. 'Z' | '_' -> true
  | _ -> false

let is_alnum c = (is_digit c) || (is_alpha c)

let scan_number =
  let* state = get in
  let* value = take_while is_digit in
  let+ state' = get in
  Result.map value (token state state')

let scan_kw_id =
  let* state = get in
  let* value = take_while is_alnum in
  let+ state' = get in
  Result.map value (token state state')

