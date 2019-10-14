From Maniunfold.Has Require Export
  ScalarMultiplication.
From Maniunfold.Is Require Export
  Ring AbelianGroup.

Import AdditiveNotations.

Class IsRightModule (S A : Type) {S_has_eqv : HasEqv S}
  {S_has_add : HasAdd S} {S_has_zero : HasZero S} {S_has_neg : HasNeg S}
  {S_has_mul : HasMul S} {S_has_one : HasOne S}
  {A_has_eqv : HasEqv A}
  {A_has_opr : HasOpr A} {A_has_idn : HasIdn A} {A_has_inv : HasInv A}
  {has_rsmul : HasRSMul S A} : Prop := {
  S_add_mul_is_ring :> IsRing S;
  A_opr_is_abelian_group :> IsAbelianGroup A;
  rsmul_proper : rsmul ::> eqv ==> eqv ==> eqv;
  rsmul_identity : forall x : A, x *> 1 == x;
  rsmul_mul_compatible : forall (a b : S) (x : A),
    x *> (a * b) == (x *> a) *> b;
  rsmul_add_distributive : forall (a b : S) (x : A),
    x *> (a + b) == x *> a + x *> b;
  rsmul_opr_distributive : forall (a : S) (x y : A),
    (x + y) *> a == x *> a + y *> a;
}.

Add Parametric Morphism {S A : Type}
  `{is_right_module : IsRightModule S A} : rsmul
  with signature eqv ==> eqv ==> eqv
  as eqv_rsmul_morphism.
Proof. intros x y p z w q. apply rsmul_proper; auto. Qed.