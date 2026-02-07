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

type ('a, 'e) t =
  | Ok of 'a list
  | Error of 'e list
  [@@deriving show]

let zero = Ok []
let pure x = Ok [x]
let fail e = Error [e]

let%test _ = Ok [] = zero
let%test _ = Ok [2] = pure 2
let%test _ = Error ["1"] = fail "1"

let concat r1 r2 =
  match (r1, r2) with
  | Ok xs1, Ok xs2 -> Ok (xs1 @ xs2)
  | Error es1, Error es2 -> Error (es1 @ es2)
  | Error es, _ | _, Error es -> Error es
let ( <+> ) = concat

let%test _ = Ok [1; 2; 3] = (Ok [1; 2] <+> Ok [3])
let%test _ = Error ["x"] = (Ok [1; 2] <+> Error ["x"])
let%test _ = Error ["x"] = (Error ["x"] <+> Ok [3])
let%test _ = Error ["x"; "y"] = (Error ["x"] <+> Error ["y"])

let bind r f =
  match r with
  | Error es -> Error es
  | Ok xs -> xs |> List.map f |> List.fold_left concat zero
let ( let* ) = bind

let%test _ = Ok [3] = bind (Ok [3]) pure
let%test _ = Error ["x"] = bind (Error ["x"]) pure

let map r f = bind r (fun x -> pure (f x))
let ( let+ ) = map

let%test _ = Ok [4] = map (Ok [3]) (fun x -> x + 1)
let%test _ = Error ["x"] = map (Error ["x"]) (fun x -> x + 1)

let join rr = bind rr (fun r -> r)

let%test _ = Ok [3; 5; 6] = (Ok [3; 5; 6] |> pure |> join)
let%test _ = Error ["x"] = (Error ["x"] |> join)
let%test _ = Error ["x"] = (Error ["x"] |> pure |> join)

