(* bad *)
From Coq Require Import
  NArith.NArith Lists.List.
From Maniunfold.Has Require Export
  OneSortedCardinality.
From Maniunfold.Is Require Export
  OneSortedFinite Isomorphism.

Local Open Scope N_scope.

Section Context.

Context (A : Type) `(IsFin A).

Import N.

(** TODO No more violence!
    We use it here to get partial transparency without having to think. *)

Axiom violence : forall n p : N, n < p.

Definition enum : list A.
Proof.
  set (ns := map of_nat (seq O (to_nat (card A)))).
  refine (map _ ns).
  intros n. apply g. exists n.
  apply violence. Defined.

(** TODO Prove that [enum] is a disjoint cover of [A]:
    it has all the inhabitants, but no duplicates. *)

End Context.
