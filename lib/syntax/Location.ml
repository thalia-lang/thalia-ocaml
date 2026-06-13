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

type t = int * int * int
  [@@deriving eq, show { with_path = false }]

let make offset line column =
  offset, line, column
let default = 0, 1, 1

let offset (offset, _, _) = offset
let line (_, line, _) = line
let column (_, _, column) = column

let next ?(is_eol = false) (offset, line, column) =
  if is_eol
    then (offset + 1), (line + 1), 1
  else (offset + 1), line, (column + 1)
