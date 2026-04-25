use <top_leaves.scad>
use <structure.scad>
use <top_leaves.scad>
use <bottom_leaves.scad>

top_leaf_assembly_jig();

translate([200,0])drill_guide();
translate([200,-30])glue_guide();


$fn=360;
for(i=[0:2]){
  translate([460+i*20,i*50])linear_extrude(5)top_leaf_template_2d();
}

translate([200,-30])rotate([0,0,-90])bottom_leaf_template();
