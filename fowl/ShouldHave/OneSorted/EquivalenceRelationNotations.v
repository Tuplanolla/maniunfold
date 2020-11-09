From Maniunfold.Has Require Export
  OneSorted.EquivalenceRelation.

Reserved Notation "x '==' y" (at level 70, no associativity).
Reserved Notation "'_==_'" (at level 0, no associativity).
Reserved Notation "x '=/=' y" (at level 70, no associativity).
Reserved Notation "'_=/=_'" (at level 0, no associativity).

Declare Scope rel_scope.

Delimit Scope rel_scope with rel.

Open Scope rel_scope.

Notation "x '==' y" := (eq_rel x y) : rel_scope.
Notation "'_==_'" := eq_rel (only parsing) : rel_scope.
Notation "x '=/=' y" := (not (eq_rel x y)) : rel_scope.
Notation "'_=/=_'" := (fun x y : _ => not (eq_rel x y))
  (only parsing) : rel_scope.
