use <bartscad/poly.scad>

use <util.scad>

module leaf_hinge_profile(){
  difference(){
    poly([
      fillet([-5,6],1),
      fillet([-9,1],1),
      [-9,6.1],
      [9,6.1],
      fillet([9,1],1),
      fillet([5,6],1),
      fillet([5,-5],5),
      fillet([-5,-5],5),
    ]);
    circle(d=3);
  }
}

module leaf_hinge_mount(){
  tr_leaf(){
    difference(){
      translate([-10.5,0,0])rotate([90,0,90])linear_extrude(55.5){
        leaf_hinge_profile();
      }
      translate([-5.5,0,0])rotate([90,0,90])cylinder(d=12,h=45.5);
      for(pos=[[9,9.1],[45-19.5,-9.1]]){
        translate(pos)cylinder(r=1.1,h=20,center=true);
      }
    }
  }
}

module leaf_hinge_core(){
  tr_leaf(){
    translate([0,0,1])linear_extrude(5)poly([
      [15,12],
      fillet([15,10.1],1),
      fillet([8,10.1],1),
      fillet([8,8.1],1),
      fillet([10,8.1],1),
      [10,9.1],
      [15,9.1],
    ]);
    difference(){
      translate([0,0,1])linear_extrude(5)poly([
        fillet([-10.5,-15],3),
        fillet([50,-15],3),
        fillet([50,15],3),
        fillet([15,15],2),
        [15,5],
        [45,5],
        [45,-5],
        [-10.5,-5],
      ]);
      for(pos=[
        [-7.5,-12],
        [47,-12],
        [47,12],
        [18,12],
      ]){
        translate(pos){
          cylinder(d=3,h=3);
          translate([0,0,3])cylinder(r1=1.5,r2=0.5,h=1);
          cylinder(d=1.2,h=10);
        }
        translate([-10.5,0,0])rotate([90,0,90])linear_extrude(55.5){
          offset(0.1)leaf_hinge_profile();
        }
      }
      translate([44,0,0])rotate([0,90,0])cylinder(d=8,h=7);
    }
  }
}

module leaf_hinge(){
  leaf_hinge_mount();
  leaf_hinge_core();
}

leaf_hinge();

