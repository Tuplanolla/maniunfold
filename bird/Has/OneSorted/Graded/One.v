From Maniunfold.Has Require Export
  OneSorted.BinaryOperation OneSorted.Graded.NullaryOperation.
From Maniunfold.ShouldHave Require Import
  OneSorted.AdditiveNotations.

Class HasGrdOne {A : Type} (P : A -> Type)
  {A_has_null_op : HasNullOp A} : Type :=
  grd_one : P 0.

Typeclasses Transparent HasGrdOne.

Section Context.

Context {A : Type} {P : A -> Type} `{A_has_grd_one : HasGrdOne A P}.

Global Instance P_has_grd_null_op : HasGrdNullOp P := grd_one.

End Context.
