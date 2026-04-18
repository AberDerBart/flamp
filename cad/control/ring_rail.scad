include <../constants.scad>
include <constants.scad>

module control_ring_rail(extend_angle_top=0,extend_angle_bottom=6){
  module top_end(){
    linear_extrude(5, center=true)difference(){
      circle(d=17);
      circle(d=7.2);
      translate([0,-17/2])square(17,center=true);
    }
  }

  module bottom_end(){
    linear_extrude(5,center=true)difference(){
      let(d=(17-7.2)/2)
        for(x=[17/2-d/2,-17/2+d/2])
        translate([x,0])
        circle(d=d);
      translate([0,17/2])square(17,center=true);
    }
  }

  translate([0,0,Z_SERVO])rotate([90,0,0]){
    translate([0,0,R_SERVO_LINK+1])linear_extrude(3,center=true){
      for(x=[-10,10]){
        translate([x,OFFSET_Z_CONTROL_RAIL])difference(){
          circle(d=10);
          circle(d=3.2);
        }
      }
    }
    rotate([-SERVO_TRAVEL/2-extend_angle_top,0,0])translate([0,0,R_SERVO_LINK])top_end();
    rotate([extend_angle_bottom,0,0])translate([0,0,R_SERVO_LINK])bottom_end();
    difference(){
      rotate([0,-90,0])rotate_extrude(SERVO_TRAVEL/2+extend_angle_top+extend_angle_bottom,start=-extend_angle_bottom){
        translate([R_SERVO_LINK,0])difference(){
          square([5,17],center=true);
          square([6,7.2],center=true);
        }
      }

      translate([0,0,R_SERVO_LINK-10]){
        for(x=[-10,10]){
          translate([x,OFFSET_Z_CONTROL_RAIL])cylinder(d=7,h=100,center=true);
        }
      }
    }
  }
}

$fn=360;
control_ring_rail();
