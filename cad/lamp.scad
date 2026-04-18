use <bartscad/bearings.scad>
use <bartscad/servos.scad>
use <bartscad/linkage.scad>
use <bartscad/poly.scad>

use <util.scad>
use <top_leaves.scad>
use <link.scad>
use <leaf.scad>
use <bottom_leaves.scad>
use <structure.scad>
use <light-fixture.scad>
use <control.scad>

use <top_leaves/link.scad>
use <bottom_leaves/link.scad>

include <constants.scad>

$hide_leaves=false;


module control_mechanism(){
  translate([0,0,Z_CONTROL_RING])animate_rz(115,90){
    control_ring();
    for(a=[0,24]){
      translate([0,0,H_CONTROL_RING/2])
        scale([1,1,(a==0) ? -1:1])
        translate([0,0,H_CONTROL_RING/2])
        rotate([0,0,a])
        color("#22d")
        ring(5,130)
        animate_rz(-96.3,-79.5)
      {
        bottom_leaf_link();
      }
    }
  }
}

module mechanism(){
  control_bearing_assembly();
  translate([0,0,Z_LEAVES_1])rotate([0,0,5.7])bottom_leaf_ring();
  control_mechanism();
  translate([0,0,Z_LEAVES_2])rotate([0,0,5.7+24])bottom_leaf_ring([30]){
    top_leaf_link();
  };
  //color("#2dd")translate([0,0,Z_LEAVES_TOP])top_leaf_ring();
  servo();
}


module lamp(){
  structure();
  mechanism();
  //light_fixture();
}

$fn=72;
lamp();

