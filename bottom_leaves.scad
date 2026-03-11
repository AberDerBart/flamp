use <bartscad/linkage.scad>
use <bartscad/fasteners.scad>

use <util.scad>
use <leaf.scad>
use <link.scad>

include <constants.scad>

$fn=360;

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

module bottom_leaf_spacer(){
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

module bottom_leaf_assembly(additional_link_holes=[]){
  linear_extrude(H_LEAVES,center=true)bottom_leaf_2d(additional_link_holes);
  bottom_leaf_spacer();
}

module bottom_leaf_ring(additional_link_holes=[]){
  ring(5,180){
    animate_rz(-80,0)rotate([0,0,-115]){
      color("#c82")translate([0,0,H_LEAF_GAP/2])bottom_leaf_assembly(additional_link_holes);
      rotate([0,0,-10]) translate([30,0,H_LEAF_GAP/2+H_LEAVES/2])children();
    }
  }
}

module bottom_leaf_template() {
  linear_extrude(4)difference(){
    bottom_leaf_2d([30]);
    hull()offset(-15)bottom_leaf_2d();
  }
}

!bottom_leaf_spacer();

translate([0,0,-H_LEAVES/2])linear_extrude(H_LEAVES)bottom_leaf_2d();
translate([140,0,0])bottom_leaf_template();

translate([0,-30,0])bottom_leaf_link();
