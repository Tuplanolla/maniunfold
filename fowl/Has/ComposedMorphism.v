(** * Composition of Morphisms *)

From Maniunfold.Has Require Export
  Morphism.
From Maniunfold.ShouldHave Require Import
  MorphismNotations.

Class HasCompHom (A : Type) (HC : HasHom A) : Type :=
  comp_hom (x y z : A) (a : y --> z) (b : x --> y) : x --> z.

Typeclasses Transparent HasCompHom.
