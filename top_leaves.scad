use <bartscad/linkage.scad>
use <bartscad/poly.scad>
use <bartscad/rotex.scad>
use <bartscad/origins.scad>
use <bartscad/tr.scad>
use <bartscad/ex.scad>

use <util.scad>
use <leaf.scad>
use <link.scad>

include <constants.scad>

$fn=360;

BRACKET_OFFSET=8;

TOP_LEAF_ANGLE_MIN=-28;
TOP_LEAF_ANGLE_MAX=0;

function interpolate_sin(x, tl, th, vl, vh) = x <= tl ? vl : x >= th ? vh : vl + (1 - cos((x-tl)/(th-tl)*180)) / 2 * (vh-vl);
function tilt_angle(a) = interpolate_sin(a, TOP_LEAF_ANGLE_MIN, TOP_LEAF_ANGLE_MAX, 15, 4);
//function tilt_angle(a) = interpolate_sin(a, -14, -14, 15, 3);

tilt_angle_t = tilt_angle(oscillate(TOP_LEAF_ANGLE_MIN,TOP_LEAF_ANGLE_MAX));

module rot_leaf(){
  rotate([-tilt_angle_t,0,0])children();
}

module rot_leaf_inv(a=tilt_angle_t){
  rotate([a,0,0])children();
}
function rot_leaf_inv(a=tilt_angle_t) = rx(a);

module tr_leaf(){
  translate([0,0,8])rot_leaf()translate([0,0,6])children();
}

module tr_leaf_inv(a=tilt_angle_t){
  translate([0,0,-6])rot_leaf_inv(a)translate([0,0,-8])children();
}

function tr_leaf_inv(a=titl_angle_t) = tz(-6)*rot_leaf_inv(a)*tz(-8);


module top_leaf_2d(){
  rotate([0,0,-30])translate([-BRACKET_OFFSET*1.5-5,0])rotate([0,0,30])leaf(240,60);
}


module top_leaf(){
  tr_leaf()linear_extrude(H_LEAVES)top_leaf_2d();
}

function norm_diff(a,c) = sqrt((a*a)-(c*c));


module tilt_support_rail(){
  linear_extrude(0.09,center=true) {
    translate([0,-3])square([8,13]);
  }
}

module tilt_support_cutout(){
  linear_extrude(0.1,center=true){
    translate([-1,0])square([5,7]);
  }
}

module top_leaf_bracket(){
  module tilt_rail(){
    tilt_rail_profile = [
      [8,10],
      [8,-3],
      [0,-3],
      [0,0],
      [5,0],
      [5,8],
      [0,8],
      [0,10],
    ];

    function tr_tilt_rail(a) = tr_leaf_inv(tilt_angle(-28-a)) * tz(3) * rz(a-15)*t(x=150,z=6);

    tr_leaf(){
      let (geo = [for (a=[-32:1:4]) 
        [
          each [for (p2d=tilt_rail_profile) 
            d3(tr_tilt_rail(a) * [p2d.x, 0, p2d.y, 1])
          ],
          // add last and first pointed scaled to z=0 to attach to the leaf
          d3(sz(0) * tr_tilt_rail(a) * [tilt_rail_profile[7].x, 0, tilt_rail_profile[7].y, 1]),
          d3(sz(0) * tr_tilt_rail(a) * [tilt_rail_profile[0].x, 0, tilt_rail_profile[0].y, 1]),
        ]
      ]) ex(geo);
    }
  }

  module leaf_hinge(){
    module leaf_hinge_2d(){
      difference(){
        poly([
          [-5,0],
          fillet([-5,-11],5),
          fillet([5,-11],5),
          [5,0],
        ]);
        translate([0,-6])circle(d=3);
      }
    }

    difference(){
      union(){
        tr_leaf(){
          translate([-5.5,0,0])rotate([90,0,-90])linear_extrude(5){
            leaf_hinge_2d();
          }
          translate([40,0,0])rotate([90,0,90])linear_extrude(5)leaf_hinge_2d();
          scale([1,1,-1])linear_extrude(3){
            poly([
              [-10.5,-5],
              fillet([-10.5,-15],5),
              fillet([45,-15],5),
              [45,-5],
            ]);
          }
        }
      }
    }
  }

  module bracket(){
    difference(){
      union(){
        cylinder(d=10,h=8);
        translate([-5,0,8])rotate([0,90,0])cylinder(d=10, h=44.5);
        rotate([0,0,232+72])linkage([0,0],[70,0],20,54,true){
          linear_extrude(3)link($l);
          linear_extrude(0);
        }
        rotate([0,0,232+72]){
          linkage([0,0],[70,0],20,54,true){
            linear_extrude(0);
            translate([0,0,-8]){
              linear_extrude(3)link($l);
              cylinder(d=10,h=11);
            }
          }
        }
      }
      cylinder(d=2.8,h=100,center=true);
      translate([0,0,8])rotate([0,90,0])cylinder(d=2.8, h=200, center=true);
    }
  }

  bracket();
  leaf_hinge();
  tilt_rail();
}

module top_leaf_assembly(){
  rotate([0,0,-72]){
    top_leaf();
    top_leaf_bracket();
  }
}

module top_leaf_ring(){
  ring(5,180){
    animate_rz(TOP_LEAF_ANGLE_MIN,TOP_LEAF_ANGLE_MAX){
      top_leaf_assembly();
    }
    #rotate([0,0,-72-15-28])translate([150,0,9+7/2])rotate([0,90,0])cylinder(d=7,h=3);
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


color("#c44")translate([0,0,1])top_leaf();
top_leaf_bracket();
