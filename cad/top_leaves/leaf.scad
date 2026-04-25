include <../constants.scad>
use <../leaf.scad>

include <util.scad>

module top_leaf_2d_raw(){
  leaf(240,60);
}

module top_leaf_2d(){
  rotate([0,0,-30])translate([-BRACKET_OFFSET*1.5-5,0])rotate([0,0,30])top_leaf_2d_raw();
}

module top_leaf(){
  tr_leaf()translate([0,0,6])linear_extrude(H_LEAVES)top_leaf_2d();
}

$fn=360;
top_leaf();
