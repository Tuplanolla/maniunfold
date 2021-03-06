(* bad *)
From Maniunfold.Has Require Export
  UnaryOperation Addition Action
  Addition Zero Negation
  OneSortedGradedMultiplication OneSortedGradedOne
  ThreeSortedGradedBinaryFunction.
From Maniunfold.Is Require Export
  TwoSortedLeftDistributive ThreeSortedBicompatible
  OneSortedRing TwoSortedLeftModule TwoSortedRightModule
  TwoSortedGradedLeftModule TwoSortedGradedRightModule
  ThreeSortedGradedBimodule
  TwoSortedGradedBimodule
  TwoSortedUnital Isomorphism.
From Maniunfold.ShouldHave Require Import
  OneSortedArithmeticNotations.

Class IsGrdLBiaddve (A : Type) (P Q R : A -> Type)
  `(HasBinOp A) `(HasNullOp A)
  `(forall i : A, HasAdd (P i))
  `(forall i : A, HasAdd (R i))
  `(!HasGrdBinFn P Q R bin_op) : Prop :=
  grd_l_biaddve : forall (i j : A) (x y : P i) (z : Q j),
    grd_bin_fn _ _ (x + y) z = grd_bin_fn _ _ x z + grd_bin_fn _ _ y z.
