include <../constants.scad>

module support(){
  linear_extrude(H_LEAF_GAP){
    difference(){
      circle(d=14);
      circle(d=10);
    }
  }
  translate([0,0,1.5])linear_extrude(H_LEAF_GAP-1.5){
    difference(){
      circle(d=14);
      circle(d=4.2);
    }
  }
}
