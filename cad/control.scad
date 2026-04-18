use <bartscad/bearings.scad>
use <bartscad/servos.scad>
use <bartscad/linkage.scad>
use <bartscad/poly.scad>
use <bartscad/origins.scad>

use <BOSL/involute_gears.scad>

include <constants.scad>

use <link.scad>
use <util.scad>
include <electronics.scad>

include <control/constants.scad>
use <control/frame.scad>
use <control/cable_guide.scad>
use <control/drive_cam.scad>
use <control/bearing_washer.scad>
include <control/ring.scad>

function tr_servo_gear_peg(a_servo) = tz(Z_SERVO) * rz(ANGLE_CENTER+90) * rx(a_servo) * rz(ANGLE_CONTROL_RING_TRAVEL/2)*ry(90)*tz(R_SERVO_LINK);

function a_control_ring(a_servo) = asin(cos(a_servo)*SERVO_TRAVEL/2/R_SERVO_LINK);

module servo(){
  #tr(TR_SERVO)translate([0,0,-10])servo_joy_it();
  drive_cam();
}

module control_ring_bearing_stack() {
  translate([0,0,8]){
    control_bearing_washer();
    translate([0,0,9])scale([1,1,-1])bearing_f635();
  }
}

module control_frame_assembly(){
  control_frame();
  translate([0,0,Z_CONTROL_RING_BEARING_STACK]){
    rotate([0,0,ANGLE_CONTROL_RING_BEARING])for(i=BEARING_INDEXES){
      rotate([0,0,360/5*i])translate([R_CONTROL_RING_BEARING_MOUNT,0])control_ring_bearing_stack();
    }
  }
  tr(TR_POWER_SUPPLY)power_supply();
  *tr(TR_PCB)pcb();
  cable_guide();
}

module control_drill_jig(){
  linear_extrude(3) difference(){
    union(){
      hull(){
        circle(d=10);
        rotate([0,0,72+22.5])translate([105,0])circle(d=10);
      }
      hull(){
        rotate([0,0,72+22.5])translate([105,0])circle(d=10);
        rotate([0,0,72+12])translate([R_STRUCTURE,0])circle(d=10);
      }
    }
    circle(d=5);
    rotate([0,0,72+22.5])translate([105,0])circle(d=2);
    rotate([0,0,72+12])translate([R_STRUCTURE,0])circle(d=4);
  }
}

control_frame_assembly();
servo();
tr(tz(Z_CONTROL_RING)*rz(90))control_ring();
$fn=360;

