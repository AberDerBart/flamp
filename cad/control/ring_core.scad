include <../constants.scad>
include <constants.scad>
use <../util.scad>

module control_ring_core(){
  color("#2d2"){
    translate([0,0,H_CONTROL_RING])linear_extrude(H_CONTROL_RING)difference(){
      circle(r=R_CONTROL_RING_INNER+15);
      circle(r=R_CONTROL_RING_INNER);
      for(rz=LINK_CONTROL_ANGLES){
        rotate([0,0,rz])ring(5,R_CONTROL_RING_INNER+10)circle(d=3);
      }
    }
  }
}

$fn=360;
control_ring_core();
