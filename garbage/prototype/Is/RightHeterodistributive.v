From Maniunfold.Has Require Export
  EquivalenceRelation FieldOperations Power.
From Maniunfold.Is Require Export
  Setoid.
From Maniunfold.ShouldHave Require Import
  EquivalenceNotations FieldNotations PowerNotations.

Class IsRightHeterodistributive {A : Type} {has_eqv : HasEqv A}
  (has_add : HasAdd A) (has_mul : HasMul A) (has_pow : HasPow A) : Prop := {
  eqv_is_setoid :> IsSetoid eqv;
  right_heterodistributive : forall x y z : A, (x + y) ^ z == x ^ z * y ^ z;
}.
