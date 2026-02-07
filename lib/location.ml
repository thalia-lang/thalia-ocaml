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

type t = {
  offset : int;
  line : int;
  column : int;
}
[@@deriving show]

let make offset line column = { offset; line; column }

let offset { offset; _ } = offset
let line { line; _ } = line
let column { column; _ } = column

let min l1 l2 = if offset l1 < offset l2 then l1 else l2
let max l1 l2 = if offset l1 > offset l2 then l1 else l2

