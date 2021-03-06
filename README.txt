1. DESCRIPTION

Levy is a simple implementation of Paul Levy's call-by-push-value
language.  The implementation contains a parser, type-checker, and an
interpreter. It is part of the PL Zoo, see
http://math.andrej.com/plzoo/

The language has the following features:

* integers with arithmetical operations *, +, -

* booleans with conditional statements and comparison =, < of integers

* functions

* general recursion (fixpoint operator)

* call-by-push-value features: return, thunk, force, sequence, and let binding

See the file example.levy for concrete syntax.

The language is different enough from standard functional languages
that you will not be able to guess how it works without reading about
cally-by-push-value first. A good place to start is Paul Levy's FAQ at
http://www.cs.bham.ac.uk/~pbl/cbpv.html


2. AUTHOR

The authors of the program are Matija Pretnar <matija@pretnar.info>,
and Andrej Bauer <Andrej.Bauer@andrej.com>, with modifications by
Robert Simmons <robsimmons@gmail.com>. Emacs mode by Ben Mosley. 
See the file COPYRIGHT.txt for license information.


3. REQUIREMENTS

You need Objective Caml, http://caml.inria.fr/ version 3.10 or higher.

If you have an older version of Objective Caml you can still compile
the code by hand.

A simple emacs highlighting mode for Levy is included; you can include it by 
adding the following text to your .emacs file, changing the levy-root directory
to wherever the code for Levy was placed.

;; Setup for levy-mode
(setq levy-root "/home/hqbovik/levy/")
(load (concat levy-root "levy.el"))
(add-to-list 'auto-mode-alist '("\\.levy\\'" . levy-mode))


4. COMPILATION

To compile the program run the command

    make

For the native code version run

    make native

If you do not have the make utility, run

   ocamlbuild levy.byte


5. USAGE

First compile the program. You may then run the interpreter with

    ./levy.byte

If you built the native code version, this would be

    ./levy.native

The file example.levy contains examples that explain the concrete
syntax. You can load it and try it as follows:

    $ ./levy.byte example.levy
