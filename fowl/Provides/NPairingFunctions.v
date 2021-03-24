From Coq Require Import
  Lia Lists.List NArith.NArith.
From Maniunfold Require Import
  Equations.
From Maniunfold.Has Require Export
  OneSorted.Decision.
From Maniunfold.Provides Require Export
  OptionTheorems PositiveTheorems ProductTheorems NTriangularNumbers.

Import ListNotations N.

Local Open Scope N_scope.

(** Whether the given number is a power of two or not. *)

Equations pos_bin (n : positive) : bool :=
  pos_bin (xO p) := pos_bin p;
  pos_bin (xI p) := false;
  pos_bin xH := true.

(** Whether the given number is a power of two or not. *)

Equations bin (n : N) : bool :=
  bin N0 := false;
  bin (Npos p) := pos_bin p.

(** Split the given positive number into a binary factor and an odd factor.

    See [pos_binfactor] and [pos_oddfactor] for details on the factors.
    This function is an inverse of [pos_binoddprod]. *)

Equations pos_binoddfactor (n : positive) : N * positive :=
  pos_binoddfactor (xI p) := (0, xI p);
  pos_binoddfactor (xO p) := let (b, c) := pos_binoddfactor p in (succ b, c);
  pos_binoddfactor xH := (0, xH).

(** Combine the given binary factor and odd factor into a positive number.

    This function is an inverse of [pos_binoddfactor]. *)

Equations pos_binoddprod (b : N) (c : positive) : positive :=
  pos_binoddprod b c := c * Pos.shiftl 1 b.

(** This function is a dependent version of [pos_binoddfactor]. *)

Equations pos_binoddfactor_dep (n : positive) :
  {x : N * positive $ Squash (pos_odd (snd x))} :=
  pos_binoddfactor_dep n := Sexists _ (pos_binoddfactor n) _.
Next Obligation.
  intros n.
  apply squash.
  induction n as [p ep | p ep |].
  - reflexivity.
  - simp pos_binoddfactor.
    destruct (pos_binoddfactor p) as [b c].
    apply ep.
  - reflexivity. Qed.

(** This function is a dependent version of [pos_binoddprod]. *)

Equations pos_binoddprod_dep
  (b : N) (c : positive) (e : Squash (pos_odd c)) : positive :=
  pos_binoddprod_dep b c e := pos_binoddprod b c.

(** Find the binary factor of the given positive number.

    The factor is
    - the largest power of two to divide the given number and
    - the number of trailing zeros
      in the binary representation of the given number.
    This function generates the OEIS sequence A007814. *)

Equations pos_binfactor (n : positive) : N :=
  pos_binfactor n := fst (pos_binoddfactor n).

(** Find the odd factor of the given positive number.

    The factor is
    - the largest odd number to divide the given number and
    - whatever remains of the given number
      after removing trailing zeros from its binary representation.
    This function generates the OEIS sequence A000265. *)

Equations pos_oddfactor (n : positive) : positive :=
  pos_oddfactor n := snd (pos_binoddfactor n).

(** The function [pos_binoddfactor] can be written in components. *)

Lemma pair_pos_binoddfactor (n : positive) :
  pos_binoddfactor n = (pos_binfactor n, pos_oddfactor n).
Proof.
  simp pos_binfactor. simp pos_oddfactor.
  destruct (pos_binoddfactor n) as [b c].
  reflexivity. Qed.

(** The binary factor of a power of two is
    the binary logarithm of the number. *)

Lemma bin_pos_binfactor (n : positive) (e : pos_bin n) :
  pos_binfactor n = pos_log2 n.
Proof.
  induction n as [p ep | p ep |].
  - inversion e.
  - simp pos_binfactor. simp pos_binoddfactor.
    assert (e' : pos_bin p) by assumption.
    specialize (ep e').
    simp pos_binfactor in ep.
    destruct (pos_binoddfactor p) as [b c].
    simp fst in ep.
    rewrite ep.
    reflexivity.
  - reflexivity. Qed.

(** The odd factor of an odd number is the number itself. *)

Lemma odd_pos_oddfactor (n : positive) (e : pos_odd n) :
  pos_oddfactor n = n.
Proof.
  destruct n as [p | p |].
  - reflexivity.
  - inversion e.
  - reflexivity. Qed.

(** The binary factor of an odd number is zero. *)

Lemma odd_pos_binfactor (n : positive) (e : pos_odd n) :
  pos_binfactor n = 0.
Proof.
  destruct n as [p | p |].
  - reflexivity.
  - inversion e.
  - reflexivity. Qed.

(** The odd factor of a power of two is one. *)

Lemma bin_pos_oddfactor (n : positive) (e : pos_bin n) :
  pos_oddfactor n = 1%positive.
Proof.
  induction n as [p ep | p ep |].
  - inversion e.
  - simp pos_oddfactor. simp pos_binoddfactor.
    assert (e' : pos_bin p) by assumption.
    specialize (ep e').
    simp pos_oddfactor in ep.
    destruct (pos_binoddfactor p) as [b c].
    simp snd in ep.
  - reflexivity. Qed.

(** The function [pos_binoddprod] is an inverse of [pos_binoddfactor]. *)

Lemma pos_binoddprod_pos_binoddfactor (n : positive) :
  prod_uncurry pos_binoddprod (pos_binoddfactor n) = n.
Proof.
  destruct (pos_binoddfactor n) as [b c] eqn : e.
  simp prod_uncurry. simp pos_binoddprod.
  generalize dependent b. induction n as [p ep | p ep |]; intros b e.
  - simp pos_binoddfactor in e.
    injection e. clear e. intros ec eb. subst b c.
    rewrite pos_shiftl_0_r. rewrite Pos.mul_1_r.
    reflexivity.
  - simp pos_binoddfactor in e.
    destruct (pos_binoddfactor p) as [b' c'] eqn : e'.
    injection e. clear e. intros ec eb. subst b c.
    rewrite pos_shiftl_succ_r'. rewrite Pos.mul_xO_r.
    rewrite ep by reflexivity.
    reflexivity.
  - simp pos_binoddfactor in e.
    injection e. clear e. intros ec eb. subst b c.
    reflexivity. Qed.

(** The function [pos_binoddfactor] is not an inverse of [pos_binoddprod]. *)

Lemma not_pos_binoddfactor_pos_binoddprod : ~ forall (b : N) (c : positive),
  pos_binoddfactor (pos_binoddprod b c) = (b, c).
Proof. intros e. specialize (e 2%N 2%positive). cbv in e. inversion e. Qed.

(** The function [pos_binoddfactor] is an inverse of [pos_binoddprod]
    when the second factor is odd. *)

Lemma pos_binoddfactor_pos_binoddprod (b : N) (c : positive) (e : pos_odd c) :
  pos_binoddfactor (pos_binoddprod b c) = (b, c).
Proof.
  simp pos_binoddprod.
  destruct b as [| p].
  - rewrite pos_shiftl_0_r. rewrite Pos.mul_1_r.
    rewrite pair_pos_binoddfactor.
    rewrite odd_pos_binfactor by assumption.
    rewrite odd_pos_oddfactor by assumption.
    reflexivity.
  - induction p as [| q eq] using Pos.peano_ind.
    + simp shiftl. simp iter.
      rewrite (Pos.mul_comm c 2). change (2 * c)%positive with (xO c).
      simp pos_binoddfactor.
      rewrite pair_pos_binoddfactor.
      rewrite odd_pos_binfactor by assumption.
      rewrite odd_pos_oddfactor by assumption.
      reflexivity.
    + simp shiftl. simp shiftl in eq.
      rewrite Pos.iter_succ.
      rewrite Pos.mul_xO_r.
      simp pos_binoddfactor.
      rewrite eq by assumption.
      reflexivity. Qed.

(** The function [pos_binoddprod_dep] is an inverse
    of [pos_binoddfactor_dep]. *)

Lemma pos_binoddprod_dep_pos_binoddfactor_dep (n : positive) :
  Ssig_uncurry (prod_uncurry_dep pos_binoddprod_dep)
  (pos_binoddfactor_dep n) = n.
Proof. apply (pos_binoddprod_pos_binoddfactor n). Qed.

(** The function [pos_binoddfactor_dep] is an inverse
    of [pos_binoddprod_dep]. *)

Lemma pos_binoddfactor_dep_pos_binoddprod_dep
  (b : N) (c : positive) (e : Squash (pos_odd c)) :
  pos_binoddfactor_dep (pos_binoddprod_dep b c e) = Sexists _ (b, c) e.
Proof.
  simp pos_binoddprod_dep. simp pos_binoddfactor_dep.
  apply Spr1_inj.
  simp Spr1.
  apply pos_binoddfactor_pos_binoddprod.
  (** TODO Instances! *)
  assert (HasDec (pos_odd c)).
  { hnf. cbv [pos_odd negb pos_even]. destruct c. all: intuition. }
  apply unsquash in e. auto. Qed.

(** Split the given natural number into a binary factor and an odd factor,
    except for the degenerate case at zero.

    See [pos_binoddfactor] for details on this function. *)

Equations binoddfactor (n : N) : N * N :=
  binoddfactor N0 := (0, 0);
  binoddfactor (Npos p) := let (b, c) := pos_binoddfactor p in (b, Npos c).

(** Combine the given binary factor and odd factor into a natural number,
    except for the degenerate case at zero.

    See [pos_binoddprod] for details on this function. *)

Equations binoddprod (b c : N) : N :=
  binoddprod b N0 := 0;
  binoddprod b (Npos p) := Npos (pos_binoddprod b p).

(** The function [binoddprod] has an arithmetic form. *)

Lemma binoddprod_eqn (b c : N) : binoddprod b c = c * 2 ^ b.
Proof.
  destruct c as [| p].
  - reflexivity.
  - simp binoddprod.
    simp pos_binoddprod.
    rewrite <- shiftl_1_l.
    reflexivity. Qed.

(** Find the binary factor of the given positive number.
    except for the degenerate case at zero.

    See [pos_binfactor] for details on this function. *)

Equations binfactor (n : N) : N :=
  binfactor n := fst (binoddfactor n).

(** Find the odd factor of the given positive number.
    except for the degenerate case at zero.

    See [pos_oddfactor] for details on this function. *)

Equations oddfactor (n : N) : N :=
  oddfactor n := snd (binoddfactor n).

(** The function [binoddprod] is an inverse of [binoddfactor]. *)

Lemma binoddprod_binoddfactor (n : N) :
  prod_uncurry binoddprod (binoddfactor n) = n.
Proof.
  destruct n as [| p].
  - reflexivity.
  - pose proof pos_binoddprod_pos_binoddfactor p as e.
    simp binoddfactor.
    destruct (pos_binoddfactor p) as [b c].
    cbv [prod_uncurry fst snd]. simp binoddprod.
    cbv [prod_uncurry fst snd] in e.
    rewrite e.
    reflexivity. Qed.

(** The function [binoddfactor] is not an inverse of [binoddprod]. *)

Lemma not_binoddfactor_binoddprod : ~ forall b c : N,
  binoddfactor (binoddprod b c) = (b, c).
Proof.
  intros e.
  apply not_pos_binoddfactor_pos_binoddprod.
  intros b c.
  specialize (e b (Npos c)).
  simp binoddprod in e. simp binoddfactor in e.
  destruct (pos_binoddfactor (pos_binoddprod b c)) as [b' c'].
  injection e. clear e. intros ec eb. subst b c.
  reflexivity. Qed.

(** The function [binoddfactor] is an inverse of [binoddprod]
    when the second factor is odd. *)

Lemma odd_binoddfactor_binoddprod (b c : N) (e : odd c) :
  binoddfactor (binoddprod b c) = (b, c).
Proof.
  destruct b as [| p], c as [| q].
  - reflexivity.
  - rewrite binoddprod_eqn.
    rewrite pow_0_r. rewrite mul_1_r.
    simp binoddfactor.
    rewrite pair_pos_binoddfactor.
    rewrite odd_pos_binfactor by assumption.
    rewrite odd_pos_oddfactor by assumption.
    reflexivity.
  - inversion e.
  - rewrite binoddprod_eqn.
    change (Npos q * 2 ^ Npos p) with (Npos (q * 2 ^ p)).
    simp binoddfactor.
    change (q * 2 ^ p)%positive with (pos_binoddprod (Npos p) q).
    rewrite pos_binoddfactor_pos_binoddprod by assumption.
    reflexivity. Qed.

Module PairingFunction.

Class HasSize : Type := size (a : N) : positive.

Class HasShellPair : Type := shell_pair (n : N) : N * N.

Class HasShellPairDep `(HasSize) : Type :=
  shell_pair_dep (n : N) : {x : N * N $ Squash (snd x < Npos (size (fst x)))}.

Global Instance has_shell_pair `(HasSize) `(!HasShellPairDep size) :
  HasShellPair := fun n : N =>
  Spr1 (shell_pair_dep n).

Class HasUnshellPair : Type := unshell_pair (a b : N) : N.

Class HasUnshellPairDep `(HasSize) : Type :=
  unshell_pair_dep (a b : N) (l : Squash (b < Npos (size a))) : N.

Global Instance has_unshell_pair_dep `(HasSize) `(HasUnshellPair) :
  HasUnshellPairDep size := fun (a b : N) (l : Squash (b < pos (size a))) =>
  unshell_pair a b.

Class HasShellUnpair : Type := shell_unpair (x y : N) : N * N.

Class HasShellUnpairDep `(HasSize) : Type :=
  shell_unpair_dep (x y : N) :
  {x : N * N $ Squash (snd x < Npos (size (fst x)))}.

Global Instance has_shell_unpair `(HasSize) `(!HasShellUnpairDep size) :
  HasShellUnpair := fun x y : N =>
  Spr1 (shell_unpair_dep x y).

Class HasUnshellUnpair : Type := unshell_unpair (a b : N) : N * N.

Class HasUnshellUnpairDep `(HasSize) : Type :=
  unshell_unpair_dep (a b : N) (l : Squash (b < Npos (size a))) : N * N.

Global Instance has_unshell_unpair_dep `(HasSize) `(HasUnshellUnpair) :
  HasUnshellUnpairDep size := fun (a b : N) (l : Squash (b < pos (size a))) =>
  unshell_unpair a b.

Class HasPairing `(HasSize)
  `(!HasShellPairDep size) `(!HasUnshellPairDep size)
  `(!HasShellUnpairDep size) `(!HasUnshellUnpairDep size) : Type :=
  pairing : unit.

Global Instance has_pairing `(HasSize)
  `(!HasShellPairDep size) `(!HasUnshellPairDep size)
  `(!HasShellUnpairDep size) `(!HasUnshellUnpairDep size) : HasPairing size
  shell_pair_dep unshell_pair_dep shell_unpair_dep unshell_unpair_dep := tt.

Class IsUnshellPairDepShellPairDep `(HasPairing) : Prop :=
  unshell_pair_dep_shell_pair_dep (n : N) :
  Ssig_uncurry (prod_uncurry_dep unshell_pair_dep) (shell_pair_dep n) = n.

Class IsShellPairDepUnshellPairDep `(HasPairing) : Prop :=
  shell_pair_dep_unshell_pair_dep (a b : N) (l : Squash (b < Npos (size a))) :
  shell_pair_dep (unshell_pair_dep a b l) = Sexists _ (a, b) l.

Class IsUnshellUnpairDepShellUnpairDep `(HasPairing) : Prop :=
  unshell_unpair_dep_shell_unpair_dep (x y : N) :
  Ssig_uncurry (prod_uncurry_dep unshell_unpair_dep) (shell_unpair_dep x y) =
  (x, y).

Class IsShellUnpairDepUnshellUnpairDep `(HasPairing) : Prop :=
  shell_unpair_dep_unshell_unpair_dep
  (a b : N) (l : Squash (b < Npos (size a))) :
  prod_uncurry shell_unpair_dep (unshell_unpair_dep a b l) =
  Sexists _ (a, b) l.

Class IsPairing `(HasPairing) : Prop := {
  pairing_is_unshell_pair_dep_shell_pair_dep :>
    IsUnshellPairDepShellPairDep pairing;
  pairing_is_shell_pair_dep_unshell_pair_dep :>
    IsShellPairDepUnshellPairDep pairing;
  pairing_is_unshell_unpair_dep_shell_unpair_dep :>
    IsUnshellUnpairDepShellUnpairDep pairing;
  pairing_is_shell_unpair_dep_unshell_unpair_dep :>
    IsShellUnpairDepUnshellUnpairDep pairing;
}.

Section Context.

Context `{IsPairing}.

Fail Equations pair (n : N) : N * N :=
  pair n := prod_uncurry unshell_unpair (shell_pair n).

Equations pair (n : N) : N * N :=
  pair n := Ssig_uncurry (prod_uncurry_dep unshell_unpair_dep)
    (shell_pair_dep n).

Fail Equations unpair (x y : N) : N :=
  unpair x y := prod_uncurry unshell_pair (shell_unpair x y).

Equations unpair (x y : N) : N :=
  unpair x y := Ssig_uncurry (prod_uncurry_dep unshell_pair_dep)
    (shell_unpair_dep x y).

Theorem unpair_pair (n : N) : prod_uncurry unpair (pair n) = n.
Proof.
  destruct (pair n) as [x y] eqn : exy.
  simp pair in exy.
  destruct (shell_pair_dep n) as [[a b] l] eqn : eab.
  simp Ssig_uncurry in exy. simp prod_uncurry_dep in exy.
  simp prod_uncurry. simp unpair.
  destruct (shell_unpair_dep x y) as [[a' b'] l'] eqn : eab'.
  simp Ssig_uncurry. simp prod_uncurry_dep.
  pose proof shell_unpair_dep_unshell_unpair_dep a b l as loop_t.
  pose proof unshell_pair_dep_shell_pair_dep n as loop_s.
  (** We need to reduce implicit arguments before rewriting. *)
  unfold size in loop_t.
  (** Contract [t ^-1]. *)
  rewrite exy in loop_t.
  simp prod_uncurry in loop_t. rewrite eab' in loop_t.
  inversion loop_t; subst a' b'.
  (* assert (l' = l) by reflexivity; subst l'. *)
  clear loop_t.
  (** Contract [s]. *)
  rewrite eab in loop_s.
  simp Ssig_uncurry in loop_s. Qed.

Theorem pair_unpair (x y : N) : pair (unpair x y) = (x, y).
Proof.
  simp pair.
  destruct (shell_pair_dep (unpair x y)) as [[a b] l] eqn : eab.
  simp unpair in eab.
  destruct (shell_unpair_dep x y) as [[a' b'] l'] eqn : eab'.
  simp Ssig_uncurry in eab. simp prod_uncurry_dep in eab.
  simp Ssig_uncurry. simp prod_uncurry_dep.
  pose proof shell_pair_dep_unshell_pair_dep a' b' l' as loop_s.
  pose proof unshell_unpair_dep_shell_unpair_dep x y as loop_t.
  (** We need to reduce implicit arguments before rewriting. *)
  unfold size in loop_s.
  (** Contract [s ^-1]. *)
  rewrite eab in loop_s.
  inversion loop_s; subst a' b'.
  (* assert (l' = l) by reflexivity; subst l'. *)
  clear loop_s.
  (** Contract [t]. *)
  rewrite eab' in loop_t.
  simp Ssig_uncurry in loop_t. Qed.

End Context.

End PairingFunction.

Module Cantor.

Equations size (a : N) : positive :=
  size a := succ_pos a.

Equations shell_pair (n : N) : N * N :=
  shell_pair n := untri_rem n.

Equations shell_pair_dep (n : N) :
  {x : N * N $ Squash (snd x < Npos (size (fst x)))} :=
  shell_pair_dep n := Sexists _ (shell_pair n) _.
Next Obligation.
  intros n.
  apply squash.
  simp size.
  rewrite succ_pos_spec.
  simp shell_pair.
  rewrite untri_rem_tri_untri.
  simp fst snd.
  pose proof tri_untri_untri_rem n as l.
  lia. Qed.

Equations unshell_pair (a b : N) : N :=
  unshell_pair a b := b + tri a.

Equations unshell_pair_dep
  (a b : N) (l : Squash (b < Npos (size a))) : N :=
  unshell_pair_dep a b l := unshell_pair a b.

Lemma unshell_pair_dep_shell_pair_dep (n : N) :
  Ssig_uncurry (prod_uncurry_dep unshell_pair_dep) (shell_pair_dep n) = n.
Proof.
  cbv [Ssig_uncurry Spr1 Spr2].
  simp shell_pair_dep.
  cbv [prod_uncurry_dep].
  simp unshell_pair_dep.
  simp unshell_pair.
  simp shell_pair.
  rewrite untri_rem_tri_untri.
  cbv [fst snd].
  pose proof tri_untri n as l.
  lia. Qed.

Lemma shell_pair_dep_unshell_pair_dep
  (a b : N) (l : Squash (b < Npos (size a))) :
  shell_pair_dep (unshell_pair_dep a b l) = Sexists _ (a, b) l.
Proof.
  simp shell_pair_dep.
  apply Spr1_inj.
  cbv [Spr1].
  simp shell_pair.
  simp unshell_pair_dep.
  simp unshell_pair.
  eapply unsquash in l.
  simp size in l.
  rewrite succ_pos_spec in l.
  rewrite untri_rem_tri_untri.
  assert (l' : b <= a) by lia.
  pose proof tri_why a b l' as e.
  rewrite e.
  f_equal. lia.
  Unshelve.
  (** TODO Instances! *)
  apply A_has_unsquash. destruct (N.ltb_spec0 b (Npos (size a))).
  - left. lia.
  - right. lia. Qed.

Equations shell_unpair (x y : N) : N * N :=
  shell_unpair x y := (y + x, y).

Equations shell_unpair_dep (x y : N) :
  {x : N * N $ Squash (snd x < Npos (size (fst x)))} :=
  shell_unpair_dep x y := Sexists _ (shell_unpair x y) _.
Next Obligation.
  intros x y.
  apply squash.
  simp size.
  rewrite succ_pos_spec.
  simp shell_unpair.
  simp fst snd.
  lia. Qed.

Equations unshell_unpair (a b : N) : N * N :=
  unshell_unpair a b := (a - b, b).

Equations unshell_unpair_dep (a b : N)
  (l : Squash (b < Npos (size a))) : N * N :=
  unshell_unpair_dep a b l := unshell_unpair a b.

Lemma unshell_unpair_dep_shell_unpair_dep (x y : N) :
  Ssig_uncurry (prod_uncurry_dep unshell_unpair_dep) (shell_unpair_dep x y) =
  (x, y).
Proof.
  cbv [Ssig_uncurry Spr1 Spr2].
  simp shell_unpair_dep.
  cbv [prod_uncurry_dep].
  simp unshell_unpair_dep.
  simp unshell_unpair.
  simp shell_unpair.
  cbv [fst snd].
  f_equal.
  lia. Qed.

Lemma shell_unpair_dep_unshell_unpair_dep
  (a b : N) (l : Squash (b < Npos (size a))) :
  prod_uncurry shell_unpair_dep (unshell_unpair_dep a b l) =
  Sexists _ (a, b) l.
Proof.
  cbv [prod_uncurry].
  simp shell_unpair_dep.
  apply Spr1_inj.
  cbv [Spr1].
  simp unshell_unpair_dep.
  simp unshell_unpair.
  simp shell_unpair.
  cbv [fst snd].
  f_equal.
  eapply unsquash in l.
  simp size in l.
  rewrite succ_pos_spec in l.
  lia. Unshelve.
  (** TODO Instances! *)
  apply A_has_unsquash. destruct (N.ltb_spec0 b (Npos (size a))).
  - left. lia.
  - right. lia. Qed.

Module PF := PairingFunction.

Global Instance has_size : PF.HasSize := size.
Global Instance has_shell_pair_dep : PF.HasShellPairDep size := shell_pair_dep.
Global Instance has_unshell_pair_dep : PF.HasUnshellPairDep size := unshell_pair_dep.
Global Instance has_shell_unpair_dep : PF.HasShellUnpairDep size := shell_unpair_dep.
Global Instance has_unshell_unpair_dep : PF.HasUnshellUnpairDep size := unshell_unpair_dep.
Global Instance has_pairing : PF.HasPairing size shell_pair_dep unshell_pair_dep shell_unpair_dep unshell_unpair_dep := tt.

Global Instance is_unshell_pair_dep_shell_pair_dep : PF.IsUnshellPairDepShellPairDep PF.pairing.
Proof. exact @unshell_pair_dep_shell_pair_dep. Qed.
Global Instance is_shell_pair_dep_unshell_pair_dep : PF.IsShellPairDepUnshellPairDep PF.pairing.
Proof. exact @shell_pair_dep_unshell_pair_dep. Qed.
Global Instance is_unshell_unpair_dep_shell_unpair_dep : PF.IsUnshellUnpairDepShellUnpairDep PF.pairing.
Proof. exact @unshell_unpair_dep_shell_unpair_dep. Qed.
Global Instance is_shell_unpair_dep_unshell_unpair_dep : PF.IsShellUnpairDepUnshellUnpairDep PF.pairing.
Proof. exact @shell_unpair_dep_unshell_unpair_dep. Qed.
Global Instance is_pairing : PF.IsPairing PF.pairing.
Proof. esplit; typeclasses eauto. Qed.

Compute map PF.pair (seq 0 64).
Compute map (prod_uncurry PF.unpair o PF.pair) (seq 0 64).

End Cantor.

Module RosenbergStrong.

Definition pair_shell (n : N) : N := sqrt n.

Arguments pair_shell _ : assert.

(* Definition z (x : N) : N := 1 + 2 * x.
Definition sum_z (x : N) : N := x ^ 2.
Compute map z (seq 0 32).
Compute map sum_z (seq 0 32).
Compute map (fun x : N => (z x, sum_z (1 + x) - sum_z x)) (seq 0 32).
Program Fixpoint s (tot ix : N) (x : N) {measure (N.to_nat x)} : N * N :=
  if x <? z ix + tot then (ix, x - tot) else s (z ix + tot) (1 + ix) x.
Next Obligation. Admitted.
Next Obligation. Tactics.program_solve_wf. Defined.
Compute map (s 0 0) (seq 0 32).
Compute map sqrtrem (seq 0 32). *)

Definition unpair_shell (p q : N) : N := max q p.

Arguments unpair_shell _ _ : assert.

Definition pair (n : N) : N * N :=
  let (s, t) := sqrtrem n in
  if s <=? t then (s - (t - s), s) else (s, t).

Arguments pair _ : assert.

Definition unpair (p q : N) : N :=
  if p <=? q then (q - p) + q * (1 + q) else q + p * p.

Arguments unpair _ _ : assert.

Theorem unpair_shell_pair (n : N) :
  prod_uncurry unpair_shell (pair n) = pair_shell n.
Proof.
  cbv [prod_uncurry fst snd unpair_shell pair pair_shell].
  rewrite <- sqrtrem_sqrt. cbv [fst snd].
  destruct_sqrtrem s t est es e0st l1st.
  clear est es.
  destruct (leb_spec s t) as [lst | lst]; lia. Qed.

Theorem pair_shell_unpair (p q : N) :
  pair_shell (unpair p q) = unpair_shell p q.
Proof.
  cbv [pair_shell unpair unpair_shell].
  rewrite <- sqrtrem_sqrt. cbv [fst snd].
  destruct_sqrtrem s t est es e0st l1st.
  clear est es.
  destruct (leb_spec p q) as [lpq | lpq]; nia. Qed.

Theorem unpair_pair (n : N) : prod_uncurry unpair (pair n) = n.
Proof.
  cbv [prod_uncurry fst snd unpair pair].
  destruct_sqrtrem s t est es e0st l1st.
  clear est es.
  destruct (leb_spec s t) as [lst | lst].
  - destruct (leb_spec (s - (t - s)) s) as [lst' | lst']; lia.
  - destruct (leb_spec s t) as [lst' | lst']; lia. Qed.

Theorem pair_unpair (p q : N) : pair (unpair p q) = (p, q).
Proof.
  cbv [pair unpair].
  destruct_sqrtrem s t est es e0st l1st.
  clear est es.
  destruct (leb_spec s t) as [lst | lst].
  - destruct (leb_spec p q) as [lpq | lpq].
    + assert (e : s = q) by nia. subst s. f_equal; nia.
    + assert (f : s <> q) by nia. exfalso.
      assert (l : p <= s) by nia. nia.
  - destruct (leb_spec p q) as [lpq | lpq].
    + assert (f : s <> p) by nia. exfalso.
      assert (l : q < s) by nia. nia.
    + assert (e : s = p) by nia. subst s. f_equal; nia. Qed.

End RosenbergStrong.

Module Szudzik.

Definition pair_shell (n : N) : N := sqrt n.

Arguments pair_shell _ : assert.

Definition unpair_shell (p q : N) : N := max q p.

Arguments unpair_shell _ _ : assert.

Definition pair (n : N) : N * N :=
  let (s, t) := sqrtrem n in
  if s <=? t then (t - s, s) else (s, t).

Arguments pair _ : assert.

Definition unpair (p q : N) : N :=
  if p <=? q then p + q * (1 + q) else q + p * p.

Arguments unpair _ _ : assert.

(** Note how the three following proofs are
    nearly exactly the same as in [RosenbergStrong]. *)

Theorem unpair_shell_pair (n : N) :
  prod_uncurry unpair_shell (pair n) = pair_shell n.
Proof.
  cbv [prod_uncurry fst snd unpair_shell pair pair_shell].
  rewrite <- sqrtrem_sqrt. cbv [fst snd].
  destruct_sqrtrem s t est es e0st l1st.
  clear est es.
  destruct (leb_spec s t) as [lst | lst]; lia. Qed.

Theorem pair_shell_unpair (p q : N) :
  pair_shell (unpair p q) = unpair_shell p q.
Proof.
  cbv [pair_shell unpair unpair_shell].
  rewrite <- sqrtrem_sqrt. cbv [fst snd].
  destruct_sqrtrem s t est es e0st l1st.
  clear est es.
  destruct (leb_spec p q) as [lpq | lpq]; nia. Qed.

Theorem unpair_pair (n : N) : prod_uncurry unpair (pair n) = n.
Proof.
  cbv [prod_uncurry fst snd unpair pair].
  destruct_sqrtrem s t est es e0st l1st.
  clear est es.
  destruct (leb_spec s t) as [lst | lst].
  - destruct (leb_spec (t - s) s) as [lst' | lst']; lia.
  - destruct (leb_spec s t) as [lst' | lst']; lia. Qed.

Theorem pair_unpair (p q : N) : pair (unpair p q) = (p, q).
Proof.
  cbv [pair unpair].
  destruct_sqrtrem s t est es e0st l1st.
  clear est es.
  destruct (leb_spec s t) as [lst | lst].
  - destruct (leb_spec p q) as [lpq | lpq].
    + assert (e : s = q) by nia. subst s. f_equal; nia.
    + assert (f : s <> q) by nia. exfalso.
      assert (l : p <= s) by nia. nia.
  - destruct (leb_spec p q) as [lpq | lpq].
    + assert (f : s <> p) by nia. exfalso.
      assert (l : q < s) by nia. nia.
    + assert (e : s = p) by nia. subst s. f_equal; nia. Qed.

End Szudzik.

#[ugly]
Module Hausdorff.

Lemma pos_binfactor_even (n : positive) :
  pos_binfactor (2 * n) = 1 + pos_binfactor n.
Proof.
  induction n as [p ei | p ei |].
  - reflexivity.
  - cbn [pos_binfactor].
    replace (1 + succ (pos_binfactor p)) with (succ (1 + pos_binfactor p)) by lia.
    rewrite <- ei. reflexivity.
  - reflexivity. Qed.

Lemma pos_binfactor_even_succ (n : positive) :
  pos_binfactor (succ_pos (2 * Npos n - 1)) = 1 + pos_binfactor n.
Proof.
  induction n as [p ei | p ei |].
  - reflexivity.
  - cbn [pos_binfactor].
    replace (1 + succ (pos_binfactor p)) with (succ (1 + pos_binfactor p)) by lia.
    rewrite <- ei. reflexivity.
  - reflexivity. Qed.

Lemma part_factor (n : N) (f : n <> 0) :
  exists p q : N, n = (1 + 2 * q) * 2 ^ p.
Proof.
  destruct n as [| p].
  - contradiction.
  - exists (pos_binfactor p), ((pos_oddfactor p - 1) / 2). clear f.
    induction p as [q ei | q ei |].
    + cbn [pos_binfactor pos_oddfactor]. rewrite pow_0_r. rewrite mul_1_r.
      rewrite <- divide_div_mul_exact. rewrite (mul_comm 2 _). rewrite div_mul.
      lia. lia. lia. cbn. replace (q~0)%positive with (2 * q)%positive by lia.
      replace (pos (2 * q)%positive) with (2 * Npos q) by lia.
      apply divide_factor_l.
    + cbn [pos_binfactor pos_oddfactor]. rewrite pow_succ_r by lia.
      rewrite mul_assoc. lia.
    + reflexivity. Qed.

Lemma part_factor_again (p q : N) :
  exists n : N, n = (1 + 2 * q) * 2 ^ p.
Proof. exists ((1 + 2 * q) * 2 ^ p). reflexivity. Qed.

Lemma part_urgh (n : positive) :
  let p := pos_binfactor n in
  let q := (pos_oddfactor n - 1) / 2 in
  Npos n = (1 + 2 * q) * 2 ^ p.
Proof.
  intros p' q'. subst p' q'.
  induction n as [q ei | q ei |].
  + cbn [pos_binfactor pos_oddfactor]. rewrite pow_0_r. rewrite mul_1_r.
    rewrite <- divide_div_mul_exact. rewrite (mul_comm 2 _). rewrite div_mul.
    lia. lia. lia. cbn. replace (q~0)%positive with (2 * q)%positive by lia.
    replace (pos (2 * q)%positive) with (2 * Npos q) by lia.
    apply divide_factor_l.
  + cbn [pos_binfactor pos_oddfactor]. rewrite pow_succ_r by lia.
    rewrite mul_assoc. lia.
  + reflexivity. Qed.

Lemma binfactor_odd (n : N) : binfactor (1 + 2 * n) = 0.
Proof.
  destruct n as [| p].
  - arithmetize. reflexivity.
  - induction p as [q ei | q ei |].
    + reflexivity.
    + reflexivity.
    + reflexivity. Qed.

Lemma binfactor_even (n : N) (f : n <> 0) :
  binfactor (2 * n) = 1 + binfactor n.
Proof.
  destruct n as [| p].
  - arithmetize. cbn. lia.
  - apply (pos_binfactor_even p). Qed.

Lemma binfactor_pow_2 (n p : N) (f : p <> 0) :
  binfactor (2 ^ n * p) = n + binfactor p.
Proof.
  destruct n as [| q].
  - arithmetize. reflexivity.
  - generalize dependent p. induction q as [r ei | r ei |]; intros p f.
    + replace (pos r~1) with (succ (2 * pos r)) by lia.
      rewrite pow_succ_r'.
      rewrite <- mul_assoc.
      rewrite binfactor_even.
      replace (2 * pos r) with (pos r + pos r) by lia.
      rewrite pow_add_r.
      rewrite <- mul_assoc.
      rewrite ei.
      rewrite ei. lia. lia.
      specialize (ei p).
      destruct p. lia.
      pose proof pow_nonzero 2 (pos r).
      lia.
      pose proof pow_nonzero 2 (2 * pos r).
      lia.
    + replace (pos r~0) with (2 * pos r) by lia.
      replace (2 * pos r) with (pos r + pos r) by lia.
      rewrite pow_add_r.
      rewrite <- mul_assoc.
      rewrite ei.
      rewrite ei. lia.
      lia.
      pose proof pow_nonzero 2 (pos r).
      lia.
    + arithmetize.
      destruct p. lia.
      rewrite binfactor_even.
      lia. lia. Qed.

Lemma binfactor_trivial (p q : N) :
  binfactor ((1 + 2 * q) * 2 ^ p) = p.
Proof.
  destruct p as [| r].
  - arithmetize. apply binfactor_odd.
  - generalize dependent q. induction r as [s ei | s ei |]; intros q.
    + replace (pos s~1) with (succ (2 * pos s)) by lia.
      rewrite pow_succ_r'.
      replace (2 * pos s) with (pos s + pos s) by lia.
      rewrite pow_add_r.
      rewrite mul_shuffle3.
      rewrite binfactor_even.
      rewrite mul_shuffle3.
      rewrite binfactor_pow_2.
      rewrite ei. lia.
      pose proof pow_nonzero 2 (pos s).
      lia.
      pose proof pow_nonzero 2 (pos s).
      lia.
    + replace (pos s~0) with (2 * pos s) by lia.
      replace (2 * pos s) with (pos s + pos s) by lia.
      rewrite pow_add_r.
      rewrite mul_shuffle3.
      rewrite binfactor_pow_2.
      rewrite ei. lia.
      pose proof pow_nonzero 2 (pos s).
      lia.
    + arithmetize.
      rewrite binfactor_even.
      rewrite binfactor_odd.
      lia. lia. Qed.

Lemma pos_binfactor_trivial (p q : N) :
  pos_binfactor (succ_pos ((1 + 2 * q) * 2 ^ p - 1)) = p.
Proof.
  pose proof binfactor_trivial p q as e.
  remember ((1 + 2 * q) * 2 ^ p) as r eqn : er.
  destruct r as [| s].
  - arithmetize. cbn. rewrite <- e. reflexivity.
  - replace (succ_pos (Npos s - 1)) with s. rewrite <- e. reflexivity.
    induction s.
    reflexivity.
    cbn. rewrite Pos.pred_double_spec. rewrite Pos.succ_pred; lia.
    reflexivity. Qed.

Lemma oddfactor_odd (n : N) : oddfactor (1 + 2 * n) = 1 + 2 * n.
Proof.
  destruct n as [| p].
  - arithmetize. reflexivity.
  - induction p as [q ei | q ei |].
    + reflexivity.
    + reflexivity.
    + reflexivity. Qed.

Lemma oddfactor_even (n : N) :
  oddfactor (2 * n) = oddfactor n.
Proof.
  destruct n as [| p].
  - arithmetize. cbn. lia.
  - reflexivity. Qed.

Lemma oddfactor_pow_2 (n p : N) (f : p <> 0) :
  oddfactor (2 ^ n * p) = oddfactor p.
Proof.
  destruct n as [| q].
  - arithmetize. cbn. lia.
  - generalize dependent p. induction q as [s ei | s ei |]; intros p f.
    + replace (pos s~1) with (succ (2 * pos s)) by lia.
      rewrite pow_succ_r'.
      replace (2 * pos s) with (pos s + pos s) by lia.
      rewrite pow_add_r.
      rewrite <- mul_assoc.
      rewrite oddfactor_even.
      rewrite <- mul_assoc.
      rewrite ei.
      rewrite ei.
      lia.
      lia.
      pose proof pow_nonzero 2 (pos s).
      lia.
    + replace (pos s~0) with (2 * pos s) by lia.
      replace (2 * pos s) with (pos s + pos s) by lia.
      rewrite pow_add_r.
      rewrite <- mul_assoc.
      rewrite ei.
      rewrite ei.
      lia.
      lia.
      pose proof pow_nonzero 2 (pos s).
      lia.
    + arithmetize.
      rewrite oddfactor_even.
      lia. Qed.

Lemma oddfactor_trivial (p q : N) :
  oddfactor ((1 + 2 * q) * 2 ^ p) = 1 + 2 * q.
Proof.
  destruct p as [| r].
  - arithmetize. apply oddfactor_odd.
  - generalize dependent q. induction r as [s ei | s ei |]; intros q.
    + replace (pos s~1) with (succ (2 * pos s)) by lia.
      rewrite pow_succ_r'.
      replace (2 * pos s) with (pos s + pos s) by lia.
      rewrite pow_add_r.
      rewrite mul_shuffle3.
      rewrite oddfactor_even.
      rewrite mul_shuffle3.
      rewrite oddfactor_pow_2.
      rewrite ei. lia.
      pose proof pow_nonzero 2 (pos s).
      lia.
    + replace (pos s~0) with (2 * pos s) by lia.
      replace (2 * pos s) with (pos s + pos s) by lia.
      rewrite pow_add_r.
      rewrite mul_shuffle3.
      rewrite oddfactor_pow_2.
      rewrite ei. lia.
      pose proof pow_nonzero 2 (pos s).
      lia.
    + arithmetize.
      rewrite oddfactor_even.
      rewrite oddfactor_odd.
      lia. Qed.

Lemma pos_oddfactor_trivial (p q : N) :
  pos_oddfactor (succ_pos ((1 + 2 * q) * 2 ^ p - 1)) = 1 + 2 * q.
Proof.
  pose proof oddfactor_trivial p q as e.
  remember ((1 + 2 * q) * 2 ^ p) as r eqn : er.
  destruct r as [| s].
  - arithmetize. rewrite <- e. cbn. pose proof pow_nonzero 2 p. lia.
  - replace (succ_pos (Npos s - 1)) with s. rewrite <- e. reflexivity.
    induction s.
    reflexivity.
    cbn. rewrite Pos.pred_double_spec. rewrite Pos.succ_pred; lia.
    reflexivity. Qed.

Local Lemma logging (n : positive) : pos_log2 n = log2 (Npos n).
Proof.
  induction n; cbn.
  rewrite IHn; destruct n; reflexivity.
  rewrite IHn; destruct n; reflexivity.
  reflexivity. Qed.

Definition pair_shell (n : N) : N :=
  pos_log2 (succ_pos n).

Arguments pair_shell _ : assert.

Lemma pair_shell_eqn (n : N) : pair_shell n =
  log2 (1 + n).
Proof.
  cbv [pair_shell]. rewrite logging.
  rewrite succ_pos_spec. rewrite add_1_l. reflexivity. Qed.

Definition unpair_shell (p q : N) : N := p + pos_log2 (succ_pos (shiftl q 1)).

Arguments unpair_shell _ _ : assert.

Lemma unpair_shell_eqn (p q : N) : unpair_shell p q =
  log2 (binoddprod p (1 + 2 * q)).
Proof. cbv [unpair_shell]. arithmetize. Admitted.

Definition pair (n : N) : N * N :=
  let (p, q) := binoddfactor (succ n) in
  (p, shiftr (pred q) 1).
  (* (pos_binfactor (succ_pos n), shiftr (pred (pos_oddfactor (succ_pos n))) 1). *)

Arguments pair _ : assert.

Lemma pair_eqn (n : N) : pair n =
  (pos_binfactor (succ_pos n), (pos_oddfactor (succ_pos n) - 1) / 2).
Proof. Admitted.

Definition unpair (p q : N) : N := pred (binoddprod p (succ (shiftl q 1))).

Arguments unpair _ _ : assert.

Lemma unpair_eqn (p q : N) : unpair p q =
  (1 + 2 * q) * 2 ^ p - 1.
Proof. cbv [unpair]. rewrite binoddprod_eqn. arithmetize. reflexivity. Qed.

Compute map pair (seq 0 64).
Compute map (prod_uncurry unpair o pair) (seq 0 64).

Compute map pair_shell (seq 0 64).
Compute map (prod_uncurry unpair_shell o pair) (seq 0 64).

Theorem unpair_shell_pair (n : N) :
  prod_uncurry unpair_shell (pair n) = pair_shell n.
Proof.
  cbv [prod_uncurry fst snd unpair_shell pair pair_shell]. Admitted.

Theorem pair_shell_unpair (p q : N) :
  pair_shell (unpair p q) = unpair_shell p q.
Proof.
  cbv [pair_shell unpair unpair_shell]. Admitted.

Theorem unpair_pair (n : N) : prod_uncurry unpair (pair n) = n.
Proof.
  cbv [prod_uncurry]. rewrite unpair_eqn. rewrite pair_eqn. cbv [fst snd].
  destruct (eqb_spec n 0) as [e | f].
  - subst n. reflexivity.
  - pose proof (part_urgh (succ_pos n)) as e.
    rewrite <- e. rewrite succ_pos_spec. lia. Qed.

Theorem pair_unpair (p q : N) : pair (unpair p q) = (p, q).
Proof.
  cbv [prod_uncurry]. rewrite pair_eqn. rewrite unpair_eqn.
  f_equal.
  - rewrite pos_binfactor_trivial. reflexivity.
  - rewrite pos_oddfactor_trivial.
    replace (1 + 2 * q - 1) with (2 * q) by lia.
    rewrite div_Even. reflexivity. Qed.

End Hausdorff.
