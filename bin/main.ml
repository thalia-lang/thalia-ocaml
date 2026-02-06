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

open Thalia

let main () : (string, string) Result.t =
  let open Result in
  let* x1 = Ok [1; 2; 3] in
  let+ x2 = Ok [1; 2; 3] in
  x1 + x2 |> string_of_int

let () =
  match main () with
  | Result.Ok xs ->
      xs
      |> List.map (fun s -> "'" ^ s ^ "'")
      |> String.concat ", "
      |> (fun s -> ">> Values: [" ^ s ^ "]")
      |> print_endline
  | Result.Error es ->
      es
      |> List.map (fun s -> "'" ^ s ^ "'")
      |> String.concat ", "
      |> (fun s -> ">> Errors: [" ^ s ^ "]")
      |> print_endline

