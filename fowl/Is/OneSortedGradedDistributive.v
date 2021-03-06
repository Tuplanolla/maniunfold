(* bad *)
From Maniunfold.Has Require Export
  BinaryOperation Addition OneSortedGradedMultiplication.
From Maniunfold.Is Require Export
  OneSortedGradedLeftDistributive OneSortedGradedRightDistributive.

Class IsGrdDistr (A : Type) (P : A -> Type)
  `(HasBinOp A)
  `(P_has_add : forall i : A, HasAdd (P i))
  `(HasGrdMul A P) : Prop := {
  add_grd_mul_is_grd_distr_l :> IsGrdDistrL bin_op P_has_add grd_mul;
  add_grd_mul_is_grd_distr_r :> IsGrdDistrR bin_op P_has_add grd_mul;
}.
