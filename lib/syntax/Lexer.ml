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

module Chars = Char.Ascii
module Input = LexerInput
module Table = Map.Make(String)

type t = Input.t
  [@@deriving eq, show { with_path = false }]

let keywords : (Token.meta -> Token.t) Table.t =
  Table.empty
let symbols : (Token.meta -> Token.t) Table.t =
  Table.empty

let make = Input.make

let scan_space s =
  let s' = Input.skip_while Chars.is_blank s in
  let m = Input.meta_of s s' in
  s', Some (Token.Space m)

let scan_comment s =
  let s' = Input.skip_while (( <> ) '\n') s in
  let m = Input.meta_of s s' in
  s', Some (Token.Comment m)

let scan_int s =
  let s' = Input.skip_while Chars.is_digit s in
  let m = Input.meta_of s s' in
  let v = Input.string_of s s' |> int_of_string in
  s', Some (Token.Int (m, v))

let scan_kw_or_id s =
  let s' = Input.skip_while Chars.is_alphanum s in
  let m = Input.meta_of s s' in
  let v = Input.string_of s s' in
  match Table.find_opt v keywords with
  | Some kwd -> s', Some (kwd m)
  | None -> s', Some (Token.Id (m, v))

let rec scan_symbols max_size s =
  let s' = Input.skip max_size s in
  let m = Input.meta_of s s' in
  let v = Input.string_of s s' in
  match Table.find_opt v symbols with
  | Some sym -> s', Some (sym m)
  | None when max_size = 1 -> s', None
  | None -> scan_symbols (max_size - 1) s

let scan_next s =
  match Input.first s with
  | None -> s, Some (Token.Eof (Input.meta_of s s))
  | Some c when Chars.is_digit c -> scan_int s
  | Some c when Chars.is_letter c -> scan_kw_or_id s
  | Some c when Chars.is_blank c -> scan_space s
  | Some '/' when Input.peek 1 s = Some '/' -> scan_comment s
  | _ -> scan_symbols 3 s

