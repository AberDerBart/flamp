use <bartscad/poly.scad>

module lf_diffusor_clamp(){
  translate([0,0,-2]){
    linear_extrude(4.8)difference(){
      poly([
        fillet([5,5],5),
        [-5,5],
        [-5,-5],
        fillet([5,-5],5),
      ]);
      circle(d=3.2);
    }
    linear_extrude(2)difference(){
      poly([
        fillet([5,5],5),
        [-8,5],
        [-8,-5],
        fillet([5,-5],5),
      ]);
      circle(d=3.2);
    }
  }
}

lf_diffusor_clamp();
