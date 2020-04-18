From Maniunfold.Has Require Export
  Categorical.Morphism Categorical.Composition Categorical.Identity
  Categorical.Inverse.
From Maniunfold.Is Require Export
  Categorical.Category Categorical.Invertible Categorical.Involutive.
From Maniunfold.ShouldHave Require Import
  Categorical.Notations.

Class IsGrpd (A : Type) {A_has_hom : HasHom A}
  (A_hom_has_comp : HasComp A hom) (A_hom_has_idt : HasIdt A hom)
  (A_hom_has_inv : HasInv A hom) : Prop := {
  A_comp_idt_is_cat :> IsCat A comp idt;
  A_comp_idt_inv_is_cat_inv :> IsCatInv A comp idt inv;
}.

Section Context.

Context {A : Type} `{is_grpd : IsGrpd A}.

Global Instance inv_is_cat_invol : IsCatInvol A inv.
Proof.
  intros x y f.
  rewrite <- (cat_r_unl ((f ^-1) ^-1)).
  rewrite <- (cat_l_inv f).
  rewrite (cat_assoc ((f ^-1) ^-1) (f ^-1) f).
  rewrite (cat_l_inv (f ^-1)).
  rewrite (cat_l_unl f).
  reflexivity. Defined.

End Context.