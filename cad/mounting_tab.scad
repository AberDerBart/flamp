use <bartscad/poly.scad>

module mounting_tab(d, d_screw, h, l=undef, countersink=false) {
  module _2d(){
    let(l = is_undef(l) ? d/2:l){
      difference(){
        poly([
          [l, -d/2],
          fillet([-d/2,-d/2], d/2),
          fillet([-d/2,d/2], d/2),
          [l, d/2],
        ]);
        circle(d=d_screw);
      }
    }
  }

  if (countersink) {
    difference(){
      linear_extrude(h)_2d();
      translate([0,0,h-d_screw/2+0.01])cylinder(r1=d_screw/2, r2=d_screw,h=d_screw/2);
    }
  } else {
    linear_extrude(h)_2d();
  }
}

mounting_tab(10,4,3, l=30,countersink=true);
