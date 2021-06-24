(** * Monoid *)

From Maniunfold.Has Require Export
  NullaryOperation BinaryOperation.
From Maniunfold.Is Require Export
  Semigroup Unital.
From Maniunfold.ShouldHave Require Import
  AdditiveNotations.

Class IsMon (A : Type) (Hx : HasNullOp A) (Hk : HasBinOp A) : Prop := {
  is_semigrp :> IsSemigrp _+_;
  is_unl :> IsUnl 0 _+_;
}.
