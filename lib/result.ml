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
  type error
end

module type T = sig
  include BASE

  type 'a self =
    | Ok of 'a list
    | Error of error list

  include Monad.T with type 'a t = 'a self

  val zero : 'a t
  val fail : error -> 'a t

  val concat : 'a t -> 'a t -> 'a t
  val ( <+> ) : 'a t -> 'a t -> 'a t
end

module Make(M: BASE) = struct
  type error = M.error

  type 'a self =
    | Ok of 'a list
    | Error of error list

  let zero = Ok []
  let fail e = Error [e]

  let concat r1 r2 =
    match (r1, r2) with
    | Ok xs1, Ok xs2 -> Ok (xs1 @ xs2)
    | Error es1, Error es2 -> Error (es1 @ es2)
    | Error es, _ | _, Error es -> Error es
  let ( <+> ) = concat

  module Monad_base = struct
    type 'a t = 'a self

    let pure x = Ok [x]
    let bind r f =
      match r with
      | Error es -> Error es
      | Ok xs -> xs |> List.map f |> List.fold_left concat zero
  end

  include Monad.Make(Monad_base)
end

