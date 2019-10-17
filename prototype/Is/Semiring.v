From Maniunfold.Has Require Export
  EquivalenceRelation FieldOperations FieldIdentities.
From Maniunfold.Is Require Export
  CommutativeMonoid Monoid Distributive.

Class IsSemiring {A : Type} {has_eqv : HasEqv A}
  (has_add : HasAdd A) (has_zero : HasZero A)
  (has_mul : HasMul A) (has_one : HasOne A) : Prop := {
  semiring_add_is_commutative_monoid :> IsCommutativeMonoid add zero;
  semiring_mul_is_monoid :> IsMonoid mul one;
  semiring_is_distributive :> IsDistributive add mul;
}.

Add Parametric Morphism {A : Type} `{is_semiring : IsSemiring A} : add
  with signature eqv ==> eqv ==> eqv
  as eqv_add_morphism.
Proof. apply semigroup_opr_is_proper; auto. Qed.

Add Parametric Morphism {A : Type} `{is_semiring : IsSemiring A} : mul
  with signature eqv ==> eqv ==> eqv
  as eqv_mul_morphism.
Proof. apply semigroup_opr_is_proper; auto. Qed.
