include <../constants.scad>
use <../link.scad>

module bottom_leaf_link(){
  let(h=(H_LEAF_GAP-H_LEAVES+H_SUPPORT_RING-H_CONTROL_RING)/2){
    linear_extrude((h+H_LINKS)/2)difference(){
      circle(d=10);
      circle(d=2.8);
    }
    translate([L_BOTTOM_LEAF_LINKS[0],0,h])scale([1,1,-1]){
      linear_extrude(h)difference(){
        circle(d=10);
        circle(d=2.8);
      }
    }
    translate([0,0,h/2])linear_extrude(H_LINKS,center=true)link(L_BOTTOM_LEAF_LINKS[0]);
  }
}

$fn=360;
bottom_leaf_link();
