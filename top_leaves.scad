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

$fn=360;

BRACKET_OFFSET=8;

TOP_LEAF_ANGLE_MIN=-100;
TOP_LEAF_ANGLE_MAX=-68;

function interpolate_sin(x, tl, th, vl, vh) = x <= tl ? vl : x >= th ? vh : vl + (1 - cos((x-tl)/(th-tl)*180)) / 2 * (vh-vl);
function tilt_angle(a) = interpolate_sin(a, TOP_LEAF_ANGLE_MIN, TOP_LEAF_ANGLE_MAX, 15, 4);

tilt_angle_t = tilt_angle(oscillate(TOP_LEAF_ANGLE_MIN,TOP_LEAF_ANGLE_MAX));

angle_t=oscillate(TOP_LEAF_ANGLE_MIN,TOP_LEAF_ANGLE_MAX);

echo(TOP_LEAF_OSC_ANGLE=angle_t);

module rot_leaf(){
  rotate([-tilt_angle_t,0,0])children();
}

function rot_leaf_inv(a=tilt_angle_t) = rx(a);

module tr_leaf(){
  translate([0,0,8])rot_leaf()translate([0,0,0])children();
}

function tr_leaf_inv(a=tilt_angle_t) = rot_leaf_inv(a)*tz(-8);


module top_leaf_2d(){
  rotate([0,0,-30])translate([-BRACKET_OFFSET*1.5-5,0])rotate([0,0,30])leaf(240,60);
}


module top_leaf(){
  tr_leaf()translate([0,0,6])linear_extrude(H_LEAVES)top_leaf_2d();
}

function tr_tilt_roller() = rz(-90-ANGLE_OFFSET_TILT_ROLLER)*tx(OFFSET_TILT_ROLLER)*tz(4);

module tilt_roller(){
  module mounting_profile(){
    rotate([0,0,-ANGLE_OFFSET_TILT_ROLLER])difference(){
      hull(){
        circle(d=10);
        rotate([0,0,ANGLE_OFFSET_TILT_ROLLER])translate([0,-5])square([7,10]);
        translate([-15,-13])square([26,3]);
      }
    }
  }

  color("#482")tr(tr_tilt_roller()){
    difference(){
      union(){
        translate([0,0,-7])linear_extrude(6)intersection(){
          mounting_profile();
          rotate([0,0,-ANGLE_OFFSET_TILT_ROLLER])translate([0,-R_STRUCTURE,0])circle(r=R_STRUCTURE-10);
        }
        hull(){
          translate([0,0,-4]){
            mounting_tab(10,4,3,countersink=true);
            linear_extrude(3)mounting_profile();
          }
          translate([4,0,0])yzx(){
            linear_extrude(3){
              hull(){
                translate([-5,-4])square([10,4]);
                translate([0,8+3.5])circle(d=7);
              }
            }
          }
        }
        translate([4,0,0])yzx()translate([0,8+3.5,3])cylinder(r1=3.5,r2=2,h=1.5);
      }
      yzx()translate([0,8+3.5])cylinder(d=2.8,h=20,center=true);
      cylinder(d=3,h=100,center=true);
      translate([0,0,2])cylinder(d=8,h=20);
      cylinder(r1=1.5, r2=3.6,h=2.1);
    }
  }
}

module tilt_rail(){
  tilt_rail_profile = [
    [9,10],
    [9,-3],
    [0,-3],
    [0,0],
    [6,0],
    [6,7.5],
    [0,7.5],
  ];

  function tr_tilt_rail(a) = rx(tilt_angle(a))*rz(-a)*tr_tilt_roller()*tx(8.5);

  tr_leaf(){
    let (geo = [for (a=[TOP_LEAF_ANGLE_MIN-1:1:TOP_LEAF_ANGLE_MAX+1]) 
      [
        each [for (p2d=tilt_rail_profile) 
          d3(tr_tilt_rail(a) * [p2d.x, 0, p2d.y, 1])
        ],
        // add last and first pointed scaled to z=0 to attach to the leaf
        d3(tz(6)*sz(0) * tr_tilt_rail(a) * [tilt_rail_profile[6].x, 0, tilt_rail_profile[6].y, 1]),
        d3(tz(6)*sz(0) * tr_tilt_rail(a) * [tilt_rail_profile[0].x, 0, tilt_rail_profile[0].y, 1]),
      ]
    ]) ex(geo);
    for(a=[TOP_LEAF_ANGLE_MIN+1,TOP_LEAF_ANGLE_MAX-1]){
      tr(rz(-a)*tr_tilt_roller())
        translate([8.5+3+9,0,2])
        scale([-1,1,-1])
        mounting_tab(7,D_TOP_LEAF_MOUNTING_SCREW,3,l=5,countersink=true);
    }
    tr(rz(-TOP_LEAF_ANGLE_MIN-10)*tr_tilt_roller())
      translate([8.5-3,0,2])
      scale([01,1,-1])
      mounting_tab(7,D_TOP_LEAF_MOUNTING_SCREW,3,l=5,countersink=true);
  }
}

module leaf_hinge(){
  module leaf_hinge_2d(){
    difference(){
      poly([
        fillet([1.5,6],1),
        fillet([1.5,-1.5],1.5),
        fillet([-1.5,-1.5],1.5),
        fillet([-1.5,1],1),
        fillet([-5,1],1),
        fillet([-5,-5],5),
        fillet([5,-5],5),
        [5,6],
      ]);
    }
  }

  difference(){
    union(){
      tr_leaf(){
        translate([-5.5,0,0])rotate([90,0,-90])linear_extrude(5){
          leaf_hinge_2d();
        }
        translate([40,0,0])scale([-1,1,1])rotate([90,0,-90])linear_extrude(5)leaf_hinge_2d();
        translate([0,0,6])scale([1,1,-1])linear_extrude(3)difference(){
          poly([
            [-10.5,-5],
            fillet([-10.5,-15],5),
            fillet([45,-15],5),
            [45,-5],
          ]);
          for (p=[[-5.5,-10],[40,-10]]){
            translate(p)circle(d=D_TOP_LEAF_MOUNTING_SCREW);
          }
        }
      }
    }
  }
}

module top_leaf_bracket(){
  difference(){
    union(){
      translate([0,0,1])cylinder(d=10,h=7);
      translate([0,0,0.5])cylinder(r1=2.5,r2=5,h=2);
      translate([-5,0,8])rotate([0,90,0])linear_extrude(44.5){
        poly([
          fillet([5,5],5),
          fillet([-1.1,5],1),
          fillet([-4.5,0],6),
          fillet([-1.1,-5],1),
          fillet([5,-5],5),
        ]);
      }
      translate([0,0,1])rotate([0,0,-90])linear_extrude(3)link(20);
      translate([0,-20,-12]){
        cylinder(d=10,h=16);
        rotate([0,0,-48])linear_extrude(3)link(43.5);
      }
    }
    cylinder(d=2.8,h=100,center=true);
    translate([0,0,8])rotate([0,90,0])cylinder(d=2.8, h=200, center=true);
  }
}

module top_leaf_assembly(){
  rotate([0,0,0]){
    animate_rz(TOP_LEAF_ANGLE_MIN,TOP_LEAF_ANGLE_MAX){
      *top_leaf();
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
        fillet([60,20],14),
        [60,5],
        [120,5],
        [120,100],
        fillet([190,-80],100),
        fillet([117,-130],10),
        fillet([93,-120],10),
        fillet([149,-7],30),
      ]);
    }
  }
  linear_extrude(4) restrict() difference(){
    offset(2)top_leaf_2d();
    top_leaf_2d();
  }
  linear_extrude(1) restrict() difference(){
    top_leaf_2d();
    offset(0.1)projection()leaf_hinge();
    offset(0.1)projection(cut=true)translate([0,0,-5.99])tr(tr_leaf_inv())tilt_rail();
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

top_leaf_assembly();


translate([200,0])color("#f00")animate_rz(TOP_LEAF_ANGLE_MIN,TOP_LEAF_ANGLE_MAX)tr_leaf()top_leaf_assembly_jig();
