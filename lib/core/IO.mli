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

type 'a t = unit -> 'a

include Monad.T
  with type 'a t := 'a t

val run : 'a t -> 'a

val print : string -> unit t
val println : string -> unit t

val eprint : string -> unit t
val eprintln : string -> unit t

val with_file_in : string -> (in_channel -> 'a t) -> 'a t
val with_file_out : string -> (out_channel -> 'a t) -> 'a t

val fread : string -> string t
val fwrite : string -> string -> unit t
val fappend : string -> string -> unit t
