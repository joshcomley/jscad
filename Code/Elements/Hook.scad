module hook(           //
    wallThickness = 3, //
    width = 18,        //
    length = 10,       //
    holeDiameter       //
) {
  function holeDiameterCalc() = width - (wallThickness * 2);
  translate([0,-(width/2),0])// 
  difference() {
    group() {
      linear_extrude(height = wallThickness) //
          square([ length, width ]);
      translate([ length, width / 2, 0 ]) //
          linear_extrude(wallThickness)   //
          circle(d = width);
    }
    translate([ length, width / 2, -1 ]) //
        linear_extrude(wallThickness + 2)   //
        circle(d =                      //
               is_undef(holeDiameter)   //
                   ? holeDiameterCalc() //
                   : holeDiameter       //
        );
  }
}