#ifdef CLUSTER
#define SUBGRAPH(x) cluster_##x
#else
#define SUBGRAPH(x) uncluster_##x
#endif

digraph habitat {
  /** We do not have this component,
      because the formal specification does not need a utility library. */
  /* subgraph SUBGRAPH(bird) {
    label = "Component\nBird"
  } */

  subgraph SUBGRAPH(fowl) {
    label = "Component\nFowl"

    node [shape = box]

    fowl [label = "Coq Source\nfor Formal Specification"]
  }

  /** We do not have this component,
      because the formal specification is not accessed through a proxy. */
  /* subgraph SUBGRAPH(feathers) {
    label = "Component\nFeathers"
  } */

  /** We do not have this component,
      because the message specification does not need a utility library. */
  /* subgraph SUBGRAPH(plant) {
    label = "Component\nPlant"
  } */

  subgraph SUBGRAPH(flower) {
    label = "Component\nFlower"

    node [shape = box]

    flower [label = "Thrift IDL Source\nfor Message Specification"]
  }

  /** We do not have this component,
      because the message specification is not accessed through a proxy. */
  /* subgraph SUBGRAPH(leaves) {
    label = "Component\nLeaves"
  } */

  subgraph SUBGRAPH(ungulate) {
    label = "Component\nUngulate"

    node [shape = box]

    ungulate [label = "OCaml Source\nfor Common Tasks"]

    node [shape = oval]

    ungulate_from_ungulate [label = "Utility Library\nfor Common Tasks"]
  }

  subgraph SUBGRAPH(camel) {
    label = "Component\nCamel"

    node [shape = box]

    camel [label = "OCaml Source\nfor Symbolic Manipulation"]
    camel_from_fowl [label = "OCaml Source\nfor Formal Verification"]

    node [shape = oval]

    camel_from_camel [label = "Server Library\nfor Verified Symbolic Manipulation"]
  }

  subgraph SUBGRAPH(fur) {
    label = "Component\nFur"

    node [shape = box]

    fur [label = "OCaml Source\nfor Message Interpretation"]
    fur_from_flower [label = "OCaml Source\nfor Message Transmission"]

    node [shape = oval]

    fur_from_fur [label = "Server Proxy\nfor Verified Symbolic Manipulation"]
  }

  subgraph SUBGRAPH(reptile) {
    label = "Component\nReptile"

    node [shape = box]

    reptile [label = "Python Source\nfor Common Tasks"]

    node [shape = oval]

    reptile_from_reptile [label = "Utility Library\nfor Common Tasks"]
  }

  subgraph SUBGRAPH(snake) {
    label = "Component\nSnake"

    node [shape = box]

    snake [label = "Python Source\nfor Graphical User Interaction"]

    node [shape = oval]

    snake_from_snake [label = "Client Program\nfor Graphical User Interaction"]
  }

  subgraph SUBGRAPH(scales) {
    label = "Component\nScales"

    node [shape = box]

    scales [label = "Python Source\nfor Graphical User Interaction"]
    scales_from_flower [label = "Python Source\nfor Message Transmission"]

    node [shape = oval]

    scales_from_scales [label = "Client Proxy\nfor Graphical User Interaction"]
  }

  subgraph SUBGRAPH(turtle) {
    label = "Component\nTurtle"

    node [shape = box]

    turtle [label = "Python Source\nfor Terminal User Interaction"]

    node [shape = oval]

    turtle_from_turtle [label = "Client Program\nfor Terminal User Interaction"]
  }

  subgraph SUBGRAPH(shell) {
    label = "Component\nShell"

    node [shape = box]

    shell [label = "Python Source\nfor Terminal User Interaction"]
    shell_from_flower [label = "Python Source\nfor Message Transmission"]

    node [shape = oval]

    shell_from_shell [label = "Client Proxy\nfor Terminal User Interaction"]
  }

  subgraph SUBGRAPH(fungus) {
    label = "Component\nFungus"

    node [shape = box]

    fungus [label = "C++ Source\nfor Common Tasks"]

    node [shape = oval]

    fungus_from_fungus [label = "Utility Library\nfor Common Tasks"]
  }

  subgraph SUBGRAPH(truffle) {
    label = "Component\nTruffle"

    node [shape = box]

    truffle [label = "C++ Source\nfor Numerical Computation"]

    node [shape = oval]

    truffle_from_truffle [label = "Server Library\nfor Numerical Computation"]
  }

  subgraph SUBGRAPH(spores) {
    label = "Component\nSpores"

    node [shape = box]

    spores [label = "C++ Source\nfor Message Interpretation"]
    spores_from_flower [label = "C++ Source\nfor Message Transmission"]

    node [shape = oval]

    spores_from_spores [label = "Server Proxy\nfor Numerical Computation"]
  }

  /** We do not have this component,
      because the broker uses the same utility library as the server proxy. */
  /* subgraph SUBGRAPH(primate) {
    label = "Component\nPrimate"
  } */

  subgraph SUBGRAPH(ape) {
    label = "Component\nApe"

    node [shape = box]

    ape [label = "OCaml Source\nfor Message Interpretation"]
    ape_from_flower [label = "OCaml Source\nfor Message Transmission"]

    node [shape = oval]

    ape_from_ape [label = "Broker\nfor Message Passing"]
  }

  /** We do not have this component,
      because the broker is not accessed through a proxy. */
  /* subgraph SUBGRAPH(hair) {
    label = "Component\nHair"
  } */

#ifdef SHOWCOMPILE
  /** We illustrate compiling the system with solid edges. */
  edge [style = solid]
#else
  edge [style = invis]
#endif

#ifdef COMPILE
  fowl -> camel_from_fowl [label = "(1) Code Extraction"]
  flower -> fur_from_flower [label = "(1) Code Generation"]
  flower -> scales_from_flower [label = "(1) Code Generation"]
  flower -> shell_from_flower [label = "(1) Code Generation"]
  flower -> spores_from_flower [label = "(1) Code Generation"]
  flower -> ape_from_flower [label = "(1) Code Generation"]
  ungulate -> ungulate_from_ungulate [label = "(1) Compilation"]
  fungus -> fungus_from_fungus [label = "(1) Compilation"]
  truffle -> truffle_from_truffle [label = "(1) Compilation"]

  ungulate_from_ungulate -> ape_from_ape [label = "(2) Linking"]
  camel -> camel_from_camel [label = "(2) Compilation"]
  camel_from_fowl -> camel_from_camel [label = "(2) Compilation"]
  fungus_from_fungus -> spores_from_spores [label = "(2) Linking"]
  truffle_from_truffle -> spores_from_spores [label = "(2) Linking"]
  spores -> spores_from_spores [label = "(2) Compilation"]
  spores_from_flower -> spores_from_spores [label = "(2) Compilation"]
  ape -> ape_from_ape [label = "(2) Compilation"]
  ape_from_flower -> ape_from_ape [label = "(2) Compilation"]

  ungulate_from_ungulate -> fur_from_fur [label = "(3) Linking"]
  camel_from_camel -> fur_from_fur [label = "(3) Linking"]
  fur -> fur_from_fur [label = "(3) Compilation"]
  fur_from_flower -> fur_from_fur [label = "(3) Compilation"]

  fur_from_fur -> ape_from_ape [label = "(4) Connection", dir = both]
  reptile -> reptile_from_reptile [label = "(4) Interpretation"]
  reptile_from_reptile -> snake_from_snake [label = "(4) Interpretation"]
  reptile_from_reptile -> scales_from_scales [label = "(4) Interpretation"]
  reptile_from_reptile -> turtle_from_turtle [label = "(4) Interpretation"]
  reptile_from_reptile -> shell_from_shell [label = "(4) Interpretation"]
  snake -> snake_from_snake [label = "(4) Interpretation"]
  snake_from_snake -> scales_from_scales [label = "(4) Interpretation"]
  scales -> scales_from_scales [label = "(4) Interpretation"]
  scales_from_flower -> scales_from_scales [label = "(4) Interpretation"]
  scales_from_scales -> ape_from_ape [label = "(4) Connection", dir = both]
  turtle -> turtle_from_turtle [label = "(4) Interpretation"]
  turtle_from_turtle -> shell_from_shell [label = "(4) Interpretation"]
  shell -> shell_from_shell [label = "(4) Interpretation"]
  shell_from_flower -> shell_from_shell [label = "(4) Interpretation"]
  shell_from_shell -> ape_from_ape [label = "(4) Connection", dir = both]
  spores_from_spores -> ape_from_ape [label = "(4) Connection", dir = both]
#endif

#ifdef SHOWRUN
  /** We illustrate running the system with dashed edges. */
  edge [style = dashed]
#else
  edge [style = invis]
#endif

#ifdef RUN
  snake_from_snake -> scales_from_scales [label = "(1) Problem\nas Python Object"]
  scales_from_scales -> ape_from_ape [label = "(2) Problem\nas Thrift Message"]
  ape_from_ape -> fur_from_fur [label = "(3) Problem\nas Thrift Message"]
  fur_from_fur -> camel_from_camel [label = "(4) Problem\nas OCaml Object"]
  camel_from_camel -> fur_from_fur [label = "(5) Command\nas OCaml Object"]
  fur_from_fur -> ape_from_ape [label = "(6) Command\nas Thrift Message"]
  ape_from_ape -> spores_from_spores [label = "(7) Command\nas Thrift Message"]
  spores_from_spores -> truffle_from_truffle [label = "(8) Command\nas C++ Object"]
  truffle_from_truffle -> spores_from_spores [label = "(9) Result\nas C++ Object"]
  spores_from_spores -> ape_from_ape [label = "(10) Result\nas Thrift Message"]
  ape_from_ape -> fur_from_fur [label = "(11) Result\nas Thrift Message"]
  fur_from_fur -> camel_from_camel [label = "(12) Result\nas OCaml Object"]
  camel_from_camel -> fur_from_fur [label = "(13) Solution\nas OCaml Object"]
  fur_from_fur -> ape_from_ape [label = "(14) Solution\nas Thrift Message"]
  ape_from_ape -> scales_from_scales [label = "(15) Solution\nas Thrift Message"]
  scales_from_scales -> snake_from_snake [label = "(16) Solution\nas Python Object"]
#endif

#ifdef SHOWCONSTRAIN
  edge [style = dotted]
#else
  /** We use invisible edges to adjust the layout. */
  edge [style = invis]
#endif

  ungulate_from_ungulate -> camel
  reptile_from_reptile -> snake
  reptile_from_reptile -> turtle
  fungus_from_fungus -> truffle

  ungulate_from_ungulate -> fowl -> camel
  reptile_from_reptile -> fowl -> snake
  reptile_from_reptile -> fowl -> turtle
  fungus_from_fungus -> fowl -> truffle

  camel_from_camel -> fur
  snake_from_snake -> scales
  turtle_from_turtle -> shell
  truffle_from_truffle -> spores

  camel_from_camel -> flower -> fur
  snake_from_snake -> flower -> scales
  turtle_from_turtle -> flower -> shell
  truffle_from_truffle -> flower -> spores

  fur_from_fur -> ape
  scales_from_scales -> ape
  shell_from_shell -> ape
  spores_from_spores -> ape
}
