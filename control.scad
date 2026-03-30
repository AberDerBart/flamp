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

ANGLE_CENTER=180;

BEARING_INDEXES=[1,2,4];
//TR_SERVO=rz(-30)*ty(67)*tz(Z_CONTROL_RING_BEARING_STACK+4+6.5);

TR_POWER_SUPPLY=rz(ANGLE_CENTER)*t(0,-30,Z_CONTROL_RING_BEARING_STACK);
TR_PCB=rz(ANGLE_CENTER)*t(10,29,Z_CONTROL_RING_BEARING_STACK+15)*rz(-90);

MM_PER_TOOTH=2.6;
TEETH_SERVO=25;
TEETH_CONTROL_RING=180;

TR_SERVO=rz(ANGLE_CENTER)
  * ty(pitch_radius(MM_PER_TOOTH,TEETH_CONTROL_RING))
  * tz(Z_CONTROL_RING+H_CONTROL_RING-pitch_radius(MM_PER_TOOTH,TEETH_SERVO))
  * t(y=-H_CONTROL_RING/sqrt(2), z=H_CONTROL_RING/sqrt(2))
  * rx(-90);

POS_CABLE_GUIDE=[0,67];

module servo_gear(){
  difference(){
    union(){
      tr(rz(4))gear(mm_per_tooth=MM_PER_TOOTH,number_of_teeth=TEETH_SERVO, thickness=4, bevelang=45);
      translate([0,0,-9.5])cylinder(d=18.5,h=7.52);
    }
    translate([0,0,-10]){
      cylinder(d=5.8,h=4.5);
      cylinder(d=3.2,h=20);
    }
  }
}

module servo(){
  tr(TR_SERVO){
    *translate([0,0,-10])servo_joy_it();
    servo_gear();
  }
}

module control_ring(){
  color("#2d2"){
    rotate([0,0,-90+ANGLE_CENTER-3])translate([0,0,H_CONTROL_RING])difference(){
      linear_extrude(H_CONTROL_RING){
        difference(){
          circle(r=R_CONTROL_RING_INNER+1);
          rotate([0,0,6])translate([-1000,-500])square(1000);
          rotate([0,0,180-25])translate([-1000,-500])square(1000);
          circle(r=pitch_radius(MM_PER_TOOTH, TEETH_CONTROL_RING)-H_CONTROL_RING-1);
        }
      }
      translate([0,0,H_CONTROL_RING/2])gear(mm_per_tooth=MM_PER_TOOTH, number_of_teeth=180,thickness=7,interior=true,bevelang=45);
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

module gear_support(){
  translate([0,0,Z_CONTROL_RING+H_CONTROL_RING*2])rotate_extrude(20,start=ANGLE_CENTER+90-10){
    translate([72,0])square([10,3]);
  }
}

module control_frame(){
  gear_support();
  color("#d22")translate([0,0,H_BASE])difference(){
    union(){
      linear_extrude(TR_PCB[2][3]-H_BASE-2)tr(TR_PCB) difference(){
        hull()projection()pcb();
        for(tr_hole=TR_PCB_MOUNTING_HOLES){
          tr(tr_hole)circle(d=2.8);
        }
      }
      linear_extrude(TR_PCB[2][3]-H_BASE){
        for(tr_hole=TR_PCB_MOUNTING_HOLES){
          tr(TR_PCB*tr_hole)difference(){
            circle(d=8);
            circle(d=2.8);
          }
        }
      }
      linear_extrude(6.5){
        difference(){
          union(){
            difference(){
              hull(){
                translate(POS_CABLE_GUIDE)circle(d=15);
                translate([-20,60])circle(d=15);
              }
              translate(POS_CABLE_GUIDE)circle(d=3.2);
            }
            hull(){
              translate([15,-20])circle(d=15);
              tr(TR_POWER_SUPPLY*TR_POWER_SUPPLY_MOUNTING_TABS[1])circle(d=15);
            }
            hull(){
              translate([-20,50])circle(d=15);
              tr(TR_POWER_SUPPLY*TR_POWER_SUPPLY_MOUNTING_TABS[0])circle(d=15);
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
                }
              }
            }
          }
          for(tr_hole=TR_POWER_SUPPLY_MOUNTING_TABS) tr(TR_POWER_SUPPLY*tr_hole) circle(d=2.8);
          for(tr_hole=TR_PCB_MOUNTING_HOLES) tr(TR_PCB*tr_hole)circle(d=2.8);
        }
      }
    }
    tr(tz(-H_BASE)*TR_SERVO*tz(-10)){
      servo_joy_it_cutout();
      translate([-30,-10,-42.1])cube([30,15.1,10]);
    }
  }
}

module cable_guide() {
  translate([POS_CABLE_GUIDE.x, POS_CABLE_GUIDE.y,Z_CONTROL_RING_BEARING_STACK-2])rotate([0,0,134])difference(){
    union(){
      linear_extrude(5)poly([
        [4,-4],
        [-4,-4],
        fillet([-4,4],4),
        fillet([4,4],4),
      ]);
      xzy()translate([0,0,-7])linear_extrude(3){
        difference(){
          poly([
            fillet([-6,32],2),
            fillet([-6,5],2),
            [4,5],
            [4,0],
            fillet([-14,0],5),
            fillet([-14,41],5),
            fillet([102,41],5),
            fillet([106,48.5],5),
            [120,48.5],
            [120,45.5],
            [112,45.5],
            fillet([112,32],12),
          ]);
          for(x=[5,80]){
            translate([x,31])square([5,3]);
            translate([x,39])square([5,3]);
          }
        }
      }
      hull(){
        translate([120,-7+4,45.5])cylinder(d=8,h=3);
        translate([109,-7,45.5])cube(3);
      }
    }
    cylinder(d=2.8,h=10);
    translate([120,-7+4,45]){
      cylinder(d=1.5,h=4);
      translate([0,0,1])cylinder(r1=0.1,r2=3,h=3);
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

control_bearing_assembly();
servo();
tr(tz(Z_CONTROL_RING)*rz(90))control_ring();
$fn=360;
translate([130,0])control_drill_jig();

