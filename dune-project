(lang dune 3.16)
(generate_opam_files true)

(name thalia)
(version 0.0.0)
(authors "Stan Vlad <vstan02@protonmail.com>")
(source (github thalia-lang/thalia-ocaml))
(license LGPL-3.0)

(package
 (name thalia)
 (synopsis "Thalia programming language")
 (description "Thalia is a procedural programming language designed to be fast, statically typed, and suitable for general-purpose applications.")
 (depends ocaml dune ppx_deriving alcotest))

