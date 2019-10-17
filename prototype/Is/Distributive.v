From Maniunfold.Has Require Export
  EquivalenceRelation FieldOperations.
From Maniunfold.Is Require Export
  LeftDistributive RightDistributive.

Class IsDistributive {A : Type} {has_eqv : HasEqv A}
  (has_add : HasAdd A) (has_mul : HasMul A) : Prop := {
  mul_add_is_left_distributive :> IsLeftDistributive add mul;
  mul_add_is_right_distributive :> IsRightDistributive add mul;
}.
