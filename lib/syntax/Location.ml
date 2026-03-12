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

type t = {
  offset : int;
  line : int;
  column : int;
} [@@deriving eq, show { with_path = false }]

type span = t * t
  [@@deriving eq, show { with_path = false }]

let make offset line column =
  { offset; line; column }
let zero = make 0 1 1

let offset { offset; _ } = offset
let line { line; _ } = line
let column { column; _ } = column

let next is_eol { offset; line; column } =
  let l, c = match is_eol with
    | true -> line + 1, 1
    | false -> line, column + 1
  in make (offset + 1) l c

