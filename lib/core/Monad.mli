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
  type 'a t

  val return : 'a -> 'a t
  val bind : 'a t -> ('a -> 'b t) -> 'b t
end

module type T = sig
  include BASE
  include Applicative.T
    with type 'a t := 'a t

  val join : 'a t t -> 'a t
  val ( let* ) : 'a t -> ('a -> 'b t) -> 'b t
  val ( >>= ) : 'a t -> ('a -> 'b t) -> 'b t
  val ( >=> ) : ('a -> 'b t) -> ('b -> 'c t) -> ('a -> 'c t)
  val ( <=< ) : ('b -> 'c t) -> ('a -> 'b t) -> ('a -> 'c t)
end

module Id : T
  with type 'a t = 'a

module Make : functor (M : BASE) -> T
  with type 'a t := 'a M.t
