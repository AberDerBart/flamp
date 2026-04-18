include <../constants.scad>
use <leaf.scad>

module bottom_leaf_bracket(){
  color("#282")difference(){
    union(){
      cylinder(d=15,h=H_LEAF_GAP-1,center=true);
      translate([0,0,H_LEAF_GAP/2-1])cylinder(r2=2,r1=3,h=1);
      scale([1,1,-1])linear_extrude((H_LEAF_GAP-1)/2){
        rotate([0,0,-18])hull(){
          translate([3,0])circle(d=9);
          translate([3,32])circle(d=9);
        }
      }
      linear_extrude((H_LEAF_GAP-1),center=true){
        rotate([0,0,-18])scale([1,-1])square([7.5,7.5]);
      }
    }
    linear_extrude(H_LEAVES,center=true){
      bottom_leaf_2d();
      circle(d=4);
    }
    cylinder(d=2.8,h=100,center=true);
    for(p=[[4,3],[8,15],[13,30]]){
      translate(p){
        scale([1,1,-1])cylinder(d=1.5,h=100);
        translate([0,0,-H_LEAF_GAP/2])cylinder(r1=2.5,r2=0.5,h=2);
      }
    }
  }
}

$fn=360;
bottom_leaf_bracket();
