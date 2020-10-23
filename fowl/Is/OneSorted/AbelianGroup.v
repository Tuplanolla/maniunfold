From Maniunfold.Has Require Export
  OneSorted.BinaryOperation OneSorted.NullaryOperation
  OneSorted.UnaryOperation.
From Maniunfold.Is Require Export
  OneSorted.Commutative OneSorted.Group OneSorted.UnaryDistributive.
From Maniunfold.ShouldHave Require Import
  OneSorted.AdditiveNotations.

(** Abelian group, commutative group. *)

Class IsAbGrp (A : Type) `(HasBinOp A)
  `(HasNullOp A) `(HasUnOp A) : Prop := {
  A_bin_op_is_comm :> IsComm (bin_op (A := A));
  A_bin_op_null_op_un_op_is_grp :> IsGrp bin_op null_op un_op;
}.

Section Context.

Context {A : Type} `{IsAbGrp A}.

Theorem A_bin_op_un_op_un_distr : forall x y : A,
  - (x + y) = - x + - y.
Proof.
  intros x y.
  rewrite (comm x y).
  rewrite (un_antidistr y x).
  reflexivity. Defined.

Global Instance A_bin_op_un_op_is_un_distr : IsUnDistr bin_op un_op.
Proof. intros x y. apply A_bin_op_un_op_un_distr. Defined.

End Context.
