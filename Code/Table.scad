module table(length = 100,      //
             width = 100,       //
             legThickness = 4,  //
             bodyHeight = 5,    //
             legHeight = 50,    //
             legXInset = 5,     //
             legYInset = 5,     //
             upsidedown = false //
) {
  height = legHeight + bodyHeight;
  module theTable() {
    module leg() { cube([ legThickness, legThickness, legHeight ]); }
    translate([ 0, 0, legHeight ]) cube([ width, length, bodyHeight ]);

    rotate(a = 90) translate([ legXInset, -width + legYInset, 0 ]) leg();
    rotate(a = 90) translate(
        [ (length - legThickness) - legXInset, -width + legYInset, 0 ]) leg();
    rotate(a = 90) translate(
        [ (length - legThickness) - legXInset, -legThickness - legYInset, 0 ])
        leg();
    rotate(a = 90) translate([ legXInset, -legThickness - legYInset, 0 ]) leg();
  }
  if (upsidedown) {
    rotate([ 180, 0, 0 ])                  //
        translate([ 0, -length, -height ]) //
        theTable();
  } else {
    theTable(); //
  }
}