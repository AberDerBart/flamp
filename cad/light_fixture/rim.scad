use <bartscad/origins.scad>
use <bartscad/poly.scad>

include <../constants.scad>

module lf_rim_segment(){
  color("#4c4")rotate([0,0,-20])translate([0,0,Z_LIGHT_FIXTURE+3])difference(){
    linear_extrude(10)union(){
      difference(){
        circle(r=R_LIGHT_FIXTURE);
        circle(r=R_LIGHT_FIXTURE-5);
        translate([-500,-1000])square([1000,1000]);
        rotate([0,0,360/5])translate([-500,0])square([1000,1000]);
      }
      rotate([0,0,20]){
        difference(){
          union(){
            translate([R_LIGHT_FIXTURE-1,-5])square([R_STRUCTURE-R_LIGHT_FIXTURE+1,10]);
            translate([R_STRUCTURE,0])circle(d=10);
          }
          translate([R_LIGHT_FIXTURE+5,0])circle(d=2.8);
          translate([R_STRUCTURE,0])circle(d=3);
        }
      }

      translate([R_LIGHT_FIXTURE-5,0])square([5,10]);
      rotate([0,0,360/5])translate([R_LIGHT_FIXTURE,0])poly([
        [0,0],
        [0,10],
        [5,10],
        fillet([5,-5],3),
        [-3,-5],
        [-3,0],
      ]);
    }
    translate([R_LIGHT_FIXTURE,5,5])rotate([0,90,0])cylinder(d=2.8,h=100,center=true);
    rotate([0,0,360/5])translate([R_LIGHT_FIXTURE,5,5])rotate([0,90,0])cylinder(d=3,h=100,center=true);
    rotate([0,0,20])translate([R_STRUCTURE,0,0]){
      translate([0,0,7.5])cylinder(r1=1,r2=4.1,h=3.1);
      let(z=1)xzy()linear_extrude(20,center=true)poly([
        [-23,-1],
        [-12,z],
        [10,z],
        [10,-1],
      ]);
    }
    translate([0,0,5])rotate([0,90,15])cylinder(d=5,h=1000);
  }
}

module lf_rim(){
  for(rz=[0:360/5:359]){
    rotate([0,0,rz+ANGLE_LIGHT_FIXTURE])lf_rim_segment();
  }
}

$fn=360;
lf_rim_segment();
