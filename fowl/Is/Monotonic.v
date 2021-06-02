(** * Monotonicity of a Function *)

From Maniunfold.Has Require Export
  Function OneSortedOrderRelation.
From Maniunfold.ShouldHave Require Import
  OneSortedOrderRelationNotations.

Fail Fail Class IsMono (A B : Type)
  (R : HasOrdRel A) (S : HasOrdRel B) (f : A -> B) : Prop :=
  mono (x y : A) (l : x <= y) : f x <= f y.

Notation IsMono R S f := (Proper (R ==> S) f).
Notation mono := (proper_prf : IsMono _ _ _).