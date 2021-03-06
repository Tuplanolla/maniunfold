From Coq Require Export
  Morphisms.
From Maniunfold.Has Require Export
  Relation Point.
From Maniunfold.ShouldHave Require Import
  RelationNotations.

Class IsProper {A : Type} (has_rel : HasRel A) (has_pt : HasPt A) : Prop :=
  proper : pt ~ pt.

Section Context.

Context {A : Type} `{is_proper : IsProper A}.

Global Instance proper_is_proper : Proper rel pt | 0 := proper.

End Context.
