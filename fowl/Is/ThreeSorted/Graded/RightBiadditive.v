(* bad *)
From Maniunfold.Has Require Export
  OneSorted.UnaryOperation OneSorted.Addition TwoSorted.LeftAction
  OneSorted.Addition OneSorted.Zero OneSorted.Negation
  OneSorted.Graded.Multiplication OneSorted.Graded.One
  ThreeSorted.Graded.BinaryFunction.
From Maniunfold.Is Require Export
  TwoSorted.LeftDistributive ThreeSorted.Bicompatible
  OneSorted.CommutativeRing TwoSorted.LeftModule TwoSorted.RightModule
  TwoSorted.Graded.LeftModule TwoSorted.Graded.RightModule
  ThreeSorted.Graded.Bimodule
  TwoSorted.Graded.Bimodule
  TwoSorted.Unital TwoSorted.Isomorphism.
From Maniunfold.ShouldHave Require Import
  OneSorted.ArithmeticNotations.

Class IsGrdRBiaddve (A : Type) (P Q R : A -> Type)
  `(HasBinOp A) `(HasNullOp A)
  `(forall i : A, HasAdd (Q i))
  `(forall i : A, HasAdd (R i))
  `(!HasGrdBinFn P Q R bin_op) : Prop :=
  grd_r_biaddve : forall (i j : A) (x : P i) (y z : Q j),
    grd_bin_fn _ _ x (y + z) = grd_bin_fn _ _ x y + grd_bin_fn _ _ x z.
