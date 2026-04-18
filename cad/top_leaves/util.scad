use <bartscad/tr.scad>

include <../util.scad>

BRACKET_OFFSET=8;

TOP_LEAF_ANGLE_MIN=-100;
TOP_LEAF_ANGLE_MAX=-68;

function interpolate_sin(x, tl, th, vl, vh) = x <= tl ? vl : x >= th ? vh : vl + (1 - cos((x-tl)/(th-tl)*180)) / 2 * (vh-vl);
function tilt_angle(a) = interpolate_sin(a, TOP_LEAF_ANGLE_MIN, TOP_LEAF_ANGLE_MAX, 15, 4);

tilt_angle_t = tilt_angle(oscillate(TOP_LEAF_ANGLE_MIN,TOP_LEAF_ANGLE_MAX));

module rot_leaf(){
  rotate([-tilt_angle_t,0,0])children();
}

module tr_leaf(){
  translate([0,0,8])rot_leaf()translate([0,0,0])children();
}

angle_t=oscillate(TOP_LEAF_ANGLE_MIN,TOP_LEAF_ANGLE_MAX);

function rot_leaf_inv(a=tilt_angle_t) = rx(a);

function tr_leaf_inv(a=tilt_angle_t) = rot_leaf_inv(a)*tz(-8);
