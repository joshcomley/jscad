module rightTriangle(side1, side2, corner_radius, triangle_height) {
  translate([ corner_radius, corner_radius, 0 ]) {
    hull() {
      cylinder(r = corner_radius, h = triangle_height);
      translate([ side1 - corner_radius * 2, 0, 0 ])
          cylinder(r = corner_radius, h = triangle_height);
      translate([ 0, side2 - corner_radius * 2, 0 ])
          cylinder(r = corner_radius, h = triangle_height);
    }
  }
}

module rounded_square(size, radius_corner) {
  translate([ radius_corner, radius_corner, 0 ]) minkowski() {
    square(size - 2 * radius_corner);
    circle(radius_corner);
  }
}