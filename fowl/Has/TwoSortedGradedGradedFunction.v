From Maniunfold.Has Require Export
  UnaryOperation.
From Maniunfold.ShouldHave Require Import
  OneSortedAdditiveNotations.

(** Graded function.
    See [Has.Function]. *)

Class HasGrdFn (A : Type) (P Q : A -> Type) `(HasUnOp A) : Type :=
  grd_fn : forall i : A, P i -> Q (- i).

Typeclasses Transparent HasGrdFn.
