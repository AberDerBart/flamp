use <bartscad/linkage.scad>
use <bartscad/poly.scad>
use <bartscad/rotex.scad>
use <bartscad/origins.scad>
use <bartscad/tr.scad>
use <bartscad/ex.scad>

use <util.scad>
use <leaf.scad>
use <link.scad>
use <mounting_tab.scad>

include <constants.scad>

include <top_leaves/util.scad>
use <top_leaves/leaf.scad>
use <top_leaves/tilt_roller.scad>
use <top_leaves/tilt_rail.scad>
use <top_leaves/hinge.scad>
use <top_leaves/bracket.scad>
use <top_leaves/link.scad>

module top_leaf_assembly(){
  rotate([0,0,0]){
    animate_rz(TOP_LEAF_ANGLE_MIN,TOP_LEAF_ANGLE_MAX){
      top_leaf();
      top_leaf_bracket();
      leaf_hinge();
      tilt_rail();
    }
  }
  tilt_roller();
}

module top_leaf_ring(){
  ring(5,180){
    top_leaf_assembly();
  }
}

module top_leaf_assembly_jig(){
  module restrict(){
    intersection(){
      children();
      poly([
        [-100,-7],
        [0,20],
        fillet([50,40],14),
        [60,5],
        [120,5],
        [120,100],
        [150,-35],
        [135,-90],
        [102,-115],
        [90,-105],
        fillet([149,-7],30),
      ]);
    }
  }
  linear_extrude(4) restrict() difference(){
    union(){
      offset(2)top_leaf_2d();
      translate([-10,10])circle(r=5);
    }
    top_leaf_2d();
  }
  linear_extrude(1) restrict() difference(){
    top_leaf_2d();
    offset(0.1)projection()leaf_hinge();
    offset(0.1)translate([40,10.8]){
      hull(){
        circle(d=10);
        translate([-6,-20])circle(d=10);
      }
    }
    offset(0.1)projection(cut=true)translate([0,0,-5.99])tr(tr_leaf_inv())tilt_rail();
    for(p=[[160,-42],[138,-61],[117,-117],[18,12],[47,12]]){
      translate(p)circle(d=3);
    }
  }
}

module top_leaf_template_2d(){
  module puzzle(){
    poly([
      [81,0],
      fillet([88,0],1),
      fillet([86,5],1),
      fillet([96,5],1),
      fillet([94,0],1),
      [102,0],
      [102,200],
      [-200,200],
      [-200,0],
    ]);
  }
  difference(){
    intersection(){
      translate([-1/sqrt(3)*240,0]) rotate([0,0,30]) difference() {
        top_leaf_2d();
        offset(-20)top_leaf_2d();
      }
      puzzle();
    }
    rotate([0,0,120])puzzle();
  }
}

$fn=360;
top_leaf_assembly();

translate([200,0])color("#f00")animate_rz(TOP_LEAF_ANGLE_MIN,TOP_LEAF_ANGLE_MAX)tr_leaf()top_leaf_assembly_jig();

