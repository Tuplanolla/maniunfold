(* bad *)
From Maniunfold.Has Require Export
  OneSorted.BinaryOperation OneSorted.Addition OneSorted.Graded.Multiplication.
From Maniunfold.Is Require Export
  OneSorted.Graded.LeftDistributive OneSorted.Graded.RightDistributive.

Class IsGrdDistr (A : Type) (P : A -> Type)
  `(HasBinOp A)
  `(P_has_add : forall i : A, HasAdd (P i))
  `(HasGrdMul A P) : Prop := {
  P_add_grd_mul_is_grd_l_distr :> IsGrdLDistr P bin_op P_has_add grd_mul;
  P_add_grd_mul_is_grd_r_distr :> IsGrdRDistr P bin_op P_has_add grd_mul;
}.
