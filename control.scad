use <bartscad/bearings.scad>
use <bartscad/servos.scad>
use <bartscad/linkage.scad>
use <bartscad/poly.scad>

use <BOSL/involute_gears.scad>

include <constants.scad>

use <link.scad>
use <util.scad>
include <electronics.scad>

BEARING_INDEXES=[1,2,4];
//TR_SERVO=rz(-30)*ty(67)*tz(Z_CONTROL_RING_BEARING_STACK+4+6.5);

TR_POWER_SUPPLY=rz(90-120)*t(0,-33,Z_CONTROL_RING_BEARING_STACK);
TR_PCB=rz(90-120)*t(10,26,Z_CONTROL_RING_BEARING_STACK+15)*rz(-90);

MM_PER_TOOTH=2.5;
TEETH_SERVO=25;
TEETH_CONTROL_RING=180;

TR_SERVO=rz(-30)
  * ty(pitch_radius(MM_PER_TOOTH,TEETH_CONTROL_RING))
  * tz(Z_CONTROL_RING+H_CONTROL_RING-pitch_radius(MM_PER_TOOTH,TEETH_SERVO))
  * t(y=-H_CONTROL_RING/sqrt(2), z=H_CONTROL_RING/sqrt(2))
  * rx(-90);

module servo(){
  tr(TR_SERVO){
    translate([0,0,-10])servo_joy_it();
    tr(rz(4))gear(mm_per_tooth=MM_PER_TOOTH,number_of_teeth=TEETH_SERVO, thickness=4, bevelang=45);
  }
}

module control_ring(){
  color("#2d2"){
    rotate([0,0,-90-30])translate([0,0,H_CONTROL_RING])difference(){
      linear_extrude(H_CONTROL_RING){
        difference(){
          circle(r=R_CONTROL_RING_INNER+1);
          translate([-1000,-500])square(1000);
          rotate([0,0,180-25])translate([-1000,-500])square(1000);
          circle(r=pitch_radius(MM_PER_TOOTH, TEETH_CONTROL_RING)-H_CONTROL_RING-1);
        }
      }
      translate([0,0,H_CONTROL_RING/2])gear(mm_per_tooth=MM_PER_TOOTH, number_of_teeth=180,thickness=7,interior=true,bevelang=45,teeth_to_hide=180-25);
    }
    translate([0,0,H_CONTROL_RING])linear_extrude(H_CONTROL_RING)difference(){
      circle(r=R_CONTROL_RING_INNER+15);
      circle(r=R_CONTROL_RING_INNER);
      for(rz=LINK_CONTROL_ANGLES){
        rotate([0,0,rz])ring(5,R_CONTROL_RING_INNER+10)circle(d=3);
      }
    }
  }
  ring(5,0){
    translate([0,0,-0.01])
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

module control_frame(){
  color("#d22")translate([0,0,H_BASE])linear_extrude(6.5){
    tr(TR_SERVO)union(){
      difference(){
        union(){
          translate([0,-5])offset(5)servo_sg90_cutout();
          translate([17,-10])rotate([0,0,-72])link(58);
          translate([-7,-10])rotate([0,0,-140])link(38);
        }
        offset(0.1)servo_sg90_cutout();
        servo_sg90_mounting_holes();
      }
    }
    difference(){
      union(){
        tr(TR_POWER_SUPPLY*TR_POWER_SUPPLY_MOUNTING_TABS[1])circle(d=15);
        hull(){
          translate([38,-28])circle(d=15);
          tr(TR_POWER_SUPPLY*TR_POWER_SUPPLY_MOUNTING_TABS[0])circle(d=15);
        }
        hull(){
          for(tr_hole=TR_PCB_MOUNTING_HOLES) tr(TR_PCB*tr_hole) circle(d=10);
        }
        for(i=BEARING_INDEXES)let(rz=360/5*i){
          rotate([0,0,rz+ANGLE_CONTROL_RING_BEARING]){
            difference(){
              union(){
                hull(){
                  circle(d=20);
                  translate([R_CONTROL_RING_BEARING_MOUNT,0])circle(d=15);
                }
                hull(){
                  translate([R_CONTROL_RING_BEARING_MOUNT,0])circle(d=15);
                  rotate([0,0,-ANGLE_CONTROL_RING_BEARING+22.5])translate([105,0])circle(d=12);
                }
              }
              rotate([0,0,-ANGLE_CONTROL_RING_BEARING+22.5])translate([105,0])circle(d=3);
              translate([R_CONTROL_RING_BEARING_MOUNT,0])circle(d=7);
              circle(d=5);
            }
          }
        }
      }
      for(tr_hole=TR_POWER_SUPPLY_MOUNTING_TABS) tr(TR_POWER_SUPPLY*tr_hole) circle(d=2.8);
      for(tr_hole=TR_PCB_MOUNTING_HOLES) tr(TR_PCB*tr_hole)circle(d=2.8);
    }
  }
}

module control_bearing_assembly(){
  control_frame();
  translate([0,0,Z_CONTROL_RING_BEARING_STACK]){
    rotate([0,0,ANGLE_CONTROL_RING_BEARING])for(i=BEARING_INDEXES){
      rotate([0,0,360/5*i])translate([R_CONTROL_RING_BEARING_MOUNT,0])control_ring_bearing_stack();
    }
  }
  tr(TR_POWER_SUPPLY)power_supply();
  tr(TR_PCB)pcb();
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

control_bearing_assembly();
servo();
tr(tz(Z_CONTROL_RING)*rz(90))control_ring();
$fn=360;
translate([130,0])control_drill_jig();
