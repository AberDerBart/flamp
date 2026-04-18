use <bartscad/servos.scad>
include <../constants.scad>
include <../electronics.scad>
include <constants.scad>

module control_frame(){
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
      linear_extrude(16.5){
        for(i=BEARING_INDEXES)let(rz=360/5*i){
          rotate([0,0,rz+ANGLE_CONTROL_RING_BEARING])translate([R_CONTROL_RING_BEARING_MOUNT,0])difference(){
            circle(d=12);
            circle(d=4.8);
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
                  translate([R_CONTROL_RING_BEARING_MOUNT,0])circle(d=5);
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

control_frame();
