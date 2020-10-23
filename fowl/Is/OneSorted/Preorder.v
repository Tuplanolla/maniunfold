(* bad *)
From Coq Require Import
  Classes.RelationClasses.
From Maniunfold.Has Require Export
  OneSorted.OrderRelation.
From Maniunfold.Is Require Export
  Reflexive Transitive.

Class IsPreord (A : Type) `(HasOrdRel A) : Prop := {
  A_ord_rel_is_refl :> IsRefl A ord_rel;
  A_ord_rel_is_trans :> IsTrans A ord_rel;
}.

Section Context.

Context {A : Type} `{IsPreord A}.

Global Instance ord_rel_pre_order : PreOrder ord_rel | 0.
Proof. split; typeclasses eauto. Defined.

End Context.
