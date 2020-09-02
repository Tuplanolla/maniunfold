From Maniunfold.Has Require Export
  OneSorted.NullaryOperation.
From Maniunfold.ShouldHave Require Import
  OneSorted.AdditiveNotations.

(** Graded nullary operation.
    See [Has.OneSorted.NullaryOperation]. *)

Class HasGrdNullOp {A : Type} (P : A -> Type)
  {A_has_null_op : HasNullOp A} : Type :=
  grd_null_op : P 0.

Typeclasses Transparent HasGrdNullOp.