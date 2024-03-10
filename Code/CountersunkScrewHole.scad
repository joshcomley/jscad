counterSunkScrewDefaultHeadHeight = 4.15;
module counterSunkScrewHole(                        //
    length = 30,                                    //
    width = 2.2,                                    //
    headWidth = 8.1,                                //
    headHeight = counterSunkScrewDefaultHeadHeight, //
    cutoutAboveHeight = 10,                         //
    // this is how round the screw is. Lower this number to
    // get faster renderings.
    grani = 32 //
) {
  rotate([ 0, 180, 0 ])                   //
      counterSunkScrew(length,            //
                       width,             //
                       headWidth,         //
                       headHeight,        //
                       cutoutAboveHeight, //
                       grani              //
      );
}

module counterSunkScrew(                            //
    length = 30,                                    //
    width = 2.2,                                    //
    headWidth = 8.1,                                //
    headHeight = counterSunkScrewDefaultHeadHeight, //
    cutoutAboveHeight = 10,                         //
    // this is how round the screw is. Lower this number to
    // get faster renderings.
    grani = 32 //
) {
  cutoutAbove = headWidth + 2;
  union() {
    translate([ 0, 0, -cutoutAboveHeight - 0.0000001 ]) //
        color("magenta")                                //
        cylinder(d1 = cutoutAbove, d2 = cutoutAbove, h = cutoutAboveHeight,
                 $fn = grani);
    cutoutClearer = 0.01;
    translate([ 0, 0, -(cutoutClearer / 2) ])  //
        color("green")                         //
        linear_extrude(height = cutoutClearer) //
        circle(d = headWidth);
    color("red") //
        cylinder(d1 = headWidth, d2 = width, h = headHeight, $fn = grani);

    cylinder(d1 = width, d2 = width, h = length + headHeight, $fn = grani);
  }
}