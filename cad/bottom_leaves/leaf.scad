include <../constants.scad>
use <../link.scad>
use <../leaf.scad>

module bottom_leaf_2d(additional_link_holes=[]){
  difference(){
    offset(-10)offset(10)union(){
      circle(d=10);
      rotate([0,0,75])leaf(180,30);
      rotate([0,0,-10]){
        link(L_BOTTOM_LEAF_LINKS[1]);
      }
    }
    for(x=[0,L_BOTTOM_LEAF_LINKS[1], each additional_link_holes]){
      rotate([0,0,-10])translate([x,0])circle(d=3);
    }
  }
}

module bottom_leaf(additional_link_holes=[30]){
  linear_extrude(H_LEAVES,center=true)bottom_leaf_2d(additional_link_holes);
}

$fn=360;
bottom_leaf();

