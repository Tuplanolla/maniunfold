From Coq Require Import
  ZArith.
From Maniunfold.Is Require Export
  Equivalence Magma Semigroup Monoid Group.
From Maniunfold.ShouldHave Require Import
  EquivalenceRelationNotations AdditiveNotations.

Global Instance Z_has_eq_rel : HasEqRel Z := Z.eq.

Global Instance Z_eq_is_refl_eq : IsReflEq Z.eq.
Proof. intros x. reflexivity. Qed.

Global Instance Z_eq_is_sym_eq : IsSymEq Z.eq.
Proof. intros x y p. symmetry; auto. Qed.

Global Instance Z_eq_is_trans_eq : IsTransEq Z.eq.
Proof. intros x y z p q. transitivity y; auto. Qed.

Global Instance Z_eq_is_eq : IsEq Z.eq.
Proof. constructor; typeclasses eauto. Qed.

Module Additive.

Global Instance Z_add_has_bin_op : HasBinOp Z := Z.add.

Global Instance Z_add_is_proper :
  IsProper (eq_rel ==> eq_rel ==> eq_rel) Z.add.
Proof. apply Z.add_wd. Qed.

Global Instance Z_add_is_mag : IsMag Z.add.
Proof. constructor; typeclasses eauto. Qed.

Global Instance Z_add_is_assoc : IsAssoc Z.add.
Proof. intros x y z. apply Z.add_assoc. Qed.

Global Instance Z_add_is_sgrp : IsSgrp Z.add.
Proof. constructor; typeclasses eauto. Qed.

Global Instance Z_has_un : HasUn Z := Z.zero.

Global Instance Z_add_zero_is_l_unl : IsLUnl Z.add Z.zero.
Proof. intros x. apply Z.add_0_l. Qed.

Global Instance Z_add_zero_is_r_unl : IsRUnl Z.add Z.zero.
Proof. intros x. apply Z.add_0_r. Qed.

Global Instance Z_add_zero_is_unl : IsUnl Z.add Z.zero.
Proof. constructor; typeclasses eauto. Qed.

Global Instance Z_add_zero_is_mon : IsMon Z.add Z.zero.
Proof. constructor; typeclasses eauto. Qed.

Global Instance Z_has_un_op : HasUnOp Z := Z.opp.

Global Instance Z_opp_is_proper : IsProper (eq_rel ==> eq_rel) Z.opp.
Proof. apply Z.opp_wd. Qed.

Global Instance Z_add_zero_opp_is_l_inv : IsLInv Z.add Z.zero Z.opp.
Proof. intros x. apply Z.add_opp_diag_l. Qed.

Global Instance Z_add_zero_opp_is_r_inv : IsRInv Z.add Z.zero Z.opp.
Proof. intros x. apply Z.add_opp_diag_r. Qed.

Global Instance Z_add_zero_opp_is_inv : IsInv Z.add Z.zero Z.opp.
Proof. constructor; typeclasses eauto. Qed.

Global Instance Z_add_zero_opp_is_grp : IsGrp Z.add Z.zero Z.opp.
Proof. constructor; typeclasses eauto. Qed.

End Additive.

Module Multiplicative.

Global Instance Z_mul_has_bin_op : HasBinOp Z := Z.mul.

Global Instance Z_mul_is_proper :
  IsProper (eq_rel ==> eq_rel ==> eq_rel) Z.mul.
Proof. apply Z.mul_wd. Qed.

Global Instance Z_mul_is_mag : IsMag Z.mul.
Proof. constructor; typeclasses eauto. Qed.

Global Instance Z_mul_is_assoc : IsAssoc Z.mul.
Proof. intros x y z. apply Z.mul_assoc. Qed.

Global Instance Z_mul_is_sgrp : IsSgrp Z.mul.
Proof. constructor; typeclasses eauto. Qed.

Global Instance Z_has_un : HasUn Z := Z.one.

Global Instance Z_mul_one_is_l_unl : IsLUnl Z.mul Z.one.
Proof. intros x. apply Z.mul_1_l. Qed.

Global Instance Z_mul_one_is_r_unl : IsRUnl Z.mul Z.one.
Proof. intros x. apply Z.mul_1_r. Qed.

Global Instance Z_mul_one_is_unl : IsUnl Z.mul Z.one.
Proof. constructor; typeclasses eauto. Qed.

Global Instance Z_mul_one_is_mon : IsMon Z.mul Z.one.
Proof. constructor; typeclasses eauto. Qed.

End Multiplicative.