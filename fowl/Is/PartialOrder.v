(** * Partial Order *)

From Maniunfold.Has Require Export
  OrderRelation.
From Maniunfold.ShouldHave Require Import
  OrderRelationNotations.
From Maniunfold.Is Require Export
  Preorder Antisymmetric.

Fail Fail Class IsPartOrd (A : Type) (R : HasOrdRel A) : Prop := {
  is_preord :> IsPreord _<=_;
  is_antisym :> IsAntisym _<=_;
}.

Notation IsPartOrd R := (PartialOrder _=_ R).
