# Notes

These informal notes complement some papers and implementations.

## Personal Notes by Sampsa Kiiskinen

### Coherence Conditions

When defining classes,
all the operational classes must be constraints and
all the predicative classes must be coercible fields.

### Naming Conventions

Operative classes are prefixed with `Has` and predicative classes with `Is`.
Operations themselves are abbreviated to less than six characters,
while predicates are never abbreviated.

Definitions and instances for a type are prefixed with its name.
For example, we would have `Instance t_magic_lamp : MagicLamp t`.

Coercible fields contain the verb `is`, while plain fields do not.
For example, we would have `opr_is_associative : IsAssociative A` or
`opr_associative : forall x y z : A, x + (y + z) == (x + y) + z`.

Parametric relations and morphisms
have the suffixes `relation` and `morphism` respectively.

### Implicit Generalization

When defining classes, implicit generalization must not be used.
When declaring parametric relations or morphisms,
implicit generalization should be used.
When defining theorems, implicit generalization may be used.

## Type Classes for Mathematics in Type Theory by Spitters and van der Weegen

Regarding overlapping instances of operational classes (major issue),
Spitters and van der Weegen claim that "the issue rarely arises".
This seems dubious to a Haskell programmer,
but I will trust their word and see what happens.

> Because predicate classes only provide contextual information and
> are insulated from the actual algebraic expressions,
> their instances can always be kept entirely opaque ---
> only their existence matters.
> Together, these properties largely defuse
> an argument occasionally voiced against type classes
> concerning perceived unpredictability of instance resolution.
> While it is certainly true that in contexts with redundant information
> it can become hard to predict which instance
> of a predicate class will be found by proof search,
> it simply does not matter which one is found.
> Moreover, for operational type classes the issue rarely arises because
> their instances are not nearly as abundant.

Regarding conjunctions of properties or property generators
in the definitions of predicative classes (minor issue),
Spitters and van der Weegen claim that
"almost any generic predicate worth naming
is worth representing as a predicate type class" and
use hybrid operational-style predicative classes in the implementation.
It is a bit strange not to mention the hybrid approach,
but I will follow suit and see what happens.

> We use names for properties like distributivity and absorption,
> because these are type classes as well
> (which is why we declare them with `:>`).
> It has been our experience
> that almost any generic predicate worth naming
> is worth representing as a predicate type class,
> so that its proofs will be resolved as instances
> behind the scenes whenever possible.
> Doing this consistently minimizes administrative noise in the code,
> bringing us closer to ordinary mathematical vernacular.
> Indeed, we believe that type classes are an elegant and
> apt formalization of the seemingly casual manner in which
> ordinary mathematical presentation assumes implicit administration and
> use of a 'database' of properties previously proved.
> Much more so than the existing canonical structures facility,
> because canonical structures can only be used
> with bundled representations,
> which we argued against in section 3.

Regarding modules and the expression problem (minor issue),
Spitters and van der Weegen make no claims and
fail to account for this in the implementation.
I have not found a solution to this problem either,
but disallowing operational class sharing and
using explicit operational class inheritance might work
(or exacerbate the overlapping instance problem).
I will try this and see what happens.

Regarding the scope of operational classes (minor issue),
Spitters and van der Weegen claim that
"what we really need are canonical names" and
have one module with all the operational classes in the implementation.
This conflicts with explicit operational class inheritance,
so I will ignore their advice and see what happens.

> Because `e` and `op` are freshly introduced local names,
> we cannot bind notations to them prior to this theorem.
> Hence, if we want notations,
> what we really need are canonical names for these components.
> This is easily accomplished with single-field type classes
> containing one component each,
> which we will call operational type classes.

Regarding the sharing of operational classes
between different structures (minor issue),
Spitters and van der Weegen make no claims,
but seem to share them as they see fit in the implementation.
Whether sharing is required by canonical names or vice versa is unclear.
I will let explicit operational class inheritance
give rise to sharing and see what happens.

Regarding conflicting or extensible notations (minor issue),
Spitters and van der Weegen make no claims and
do not support such a thing in the implementation.
However, I have found a way to accomplish this
with scopes and module shadowing.

Regarding dependently-typed operational type classes (major issue),
Spitters and van der Weegen make no claims,
but use them with implicit generalization in the implementation.
This must be too obvious to be mentioned,
even though implicit generalization generates unpredictable names
for the inferred arguments, making the code fragile.
I will try to formulate a naming convention
that produces predictable names and and see what happens.

Regarding efficiency of extracted code (major issue),
Spitters and van der Weegen make a related claim that
"efficiency of computation using type-checked terms is not affected".
I have also observed this,
but based on the assumption that the OCaml compiler
can inline identity, constant and projection functions
across modules (this is likely to be true, but not a given).

Regarding the universal usability (major issue),
Spitters and van der Weegen claim that they could make
"an unequivocal endorsement of type classes".
I have found a simple counterexample,
where trying to model higher groupoid structure is
more tedious and unpleasant than it would be with plain records.
However, I might not need to do that in practice.

> There are really only two pending concerns that keeps us
> from making an unequivocal endorsement of type classes
> as a versatile, expressive, and elegant means
> of organizing proof developments.
> The first and lesser of the two is universe polymorphism
> for definitions as described in the previous section.
> The second is instance resolution efficiency.
> In more complex parts of our development
> we are now experiencing increasingly serious efficiency problems,
> despite having already made sacrifices
> by artificially inhibiting many natural class instances
> in order not to further strain instance resolution.
> Fortunately, there is plenty of potential for improvement
> of the current instance resolution implementation.
> One source is the vast literature
> on efficient implementation of Prolog-style resolution,
> which the hint-based proof search used
> for instance resolution greatly resembles.
> We emphasize that these efficiency problems only affect type checking;
> efficiency of computation using type-checked terms is not affected.

None of these issues prevent working on the system,
but solving some of them would get rid of a lot of pointless busywork.