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

module T = struct
  type item = char

  type t = {
    input : string;
    location : Location.t
  } [@@deriving eq, show { with_path = false }]

  let make input =
    { input; location = Location.zero }

  let meta_of s s' =
    Token.make_meta (s.location, s'.location)

  let string_of s s' =
    let offset = Location.offset s.location in
    let offset' = Location.offset s'.location in
    String.sub s.input offset (offset' - offset)

  let first { input; location } =
    let index = Location.offset location in
    if index >= String.length input
      then None else Some (String.get input index)

  let rest s =
    match first s with
    | None -> s
    | Some c ->
        { s with location = Location.next (c == '\n') s.location }
end

include T
include Stream.Make(T)

