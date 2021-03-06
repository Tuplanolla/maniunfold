# # Jolly Coexistence of Coq and Other Languages
#
# ## Introduction
#
# You are reading a literate Make file for a mock project.
# This mock project shows how to call C++ code
# through an OCaml program
# extracted from a Coq specification.
#
# ## Mock Use Case
#
# In order to properly demonstrate the challenges involved,
# we need a use case that is sufficiently complicated,
# but still small enough to fit into a presentation.
# Luckily, such a use case is easily found
# from a recent mathematical publication [@peckham-2011],
# which is surprisingly not a joke.
# In particular, we focus on the evaluation of points on the monkey saddle,
# which is a two-dimensional surface generated
# by the function $(r, t) \mapsto r^3 \cos (3 t)$ in polar coordinates or
# by the function $(x, y) \mapsto x^3 - 3 x y^2$ in Cartesian coordinates.

build: build-jr1 build-jr2 build-dec build-flow

clean: clean-flow clean-dec clean-jr2 clean-jr1

# ## Numerical Side
#
# Suppose we have a numerical solver called JR
# that evaluates integer points on the monkey saddle,
# among other things.
# Since JR is written in C++ and
# depends on the GNU Multiple Precision Arithmetic Library,
# we can build it as follows.

build-jr1:
	g++ -c jrlib.cxx
	g++ -c jrmain.cxx
	g++ -o jrmain jrlib.o jrmain.o -lgmpxx -lgmp
	./jrmain

clean-jr1:
	$(RM) jrlib.o
	$(RM) jrmain.o
	$(RM) jrmain

# As it is generally a good idea
# to isolate the reusable components of a program and
# put them into their own little library,
# we also do so for JR.
# This often requires a lot of work,
# but since JR was designed well in the first place,
# with thread-safety and reentrancy in mind,
# the same old code works without modifications.

build-jr2:
	g++ -c -fPIC jrlib.cxx
	g++ -o libjrlib.so -shared jrlib.o -lgmpxx -lgmp
	g++ -c jrmain.cxx
	# Since we do not want to install the library as a system library,
	# we need to tell the linker where to find it instead.
	# We could do this by setting the environment variables
	# `LIBRARY_PATH` and `LD_LIBRARY_PATH`,
	# but it is more convenient to embed their values into the files directly.
	g++ -L. -Wl,-rpath=. -o jrmain jrmain.o -ljrlib -lgmpxx -lgmp
	./jrmain

clean-jr2:
	$(RM) jrlib.o
	$(RM) libjrlib.so
	$(RM) jrmain.o
	$(RM) jrmain

# For maximal reusability,
# we also want the library to be compatible with languages other than C++.
# Since C is usually the lowest common denominator,
# we write a wrapper for JR in C and put it into the library as well.

build-jr3:
	g++ -c -fPIC jrlib.cxx
	g++ -c -fPIC jrwrap.cxx
	g++ -o libjrlib.so -shared jrlib.o jrwrap.o -lgmpxx -lgmp
	# We can ignore the wrapper when we compile the old executable.
	# Link-time optimization should get rid of it anyway.
	g++ -c jrmain.cxx
	g++ -L. -Wl,-rpath=. -o jrmain jrmain.o -ljrlib -lgmpxx -lgmp
	./jrmain

clean-jr3:
	$(RM) jrlib.o
	$(RM) jrwrap.o
	$(RM) libjrlib.so
	$(RM) jrmain.o
	$(RM) jrmain

# In a bigger project,
# it would be smarter to generate the wrapper with some tool,
# such as SWIG, Ctypes or Camlidl.
# However, it is more instructive to write it by hand here.
#
# Suppose we have another numerical solver called SR,
# which is written in some version of Python.
# Since Python is interpreted,
# we can run it directly as follows.

build-sr1:
	python3 srmain.py

clean-sr1:
	$(RM) -r __pycache__
	$(RM) srlib.pyc
	$(RM) srmain.pyc

# Linking a shared library that is written
# in an interpreted and garbage-collected language
# is usually extremely unpleasant,
# so we do not even attempt to build one here.
# Instead, we shall implement a server
# that communicates with a client using a simple protocol.
# The protocol can be transmitted over pipes or sockets.

build-sr2:
	python3 srmain.py

clean-sr2:
	$(RM) -r __pycache__
	$(RM) srlib.pyc
	$(RM) srwrap.pyc
	$(RM) srmain.pyc

# As before,
# it would be smarter to use an established serialization protocol,
# such as Protocol Buffers, Cap'n Proto, XML or JSON.
# It simply takes less effort to use a custom protocol here.
#
# ## Analytical Side
#
# Our dependencies are now in order,
# so we can move on to the formal specification,
# which we shall call DEC.
# We write the specification in Coq and extract it into OCaml,
# because it happens to be the language with the best support for extraction.
# We also independently check the proofs for consistency,
# so that we can be sure erasing them from the extracted code is justified.

build-spec:
	coqc $$(cat _CoqProject) ZTriangle.v
	coqc $$(cat _CoqProject) Spec.v
	# The checking is disabled in this presentation,
	# because it can take over a minute,
	# while everything else takes less than a second.
	touch Spec.out.log Spec.err.log \
	# coqchk Spec.vo 1> Spec.out.log 2> Spec.err.log

clean-spec:
	$(RM) .ZTriangle.aux ZTriangle.vo ZTriangle.glob
	$(RM) .Spec.aux Spec.vo Spec.glob spec.mli spec.ml
	$(RM) Spec.out.log Spec.err.log

# ## Both Sides Together
#
# In order to bring DEC and JR together,
# we do three things.
#
# First, we write an OCaml executable that handles all the input and output.
# This would also be the part for less critical features,
# such as natural language parsers,
# pretty printers or graphical user interfaces.
#
# Second, we write an OCaml adapter
# that translates inhabitants of extracted types
# into inhabitants of native types.
# This is not mandatory and could also be done
# with the extraction mechanism of Coq,
# but doing it in OCaml is more convenient and
# makes working with the extracted code much faster and easier.
#
# Third, we write OCaml drivers for JR and SR and
# integrate them into the executable.
# This step also involves writing a C stub
# that handles the memory management between C and OCaml.

build-dec: build-jr3 build-sr2 build-spec
	# This is the driver for JR.
	ocamlfind ocamlopt -c stubjr.c
	ocamlfind ocamlopt -c driver_jr.mli
	ocamlfind ocamlopt -c driver_jr.ml
	# This is the driver for SR.
	ocamlfind ocamlopt -c -package unix driver_sr.mli
	ocamlfind ocamlopt -c -package unix driver_sr.ml
	# This is the extracted code.
	ocamlfind ocamlopt -c spec.mli
	ocamlfind ocamlopt -c spec.ml
	# This is the adapter.
	ocamlfind ocamlopt -c -package num adapter.mli
	ocamlfind ocamlopt -c -package num adapter.ml
	# This is the executable.
	ocamlfind ocamlopt -c -package num main.ml
	# All we have to do now is link them all together.
	ocamlfind ocamlopt -linkpkg -o main -package num -package unix \
	stubjr.o driver_jr.cmx driver_sr.cmx spec.cmx adapter.cmx main.cmx \
	-ccopt -L. -ccopt -Wl,-rpath=. -cclib -ljrlib -cclib -lgmpxx -cclib -lgmp
	./main

clean-dec: clean-spec clean-jr3 clean-sr2
	$(RM) stubjr.o
	$(RM) driver_jr.cmi driver_jr.cmx driver_jr.o
	$(RM) driver_sr.cmi driver_sr.cmx driver_sr.o
	$(RM) spec.cmi spec.cmx spec.o
	$(RM) adapter.cmi adapter.cmx adapter.o
	$(RM) main.cmi main.cmx main.o
	$(RM) main

# ## Visualization
#
# The compilation chain is best visualized with a data flow diagram.

build-flow:
	dot -Gdpi=100 -Gsize=12,8\! -Tpng -oflow.png flow.dot
	mogrify -background white -extent 1200x800 -gravity center flow.png

clean-flow:
	$(RM) flow.png
