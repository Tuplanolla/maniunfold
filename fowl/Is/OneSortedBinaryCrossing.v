(* bad *)
From Maniunfold.Has Require Export
  Negation Multiplication.
From Maniunfold.ShouldHave Require Import
  OneSortedArithmeticNotations.

Class IsBinCrs (A : Type)
  `(HasNeg A) `(HasMul A) : Prop :=
  bin_crs : forall x y : A, (- x) * y = x * (- y).
