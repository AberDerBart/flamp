**Disclaimer:** This has been developed as a personal project and the current state was good enough for me to build it but is problably not well suited to recreate.
There are also changes planned (especially to the PCB and electronics).
Please contact me or open an issue if you have any problems or questions on this project, I am happy to help (but not very motivated to do documentation work upfront).

If you want or need another license for some reason (especially for commercial use), feel free to contact me.

# Flamp

These are the design files for my flower lamp (short "Flamp"), A dimmable ceiling lamp inspired by a flower blossom with servo-actuated petals to open up or close down.

## Getting started

Check out this repository using the [`--recurse-submodules`](https://git-scm.com/docs/git-clone#Documentation/git-clone.txt---recurse-submodulespathspec) flag.

For the mechanical design, open `lamp.scad` in OpenSCAD. This gives an overview how the lamp is assembled.

For the PCB design, open [pcb/pcb.kicad_pro](pcb/pcb.kicad_pro) in KiCad.

## Necessary parts

For hardware and electronic parts, see [BOM.csv](BOM.csv).
You need to 3D print the parts from [cad/printed_parts.scad](cad/printed_parts.scad).
The design for the wooden parts can be found in [cad/wooden_parts_12mm.scad](cad/wooden_parts_12mm.scad) and [cad/wooden_parts_4mm.scad](cad/wooden_parts_4mm.scad).

1. Cut the parts with a CNC router or laser cutter from 12mm or 4mm plywood respectively
2. 3D print the [jigs](cad/jigs.scad) and use them to trace the shape of the wooden parts and saw them out.
   Then, use the jigs and a router to trim them to size and drill the holes using the jigs. Make sure to drill the holes before removing the inner parts.

## Assembly

TODO
