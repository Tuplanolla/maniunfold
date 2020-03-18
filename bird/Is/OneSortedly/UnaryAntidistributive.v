From Maniunfold.Has Require Export
  EquivalenceRelation BinaryOperation UnaryOperation.
From Maniunfold.ShouldHave Require Import
  AdditiveNotations.

Class IsUnAntidistr {A : Type}
  (has_bin_op : HasBinOp A) (has_un_op : HasUnOp A) : Prop :=
  un_antidistr : forall x y : A, - (x + y) = - y + - x.
