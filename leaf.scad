module leaf(l, width_angle=60){
  offset(5)offset(-5)
  scale(-1)translate([-l,0])rotate([0,0,width_angle/2])intersection(){
    circle(r=l);
    rotate([0,0,60-width_angle/2])translate([l,0])circle(r=l);
    rotate([0,0,width_angle/2-60])translate([l,0])circle(r=l);
  }
}


