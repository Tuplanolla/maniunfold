From Maniunfold.Has Require Export
  EquivalenceRelation OrderRelation.
From Maniunfold.Is Require Export
  Proper Antisymmetric Transitive Connex.

Class IsTotalOrder {A : Type} {has_eqv : HasEqv A}
  (has_ord : HasOrd A) : Prop := {
  total_order_ord_is_proper :> IsProper (eqv ==> eqv ==> flip impl) ord;
  total_order_ord_is_antisymmetric :> IsAntisymmetric ord;
  total_order_ord_is_transitive :> IsTransitive ord;
  total_order_ord_is_connex :> IsConnex ord;
}.

Section Context.

Context {A : Type} `{is_total_order : IsTotalOrder A}.

Theorem total_order_ord_reflexive : forall x : A, x <= x.
Proof.
  intros x. destruct (connex x x) as [H | H].
  - specialize (H : x <= x). apply H.
  - specialize (H : x <= x). apply H. Qed.

Global Instance total_order_ord_is_reflexive : IsReflexive ord := {}.
Proof. apply total_order_ord_reflexive. Qed.

End Context.
