use <bartscad/linkage.scad>
use <bartscad/fasteners.scad>

use <util.scad>
use <link.scad>

use <bottom_leaves/bracket.scad>
use <bottom_leaves/leaf.scad>
use <bottom_leaves/link.scad>

include <constants.scad>

$fn=360;

module bottom_leaf_assembly(additional_link_holes=[]){
  linear_extrude(H_LEAVES,center=true)bottom_leaf_2d(additional_link_holes);
  bottom_leaf_bracket();
}

module bottom_leaf_ring(additional_link_holes=[]){
  ring(5,180){
    animate_rz(-80,0)rotate([0,0,-115]){
      color("#c82")translate([0,0,H_LEAF_GAP/2])bottom_leaf_assembly(additional_link_holes);
      rotate([0,0,-10]) translate([30,0,H_LEAF_GAP/2+H_LEAVES/2])children();
    }
  }
}

module bottom_leaf_template() {
  linear_extrude(4)difference(){
    bottom_leaf_2d([30]);
    hull()offset(-15)bottom_leaf_2d();
  }
}

bottom_leaf_bracket();

translate([0,0,-H_LEAVES/2])linear_extrude(H_LEAVES)bottom_leaf_2d();
translate([140,0,0])bottom_leaf_template();

translate([0,-30,0])bottom_leaf_link();
