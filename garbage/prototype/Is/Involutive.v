From Maniunfold.Has Require Export
  EquivalenceRelation Endomorphism.
From Maniunfold.Is Require Export
  Setoid.
From Maniunfold.ShouldHave Require Export
  EquivalenceNotations.

Class IsInvolutive {A : Type} {has_eqv : HasEqv A}
  (has_endo : HasEndo A) : Prop := {
  eqv_is_setoid :> IsSetoid eqv;
  involutive : forall x : A, endo (endo x) == x;
}.
