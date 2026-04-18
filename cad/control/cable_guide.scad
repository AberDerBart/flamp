use <bartscad/origins.scad>
use <bartscad/poly.scad>

include <../constants.scad>
include <constants.scad>

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

cable_guide();
