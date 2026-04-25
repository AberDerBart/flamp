use <bartscad/tr.scad>

use <bottom_leaves/leaf.scad>
use <top_leaves/leaf.scad>
use <top_leaves/util.scad>
use <structure.scad>

$fn=360;

support_ring_top_rim();

for(i=[0:9]){
  translate([400,i*120,2])rotate([0,0,90])bottom_leaf();
}

for(i=[0:4]){
  translate([450,i*250,-6])tr(tr_leaf_inv())top_leaf();
}

