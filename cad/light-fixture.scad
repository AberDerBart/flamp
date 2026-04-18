use <bartscad/poly.scad>
use <bartscad/origins.scad>
use <electronics.scad>

include <constants.scad>

use <light_fixture/diffusor_clamp.scad>
use <light_fixture/rim.scad>

module lf_support(){

}

module lf_base(){
  translate([0,0,Z_LIGHT_FIXTURE]){
    linear_extrude(3){
      circle(r=R_LIGHT_FIXTURE);
    }
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

