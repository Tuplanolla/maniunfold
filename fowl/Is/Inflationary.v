(** * Inflationarity or Progressivity of a Function and a Binary Operation *)

From Maniunfold.Has Require Export
  OrderRelations BinaryOperation.
From Maniunfold.ShouldHave Require Import
  OrderRelationNotations AdditiveNotations.

Class IsInfl (A : Type) (HR : HasOrdRel A) (f : A -> A) : Prop :=
  infl (x : A) : x <= f x.

Class IsInflBinOpL (A : Type) (HR : HasOrdRel A) (Hk : HasBinOp A) : Prop :=
  infl_bin_op_l (x y : A) : y <= x + y.

(** This has the same shape as [le_add_r]. *)

Class IsInflBinOpR (A : Type) (HR : HasOrdRel A) (Hk : HasBinOp A) : Prop :=
  infl_bin_op_r (x y : A) : x <= x + y.
