From Maniunfold.Has Require Export
  BinaryRelation RightExternalBinaryOperation LeftUnaryOperation.
From Maniunfold.ShouldHave Require Import
  BinaryRelationNotations AdditiveNotations.

Class IsLExtBinComm {A B : Type} {has_bin_rel : HasBinRel B}
  (has_r_ext_bin_op : HasRExtBinOp A B) (has_l_un_op : HasLUnOp B) : Prop :=
  l_ext_bin_comm : forall (x : B) (y : A), L- (x R+ y) ~~ L- x R+ y.