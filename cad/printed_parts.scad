use <bartscad/tr.scad>
use <top_leaves/util.scad>

include <constants.scad>

use <bottom_leaves/bracket.scad>
use <bottom_leaves/link.scad>
use <top_leaves/bracket.scad>
use <top_leaves/hinge.scad>
use <top_leaves/tilt_rail.scad>
use <top_leaves/tilt_roller.scad>
use <top_leaves/link.scad>
use <structure/support.scad>
use <light_fixture/diffusor_clamp.scad>
use <light_fixture/rim.scad>

//$fn=360;

translate([37,10])for(i=[0:9]){
  translate([0,i*20,7.5]) rotate([270,0,0])rotate([0,0,108])bottom_leaf_bracket();
}

translate([60,10])for(i=[0:9]){
  translate([0,i*20,5]) rotate([90,0,0])bottom_leaf_link();
}

translate([150,15])for(i=[0:4]){
  translate([0,i*20,5])rotate([0,-90,90])top_leaf_bracket();
}

translate([225,15])for(i=[0:4]){
  translate([0,i*25,6])rotate([180,0,0])tr(tr_leaf_inv())leaf_hinge_mount();
}

translate([295,15])for(i=[0:4]){
  translate([0,i*35,-1])rotate([0,0,0])tr(tr_leaf_inv())leaf_hinge_core();
}

translate([401,22])for(i=[0:4]){
  // TODO: adjust orientation for printing
  translate([0,i*35,162.5])rotate([-94.9,0,0])rotate([180,0,60.25])tr(tr_leaf_inv())tilt_rail();
}

translate([515,150])for(i=[0:4]){
  // TODO: adjust orientation for printing
  translate([0,i*35,-33.1])rotate([0,-129.53,0])rotate([0,0,47.5])tilt_roller();
}

translate([500,90])for(i=[0:4]){
  translate([0,25*i,6])rotate([180,0,0])top_leaf_link();
}

translate([600,10])for(i=[0:9]){
  translate([0,i*20,H_LEAF_GAP])scale([1,1,-1])support();
}

translate([623,10])for(i=[0:9]){
  translate([0,i*20,2])lf_diffusor_clamp();
}

translate([640,-30])for(i=[0:4]){
  translate([0,i*50,73])rotate([180,0,70])lf_rim_segment();
}
