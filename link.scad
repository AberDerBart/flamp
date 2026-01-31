module link(l, curve=undef) {
  difference(){
    if (is_undef(curve)) {
      hull(){
        circle(d=10);
        translate([l,0])circle(d=10);
      }
    } else {
      circle(d=10);
      translate([l,0])circle(d=10);
      
      scale([1,curve> 0 ? 1:-1]) let (d = (l*l/4-curve*curve)/(2*abs(curve)), r=d+abs(curve), a=asin(l/2/r)) {
        translate([l/2,d])difference(){
          circle(r=r+5);
          circle(r=r-5);
          for(rz=[a,180-a]){
            rotate([0,0,rz])translate([0,-r-6])square(2*r+12);
          }
        }
      }
    }
    circle(d=2.8);
    translate([l,0])circle(d=2.8);
  }
  translate([l,0])children();
}
