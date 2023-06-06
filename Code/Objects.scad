module counterSunkScrew(length = 30, width = 2.2, headWidth = 8.1,
                        headHeight = 4.15, cutoutAboveHeight = 10) {
  cutoutAbove = headWidth + 2;
  union() {
    translate([ 0, 0, -cutoutAboveHeight ]) color("magenta") cylinder(
        d1 = cutoutAbove, d2 = cutoutAbove, h = cutoutAboveHeight, $fn = grani);
    color("red")
        cylinder(d1 = headWidth, d2 = width, h = headHeight, $fn = grani);

    cylinder(d1 = width, d2 = width, h = length + headHeight, $fn = grani);
  }
}