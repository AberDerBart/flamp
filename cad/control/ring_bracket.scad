use <bartscad/poly.scad>
use <bartscad/origins.scad>

include <../constants.scad>
include <constants.scad>

module control_ring_bracket(for_rail=false){
  linear_extrude(H_CONTROL_RING){
    difference(){
      hull(){
        for(rz=LINK_CONTROL_ANGLES){
          rotate([0,0,rz]){
            translate([R_CONTROL_RING_INNER+10,0])circle(d=10);
            translate([130,0])circle(d=10);
          }
        }
      }
      circle(r=R_CONTROL_RING_INNER+5);
      for(rz=LINK_CONTROL_ANGLES){
        rotate([0,0,rz]){
          translate([R_CONTROL_RING_INNER+10,0])circle(d=2.8);
          translate([130,0])circle(d=3);
        }
      }
    }
  }
  if(for_rail)
    rotate([0,0,-ANGLE_CONTROL_RING_MIN-ANGLE_CONTROL_RING_TRAVEL/2-2*360/5])
    translate([0,-R_CONTROL_RING_INNER,0])
    let(y_rail=R_SERVO_LINK-R_CONTROL_RING_INNER+2.5)
    difference()
  {
    union(){
      linear_extrude(H_CONTROL_RING){
        poly([
          [0,-6],
          [3,-10],
          fillet([15,-5],5),
          [15,-y_rail],
          [5,-y_rail],
          fillet([5,-y_rail-5],5),
          fillet([-5,-y_rail-5],5),
          [-5,-y_rail],
          [-15,-y_rail],
          [-15,-6],
        ]);
      }
      xzy(){
        for(x=[10,-10]){
          translate([x,Z_SERVO-Z_CONTROL_RING+OFFSET_Z_CONTROL_RAIL,-y_rail-5])linear_extrude(5){
            poly([
              [5,Z_CONTROL_RING-Z_SERVO+H_CONTROL_RING-OFFSET_Z_CONTROL_RAIL],
              [-5,Z_CONTROL_RING-Z_SERVO+H_CONTROL_RING-OFFSET_Z_CONTROL_RAIL],
              fillet([-5,5],5),
              fillet([5,5],5),
            ]);
          }
        }
      }
    }
    xzy(){
      for(x=[10,-10]){
        translate([x,Z_SERVO-Z_CONTROL_RING+OFFSET_Z_CONTROL_RAIL,-y_rail-5])linear_extrude(7){
          circle(d=2.8);
        }
      }
    }
  }
}

$fn=360;
control_ring_bracket(true);
