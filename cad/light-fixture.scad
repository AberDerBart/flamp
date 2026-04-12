use <bartscad/poly.scad>
use <bartscad/origins.scad>
use <electronics.scad>

include <constants.scad>

module lf_support(){

}

module lf_base(){
  translate([0,0,Z_LIGHT_FIXTURE]){
    linear_extrude(3){
      circle(r=R_LIGHT_FIXTURE);
    }
  }
}

module lf_diffusor_clamp(){
  translate([0,0,-2]){
    linear_extrude(4.8)difference(){
      poly([
        fillet([5,5],5),
        [-5,5],
        [-5,-5],
        fillet([5,-5],5),
      ]);
      circle(d=3.2);
    }
    linear_extrude(2)difference(){
      poly([
        fillet([5,5],5),
        [-8,5],
        [-8,-5],
        fillet([5,-5],5),
      ]);
      circle(d=3.2);
    }
  }
}

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

module lf_diffusor(){
  translate([0,0,Z_LIGHT_FIXTURE+13]){
    cylinder(r=R_LIGHT_FIXTURE,h=3);
    *intersection(){
      scale([1,1,1])translate([0,0,-sqrt(R_DIFFUSOR_DOME^2-R_LIGHT_FIXTURE^2)])sphere(r=R_DIFFUSOR_DOME);
      cylinder(r=R_LIGHT_FIXTURE,h=100);
    }
  }
}


module light_fixture(){
  lf_base();
  lf_rim();
  %lf_diffusor();
  for(rz=[0:360/5:359]) {
    rotate([0,0,rz+ANGLE_LIGHT_FIXTURE])translate([R_LIGHT_FIXTURE+5,0,Z_LIGHT_FIXTURE]){
      lf_diffusor_clamp();
      translate([0,0,16])scale([1,1,-1])lf_diffusor_clamp();
    }
  }
}

light_fixture();

$fn=360;

