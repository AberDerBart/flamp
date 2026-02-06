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

include <constants.scad>

$fn=360;
$hide_leaves=false;

module control_ring() {
  color("#d22")linear_extrude(H_CONTROL_RING)difference(){
    circle(r=140);
    circle(r=R_CONTROL_RING_INNER);
    for(rz=LINK_CONTROL_ANGLES){
      rotate([0,0,rz])ring(5,130)circle(d=3);
    }
  }
}

module control_ring_bearing_stack() {
  excenter(){
    translate([0,0,9])scale([1,1,-1])cylinder(d=5,h=25);
    difference(){
      union(){
        cylinder(d=8,h=3);
        cylinder(d=23,h=2.5);
      }
      cylinder(d=5.4,h=100, center=true);
    }
    translate([0,0,9])scale([1,1,-1])bearing_f635();
  }
}


module excenter(){
  difference(){
    union(){
      linear_extrude(8)let($fn=6)circle(d=11.54);
      translate([0,0,-1.5])linear_extrude(10.5)circle(d=7);
    }
    translate([0.8,0,8])linear_extrude(1000, center=true)circle(d=5);
  }
  translate([0.8,0,8])children();
}

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

module servo(){
  rotate([0,0,24])translate([0,62,6+H_CONTROL_RING]){
    servo_sg90();
    animate_rz(180,0){
      linear_extrude(3)link(l=13);
      translate([13,0])animate_rz(0,152)rotate([0,0,196])linear_extrude(3)link(l=111);
    }
  }
}

module top_leaf_link(){
  color("#d2d") difference(){
    union(){
      cylinder(d=10,h=6);
      animate_rz(0,-83)rotate([0,0,80])translate([0,0,3])linear_extrude(3)link(115.5);
    }
    cylinder(d=2.8,h=100,center=true);
  }
}
  

module mechanism(){
  translate([0,0,Z_LEAVES_1])rotate([0,0,5.7])bottom_leaf_ring();
  control_mechanism();
  translate([0,0,Z_CONTROL_RING_BEARING_STACK]){
    rotate([0,0,27.2])ring(5,R_CONTROL_RING_INNER-9.5)control_ring_bearing_stack();
  }
  translate([0,0,Z_LEAVES_2])rotate([0,0,5.7+24])bottom_leaf_ring([30]){
    top_leaf_link();
  };
  color("#2dd")translate([0,0,Z_LEAVES_TOP])top_leaf_ring();
  *servo();
}


module lamp(){
  structure();
  mechanism();
}

intersection(){
  lamp();
  //cube(1000);
}


