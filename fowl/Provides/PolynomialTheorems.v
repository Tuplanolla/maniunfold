(* bad *)
From Coq Require Import
  ZArith.ZArith.
From stdpp Require Import
  option fin_maps gmap pmap nmap.
From Maniunfold.Has Require Export
  OneSorted.Enumeration OneSorted.Cardinality TwoSorted.Isomorphism.
From Maniunfold.Is Require Export
  OneSorted.Finite TwoSorted.Isomorphism
  OneSorted.Ring TwoSorted.UnitalAssociativeAlgebra TwoSorted.Graded.Algebra.
From Maniunfold.Is Require Export
  OneSorted.AbelianGroup OneSorted.CommutativeSemigroup
  OneSorted.CommutativeMonoid OneSorted.CommutativeSemiring
  OneSorted.CommutativeRing.
From Maniunfold.Offers Require Export
  TwoSorted.IsomorphismMappings
  OneSorted.PositiveOperations OneSorted.NaturalOperations
  OneSorted.IntegerOperations.
From Maniunfold.Provides Require Export
  NTheorems ZTheorems.
From Maniunfold.ShouldHave Require
  OneSorted.AdditiveNotations OneSorted.MultiplicativeNotations.
From Maniunfold.ShouldHave Require
  OneSorted.ArithmeticNotations.
From Maniunfold.ShouldOffer Require
  OneSorted.ArithmeticOperationNotations.

Section more_merge.

Context `{FinMap K M}.

Context {A B C} (f : option A → option B → option C) `{!DiagNone f}.

(** TODO Ask the std++ people about merging this. *)

Lemma insert_merge_None (m1 : M A) (m2 : M B) i y z :
  f (Some y) (Some z) = None ->
  delete i (merge f m1 m2) = merge f (<[i:=y]> m1) (<[i:=z]> m2).
Proof. by intros; apply partial_alter_merge. Qed.

End more_merge.

Section Context.

Import OneSorted.ArithmeticNotations.
Import OneSorted.ArithmeticOperationNotations.

Context {A : Type} `{is_ring : IsRing A} `{eq_dec : EqDecision A}.

(** We cannot keep zero values in the map,
    because they would break definitional equality and
    needlessly increase space usage. *)

Definition NZ (a : A) : Prop := bool_decide (a <> 0).
Definition NZA : Type := {a : A | NZ a}.
Definition poly : Type := Nmap NZA.

Ltac stabilize :=
  repeat match goal with
  | H : ~ ?a <> ?b |- _ => apply dec_stable in H
  end.

Lemma nza_neq : forall a : NZA, `a <> 0.
Proof.
  cbv [NZA NZ]. intros [a dH]. cbn. intros H.
  apply bool_decide_unpack in dH. apply dH. apply H. Defined.

Ltac conversions := typeclasses
  convert bin_op into (add (A := poly)) and
  null_op into (zero (A := poly)) and
  un_op into (neg (A := poly)) or
  convert bin_op into (mul (A := poly)) and
  null_op into (one (A := poly)) or
  convert bin_op into (add (A := A)) and
  null_op into (zero (A := A)) and
  un_op into (neg (A := A)) or
  convert bin_op into (mul (A := A)) and
  null_op into (one (A := A)).

Definition poly_eval (x : poly) (a : A) : A :=
  map_fold (fun (i : N) (b : NZA) (c : A) => c + `b * (a ^ i)%N) 0 x.

Program Definition nza_add (a b : NZA) : option NZA :=
  let c := `a + `b in
  if decide (c <> 0) then Some (exist NZ c _) else None.
Next Obligation.
  intros a b c F. cbv [NZ]. apply bool_decide_pack. apply F. Defined.

Program Definition nza_mul (a b : NZA) : option NZA :=
  let c := `a * `b in
  if decide (c <> 0) then Some (exist NZ c _) else None.
Next Obligation.
  intros a b c F. cbv [NZ]. apply bool_decide_pack. apply F. Defined.

Global Instance union_with_nza_add_assoc :
  Assoc eq (union_with (M := option NZA) nza_add).
Proof with conversions.
  intros [a |] [b |] [c |]; try (
    repeat (rewrite union_with_left_id || rewrite union_with_right_id);
    reflexivity).
  cbv [union_with option_union_with nza_add].
  destruct (decide (`a + `b <> 0)) as [Fab | Fab],
  (decide (`b + `c <> 0)) as [Fbc | Fbc]; stabilize; cbn.
  - destruct (decide (`a + (`b + `c) <> 0)) as [Fa_bc | Fa_bc],
    (decide ((`a + `b) + `c <> 0)) as [Fab_c | Fab_c]; stabilize; cbn.
    + f_equal. apply sig_eq_pi; [typeclasses eauto | cbn]. rewrite assoc...
      reflexivity.
    + exfalso. apply Fa_bc. rewrite assoc...
      apply Fab_c.
    + exfalso. apply Fab_c. rewrite <- assoc...
      apply Fa_bc.
    + reflexivity.
  - destruct (decide ((`a + `b) + `c <> 0)) as [Fab_c | Fab_c];
    stabilize; cbn.
    + f_equal. apply sig_eq_pi; [typeclasses eauto | cbn].
      rewrite <- assoc...
      rewrite Fbc. rewrite r_unl. reflexivity.
    + exfalso. apply (nza_neq a). rewrite <- assoc in Fab_c...
      rewrite Fbc in Fab_c. rewrite r_unl in Fab_c. apply Fab_c.
  - destruct (decide (`a + (`b + `c) <> 0)) as [Fa_bc | Fa_bc];
    stabilize; cbn.
    + f_equal. apply sig_eq_pi; [typeclasses eauto | cbn].
      rewrite assoc...
      rewrite Fab. rewrite l_unl. reflexivity.
    + exfalso. apply (nza_neq c). rewrite assoc in Fa_bc...
      rewrite Fab in Fa_bc. rewrite l_unl in Fa_bc.
      apply Fa_bc.
  - f_equal. apply sig_eq_pi; [typeclasses eauto | cbn].
    assert (Ha : `a = `a + (`b + - `b)).
    { rewrite r_inv. rewrite r_unl. reflexivity. }
    assert (Hc : `c = (- `b + `b) + `c).
    { rewrite l_inv. rewrite l_unl. reflexivity. }
    rewrite Ha. rewrite assoc...
    rewrite Fab. rewrite l_unl.
    rewrite Hc. rewrite <- assoc...
    rewrite Fbc. rewrite r_unl. reflexivity. Defined.

Global Instance nza_add_comm : Comm eq nza_add.
Proof with conversions.
  intros a b. cbv [nza_add].
  destruct (decide (`a + `b <> 0)) as [Hab | Hab],
  (decide (`b + `a <> 0)) as [Hba | Hba]; stabilize.
  - f_equal. apply sig_eq_pi; [typeclasses eauto | cbn].
    rewrite comm... reflexivity.
  - exfalso. apply Hab. rewrite comm... apply Hba.
  - exfalso. apply Hba. rewrite comm... apply Hab.
  - reflexivity. Defined.

Program Definition nza_neg (a : NZA) : NZA :=
  let b := - `a in
  exist NZ b _.
Next Obligation with conversions.
  intros a b. cbv [NZ]. apply bool_decide_pack. intros H.
  pose proof proj2_sig a as F; cbn in F; cbv [NZ] in F.
  apply bool_decide_unpack in F. apply F. apply inj...
  rewrite un_absorb...
  apply H. Defined.

Lemma nza_add_nza_neg_l : forall a : NZA, nza_add (nza_neg a) a = None.
Proof with conversions.
  intros a. cbv [nza_add nza_neg]. cbn.
  destruct (decide (- `a + `a <> 0)) as [Hab | Hab]; stabilize.
  - exfalso. apply Hab. rewrite l_inv... reflexivity.
  - reflexivity. Defined.

Lemma nza_add_nza_neg_r : forall a : NZA, nza_add a (nza_neg a) = None.
Proof with conversions.
  intros a. cbv [nza_add nza_neg]. cbn.
  destruct (decide (`a + - `a <> 0)) as [Hab | Hab]; stabilize.
  - exfalso. apply Hab. rewrite r_inv... reflexivity.
  - reflexivity. Defined.

Program Definition nza_l_act (a : A) (b : NZA) : option NZA :=
  let c := a * `b in
  if decide (c <> 0) then Some (exist NZ c _) else None.
Next Obligation.
  intros a b c F. cbv [NZ]. apply bool_decide_pack.
  intros H. apply F. apply H. Defined.

Program Definition nza_r_act (a : NZA) (b : A) : option NZA :=
  let c := `a * b in
  if decide (c <> 0) then Some (exist NZ c _) else None.
Next Obligation.
  intros a b c F. cbv [NZ]. apply bool_decide_pack.
  intros H. apply F. apply H. Defined.

Lemma nza_act_comm : forall a b : NZA,
  nza_l_act (`a) b = nza_r_act a (`b).
Proof. intros a b. cbv [nza_l_act nza_r_act]. reflexivity. Defined.

Lemma nza_l_act_zero_l : forall a : NZA, nza_l_act 0 a = None.
Proof with conversions.
  intros a. cbv [nza_l_act].
  destruct (decide (0 * `a <> 0)) as [H | H]; stabilize.
  - exfalso. apply H. rewrite l_absorb. reflexivity.
  - reflexivity. Defined.

Lemma nza_r_act_zero_r : forall a : NZA, nza_r_act a 0 = None.
Proof with conversions.
  intros a. cbv [nza_r_act].
  destruct (decide (`a * 0 <> 0)) as [H | H]; stabilize.
  - exfalso. apply H. rewrite r_absorb. reflexivity.
  - reflexivity. Defined.

(** Addition of polynomials.

    The terms of the polynomials $x$, $y$ and $z$ in $z = x + y$
    are related by the parallel summation $z_n = x_n + y_n$ for all $n$.
    We need to prune zero terms after carrying out each addition,
    because it is possible that $z_n = 0$ for some $n$,
    even though $x_n \ne 0$ and $y_n \ne 0$;
    indeed, this happens whenever $y_n = - x_n$. *)

Definition poly_add (x y : poly) : poly := union_with nza_add x y.

(** Zero polynomial.

    The terms of the polynomial $x$ in $x = 0$
    are constrained by $x_n = 0$ for all $n$. *)

Definition poly_zero : poly := empty.

(** Negation of polynomials.

    The terms of the polynomials $x$ and $y$ in $y = - x$
    are related by the pointwise negation $y_n = - x_n$ for all $n$. *)

Definition poly_neg (x : poly) : poly := fmap nza_neg x.

(** Multiplication of polynomials.

    The terms of the polynomials $x$, $y$ and $z$ in $z = x \times y$
    are related by the discrete convolution
    $r_q = \sum_{n + p = q} x_n \times y_p$ for all $n$, $p$ and $q$.
    We need to prune the terms after carrying out each addition,
    because it is possible that $z_q = 0$ for some $q$,
    as was the case with $x + y$. *)

Program Definition poly_mul (x y : poly) : poly :=
  map_fold (fun (i : N) (a : NZA) (u : poly) =>
    map_fold (fun (j : N) (b : NZA) (v : poly) =>
      partial_alter (fun c : option NZA =>
        let d := `a * `b + from_option proj1_sig 0 c in
        if decide (d <> 0) then Some (exist NZ d _) else None)
      (i + j) v) u y) empty x.
Next Obligation.
  intros x y i a u j b v c d F. cbv [NZ]. apply bool_decide_pack.
  intros H. apply F. apply H. Defined.

(** Unit polynomial.

    The terms of the polynomial $x$ in $x = 1$
    are constrained by $x_0 = 1$ and $x_n = 0$ for all $n > 0$. *)

Program Definition poly_one : poly :=
  if decide (1 <> 0) then singletonM 0 (exist NZ 1 _) else empty.
Next Obligation.
  intros H. cbv [NZ]. apply bool_decide_pack. apply H. Defined.

(** Left scalar multiplication of polynomials.

    The scalar $a$ and
    the terms of the polynomials $x$ and $y$ in $y = a \times x$
    are related by the pointwise multiplication
    $x_n = a \times x_n$ for all $n$. *)

Definition poly_l_act (a : A) (x : poly) : poly :=
  omap (nza_l_act a) x.

(** Right scalar multiplication of polynomials.

    The scalar $a$ and
    the terms of the polynomials $x$ and $y$ in $y = x \times a$
    are related by the pointwise multiplication
    $x_n = x_n \times a$ for all $n$. *)

Definition poly_r_act (x : poly) (a : A) : poly :=
  omap (flip nza_r_act a) x.

(** Product of finite maps.

    Given the functions $g$ and $f$,
    the finite maps $x$, $y$ and $z$ in $z = x \times y$
    are related by $z_k = \sum_{g (i, j) = k} f (x_i, y_j)$
    for all $i$, $j$ and $k$. *)

Fail Fail Definition map_prod {K A B C M : Type}
  `{Empty M} `{FinMapToList K A M} `{PartialAlter K A M}
  (g : K -> K -> K) (f : A -> A -> B)
  (h : B -> option A -> option A) (x y : M) : M :=
  map_fold (fun (i : K) (x : A) (m : M) =>
    map_fold (fun (j : K) (y : A) (m : M) =>
      partial_alter (h (f x y)) (g i j) m) m y) empty x.

Definition dom_partial_alter {K A M : Type} `{PartialAlter K A M}
  (f : option A -> A) (i : K) (m : M) : M :=
  partial_alter (fun x : option A => mret (f x)) i m.

Definition codom_partial_alter {K A M : Type} `{PartialAlter K A M}
  (f : A -> option A) (i : K) (m : M) : M :=
  partial_alter (fun x : option A => mbind f x) i m.

(** Free product of two finite maps along their keys. *)

Definition map_free_prod {KA KB A B MA MB MAB : Type}
  `{FinMapToList KA A MA} `{FinMapToList KB B MB}
  `{Empty MAB} `{Insert (A * B) (KA * KB) MAB}
  (x : MA) (y : MB) : MAB :=
  map_fold (fun (i : KA) (a : A) (z : MAB) =>
    map_fold (fun (j : KB) (b : B) (z : MAB) =>
      insert (a, b) (i, j) z) z y) empty x.

(** Pullback of a finite map along a key altering function. *)

Definition map_pull_back {K L A MK ML : Type}
  `{FinMapToList K A MK} `{Empty ML} `{PartialAlter L (list A) ML}
  (f : K -> L) (x : MK) : ML :=
  map_fold (fun (i : K) (x : A) (y : ML) =>
    partial_alter (fun y : option (list A) =>
      Some (x :: default [] y)) (f i) y) empty x.

Definition map_semifree_prod {K A B C MA MB MC : Type}
  `{FinMapToList K A MA} `{FinMapToList K B MB}
  `{Empty MC} `{PartialAlter K (list C) MC}
  (g : K -> K -> K) (f : A -> B -> C) (x : MA) (y : MB) : MC :=
  map_fold (fun (i : K) (x : A) (m : MC) =>
    map_fold (fun (j : K) (y : B) (m : MC) =>
      partial_alter (fun z : option (list C) =>
        Some (f x y :: default [] z)) (g i j) m) m y) empty x.

Fail Program Definition poly_mult (x y : poly) : poly :=
  map_prod N.add nza_mul (fun (a : A) (b : option NZA) =>
    let cs := union_with nza_add a b in
    if decide (c <> 0) then Some (exist NZ c _) else None) x y.

End Context.

Section Tests.

Local Open Scope Z_scope.

Obligation Tactic :=
  match goal with
  | |- NZ ?x => let H := fresh in
      hnf; destruct (decide (x <> 0)) as [H | H]; auto
  end || auto.

(* 42 * x ^ 3 + 7 + 13 * x *)
Program Let p : poly := insert (N.add N.one N.two) (exist NZ 42 _)
  (insert N.zero (exist NZ 7 _) (insert N.one (exist NZ 13 _) empty)).

(* 3 * x ^ 4 + x + 5 *)
Program Let q : poly := insert (N.add N.two N.two) (exist NZ 3 _)
  (insert N.one (exist NZ 1 _) (insert N.zero (exist NZ 5 _) empty)).

Compute fmap (fun '(x, y) => (x, `y)) (map_to_list (poly_mul p q)).
Compute map_to_list
  (map_semifree_prod N.add (fun x y => Z.mul (`x) (`y)) p q : Nmap (list Z)).
Compute map_to_list (fmap (fold_right Z.add Z.zero)
  (map_semifree_prod N.add (fun x y => Z.mul (`x) (`y)) p q : Nmap (list Z))).
Compute fmap (fun '(x, y) => (x, `y)) (map_to_list (poly_mult p q)).

(* 7, 5 *)
Compute poly_eval p 0.
Compute poly_eval q 0.

(* 1180, 251 *)
Compute poly_eval p 3.
Compute poly_eval q 3.

(* None, PLeaf *)
(* Compute poly_add p (poly_neg p).
Compute poly_add (poly_neg q) q. *)

(* 12, 1431 *)
Compute poly_eval (poly_add p q) 0.
Compute poly_eval (poly_add p q) 3.

(* 35, 296180 *)
Compute poly_eval (poly_mul p q) 0.
Compute poly_eval (poly_mul p q) 3.

End Tests.

Module Additive.

Import OneSorted.AdditiveNotations.
Import OneSorted.ArithmeticNotations.

Section Context.

Context {A : Type} `{is_ring : IsRing A} `{eq_dec : EqDecision A}.

(** Performing this specialization by hand aids type inference. *)

Let poly := poly (A := A).

Ltac conversions := typeclasses
  convert bin_op into (add (A := poly)) and
  null_op into (zero (A := poly)) and
  un_op into (neg (A := poly)) or
  convert bin_op into (mul (A := poly)) and
  null_op into (one (A := poly)) or
  convert bin_op into (add (A := A)) and
  null_op into (zero (A := A)) and
  un_op into (neg (A := A)) or
  convert bin_op into (mul (A := A)) and
  null_op into (one (A := A)).

Global Instance poly_has_bin_op : HasBinOp poly := poly_add.
Global Instance poly_has_null_op : HasNullOp poly := poly_zero.
Global Instance poly_has_un_op : HasUnOp poly := poly_neg.

Global Instance poly_bin_op_is_mag : IsMag poly bin_op.
Proof. Defined.

Global Instance poly_bin_op_is_assoc : IsAssoc poly bin_op.
Proof.
  intros x y z.
  cbv [bin_op poly_has_bin_op poly_add].
  cbv [union_with map_union_with].
  apply (merge_assoc' (option_union_with nza_add)).
  typeclasses eauto. Defined.

Global Instance poly_bin_op_is_sgrp : IsSgrp poly bin_op.
Proof. split; typeclasses eauto. Defined.

Global Instance poly_bin_op_is_comm : IsComm poly bin_op.
Proof.
  intros x y. cbv [bin_op poly_has_bin_op poly_add].
  cbv [union_with map_union_with].
  apply (merge_comm' (option_union_with nza_add)).
  typeclasses eauto. Defined.

Global Instance poly_bin_op_is_comm_sgrp : IsCommSgrp poly bin_op.
Proof. split; typeclasses eauto. Defined.

Global Instance poly_bin_op_null_op_is_l_unl : IsLUnl poly bin_op null_op.
Proof.
  intros x. cbv [bin_op poly_has_bin_op poly_add
  null_op poly_has_null_op poly_zero].
  cbv [union_with map_union_with].
  apply (left_id empty (merge (option_union_with nza_add))). Defined.

Global Instance poly_bin_op_null_op_is_r_unl : IsRUnl poly bin_op null_op.
Proof.
  intros x. cbv [bin_op poly_has_bin_op poly_add
  null_op poly_has_null_op poly_zero].
  cbv [union_with map_union_with].
  apply (right_id empty (merge (option_union_with nza_add))). Defined.

Global Instance poly_bin_op_null_op_is_unl : IsUnl poly bin_op null_op.
Proof. split; typeclasses eauto. Defined.

Global Instance poly_bin_op_null_op_is_mon : IsMon poly bin_op null_op.
Proof. split; typeclasses eauto. Defined.

Global Instance poly_bin_op_null_op_is_comm_mon :
  IsCommMon poly bin_op null_op.
Proof. split; typeclasses eauto. Defined.

Global Instance poly_bin_op_null_op_un_op_is_l_inv :
  IsLInv poly bin_op null_op un_op.
Proof.
  intros x. cbv [bin_op poly_has_bin_op poly_add
  null_op poly_has_null_op poly_zero
  un_op poly_has_un_op poly_neg].
  cbv [union_with map_union_with].
  replace option_union_with with (union_with (M := option NZA))
  by reflexivity.
  generalize dependent x. apply (map_ind (M := Nmap)).
  - rewrite fmap_empty. apply (merge_empty (option_union_with nza_add)).
  - intros i x m. intros H IH.
    rewrite fmap_insert.
    rewrite <- (insert_merge_None (union_with nza_add)).
    rewrite delete_notin; auto. rewrite IH. apply (lookup_empty (A := NZA) i).
    apply nza_add_nza_neg_l. Defined.

Global Instance poly_bin_op_null_op_un_op_is_r_inv :
  IsRInv poly bin_op null_op un_op.
Proof.
  intros x. cbv [bin_op poly_has_bin_op poly_add
  null_op poly_has_null_op poly_zero
  un_op poly_has_un_op poly_neg].
  cbv [union_with map_union_with].
  replace option_union_with with (union_with (M := option NZA))
  by reflexivity.
  generalize dependent x. apply (map_ind (M := Nmap)).
  - rewrite fmap_empty. apply (merge_empty (option_union_with nza_add)).
  - intros i x m. intros H IH.
    rewrite fmap_insert.
    rewrite <- (insert_merge_None (union_with nza_add)).
    rewrite delete_notin; auto. rewrite IH. apply (lookup_empty (A := NZA) i).
    apply nza_add_nza_neg_r. Defined.

Global Instance poly_bin_op_null_op_un_op_is_inv :
  IsInv poly bin_op null_op un_op.
Proof. split; typeclasses eauto. Defined.

Global Instance poly_bin_op_null_op_un_op_is_grp :
  IsGrp poly bin_op null_op un_op.
Proof. split; typeclasses eauto. Defined.

Global Instance poly_bin_op_null_op_un_op_is_ab_grp :
  IsAbGrp poly bin_op null_op un_op.
Proof. split; typeclasses eauto. Defined.

End Context.

End Additive.

Module Multiplicative.

Import OneSorted.MultiplicativeNotations.
Import OneSorted.ArithmeticNotations.

Section Context.

Context {A : Type} `{is_ring : IsRing A} `{eq_dec : EqDecision A}.

Let poly := poly (A := A).

Global Instance poly_has_bin_op : HasBinOp poly := poly_mul.
Global Instance poly_has_null_op : HasNullOp poly := poly_one.

Global Instance poly_bin_op_is_mag : IsMag poly bin_op.
Proof. Defined.

Global Instance poly_bin_op_is_assoc : IsAssoc poly bin_op.
Proof. intros x y z. Admitted.

Global Instance poly_bin_op_is_sgrp : IsSgrp poly bin_op.
Proof. split; typeclasses eauto. Defined.

Global Instance poly_bin_op_is_comm : IsComm poly bin_op.
Proof.
  intros x y.
  cbv [bin_op poly_has_bin_op]; cbv [poly_mul].
  generalize dependent x. Admitted.

Global Instance poly_bin_op_is_comm_sgrp : IsCommSgrp poly bin_op.
Proof. split; typeclasses eauto. Defined.

Global Instance poly_bin_op_null_op_is_l_unl : IsLUnl poly bin_op null_op.
Proof.
  intros x.
  cbv [bin_op poly_has_bin_op]; cbv [poly_mul].
  match goal with
  |- map_fold ?e _ _ = _ => set (f := e)
  end.
  cbv [null_op poly_has_null_op]; cbv [poly_one].
  destruct (decide (1 <> 0)) as [H10 | H10].
  epose proof (insert_empty (M := Nmap) 0 (exist NZ 1 _)) as H.
  rewrite <- H. clear H.
  epose proof map_fold_insert_L _ (empty (A := Nmap NZA)) 0 (exist NZ 1 _) (empty (A := Nmap NZA)) as H.
  rewrite H. clear H. rewrite map_fold_empty. cbv [f]. cbn. clear f. admit.
  shelve. reflexivity. rewrite (map_fold_empty (M := Nmap) f).
  apply dec_stable in H10. (* use Is.OneSorted.Ring.degenerate. *)
  Admitted.

Global Instance poly_bin_op_null_op_is_r_unl : IsRUnl poly bin_op null_op.
Proof. intros x. Admitted.

Global Instance poly_bin_op_null_op_is_unl : IsUnl poly bin_op null_op.
Proof. split; typeclasses eauto. Defined.

Global Instance poly_bin_op_null_op_is_mon : IsMon poly bin_op null_op.
Proof. split; typeclasses eauto. Defined.

Global Instance poly_bin_op_null_op_is_comm_mon :
  IsCommMon poly bin_op null_op.
Proof. split; typeclasses eauto. Defined.

End Context.

End Multiplicative.

Import OneSorted.ArithmeticNotations.
Import OneSorted.ArithmeticOperationNotations.

Section Context.

Context {A : Type} `{is_ring : IsRing A} `{eq_dec : EqDecision A}.

Let poly := poly (A := A).

Global Instance poly_has_add : HasAdd poly := poly_add.
Global Instance poly_has_zero : HasZero poly := poly_zero.
Global Instance poly_has_neg : HasNeg poly := poly_neg.
Global Instance poly_has_mul : HasMul poly := poly_mul.
Global Instance poly_has_one : HasOne poly := poly_one.
Global Instance poly_has_l_act : HasLAct A poly := poly_l_act.
Global Instance poly_has_r_act : HasRAct A poly := poly_r_act.

Ltac conversions := typeclasses
  convert bin_op into (add (A := poly)) and
  null_op into (zero (A := poly)) and
  un_op into (neg (A := poly)) or
  convert bin_op into (mul (A := poly)) and
  null_op into (one (A := poly)) or
  convert bin_op into (add (A := A)) and
  null_op into (zero (A := A)) and
  un_op into (neg (A := A)) or
  convert bin_op into (mul (A := A)) and
  null_op into (one (A := A)).

Global Instance poly_add_mul_is_l_distr : IsLDistr poly add mul.
Proof. intros x y z. Admitted.

Global Instance poly_add_mul_is_r_distr : IsRDistr poly add mul.
Proof. intros x y z. Admitted.

Global Instance poly_add_mul_is_distr : IsDistr poly add mul.
Proof. split; typeclasses eauto. Defined.

Global Instance poly_zero_mul_is_l_absorb : IsLAbsorb poly zero mul.
Proof. intros x. Admitted.

Global Instance poly_zero_mul_is_r_absorb : IsRAbsorb poly zero mul.
Proof. intros x. Admitted.

Global Instance poly_zero_mul_is_absorb : IsAbsorb poly zero mul.
Proof. split; typeclasses eauto. Defined.

Global Instance poly_add_zero_mul_one_is_sring : IsSring poly add zero mul one.
Proof. split; typeclasses eauto. Defined.

Global Instance poly_add_zero_mul_one_is_comm_sring :
  IsCommSring poly add zero mul one.
Proof. split; typeclasses eauto. Defined.

Global Instance poly_add_zero_neg_mul_one_is_ring :
  IsRing poly add zero neg mul one.
Proof. split; typeclasses eauto. Defined.

Global Instance poly_mul_is_comm : IsComm poly mul.
Proof. intros x y. Admitted.

Global Instance poly_add_zero_neg_mul_one_is_comm_ring :
  IsCommRing poly add zero neg mul one.
Proof. split; typeclasses eauto. Defined.

Global Instance poly_is_grd_ring : IsGrdRing (fun i : N => A)
  (fun i : N => add) (fun i : N => zero) (fun i : N => neg)
  (fun i j : N => mul) one.
Proof. repeat split. Abort.

Global Instance add_zero_neg_mul_one_is_alg :
  IsAlg A poly add zero neg mul one add zero neg mul l_act r_act.
Proof. split; try typeclasses eauto. Admitted.

Global Instance add_zero_neg_mul_one_is_assoc_alg :
  IsAssocAlg A poly add zero neg mul one add zero neg mul l_act r_act.
Proof. split; typeclasses eauto. Defined.

Global Instance add_zero_neg_mul_one_is_unl_assoc_alg :
  IsUnlAssocAlg A poly add zero neg mul one add zero neg mul one l_act r_act.
Proof. split; typeclasses eauto. Defined.

End Context.
