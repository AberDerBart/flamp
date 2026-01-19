use <bartscad/bearings.scad>
use <bartscad/servos.scad>
use <bartscad/linkage.scad>

$fn=120;
$hide_leaves=false;

H_BASE=15;
H_LEAVES=4;
H_CONTROL_RING=4;
H_LEAF_GAP=8;

LINK_CONTROL_ANGLES=[0,24];
L_BOTTOM_LEAF_LINKS=[70,45];

H_SUPPORT_RING=12;

Z_LEAVES_1 = H_BASE;
Z_SUPPORT_1 = Z_LEAVES_1 + H_LEAF_GAP;
Z_LEAVES_2 = Z_SUPPORT_1 + H_SUPPORT_RING;
Z_SUPPORT_2 = Z_LEAVES_2 + H_LEAF_GAP;
Z_LEAVES_TOP = Z_SUPPORT_2 + H_SUPPORT_RING;

Z_CONTROL_RING=Z_SUPPORT_1 + H_SUPPORT_RING/2 - H_CONTROL_RING/2;
Z_CONTROL_RING_BEARING_STACK=Z_CONTROL_RING-8-3-6+1.5+H_CONTROL_RING;


module leaf(l, width_angle=60){
  scale(-1)translate([-l,0])rotate([0,0,width_angle/2])intersection(){
    circle(r=l);
    rotate([0,0,60-width_angle/2])translate([l,0])circle(r=l);
    rotate([0,0,width_angle/2-60])translate([l,0])circle(r=l);
  }
}

module ring(n, outset){
  for(i=[0:n-1]){
    rotate([0,0,i*360/n])translate([outset,0])children();
  }
}

module animate_rz(a_min, a_max) {
  let(a=(a_max+a_min)/2+sin($t*360)*(a_max-a_min)/2){
    rotate([0,0,a])children();
  }
}

module top_leaf_ring(){
  ring(5,180){
    animate_rz(-28,0){
      if(!$hide_leaves){
        rotate([-15,5,-72]) linear_extrude(H_LEAVES)leaf(240,60);
      }
      translate([0,0,-20]){
        cylinder(d=10,h=20);
        rotate([0,0,230])linear_extrude(3)link(100);
      }
    }

  }
}

module bottom_leaf_ring(){
  ring(5,180){
    translate([0,0,-5])cylinder(d=10,h=10);
    animate_rz(-80,0)rotate([0,0,-115]){
      linear_extrude(H_LEAVES){
        if(!$hide_leaves){
          rotate([0,0,75])leaf(180,30);
        }
        rotate([0,0,-10]){
          link(L_BOTTOM_LEAF_LINKS[1]);
          translate([45,0])children();
        }
      }
    }
  }
}

module support_ring() {
  difference(){
    circle(r=190);
    circle(r=170);
  }
}

module control_ring() {
  color("#d22")linear_extrude(H_CONTROL_RING)difference(){
    circle(r=140);
    circle(r=120);
    for(rz=LINK_CONTROL_ANGLES){
      rotate([0,0,rz])ring(5,130)circle(d=3);
    }
  }
}

module control_ring_bearing_stack() {
  excenter(){
    translate([0,0,-8-4-9])cylinder(d=5,h=30);
    difference(){
      union(){
        cylinder(d=8,h=3);
        cylinder(d=23,h=2.5);
      }
      cylinder(d=5.4,h=100, center=true);
    }
    translate([0,0,9])scale([1,1,-1])bearing_f635();
  }
}

module link(l) {
  difference(){
    hull(){
      circle(d=10);
      translate([l,0])circle(d=10);
    }
    circle(d=3);
    translate([l,0])circle(d=3);
  }
  translate([l,0])children();
}

module excenter(){
  difference(){
    union(){
      linear_extrude(8)let($fn=6)circle(d=11.54);
      translate([0,0,-1.5])linear_extrude(10.5)circle(d=7);
    }
    translate([0.8,0,8])linear_extrude(1000, center=true)circle(d=5);
  }
  translate([0.8,0,8])children();
}

module control_mechanism(){
  translate([0,0,Z_CONTROL_RING])animate_rz(115,90){
    control_ring();
    for(a=[0,24]){
      translate([0,0,a/3])
      rotate([0,0,a])color("#22d")ring(5,130)translate([0,0,-3])animate_rz(-96,-80)linear_extrude(3)link(L_BOTTOM_LEAF_LINKS[0]);
    }
  }
}

module servo(){
  rotate([0,0,24])translate([0,62,6+H_CONTROL_RING]){
    servo_sg90();
    animate_rz(180,0){
      linear_extrude(3)link(l=13);
      translate([13,0])animate_rz(0,152)rotate([0,0,196])linear_extrude(3)link(l=111);
    }
  }
}

module structure(){ 
  color("#dd2"){
    linear_extrude(H_BASE)hull()support_ring();
    translate([0,0,Z_LEAVES_1])rotate([0,0,12])ring(5,180)cylinder(d=16,h=H_LEAF_GAP);
    translate([0,0,Z_SUPPORT_1])linear_extrude(H_SUPPORT_RING)support_ring();
    translate([0,0,Z_LEAVES_2])rotate([0,0,12+24])ring(5,180)cylinder(d=16,h=H_LEAF_GAP);
    translate([0,0,H_BASE+H_LEAF_GAP*2+H_SUPPORT_RING])linear_extrude(H_SUPPORT_RING)support_ring();
  }
}

module mechanism(){
  translate([0,0,Z_LEAVES_1])rotate([0,0,5.7])bottom_leaf_ring();
  control_mechanism();
  translate([0,0,Z_CONTROL_RING_BEARING_STACK]){
    rotate([0,0,21.2])ring(5,110)control_ring_bearing_stack();
  }
  translate([0,0,Z_LEAVES_2])rotate([0,0,5.7+24])bottom_leaf_ring(){
    animate_rz(0,-85.5)rotate([0,0,74])translate([0,0,3])linear_extrude(3)link(126);
  };
  //translate([0,0,50])top_leaf_ring();
  *servo();
}


intersection(){
  union(){
    structure();
    mechanism();
  }
  translate([0,-1000,-1000])cube(2000);
}



