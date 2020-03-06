From Coq Require Export
  Setoid Morphisms.
From Maniunfold.Has Require Export
  OneSorted.EquivalenceRelation OneSorted.OrderRelation.
From Maniunfold.Is Require Export
  Antisymmetric Connex Transitive Reflexive
  OneSortedly.PartialOrder.
From Maniunfold.ShouldHave Require Import
  EquivalenceRelationNotations OrderRelationNotations.

Class IsTotOrd {A : Type} {has_eq_rel : HasEqRel A}
  (has_ord_rel : HasOrdRel A) : Prop := {
  ord_is_antisym :> IsAntisym ord_rel;
  ord_is_connex :> IsConnex ord_rel;
  ord_is_trans :> IsTrans ord_rel;
}.

Section Context.

Context {A : Type} `{is_tot_ord : IsTotOrd A}.

Theorem ord_rel_refl : forall x : A,
  x <= x.
Proof with change_part_ord.
  intros x. destruct (connex x x) as [H | H]...
  - apply H.
  - apply H. Qed.

Global Instance ord_rel_is_refl : IsRefl ord_rel.
Proof. intros x. apply ord_rel_refl. Qed.

Global Instance ord_rel_is_part_ord : IsPartOrd ord_rel.
Proof. repeat (constructor; try typeclasses eauto). Qed.

End Context.