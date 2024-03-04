module right_triangle(side1, side2, corner_radius, triangle_height) {
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

// Higher definition curves
$fs = 0.01;

module rounded_cube(size = [ 1, 1, 1 ], center = false, radius = 0.5,
                    apply_to = "all") {
  // If single value, convert to [x, y, z] vector
  size = (size[0] == undef) ? [ size, size, size ] : size;

  translate_min = radius;
  translate_xmax = size[0] - radius;
  translate_ymax = size[1] - radius;
  translate_zmax = size[2] - radius;

  diameter = radius * 2;

  module build_point(type = "sphere", rotate = [ 0, 0, 0 ]) {
    if (type == "sphere") {
      sphere(r = radius);
    } else if (type == "cylinder") {
      rotate(a = rotate) cylinder(h = diameter, r = radius, center = true);
    }
  }

  obj_translate = (center == false)
                      ? [ 0, 0, 0 ]
                      : [ -(size[0] / 2), -(size[1] / 2), -(size[2] / 2) ];

  translate(v = obj_translate) {
    hull() {
      for (translate_x = [ translate_min, translate_xmax ]) {
        x_at = (translate_x == translate_min) ? "min" : "max";
        for (translate_y = [ translate_min, translate_ymax ]) {
          y_at = (translate_y == translate_min) ? "min" : "max";
          for (translate_z = [ translate_min, translate_zmax ]) {
            z_at = (translate_z == translate_min) ? "min" : "max";

            translate(v =
                          [
                            translate_x, translate_y,
                            translate_z
                          ]) if ((apply_to == "all") ||
                                 (apply_to == "xmin" && x_at == "min") ||
                                 (apply_to == "xmax" && x_at == "max") ||
                                 (apply_to == "ymin" && y_at == "min") ||
                                 (apply_to == "ymax" && y_at == "max") ||
                                 (apply_to == "zmin" && z_at == "min") ||
                                 (apply_to == "zmax" && z_at == "max")) {
              build_point("sphere");
            }
            else {
              rotate =
                  (apply_to == "xmin" || apply_to == "xmax" || apply_to == "x")
                      ? [ 0, 90, 0 ]
                      : ((apply_to == "ymin" || apply_to == "ymax" ||
                          apply_to == "y")
                             ? [ 90, 90, 0 ]
                             : [ 0, 0, 0 ]);
              build_point("cylinder", rotate);
            }
          }
        }
      }
    }
  }
}

module corner_cylinder(length, radius) {
  difference() {
    cylinder(h = length, r = radius);
    heightOffset = 10;
    translate([ -radius, 0, -(heightOffset / 2) ])
        cube([ radius, radius, length + heightOffset ]);
    translate([ -radius, -(radius / 2), -(heightOffset / 2) ])
        cube([ radius, radius, length + heightOffset ]);
    translate([ -radius, -radius, -(heightOffset / 2) ])
        cube([ radius, radius, length + heightOffset ]);
    translate([ 0, -radius, -(heightOffset / 2) ])
        cube([ radius, radius, length + heightOffset ]);
    translate([ -(radius / 2), -radius, -(heightOffset / 2) ])
        cube([ radius, radius, length + heightOffset ]);
  }
}

module hollow_square(size, wallThickness = wallThickness) {
  difference() {
    square(size);
    translate([ wallThickness, wallThickness, 0 ]) //
        square([
          size[0] - (wallThickness * 2), size[1] - (wallThickness * 2)
        ]);
  }
}
module hollowSquare(size, wallThickness = wallThickness) {
  hollow_square(size, wallThickness);
}