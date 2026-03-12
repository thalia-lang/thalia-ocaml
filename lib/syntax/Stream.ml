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

module type BASE = sig
  type item
  type t

  val first : t -> item option
  val rest : t -> t
end

module type T = sig
  include BASE

  val peek : int -> t -> item option

  val skip : int -> t -> t
  val skip_while : (item -> bool) -> t -> t
end

module Make(M : BASE) = struct
  let first = M.first
  let rest = M.rest

  let pure s = s
  let ( >>= ) m f s = s |> m |> f

  let rec peek = function
    | 0 -> first
    | n -> rest >>= peek (n - 1)

  let rec skip = function
    | 0 -> pure
    | n -> rest >>= skip (n - 1)

  let rec skip_while pred s =
    match first s with
    | None -> s
    | Some i when i |> pred |> not -> s
    | _ -> skip_while pred (rest s)
end

