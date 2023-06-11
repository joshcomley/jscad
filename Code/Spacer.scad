include <jscad/code/Fonts.scad>

function fitTextToBounds(length = 100, height = 100, text = "",
                         font = "Liberation Sans", size = 10., spacing = 1.,
                         fonts = FONTS) =
    fitTextToHeight(height, text, font,
                    fitTextToLength(length, text, font, size, spacing, fonts),
                    spacing, fonts);
function fitTextToLength(length = 100, text = "", font = "Liberation Sans",
                         size = 10., spacing = 1., fonts = FONTS) =
    measureText(text, font, size, spacing, fonts) / length > 0.9          //
        ? fitTextToLength(length, text, font, size - 0.1, spacing, fonts) //
        : (measureText(text, font, size, spacing, fonts) / length < 0.8   //
               ? fitTextToLength(length, text, font, size + 0.1, spacing,
                                 fonts) //
               : size                   //
          );
function fitTextToHeight(height = 100, text = "", font = "Liberation Sans",
                         size = 10., spacing = 1., fonts = FONTS) =
    (ascender(font, size, fonts)) / height > 0.95                         //
        ? fitTextToHeight(height, text, font, size - 0.1, spacing, fonts) //
        : size;

module spacer(size, length = undef, height = undef) {
  actualHeightBox = is_undef(height) ? 10 : height;
  actualLengthBox = is_undef(length) ? 20 : length;
  font = "Liberation Sans Narrow";
  // size=20.);
  sizeText = str(size);
  //   echo(actualHeightText);
  //   echo(ascender(font, actualFontSize) - descender(font, actualFontSize));
  module label() {
    actualFontSize = fitTextToBounds(actualLengthBox - 1, //
                                     actualHeightBox - 1, //
                                     sizeText,            //
                                     font);               //
    actualLengthText =
        measureText(sizeText, font = font, size = actualFontSize);
    actualHeightText = ascender(font, actualFontSize);
    echo(actualFontSize);
    echo(actualLengthText);
    echo(actualLengthBox);
    rotate([ 90, 180, 0 ]) //
        translate([
          -actualLengthBox,
          -actualHeightBox, //
          0,                //
        ])                  //
        translate([
          ((actualLengthBox - actualLengthText) / 2) - 0.5,
          ((actualHeightBox - actualHeightText) / 2),
          -size * 1.5,                                          //
        ])                                                      //
        color("red")                                            //
        linear_extrude(height = size * 2)                       //
        drawText(sizeText, font = font, size = actualFontSize); //
  }
  label2Depth = 2;
  module label2() {
    actualFontSize = fitTextToBounds(size - 1,            //
                                     actualLengthBox - 1, //
                                     sizeText,            //
                                     font);               //
    actualLengthText =
        measureText(sizeText, font = font, size = actualFontSize);
    actualHeightText = ascender(font, actualFontSize);
    echo(actualFontSize);
    echo(actualLengthText);
    echo(actualLengthBox);
    rotate([ 0, 90, 90 ]) //
        translate([
          -(((size) / 2) + (actualLengthText / 2)),
          -(((actualLengthBox) / 2) + (actualHeightText / 2)),
          actualHeightBox, //
        ])                 //
        translate([
          0, 0,
          0,                                                    //
        ])                                                      //
        color("red")                                            //
        linear_extrude(height = label2Depth)                    //
        drawText(sizeText, font = font, size = actualFontSize); //
  }
  module box() {
    color("green") cube([ actualLengthBox, size, actualHeightBox ]);
  }
  translate([ 0, 0, size ]) rotate([ 90, 180, 180 ]) difference() {
    box();
    label();
  }
  label2();
  rotate([ 180, 0, 0 ])                                    //
      translate([ 0, -actualHeightBox, -size ]) //
      label2();
}

// spreader(12 - 6.15);
spacer(123.59);