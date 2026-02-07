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
  type state
end

module type T = sig
  include BASE
  include Monad.T with type 'a t = state -> 'a * state
end

module Make(M : BASE) = struct
  type state = M.state

  module Monad_base = struct
    type 'a t = state -> 'a * state

    let pure x = fun s -> (x, s)
    let bind m f =
      fun s ->
        let x, s' = m s in
        f x s'
  end

  include Monad.Make(Monad_base)
end

