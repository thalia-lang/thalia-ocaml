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

module type BASE = sig
  type value
  type input

  val peek : int -> input -> value option
  val rest : input -> input
end

module type T = sig
  include BASE

  val first : input -> value option

  val skip : int -> input -> input
  val skip_while : (value -> bool) -> input -> input
end

module Make : functor (M : BASE) -> T
  with type value = M.value
  with type input = M.input

