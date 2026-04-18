use <../link.scad>
use <../util.scad>

module top_leaf_link(){
  color("#d2d") difference(){
    union(){
      cylinder(d=10,h=6);
      animate_rz(3.7,-80.7)rotate([0,0,80])translate([0,0,3])linear_extrude(3)link(106.4);
    }
    cylinder(d=2.8,h=100,center=true);
  }
}
  
top_leaf_link();
