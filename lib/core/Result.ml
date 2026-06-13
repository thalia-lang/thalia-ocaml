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

module type T = sig
  type error
  type 'a outer
  include Monad.T
    with type 'a t = ('a, error) result outer

  val ok : 'a -> 'a t
  val error : error -> 'a t
  val lift : 'a outer -> 'a t
end

module MakeT (M : Monad.T) (E : sig type t end) = struct
  module T = struct
    type 'a t = ('a, E.t) result M.t

    let ok v =
      let open M in
      Ok v |> pure

    let error e =
      let open M in
      Error e |> pure

    let return = ok
    let bind mx f =
      let open M in
      mx >>= function
        | Error e -> error e
        | Ok v -> f v

    let lift mx =
      M.bind mx return
  end

  include T
  include Monad.Make(T)
end

module Make = MakeT (Monad.Id)
