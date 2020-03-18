From Maniunfold.Has Require Export
  OneSorted.Graded.BinaryOperation NullaryOperation.
From Maniunfold.Is Require Export
  Monoid.
From Maniunfold.ShouldHave Require Import
  OneSorted.AdditiveNotations
  OneSorted.Graded.AdditiveNotations.

Class IsGrdMon {A : Type} {P : A -> Type}
  (A_has_bin_op : HasBinOp A) (A_has_un : HasNullOp A)
  (P_has_grd_bin_op : HasGrdBinOp P) (P_has_grd_un : HasGrdNullOp P) : Prop := {
  bin_op_null_op_is_mon :> IsMon (A := A) bin_op null_op;
  (** TODO NullOpinline the following. *)
  grd_assoc : forall (i j k : A) (x : P i) (y : P j) (z : P k),
    rew assoc i j k in (x G+ (y G+ z)) = (x G+ y) G+ z;
  grd_l_unl : forall (i : A) (x : P i),
    rew l_unl i in (G0 G+ x) = x;
  grd_r_unl : forall (i : A) (x : P i),
    rew r_unl i in (x G+ G0) = x;
}.
