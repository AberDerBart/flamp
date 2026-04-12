use <bartscad/tr.scad>

include <constants.scad>

TR_POWER_SUPPLY_MOUNTING_TABS=[
  t(84/2+3, -57/2+15.3),
  t(-84/2-3,57/2-15.3),
];

TR_PCB_MOUNTING_HOLES=[
  t(51/2,61/2),
  t(-51/2,61/2),
  t(51/2,-61/2),
  t(-51/2,-61/2),
];

module power_supply(){
  module mounting_tab(){
    difference(){
      hull(){
        circle(d=8.9);
        translate([0,-8.9/2])square([8.9/2,8.9]);
      }
      circle(d=3.6);
    }
  }

  color("#ddd"){
    linear_extrude(29.5)square([84,57],center=true);
    linear_extrude(1.9){
      tr(TR_POWER_SUPPLY_MOUNTING_TABS[0])scale([-1,1])mounting_tab();
      tr(TR_POWER_SUPPLY_MOUNTING_TABS[1])mounting_tab();
    }
  }
}

module pcb(){
  color("#0f0")import("pcb.stl");
}
