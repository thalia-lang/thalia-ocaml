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
  type item = Token.t
  type t = Token.t list
    [@@deriving eq, show { with_path = false }]

  let filter = function
    | Token.Eof _ | Token.Space _ | Token.Comment _ -> false
    | _ -> false

  let make input =
    input |> List.filter filter

  let of_string input =
    input |> Lexer.scan_all |> make

  let first = function
    | [] -> None
    | t :: _ -> Some t

  let rest = function
    | [] -> []
    | _ :: ts -> ts
end

include T
include Stream.Make(T)

