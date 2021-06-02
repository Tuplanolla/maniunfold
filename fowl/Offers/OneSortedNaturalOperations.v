From Coq Require Import
  NArith.NArith.
From Maniunfold.Has Require Export
  TwoSortedLeftAction.
From Maniunfold.Is Require Export
  OneSortedMonoid.
From Maniunfold.Offers Require Export
  OneSortedPositiveOperations.
From Maniunfold.ShouldOffer Require Import
  OneSortedAdditivePositiveOperationNotations.

Section Context.

Context (A : Type) `{IsMon A}.

Fixpoint nat_op (n : nat) (x : A) : A :=
  match n with
  | O => 0
  | S p => x + @nat_op p x
  end.

Global Instance nat_A_has_l_act : HasLAct nat A := nat_op.

Definition n_op (n : N) (x : A) : A :=
  match n with
  | N0 => 0
  | Npos p => (p * x)%positive
  end.

Global Instance N_A_has_l_act : HasLAct N A := n_op.

End Context.

Arguments nat_op {_} _ _ !_ _.
Arguments n_op {_} _ _ !_ _.