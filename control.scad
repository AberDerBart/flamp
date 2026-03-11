use <bartscad/bearings.scad>
use <bartscad/servos.scad>
use <bartscad/linkage.scad>
use <bartscad/poly.scad>

include <constants.scad>

use <link.scad>
use <util.scad>

BEARING_INDEXES=[1,2,4];
TR_SERVO=rz(-30)*ty(67)*tz(Z_CONTROL_RING_BEARING_STACK+4+6.5);

module servo(){
  tr(TR_SERVO){
    servo_sg90();
    animate_rz(180,0){
      linear_extrude(3)link(l=13);
      translate([15,0])animate_rz(3.4,159)linear_extrude(3)link(l=56);
    }
  }
}

module control_ring_2(){
  color("#2d2"){
    translate([0,0,H_CONTROL_RING])linear_extrude(H_CONTROL_RING)difference(){
      circle(r=R_CONTROL_RING_INNER+15);
      circle(r=R_CONTROL_RING_INNER);
      for(rz=LINK_CONTROL_ANGLES){
        rotate([0,0,rz])ring(5,R_CONTROL_RING_INNER+10)circle(d=3);
      }
      rotate([0,0,-7])translate([R_CONTROL_RING_INNER+10,0])circle(d=3);
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

module control_bearing_mount(){
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
}

module control_bearing_assembly(){
  control_bearing_mount();
  translate([0,0,Z_CONTROL_RING_BEARING_STACK]){
    rotate([0,0,ANGLE_CONTROL_RING_BEARING])for(i=BEARING_INDEXES){
      rotate([0,0,360/5*i])translate([R_CONTROL_RING_BEARING_MOUNT,0])control_ring_bearing_stack();
    }
  }
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
    rotate([0,0,72+22.5])translate([105,0])circle(d=3);
    rotate([0,0,72+12])translate([R_STRUCTURE,0])circle(d=4);
  }
}

#control_bearing_assembly();
control_drill_jig();
