From Maniunfold.Has Require Export
  TwoSorted.Isomorphism.

Section Context.

Context {A B : Type} {A_B_has_iso : HasIso A B}.

(** Section, forward mapping. *)

Definition sect : A -> B := fst iso.

(** Retraction, backward mapping. *)

Definition retr : B -> A := snd iso.

End Context.