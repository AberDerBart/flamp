module ring(n, outset){
  for(i=[0:n-1]){
    rotate([0,0,i*360/n])translate([outset,0])children();
  }
}

function oscillate(v_min, v_max) = (v_max+v_min)/2+sin($t*360)*(v_max-v_min)/2;

module animate_rz(a_min, a_max) {
  let(a=(a_max+a_min)/2+sin($t*360)*(a_max-a_min)/2){
    rotate([0,0,oscillate(a_min, a_max)])children();
  }
}

