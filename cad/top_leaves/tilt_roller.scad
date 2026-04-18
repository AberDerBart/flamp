use <bartscad/origins.scad>

include <util.scad>
include <../constants.scad>
use <../mounting_tab.scad>

function tr_tilt_roller() = rz(-90-ANGLE_OFFSET_TILT_ROLLER)*tx(OFFSET_TILT_ROLLER)*tz(4);

module tilt_roller(){
  module mounting_profile(){
    rotate([0,0,-ANGLE_OFFSET_TILT_ROLLER])difference(){
      hull(){
        circle(d=10);
        rotate([0,0,ANGLE_OFFSET_TILT_ROLLER])translate([0,-5])square([7,10]);
        translate([-15,-13])square([26,3]);
      }
    }
  }

  color("#482")tr(tr_tilt_roller()){
    difference(){
      union(){
        translate([0,0,-7])linear_extrude(6)intersection(){
          mounting_profile();
          rotate([0,0,-ANGLE_OFFSET_TILT_ROLLER])translate([0,-R_STRUCTURE,0])circle(r=R_STRUCTURE-10);
        }
        hull(){
          translate([0,0,-4]){
            mounting_tab(10,4,3,countersink=true);
            linear_extrude(3)mounting_profile();
          }
          translate([4,0,0])yzx(){
            linear_extrude(3){
              hull(){
                translate([-5,-4])square([10,4]);
                translate([0,8+3.5])circle(d=7);
              }
            }
          }
        }
        translate([4,0,0])yzx()translate([0,8+3.5,3])cylinder(r1=3.5,r2=2,h=1.5);
      }
      yzx()translate([0,8+3.5])cylinder(d=2.8,h=20,center=true);
      cylinder(d=3,h=100,center=true);
      translate([0,0,2])cylinder(d=8,h=20);
      cylinder(r1=1.5, r2=3.6,h=2.1);
    }
  }
}

$fn=360;
tr_leaf_invtilt_roller();
