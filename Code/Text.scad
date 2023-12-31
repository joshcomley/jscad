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