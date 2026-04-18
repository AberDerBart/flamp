use <../link.scad>

module top_leaf_bracket(){
  difference(){
    union(){
      translate([0,0,1])cylinder(d=10,h=7);
      translate([0,0,0.5])cylinder(r1=2.5,r2=5,h=2);
      translate([-5,0,8])rotate([0,90,0])cylinder(d=10, h=44.5);
      translate([0,0,1])rotate([0,0,-90])linear_extrude(3)link(20);
      translate([0,-20,-12]){
        cylinder(d=10,h=16);
        rotate([0,0,-48])linear_extrude(3)link(43.5);
      }
    }
    cylinder(d=2.8,h=100,center=true);
    translate([0,0,8])rotate([0,90,0])cylinder(d=2.8, h=200, center=true);
  }
}

$fn=360;
top_leaf_bracket();
