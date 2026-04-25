use <structure.scad>
include <constants.scad>

$fn=360;
base();

translate([400,0])support_ring_middle();
translate([800,0])support_ring_top();
