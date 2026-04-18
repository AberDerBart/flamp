include <../constants.scad>
include <constants.scad>

module drive_cam(angle=180){
  translate([0,0,Z_SERVO])rotate([angle,0,ANGLE_CENTER+90])difference(){
    union(){
      intersection(){
        sphere(r=R_SERVO_LINK-4);
        translate([R_SERVO_LINK-10,0,0])rotate([0,90,0])difference(){
          cylinder(d=SERVO_TRAVEL+6,h=5);
          cylinder(d=5.8,h=4.2);
          cylinder(d=3.2,h=13,center=true);
        }
      }
      rotate([0,0,0])rotate([0,0,ANGLE_CONTROL_RING_TRAVEL/2])rotate([0,90,0])translate([0,0,R_SERVO_LINK]){
        translate([0,0,-3-1.5])cylinder(r1=4,r2=2,h=3);
      }
    }
    rotate([0,0,0])rotate([0,0,ANGLE_CONTROL_RING_TRAVEL/2])rotate([0,90,0])translate([0,0,R_SERVO_LINK])cylinder(d=2.8,h=100,center=true);
  }
}

drive_cam();
