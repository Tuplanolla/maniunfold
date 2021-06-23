(** * Notations for Binary Relations *)

From Maniunfold.Has Require Import
  BinaryRelation.

Reserved Notation "x '~' y" (no associativity, at level 70).

Declare Scope relation_scope.
Delimit Scope relation_scope with rel.

#[global] Open Scope relation_scope.

Notation "'_~_'" := bin_rel : relation_scope.
Notation "x '~' y" := (bin_rel x y) : relation_scope.
