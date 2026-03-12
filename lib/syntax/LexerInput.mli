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
  input : string;
  location : Location.t
} [@@deriving eq, show { with_path = false }]

include Stream.T
  with type t := t
  with type item := char

val make : string -> t

val input : t -> string
val location : t -> Location.t

val meta_of : t -> t -> Token.meta
val string_of : t -> t -> string

