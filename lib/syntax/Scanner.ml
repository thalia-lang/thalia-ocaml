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

open Core

module Make (E : sig type t end) (I : Stream.BASE) = struct
  module I' = Stream.Make (I)
  module M = State.Make (I')
  include Result.MakeT (M) (E)

  let run s m = m s

  let get =
    M.pure () |> M.get |> lift
  let put s =
    M.pure () |> M.put s |> lift
  let update f =
    M.pure () |> M.update f |> lift

  let first =
    get >|= I'.first
  let rest =
    get >|= I'.rest

  let peek index =
    get >|= I'.peek index
  let skip size =
    get >|= I'.skip size
  let skip_while pred =
    get >|= I'.skip_while pred
end
