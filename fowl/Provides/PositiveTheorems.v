From Coq Require Import
  Classes.DecidableClass Classes.Morphisms Lia PArith.PArith.
From Maniunfold.Has Require Export
  OneSorted.One.
From Maniunfold.Is Require Export
  OneSorted.AbelianGroup OneSorted.CommutativeSemigroup
  OneSorted.CommutativeMonoid.

Import Pos.

Local Open Scope N_scope.
Local Open Scope positive_scope.

(** This incomplete collection of corollaries
    would be generated by Equations. *)

Corollary pred_N_equation_1 (p : positive) : pred_N (xI p) = Npos (xO p).
Proof. reflexivity. Qed.

Corollary pred_N_equation_2 (p : positive) :
  pred_N (xO p) = Npos (pred_double p).
Proof. reflexivity. Qed.

Corollary pred_N_equation_3 : pred_N xH = 0.
Proof. reflexivity. Qed.

Hint Rewrite @pred_N_equation_1 @pred_N_equation_2 @pred_N_equation_3 : pred_N.

Corollary pos_shiftl_equation_1 (p : positive) : shiftl p 0 = p.
Proof. reflexivity. Qed.

Corollary pos_shiftl_equation_2 (p n0 : positive) :
  shiftl p (Npos n0) = iter xO p n0.
Proof. reflexivity. Qed.

Hint Rewrite @pos_shiftl_equation_1 @pos_shiftl_equation_2 : shiftl.

Corollary iter_equation_1 (A : Type) (f : A -> A) (x : A) (n' : positive) :
  iter f x (xI n') = f (iter f (iter f x n') n').
Proof. reflexivity. Qed.

Corollary iter_equation_2 (A : Type) (f : A -> A) (x : A) (n' : positive) :
  iter f x (xO n') = iter f (iter f x n') n'.
Proof. reflexivity. Qed.

Corollary iter_equation_3 (A : Type) (f : A -> A) (x : A) :
  iter f x xH = f x.
Proof. reflexivity. Qed.

Hint Rewrite @iter_equation_1 @iter_equation_2 @iter_equation_3 : iter.

(** Whether the given number is a power of two or not. *)

Equations pos_bin (n : positive) : bool :=
  pos_bin (xO p) := pos_bin p;
  pos_bin (xI p) := false;
  pos_bin xH := true.

(** These lemmas are missing from the standard library. *)

Lemma pos_shiftl_0_r (a : positive) : shiftl a 0 = a.
Proof. reflexivity. Qed.

(** These instances are missing from the standard library. *)

Global Program Instance Decidable_eq_positive (x y : positive) :
  Decidable (x = y) := {
  Decidable_witness := eqb x y;
  Decidable_spec := _;
}.
Next Obligation. intros x y. apply eqb_eq. Qed.

Global Program Instance Decidable_le_positive (x y : positive) :
  Decidable (x <= y) := {
  Decidable_witness := leb x y;
  Decidable_spec := _;
}.
Next Obligation. intros x y. apply leb_le. Qed.

Global Program Instance Decidable_lt_positive (x y : positive) : Decidable (x < y) := {
  Decidable_witness := ltb x y;
  Decidable_spec := _;
}.
Next Obligation. intros x y. apply ltb_lt. Qed.

Global Instance le_add_wd : Proper (le ==> le ==> le) add.
Proof. intros n p l n' p' l'. apply add_le_mono; [lia |]. lia. Qed.

Global Instance le_mul_wd : Proper (le ==> le ==> le) mul.
Proof. intros n p l n' p' l'. apply mul_le_mono; [lia |]. lia. Qed.

Global Instance le_div2_wd : Proper (le ==> le) div2.
Proof. intros n p l. destruct n, p; unfold div2; lia. Qed.

Global Instance le_sqrt_wd : Proper (le ==> le) sqrt.
Proof.
  intros n p l. unfold sqrt. destruct
  (sqrtrem_spec n) as [s x | s x r],
  (sqrtrem_spec p) as [s' x' | s' x' r']; cbn; nia. Qed.

(** Whether the given number is even or not. *)

Equations pos_even (n : positive) : bool :=
  pos_even (xI p) := false;
  pos_even (xO p) := true;
  pos_even xH := false.

(** Whether the given number is odd or not. *)

Equations pos_odd (n : positive) : bool :=
  pos_odd n := negb (pos_even n).

Module Additive.

Global Instance positive_has_bin_op : HasBinOp positive := Pos.add.

Global Instance positive_bin_op_is_mag : IsMag (bin_op (A := positive)).
Proof. Defined.

Global Instance positive_bin_op_is_assoc : IsAssoc (bin_op (A := positive)).
Proof. intros x y z. apply Pos.add_assoc. Defined.

Global Instance positive_bin_op_is_sgrp : IsSgrp (bin_op (A := positive)).
Proof. split; typeclasses eauto. Defined.

Global Instance positive_bin_op_is_comm : IsComm (bin_op (A := positive)).
Proof. intros x y. apply Pos.add_comm. Defined.

Global Instance positive_bin_op_is_comm_sgrp : IsCommSgrp (bin_op (A := positive)).
Proof. split; typeclasses eauto. Defined.

End Additive.

Module Multiplicative.

Global Instance positive_bin_op_has_bin_op : HasBinOp positive := Pos.mul.
Global Instance positive_has_null_op : HasNullOp positive := xH.

Global Instance positive_bin_op_is_mag : IsMag (bin_op (A := positive)).
Proof. Defined.

Global Instance positive_bin_op_is_assoc : IsAssoc (bin_op (A := positive)).
Proof. intros x y z. apply Pos.mul_assoc. Defined.

Global Instance positive_bin_op_is_sgrp : IsSgrp (bin_op (A := positive)).
Proof. split; typeclasses eauto. Defined.

Global Instance positive_bin_op_is_comm : IsComm (bin_op (A := positive)).
Proof. intros x y. apply Pos.mul_comm. Defined.

Global Instance positive_bin_op_is_comm_sgrp : IsCommSgrp (bin_op (A := positive)).
Proof. split; typeclasses eauto. Defined.

Global Instance positive_bin_op_null_op_is_l_unl : IsLUnl (bin_op (A := positive)) null_op.
Proof. intros x. apply Pos.mul_1_l. Defined.

Global Instance positive_bin_op_null_op_is_r_unl : IsRUnl (bin_op (A := positive)) null_op.
Proof. intros x. apply Pos.mul_1_r. Defined.

Global Instance positive_bin_op_null_op_is_unl : IsUnl (bin_op (A := positive)) null_op.
Proof. split; typeclasses eauto. Defined.

Global Instance positive_bin_op_null_op_is_mon : IsMon (bin_op (A := positive)) null_op.
Proof. split; typeclasses eauto. Defined.

Global Instance positive_bin_op_null_op_is_comm_mon : IsCommMon (bin_op (A := positive)) null_op.
Proof. split; typeclasses eauto. Defined.

End Multiplicative.

(** We need this just for notations. *)

Global Instance positive_has_one : HasOne positive := xH.
