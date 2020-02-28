From Maniunfold.Has Require Export
  OneSorted.BinaryRelation Unit Function.
From Maniunfold.ShouldHave Require Import
  BinaryRelationNotations AdditiveNotations.

(** TODO Calling this "external" is weird,
    because neither type seems to be "favored".
    Who are we to decide which side is the right side? *)

Class IsExtUnAbsorb {A B : Type} {has_bin_rel : HasBinRel B}
  (A_has_un : HasUn A) (B_has_un : HasUn B) (has_fn : HasFn A B) : Prop :=
  ext_un_absorb : T- T0 ~~ T0.
