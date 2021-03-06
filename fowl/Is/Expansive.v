(** * Expansivity or Longness of a Function *)

From Maniunfold.Has Require Export
  Distance OrderRelations.
From Maniunfold.ShouldHave Require Import
  OrderRelationNotations.

Class IsExpand (A B C : Type)
  (HR : HasOrdRel C) (HdA : HasDist C A) (HdB : HasDist C B)
  (f : A -> B) : Prop :=
  expand (x y : A) : dist x y <= dist (f x) (f y).
