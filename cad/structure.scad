use <bartscad/poly.scad>

include <constants.scad>
use <util.scad>

use <structure/support.scad>

$fn=360;

module base_2d(){
  difference(){
    circle(r=190);
    circle(r=95);
  }
}

module support_ring() {
  difference(){
    base_2d();
    circle(r=170);
  }
}



module top_support_ring_2d() {
  support_ring();
}

module top_support_ring_rim_2d(){
  difference(){
    circle(r=207);
    circle(r=170);
  }
}

module leaf_ring_1_holes(){
  rotate([0,0,12])ring(5,R_STRUCTURE)circle(d=4);
  rotate([0,0,5.7])ring(5,R_STRUCTURE)circle(d=3);
}

module leaf_ring_2_holes(){
  rotate([0,0,5.7+24])ring(5,R_STRUCTURE)circle(d=3);
  rotate([0,0,24+12])ring(5,R_STRUCTURE)circle(d=4);
}

module leaf_ring_top_holes(){
  ring(5,R_STRUCTURE)circle(d=8);
  rotate([0,0,-2*ANGLE_OFFSET_TILT_ROLLER])ring(5,R_STRUCTURE)circle(d=2);
  rotate([0,0,ANGLE_LIGHT_FIXTURE])ring(5,R_STRUCTURE)circle(d=2);
}

module led_strips(){
  ring(15,195)square([10,106*3/4],center=true);
}

module base(){
    linear_extrude(H_BASE)difference(){
      base_2d();
      leaf_ring_1_holes();
    }
}

module support_ring_middle() {
    linear_extrude(H_SUPPORT_RING)difference(){
      support_ring();
      leaf_ring_1_holes();
      leaf_ring_2_holes();
    }
}

module support_ring_top() {
    linear_extrude(H_SUPPORT_RING)difference(){
      top_support_ring_2d();
      leaf_ring_top_holes();
      leaf_ring_2_holes();
    }
}

module support_ring_top_rim(){
    linear_extrude(4)difference(){
      top_support_ring_rim_2d();
      leaf_ring_top_holes();
      leaf_ring_2_holes();
    }
}


module support_ring_top_assembly(){
  support_ring_top();
  translate([0,0,H_SUPPORT_RING])support_ring_top_rim();
}

module structure(){ 
    base();
    translate([0,0,Z_LEAVES_1])rotate([0,0,12])ring(5,R_STRUCTURE)support();
    translate([0,0,Z_SUPPORT_1])support_ring_middle();
    translate([0,0,Z_LEAVES_2])rotate([0,0,12+24])ring(5,R_STRUCTURE)support();
    translate([0,0,Z_SUPPORT_2])support_ring_top_assembly();
    color("#222")translate([0,0,Z_SUPPORT_2+10])led_strips();
}

module outline(width){
  difference(){
    children();
    offset(-width)children();
  }
}

module pie(angle,start=0){
  difference(){
    children();
    rotate([0,0,start+angle])translate([-500,0])square(1000);
    rotate([0,0,start+180])translate([-500,0])square(1000);
  }
}

module drill_guide(){
  module drill_guide_2d(){
    difference(){
      union(){
        pie(360/5)support_ring();
        translate([R_STRUCTURE,0])circle(d=20);
        square([R_STRUCTURE,10]);
        rotate([0,0,360/5]){
          translate([R_STRUCTURE,0])circle(d=20);
          square([R_STRUCTURE,10]);
        }
        circle(d=20);
      }
      rotate([0,0,24+12]) {
        leaf_ring_1_holes();
        leaf_ring_2_holes();
        leaf_ring_top_holes();
      }
      circle(d=5);
    }
  }

  linear_extrude(20){
    difference(){
      pie(360/5+8, start=-4)rotate([0,0,24+12])offset(3){
        leaf_ring_1_holes();
        leaf_ring_2_holes();
        leaf_ring_top_holes();
      }
      rotate([0,0,24+12]){
        leaf_ring_1_holes();
        leaf_ring_2_holes();
        leaf_ring_top_holes();
      }
    }
  }

  linear_extrude(3)drill_guide_2d();
  linear_extrude(4)difference(){
    drill_guide_2d();
    ring(5,186){
      rotate([0,0,-90])text("MT",size=5,valign="center",halign="center");
      translate([-12,0])rotate([0,0,-90])text("S",size=5,valign="center",halign="center");
    }
    rotate([0,0,-5.7])ring(5,186)rotate([0,0,-90])text("M(T)",size=5,valign="center",halign="center");
    rotate([0,0,-24])ring(5,186){
      rotate([0,0,-90])text("BM",size=5,valign="center",halign="center");
      translate([-12,0])rotate([0,0,-90])text("S",size=5,valign="center",halign="center");
    }
    rotate([0,0,-24-5.7])ring(5,186)rotate([0,0,-90])text("BM",size=5,valign="center",halign="center");
    rotate([0,0,-38])ring(5,186)rotate([0,0,-90])text("T",size=5,valign="center",halign="center");
    rotate([0,0,-36-2*ANGLE_OFFSET_TILT_ROLLER])ring(5,186)rotate([0,0,-90])text("T",size=5,valign="center",halign="center");
    rotate([0,0,-36+ANGLE_LIGHT_FIXTURE])ring(5,186)rotate([0,0,-90])text("T",size=5,valign="center",halign="center");
  }
}

module glue_guide(){
  linear_extrude(1)pie(360/15*3,start=180) difference(){
    circle(r=190+17);
    circle(r=190);
    rotate([0,0,360/15])led_strips();
  }
}

rotate([0,0,36])translate([0,0,80])drill_guide();

structure();

