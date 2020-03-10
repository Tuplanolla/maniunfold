From Coq Require Logic. Import Logic.EqNotations.
From Maniunfold.Has Require Export
  EquivalenceRelation BinaryOperation Unit LeftAction.
From Maniunfold.Is Require Export
  Ring.
From Maniunfold.ShouldHave Require Import
  EquivalenceRelationNotations ArithmeticNotations AdditiveNotations.

(** TODO This is disgusting! *)

Class HasGrdMul (A : Type) (P : A -> Type) {has_bin_op : HasBinOp A} : Type :=
  grd_mul : forall i j : A, P i -> P j -> P (i + j).

Typeclasses Transparent HasGrdMul.

Class HasGrdOne (A : Type) (P : A -> Type) : Type :=
  grd_one : forall i : A, P i.

Typeclasses Transparent HasGrdOne.

Notation "x '*' y" := (grd_mul _ _ x y) : algebra_scope.
Notation "'1'" := (grd_one _) : algebra_scope.

(** TODO Uh oh! *)

Instance eq_has_eq_rel {A : Type} : HasEqRel A := eq.

Class IsGrdRing {A : Type} {P : A -> Type}
  (A_has_bin_op : HasBinOp A) (A_has_un : HasUn A)
  {P_has_eq_rel : forall i : A, HasEqRel (P i)}
  (P_has_add : forall i : A, HasAdd (P i))
  (P_has_zero : forall i : A, HasZero (P i))
  (P_has_neg : forall i : A, HasNeg (P i))
  (has_grd_mul : HasGrdMul A P)
  (has_grd_one : HasGrdOne A P) : Prop := {
  bin_op_un_is_mon :> IsMon (A := A) (has_eq_rel := eq_has_eq_rel) bin_op un;
  add_zero_neg_is_ab_grp :> forall i : A,
    IsAbGrp (P_has_add i) (P_has_zero i) (P_has_neg i);

  (* grd_assoc : forall (i j k : A) (x : P i) (y : P j) (z : P k),
    P_has_eq_rel (i + (j + k) ~ (i + j) + k)
    (grd_mul i (j + k) x (grd_mul j k y z))
    (grd_mul (i + j) k (grd_mul i j x y) z); *)
  (* x * (y * z) == (x * y) * z; *)

  (* grd_l_unl : forall (i : A) (x : P i),
    rew [P] l_unl i in has_grd_mul 0 i (has_grd_one i) x == x; *)
  (* 1 * x == x; *)

  (* grd_r_unl : forall (i : A) (x : P i),
    rew [P] r_unl i in has_grd_mul i 0 x (has_grd_one i) == x; *)
  (* x * 1 == x; *)

  (* ??? *)
  (* add_mul_is_distr :> IsDistr add mul; *)

  (* ??? *)
  (* mul_one_is_mon :> IsMon grd_mul grd_one; *)
}.

Section Context.

Context {A : Type} {P : A -> Type} `{is_grd_ring : IsGrdRing A P}.

Check forall (i : A) (x : P i),
  rew [P] l_unl i in has_grd_mul 0 i (has_grd_one i) x == x.

End Context.
