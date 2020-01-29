From Maniunfold.Has Require Export
  EquivalenceRelation BinaryOperation.
From Maniunfold.ShouldHave Require Import
  EquivalenceRelationNotations AdditiveNotations.

Class IsLCancel {A : Type} {has_eq_rel : HasEqRel A}
  (has_bin_op : HasBinOp A) : Prop :=
  l_cancel : forall x y z : A, z + x == z + y -> x == y.