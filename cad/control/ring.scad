use <bartscad/origins.scad>
use <bartscad/poly.scad>

include <../constants.scad>
use <../util.scad>
include <constants.scad>
use <ring_bracket.scad>
use <ring_rail.scad>
use <ring_core.scad>

module control_ring(){
  translate([0,0,-Z_CONTROL_RING])rotate([0,0,-ANGLE_CONTROL_RING_MIN-ANGLE_CONTROL_RING_TRAVEL/2]){
    control_ring_rail();
  }
  control_ring_core();
  for(i=[0:4]){
    rotate([0,0,360/5*i]) translate([0,0,-0.01]) control_ring_bracket(for_rail=(i==2));
  }
}

control_ring();
