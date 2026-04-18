use <bartscad/tr.scad>
use <bartscad/ex.scad>
use <bartscad/origins.scad>
use <bartscad/poly.scad>

include <../constants.scad>

include <util.scad>
use <leaf.scad>
use <../mounting_tab.scad>
use <tilt_roller.scad>


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
    let (geo = [for (a=[TOP_LEAF_ANGLE_MIN-2:1:TOP_LEAF_ANGLE_MAX+2]) 
      [
        each [for (p2d=tilt_rail_profile) 
          d3(tr_tilt_rail(a) * [p2d.x, 0, p2d.y, 1])
        ],
        // add last and first pointed scaled to z=0 to attach to the leaf
        d3(tz(6)*sz(0) * tr_tilt_rail(a) * [tilt_rail_profile[6].x, 0, tilt_rail_profile[6].y, 1]),
        d3(tz(6)*sz(0) * tr_tilt_rail(a) * [tilt_rail_profile[0].x, 0, tilt_rail_profile[0].y, 1]),
      ]
    ]) ex(geo);
    tr(tr_tilt_rail(TOP_LEAF_ANGLE_MIN-2))yzx()linear_extrude(9)poly([
      [0,-3],
      [2,-1],
      [2,8],
      [0,10],
    ]);
    tr(tr_tilt_rail(TOP_LEAF_ANGLE_MAX+2))yzx()linear_extrude(9)poly([
      [0,-3],
      [-2,-1],
      [-2,8],
      [0,10],
    ]);
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

$fn=360;
tilt_rail();
