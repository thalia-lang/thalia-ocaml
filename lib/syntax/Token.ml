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

type meta = {
  span: Location.span
} [@@deriving eq, show { with_path = false }]

type t =
  | Id of meta * string
  | Int of meta * int
  | Minus of meta
  | Plus of meta
  | Mul of meta
  | Div of meta
  | Mod of meta
  | Less of meta
  | Less_equ of meta
  | Grt of meta
  | Grt_equ of meta
  | Equ of meta
  | Not_equ of meta
  | Rshift of meta
  | Lshift of meta
  | Log_and of meta
  | Log_or of meta
  | Bit_not of meta
  | Bit_and of meta
  | Bit_or of meta
  | Bit_xor of meta
  | Assign of meta
  | Assign_sub of meta
  | Assign_add of meta
  | Assign_mul of meta
  | Assign_div of meta
  | Assign_mod of meta
  | Assign_and of meta
  | Assign_or of meta
  | Assign_xor of meta
  | Assign_lsh of meta
  | Assign_rsh of meta
  | Lparen of meta
  | Rparen of meta
  | Lbrace of meta
  | Rbrace of meta
  | Lbracket of meta
  | Rbracket of meta
  | Comma of meta
  | Semi of meta
  | Colon of meta
  | Space of meta
  | Comment of meta
  | Eof of meta
  [@@deriving eq, show { with_path = false }]

let make_meta span = { span }

