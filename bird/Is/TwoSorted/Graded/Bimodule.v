(* bad *)
From Maniunfold.Has Require Export
  OneSorted.Addition OneSorted.Zero OneSorted.Negation
  OneSorted.Multiplication OneSorted.One
  TwoSorted.Graded.LeftAction TwoSorted.Graded.RightAction.
From Maniunfold.Is Require Export
  ThreeSorted.Graded.Bimodule.

Class IsTwoGrdBimod {A : Type} (P Q : A -> Type)
  {A_has_bin_op : HasBinOp A} {A_has_null_op : HasNullOp A}
  (P_has_add : forall i : A, HasAdd (P i))
  (P_has_zero : forall i : A, HasZero (P i))
  (P_has_neg : forall i : A, HasNeg (P i))
  (P_has_grd_mul : HasGrdMul P) (P_has_grd_one : HasGrdOne P)
  (Q_has_add : forall i : A, HasAdd (Q i))
  (Q_has_zero : forall i : A, HasZero (Q i))
  (Q_has_neg : forall i : A, HasNeg (Q i))
  (P_Q_has_grd_l_act : HasGrdLAct P Q)
  (P_Q_has_grd_r_act : HasGrdRAct P Q) : Prop :=
  P_P_Q_add_zero_neg_grd_mul_grd_one_add_zero_neg_grd_mul_grd_one_add_zero_neg_grd_l_act_grd_r_act_is_three_grd_bimod
    :> IsThreeGrdBimod P P Q
    P_has_add P_has_zero P_has_neg grd_mul grd_one
    P_has_add P_has_zero P_has_neg grd_mul grd_one
    Q_has_add Q_has_zero Q_has_neg grd_l_act grd_r_act.
