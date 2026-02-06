use <bartscad/linkage.scad>
use <bartscad/poly.scad>

use <util.scad>
use <leaf.scad>
use <link.scad>

include <constants.scad>

$fn=360;

BRACKET_OFFSET=5;

module tr_leaf(){
  translate([2,14,8])rotate([-15,0,-72])children();
}

module top_leaf_2d(){
  leaf(240,60);
}

module top_leaf(){
  tr_leaf()linear_extrude(H_LEAVES)top_leaf_2d();
}

module top_leaf_bracket(){
  difference(){
    union(){
      hull(){
        cylinder(d=10,h=20);
        tr_leaf()scale([1,1,-1])linear_extrude(3)offset(-BRACKET_OFFSET)intersection(){
          circle(r=39);
          top_leaf_2d();
        }
        rotate([0,0,232])linkage([0,0],[70,0],20,54,true){
          linear_extrude(3)link($l);
          linear_extrude(0);
        }
      }
      rotate([0,0,232]){
        linkage([0,0],[70,0],20,54,true){
          linear_extrude(0);
          translate([0,0,-8]){
            linear_extrude(3)link($l);
            cylinder(d=10,h=11);
          }
        }
      }
    }
    tr_leaf()linear_extrude(100)square(100, center=true);
    cylinder(d=2.8,h=200,center=true);
  }
}

module top_leaf_assembly(){
  top_leaf();
  top_leaf_bracket();
}

module top_leaf_ring(){
  ring(5,180){
    animate_rz(-28,0){
      top_leaf_assembly();
    }
  }
}

module top_leaf_assembly_jig(){
  linear_extrude(H_LEAVES+2) difference(){
    rotate([0,0,-30])translate([-5,-20])square([30,40]);
    top_leaf_2d();
  }
  linear_extrude(2)difference(){
    rotate([0,0,-30])translate([-5,-20])square([30,40]);
    offset(-BRACKET_OFFSET)top_leaf_2d();
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

*top_leaf_2d();

color("#c44")translate([0,0,10])top_leaf();
top_leaf_bracket();
translate([0,0,-30])top_leaf_assembly_jig();

linear_extrude(4)top_leaf_template_2d();
