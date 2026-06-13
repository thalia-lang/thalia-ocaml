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
  type 'a t = unit -> 'a

  let return v =
    fun () -> v
  let bind m f =
    fun () -> f (m ()) ()

  let run m = m ()
end

include T
include Monad.Make(T)

let print s =
  fun () -> print_string s
let println s =
  fun () -> print_endline s

let eprint s =
  fun () -> Printf.eprintf "%s" s
let eprintln s =
  fun () -> Printf.eprintf "%s\n" s

let with_file_in path f () =
  let ic = open_in path in
  Fun.protect
    ~finally:(fun () -> close_in_noerr ic)
    (fun () -> run (f ic))

let with_file_out path f () =
  let oc = open_out path in
  Fun.protect
    ~finally:(fun () -> close_out_noerr oc)
    (fun () -> run (f oc))

let fwrite path content =
  with_file_out path
    (fun oc () -> output_string oc content)

let fappend path content () =
  let oc = open_out_gen [Open_append; Open_creat] 0o644 path in
  Fun.protect
    ~finally:(fun () -> close_out_noerr oc)
    (fun () -> output_string oc content)

let fread path =
  with_file_in path
    (fun ic () ->
      let n = in_channel_length ic in
      let buf = Bytes.create n in
      really_input ic buf 0 n; Bytes.to_string buf)
