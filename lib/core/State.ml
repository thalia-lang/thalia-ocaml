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
  type input
  include Monad.T
    with type 'a t = (input -> input * 'a)

  val run : input -> 'a t -> input * 'a

  val get : 'a t -> input t
  val put : input -> 'a t -> unit t
  val update : (input -> input) -> 'a t -> unit t
end

module Make (I : sig type t end) = struct
  module T = struct
    type 'a t = I.t -> I.t * 'a

    let return v s =
      s, v
    let bind m f s =
      let s', v = m s in
      f v s'

    let run s m = m s
    let get _ s = s, s
    let put s _ _ = s, ()
    let update f _ s = f s, ()
  end

  include T
  include Monad.Make(T)
end
