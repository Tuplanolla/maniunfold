From Maniunfold.Has Require Export
  Categorical.Morphism Categorical.Composition Categorical.Identity.
From Maniunfold.ShouldHave Require Import
  Categorical.Notations.

Class IsCatLUnl (A : Type) `{HasHom A}
  `(!HasComp A hom) `(!HasIdt A hom) : Prop :=
  cat_l_unl : forall {x y : A} (f : x --> y), f o id = f.
