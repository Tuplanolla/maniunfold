(* bad *)
From Maniunfold.Has Require Export
  OneSortedBinaryOperation OneSortedNullaryOperation
  OneSortedGradedBinaryOperation OneSortedGradedNullaryOperation
  TwoSortedGradedLeftAction.
From Maniunfold.Is Require Export
  OneSortedGradedRing OneSortedAbelianGroup.
From Maniunfold.ShouldHave Require Import
  OneSortedArithmeticNotations OneSortedAdditiveNotations
  OneSortedGradedMultiplicativeNotations
  TwoSortedGradedMultiplicativeNotations.

Local Open Scope grd_l_mod_scope.

Class IsTwoGrdLUnl (A : Type) (P Q : A -> Type)
  `(HasBinOp A) `(HasNullOp A)
  `(!HasGrdLAct P Q bin_op) `(!HasGrdOne P null_op) : Prop := {
  bin_op_null_op_is_l_unl :> IsLUnl bin_op null_op;
  grd_two_l_unl : forall (i : A) (x : Q i),
    rew l_unl i in (1 * x) = x;
}.