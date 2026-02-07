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

type state = {
  input : string;
  offset : int;
  line : int;
  column : int;
} [@@deriving show]

module Automaton_base = struct
  type symbol = char
  type input = state

  let peek n { input; offset; _ } =
    if offset + n >= String.length input
      then None
      else Some (String.get input (offset + n))

  let advance s =
    match peek 0 s with
    | None -> s
    | Some c when Char.is_eol c ->
      { s with offset = s.offset + 1; column = s.column + 1 }
    | _ ->
      { s with offset = s.offset + 1; line = s.line + 1; column = 1 }
end
include Automaton.Make(Automaton_base)

module Map = Map.Make(String)

let keyword_tokens : (Span.t -> Token.t) Map.t
  = Map.of_list []

let base_tokens = Map.of_list [
  "-", (fun s -> Token.Minus s);
  "+", (fun s -> Token.Plus s);
  "/", (fun s -> Token.Div s);
  "*", (fun s -> Token.Mul s);
  "%", (fun s -> Token.Mod s);
  "<", (fun s -> Token.Less s);
  "<=", (fun s -> Token.Less_equ s);
  ">", (fun s -> Token.Grt s);
  ">=", (fun s -> Token.Grt_equ s);
  "==", (fun s -> Token.Equ s);
  "!=", (fun s -> Token.Not_equ s);
  ">>", (fun s -> Token.Rshift s);
  "<<", (fun s -> Token.Lshift s);
  "&&", (fun s -> Token.Log_and s);
  "||", (fun s -> Token.Log_or s);
  "~", (fun s -> Token.Bit_not s);
  "&", (fun s -> Token.Bit_and s);
  "|", (fun s -> Token.Bit_or s);
  "^", (fun s -> Token.Bit_xor s);
  "=", (fun s -> Token.Assign s);
  "-=", (fun s -> Token.Assign_sub s);
  "+=", (fun s -> Token.Assign_add s);
  "*=", (fun s -> Token.Assign_mul s);
  "/=", (fun s -> Token.Assign_div s);
  "%=", (fun s -> Token.Assign_mod s);
  "&=", (fun s -> Token.Assign_and s);
  "|=", (fun s -> Token.Assign_or s);
  "^=", (fun s -> Token.Assign_xor s);
  "<<=", (fun s -> Token.Assign_lsh s);
  ">>=", (fun s -> Token.Assign_rsh s);
  "(", (fun s -> Token.Lparen s);
  ")", (fun s -> Token.Rparen s);
  "{", (fun s -> Token.Lbrace s);
  "}", (fun s -> Token.Rbrace s);
  "[", (fun s -> Token.Lbracket s);
  "]", (fun s -> Token.Rbracket s);
  ",", (fun s -> Token.Comma s);
  ";", (fun s -> Token.Semi s);
  ":", (fun s -> Token.Colon s);
]

let make src = {
  input = src;
  offset = 0;
  line = 1;
  column = 1;
}

let span s1 s2 =
  Span.make
    (Location.make s1.offset s1.line s1.column)
    (Location.make s2.offset s2.line s2.column)

let value s1 s2 =
  String.sub s1.input s1.offset (s2.offset - s1.offset)

let scan_space s =
  let s' = skip_while Char.is_whitespace s in
  s', Token.Space (span s s')

let scan_comment s =
  let pred c = not (Char.is_eol c) in
  let s' = skip_while pred s in
  s', Token.Comment (span s s')

let scan_int s =
  let s' = skip_while Char.is_digit s in
  let v = value s s' in
  s', Token.Int ((span s s'), Int64.of_string v)

let scan_id s =
  let s' = skip_while Char.is_digit s in
  let v = value s s' in
  match Map.find_opt v keyword_tokens with
  | Some f -> s', f (span s s')
  | None -> s', Token.Id ((span s s'), v)

let rec scan_base max_size s =
  let s' = skip max_size s in
  let v = value s s' in
  match Map.find_opt v base_tokens with
  | Some f -> s', f (span s s')
  | None when max_size = 1 -> s', Token.Unknown (span s s')
  | None -> scan_base (max_size - 1) s

let scan_next s =
  match first s with
  | None -> s, Token.Eof (span s s)
  | Some c when Char.is_digit c -> scan_int s
  | Some c when Char.is_alpha c -> scan_id s
  | Some c when Char.is_whitespace c -> scan_space s
  | Some '/' when peek 1 s = Some '/' -> scan_comment s
  | _ -> scan_base 3 s

let scan pred src =
  let cons acc t =
    if pred t then t :: acc else acc
  in
  let rec aux acc s =
    let s', t = scan_next s in
    match first s with
    | None -> List.rev (cons acc t)
    | _ -> aux (cons acc t) s'
  in
  aux [] (make src)

let scan_all = scan (fun _ -> true)

