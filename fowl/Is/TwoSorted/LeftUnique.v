(* bad *)
From Maniunfold.Has Require Export
  TwoSorted.LeftAction TwoSorted.LeftTorsion.
From Maniunfold.ShouldHave Require Import
  TwoSorted.AdditiveNotations.

Local Open Scope l_mod_scope.

Class IsLUniq (A B : Type)
  `(HasLAct A B) `(HasLTor A B) : Prop :=
  l_uniq : forall x y : B, (y - x)%l_subgrp + x = y.
