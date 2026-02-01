use <bartscad/linkage.scad>

use <util.scad>
use <leaf.scad>
use <link.scad>

include <constants.scad>

module bottom_leaf_link(){
  let(h=(H_LEAF_GAP-H_LEAVES+H_SUPPORT_RING-H_CONTROL_RING)/2){
    linear_extrude((h+H_LINKS)/2)difference(){
      circle(d=10);
      circle(d=2.8);
    }
    translate([L_BOTTOM_LEAF_LINKS[0],0,h])scale([1,1,-1]){
      linear_extrude((h+H_LINKS)/2)difference(){
        circle(d=10);
        circle(d=2.8);
      }
    }
    translate([0,0,h/2])linear_extrude(H_LINKS,center=true)link(L_BOTTOM_LEAF_LINKS[0]);
  }
}

module bottom_leaf_2d(additional_link_holes=[]){
  difference(){
    union(){
      rotate([0,0,75])leaf(180,30);
      rotate([0,0,-10]){
        link(L_BOTTOM_LEAF_LINKS[1]);
      }
      for(x=additional_link_holes){
        rotate([0,0,-10])translate([x,0])circle(d=3);
      }
    }
  }
}

module bottom_leaf_ring(additional_link_holes=[]){
  ring(5,180){
    cylinder(d=10,h=H_LEAF_GAP);
    animate_rz(-80,0)rotate([0,0,-115]){
      translate([0,0,H_LEAF_GAP/2])linear_extrude(H_LEAVES,center=true)bottom_leaf_2d(additional_link_holes);
      rotate([0,0,-10]) translate([30,0,H_LEAF_GAP/2+H_LEAVES/2])children();
    }
  }
}

