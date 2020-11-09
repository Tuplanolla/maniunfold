(* bad *)
From Maniunfold.Has Require Export
  OneSorted.Addition OneSorted.Zero OneSorted.Negation OneSorted.Multiplication
  OneSorted.One TwoSorted.LeftAction TwoSorted.RightAction.
From Maniunfold.Is Require Export
  TwoSorted.Graded.LeftModule TwoSorted.Graded.RightModule
  ThreeSorted.Bicompatible.
From Maniunfold.ShouldHave Require Import
  OneSorted.ArithmeticNotations OneSorted.AdditiveNotations
  OneSorted.Graded.MultiplicativeNotations
  TwoSorted.Graded.MultiplicativeNotations.

Class IsGrdBicompat (A : Type) (P Q R : A -> Type)
  `(HasBinOp A) `(HasNullOp A)
  `(!@HasGrdLAct A P R bin_op)
  `(!@HasGrdRAct A Q R bin_op) : Prop := {
  A_bin_op_is_assoc :> IsAssoc bin_op;
  grd_bicompat : forall (i j k : A) (a : P i) (x : R j) (b : Q k),
    rew assoc i j k in
    (a * (x * b)%grd_r_mod)%grd_l_mod = ((a * x)%grd_l_mod * b)%grd_r_mod;
}.

Class IsThreeGrdBimod (A : Type) (P Q R : A -> Type)
  `(HasBinOp A) `(HasNullOp A)
  `(P_has_add : forall i : A, HasAdd (P i))
  `(P_has_zero : forall i : A, HasZero (P i))
  `(P_has_neg : forall i : A, HasNeg (P i))
  `(!@HasGrdMul A P bin_op) `(!@HasGrdOne A P null_op)
  `(Q_has_add : forall i : A, HasAdd (Q i))
  `(Q_has_zero : forall i : A, HasZero (Q i))
  `(Q_has_neg : forall i : A, HasNeg (Q i))
  `(!@HasGrdMul A Q bin_op) `(!@HasGrdOne A Q null_op)
  `(R_has_add : forall i : A, HasAdd (R i))
  `(R_has_zero : forall i : A, HasZero (R i))
  `(R_has_neg : forall i : A, HasNeg (R i))
  `(!@HasGrdLAct A P R bin_op)
  `(!@HasGrdRAct A Q R bin_op) : Prop := {
  P_R_add_zero_neg_grd_mul_grd_one_add_zero_neg_grd_l_act_is_grd_l_mod :>
    IsGrdLMod P R bin_op null_op P_has_add P_has_zero P_has_neg grd_mul grd_one
    R_has_add R_has_zero R_has_neg grd_l_act;
  Q_R_add_zero_neg_grd_mul_grd_one_add_zero_neg_grd_r_act_is_grd_r_mod :>
    IsGrdRMod Q R bin_op null_op Q_has_add Q_has_zero Q_has_neg grd_mul grd_one
    R_has_add R_has_zero R_has_neg grd_r_act;
  P_Q_R_grd_l_act_grd_r_act_is_grd_bicompat :>
    IsGrdBicompat P Q R bin_op null_op grd_l_act grd_r_act;
}.
