include <constants.scad>

module lf_support(){

}

module lf_base(){
  translate([0,0,Z_LIGHT_FIXTURE]){
    linear_extrude(3){
      circle(r=R_LIGHT_FIXTURE);
    }
    linear_extrude(13)difference(){
      circle(r=R_LIGHT_FIXTURE);
      circle(r=R_LIGHT_FIXTURE-3);
    }
  }
}

module lf_diffusor(){
  translate([0,0,Z_LIGHT_FIXTURE+13]){
    cylinder(r=R_LIGHT_FIXTURE,h=4);
    *intersection(){
      scale([1,1,1])translate([0,0,-sqrt(R_DIFFUSOR_DOME^2-R_LIGHT_FIXTURE^2)])sphere(r=R_DIFFUSOR_DOME);
      cylinder(r=R_LIGHT_FIXTURE,h=100);
    }
  }
}

module power_supply(){
  color("#ddd")translate([5,5,Z_LIGHT_FIXTURE])rotate([0,180,0])linear_extrude(30)translate([0,20])square([96,57],center=true);
}

module pcb(){
  color("#0f0")translate([0,-35,Z_LIGHT_FIXTURE-3])rotate([0,180,270])import("pcb/pcb.stl");
}

module light_fixture(){
  power_supply();
  pcb();
  lf_base();
  %lf_diffusor();
}

light_fixture();
