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

type t = Id of Span.t * string
       | Int of Span.t * int64
       | Minus of Span.t
       | Plus of Span.t
       | Mul of Span.t
       | Div of Span.t
       | Mod of Span.t
       | Less of Span.t
       | Less_equ of Span.t
       | Grt of Span.t
       | Grt_equ of Span.t
       | Equ of Span.t
       | Not_equ of Span.t
       | Rshift of Span.t
       | Lshift of Span.t
       | Log_and of Span.t
       | Log_or of Span.t
       | Bit_not of Span.t
       | Bit_and of Span.t
       | Bit_or of Span.t
       | Bit_xor of Span.t
       | Assign of Span.t
       | Assign_sub of Span.t
       | Assign_add of Span.t
       | Assign_mul of Span.t
       | Assign_div of Span.t
       | Assign_mod of Span.t
       | Assign_and of Span.t
       | Assign_or of Span.t
       | Assign_xor of Span.t
       | Assign_lsh of Span.t
       | Assign_rsh of Span.t
       | Lparen of Span.t
       | Rparen of Span.t
       | Lbrace of Span.t
       | Rbrace of Span.t
       | Lbracket of Span.t
       | Rbracket of Span.t
       | Comma of Span.t
       | Semi of Span.t
       | Colon of Span.t
       | Space of Span.t
       | Comment_base of Span.t
       | Comment_multi of Span.t
       | Comment_doc of Span.t
       | Eof of Span.t
       | Unknown of Span.t
       [@@deriving show]

