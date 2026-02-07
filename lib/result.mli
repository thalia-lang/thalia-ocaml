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

(** Non-deterministic result type combining list-based non-determinism with
    error handling.

    This module provides a result type that can represent multiple successful
    values or multiple errors, enabling computations that may succeed in
    multiple ways or fail with multiple error messages. *)

(** The non-deterministic result type.
    - ['a] is the type of successful values
    - ['e] is the type of error values

    [Ok xs] represents zero or more successful results. [Error es] represents
    one or more errors. *)
type ('a, 'e) t =
  | Ok of 'a list
  | Error of 'e list
  [@@deriving show]

(** [zero] represents a computation with no results (empty success). *)
val zero : ('a, 'e) t

(** [pure x] lifts a single value [x] into a successful result. *)
val pure : 'a -> ('a, 'e) t

(** [fail e] creates a failed result with error [e]. *)
val fail : 'e -> ('a, 'e) t

(** [bind r f] applies function [f] to each successful value in [r], collecting
    all results. If [r] is an error, the error is propagated.

    This enables sequencing computations where each step may produce multiple
    results or fails. *)
val bind : ('a, 'e) t -> ('a -> ('b, 'e) t) -> ('b, 'e) t

(** [let* x = r in f] is syntax sugar for [bind r f]. *)
val ( let* ) : ('a, 'e) t -> ('a -> ('b, 'e) t) -> ('b, 'e) t

(** [map r f] applies function [f] to each successful value in [r]. If [r] is an
    error, the error is propagated unchanged. *)
val map : ('a, 'e) t -> ('a -> 'b) -> ('b, 'e) t

(** [let+ x = r in f] is syntax sugar for [map r f]. *)
val ( let+ ) : ('a, 'e) t -> ('a -> 'b) -> ('b, 'e) t

(** [join rr] flattens a nested result structure. Given a result containing
    results, it merges them into a single level.

    This is useful when you have a computation that produces multiple
    computations, and you want to collect all their results. *)
val join : (('a, 'e) t, 'e) t -> ('a, 'e) t

(** [concat r1 r2] combines two results:
    - If both are successful, concatenates their value lists
    - If either is an error, returns an error with all error messages
    - If both are errors, concatenates their error lists

    This provides a choice operation for non-deterministic computations. *)
val concat : ('a, 'e) t -> ('a, 'e) t -> ('a, 'e) t

(** [r1 <+> r2] is an infix operator for [concat r1 r2]. *)
val ( <+> ) : ('a, 'e) t -> ('a, 'e) t -> ('a, 'e) t

