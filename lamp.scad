use <bartscad/bearings.scad>
use <bartscad/servos.scad>

$fn=120;

W_LEAVES=4;
W_CONTROL_RING=4;

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
      #rotate([-15,5,-72]) linear_extrude(W_LEAVES)leaf(240,60);
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
      linear_extrude(W_LEAVES){
        rotate([0,0,75])leaf(180,30);
        rotate([0,0,-10]){
          link(45);
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
  color("#d22")linear_extrude(W_CONTROL_RING)difference(){
    circle(r=140);
    circle(r=120);
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
}

module excenter(){
  difference(){
    union(){
      linear_extrude(9)let($fn=6)circle(d=11.54);
      translate([0,0,-1.5])linear_extrude(10.5)circle(d=7);
    }
    translate([0.8,0,9])linear_extrude(1000, center=true)circle(d=5);
  }
  translate([0.8,0,9])children();
}

rotate([0,0,5.7])color("#2d2")bottom_leaf_ring();
translate([0,0,4])linear_extrude(10)support_ring();
translate([0,0,6])animate_rz(115,90){
  difference(){
    control_ring();
    for(a=[0,24]){
      rotate([0,0,a])ring(5,130) cylinder(d=3,h=100,center=true);
    }
  }
  for(a=[0,24]){
    translate([0,0,a/3])
    rotate([0,0,a])color("#22d")ring(5,130)translate([0,0,-3])animate_rz(-96,-80)linear_extrude(3)link(70);
  }
}

color("#4b4")translate([0,0,15])rotate([0,0,5.7+24])bottom_leaf_ring(){
  animate_rz(0,-85.5)rotate([0,0,74])translate([0,0,3])#linear_extrude(3)link(126);
};

translate([0,0,14])rotate([0,0,12+24])ring(5,180)cylinder(d=16,h=10);

translate([0,0,19])linear_extrude(10)support_ring();
translate([0,0,21])rotate([0,0,-27])animate_rz(25,0){
  *translate([0,0,6])color("#22d")
    ring(5,105)
    animate_rz(-105,-29)
    linear_extrude(3)
    link(59);
}

translate([0,0,50])top_leaf_ring();

translate([0,0,4.5-9])rotate([0,0,21.5])ring(5,110){
  excenter(){
    bearing_f635();
    translate([0,0,6]){
      linear_extrude(0.5)difference(){
        circle(d=8);
        circle(d=5.5);
      }
      translate([0,0,0.5])linear_extrude(3)difference(){
        circle(d=23);
        circle(d=5);
      }
    }
  }
}

rotate([0,0,24])translate([0,62,6+W_CONTROL_RING]){
  servo_sg90();
  animate_rz(180,0){
    linear_extrude(3)link(l=13);
    translate([13,0])animate_rz(0,152)rotate([0,0,196])link(l=111);
  }
}

