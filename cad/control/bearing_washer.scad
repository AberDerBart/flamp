
module control_bearing_washer(){
  difference(){
    union(){
      cylinder(d=8,h=3);
      cylinder(d=23,h=2.5);
    }
    cylinder(d=5.4,h=100, center=true);
  }
}

$fn=360;
control_bearing_washer();
