From Coq Require Export
  Setoid.
From Maniunfold.Has Require Export
  BinaryRelation.
From Maniunfold.ShouldHave Require Import
  BinaryRelationNotations.

Class IsTrans {A : Type} (has_bin_rel : HasBinRel A) : Prop :=
  transitive : forall x y z : A, x ~ y -> y ~ z -> x ~ z.

Section Context.

Context {A : Type} `{is_transitive : IsTrans A}.

Global Instance bin_rel_transitive : Transitive bin_rel | 0 := transitive.

End Context.
