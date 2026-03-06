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

type kind =
  | Id
  | Int
  | Minus
  | Plus
  | Mul
  | Div
  | Mod
  | Less
  | Less_equ
  | Grt
  | Grt_equ
  | Equ
  | Not_equ
  | Rshift
  | Lshift
  | Log_and
  | Log_or
  | Bit_not
  | Bit_and
  | Bit_or
  | Bit_xor
  | Assign
  | Assign_sub
  | Assign_add
  | Assign_mul
  | Assign_div
  | Assign_mod
  | Assign_and
  | Assign_or
  | Assign_xor
  | Assign_lsh
  | Assign_rsh
  | Lparen
  | Rparen
  | Lbrace
  | Rbrace
  | Lbracket
  | Rbracket
  | Comma
  | Semi
  | Colon
  | Space
  | Comment
  | Eof
  | Unknown
  [@@deriving show]

type t = kind * Span.t
[@@deriving show]

