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

type t = Location.t * Location.t

let ( >> ) g f x = f (g x)

let make l1 l2 = (l1, l2)

let first (l, _) = l
let second (_, l) = l

let offset1 = first >> Location.offset
let offset2 = second >> Location.offset

let line1 = first >> Location.line
let line2 = second >> Location.line

let column1 = first >> Location.column
let column2 = second >> Location.column

