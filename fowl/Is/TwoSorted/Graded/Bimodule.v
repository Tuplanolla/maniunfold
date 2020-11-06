(* bad *)
From Maniunfold.Has Require Export
  OneSorted.Addition OneSorted.Zero OneSorted.Negation
  OneSorted.Multiplication OneSorted.One
  TwoSorted.Graded.LeftAction TwoSorted.Graded.RightAction.
From Maniunfold.Is Require Export
  ThreeSorted.Graded.Bimodule.

Class IsTwoGrdBimod (A : Type) (P Q : A -> Type)
  `(HasBinOp A) `(HasNullOp A)
  `(P_has_add : forall i : A, HasAdd (P i))
  `(P_has_zero : forall i : A, HasZero (P i))
  `(P_has_neg : forall i : A, HasNeg (P i))
  `(!@HasGrdMul A P bin_op) `(!@HasGrdOne A P null_op)
  `(Q_has_add : forall i : A, HasAdd (Q i))
  `(Q_has_zero : forall i : A, HasZero (Q i))
  `(Q_has_neg : forall i : A, HasNeg (Q i))
  `(!@HasGrdLAct A P Q bin_op)
  `(!@HasGrdRAct A P Q bin_op) : Prop :=
  P_P_Q_add_zero_neg_grd_mul_grd_one_add_zero_neg_grd_mul_grd_one_add_zero_neg_grd_l_act_grd_r_act_is_three_grd_bimod
    :> IsThreeGrdBimod P P Q bin_op null_op
    P_has_add P_has_zero P_has_neg grd_mul grd_one
    P_has_add P_has_zero P_has_neg grd_mul grd_one
    Q_has_add Q_has_zero Q_has_neg grd_l_act grd_r_act.
