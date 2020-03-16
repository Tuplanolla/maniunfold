From Maniunfold.Has Require Export
  EquivalenceRelation LeftAction LeftTorsion.
From Maniunfold.ShouldHave Require Import
  EquivalenceRelationNotations AdditiveNotations.

Class IsLNullUniq {A B : Type}
  (has_l_act : HasLAct A B) (has_l_tor : HasLTor A B) : Prop :=
  l_null_uniq : forall x y : B, (y L- x) L+ x = y.
