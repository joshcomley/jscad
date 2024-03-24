// parameterized_clip.scad
// Copyright (c)2023 DP design / Daniel Perry
// place this file in the correct OpenSCAD library directory for your operating system,
// then add:
// use parameterized_clip.scad
// to your code
// https://www.printables.com/model/559625-openscad-parameterized-clip-library/files

clip_default_width = 10;
clip_default_length = 10;
clip_default_thickness = 5;
clip_default_arm_width = 1;
clip_default_body_length = 4;
clip_default_tab_protrusion = 0.8;
clip_default_male_female_delta = 0.25;
clip_default_is_angled = false; // need a larger clip_default_thickness to make sense
clip_default_is_locking = true;
clip_default_is_double = false;

// $fs = 0.2;
// $fa = 4;

// // demo_clip1();
// // translate([0, 50,0]) demo_clip2();
// // demo_clip3();

// module demo_clip1()
// {
//     difference()
//     {
//         union()
//         {
//             cube([ 30, 20, 5 ], center = true);
//             translate([ 14.9, 0, -0.5 * (5 - 3) ])
//                 clip(isFemale = false, clip_default_length, clip_default_width, 3, clip_default_arm_width,
//                      clip_default_body_length, clip_default_tab_protrusion, false, false);
//         }
//         translate([ -15.1, 0, -0.5 * (5 - 3) ])
//             clip(isFemale = true, clip_default_length, clip_default_width, 3, clip_default_arm_width,
//                  clip_default_body_length, clip_default_tab_protrusion, false, false, clip_default_male_female_delta);
//     }
// }

// module demo_clip2()
// { // angled clip
//     difference()
//     {
//         union()
//         {
//             cube([ 30, 20, 30 ], center = true);
//             translate([ 14.9, 0, 0 ]) clip(isFemale = false, 20, 10, 20, 1, 0, 0.8, true, false);
//         }
//         translate([ -15.1, 0, 0 ])
//             clip(isFemale = true, 20, 10, 20, 1, 0, 0.8, true, false, clip_default_male_female_delta);
//     }
// }

// module demo_clip3()
// { // angled clip
//     difference()
//     {
//         union()
//         {
//             cube([ 30, 20, 30 ], center = true);
//             translate([ 14.9, 0, 0 ]) clip(isFemale = false, 20, 10, 20, 1, 0, 0.8, true, true);
//         }
//         translate([ -15.1, 0, 0 ])
//             clip(isFemale = true, 20, 10, 20, 1, 0, 0.8, true, true, clip_default_male_female_delta);
//     }
// }

// // clip(isFemale = false);
// // translate([0, 30, 0])
// //      clip(isFemale = true);

module clip(                                     //
    length = clip_default_length,                //
    width = clip_default_width,                  //
    thickness = clip_default_thickness,          //
    armWidth = clip_default_arm_width,           //
    bodyLength = clip_default_body_length,       //
    tapProtrusion = clip_default_tab_protrusion, //
    isAngled = clip_default_is_angled,           //
    isLocking = clip_default_is_locking,         //
    isDouble = clip_default_is_double,           //
    flipHorizontal = false,                      //
    flipVertical = false,                        //
    isFemale = false,                            //
    perpendicular = false                        //
)
{
    module generateClip(delta)
    {
        tab_dist_from_end = 4;
        tab_radius = 4 + delta;
        blocker_length = 2 * tab_radius + 2;
        difference()
        {
            union()
            {
                hull()
                {
                    translate([ length - 0.5 * armWidth, -0.5 * (width - armWidth), 0 ])
                        cylinder(h = thickness + delta, d = armWidth + delta, center = true);
                    translate([ 1, -0.5 * (width - armWidth), 0 ])
                        cube([ 2, armWidth + delta, thickness + delta ], center = true);
                }

                difference()
                {
                    translate([ length - tab_dist_from_end, -0.5 * width + tab_radius - tapProtrusion, 0 ])
                        cylinder(h = thickness + delta, r = tab_radius, center = true);
                    translate([ length - tab_dist_from_end, -0.5 * width + 0.5 * armWidth + 0.5 * blocker_length, 0 ])
                        cube([ blocker_length, blocker_length, thickness + 2 ], center = true);
                    if (isLocking)
                    {
                        translate([ length - 0.5 * blocker_length - tab_dist_from_end, -0.5 * blocker_length, 0 ])
                            cube([ blocker_length, blocker_length, thickness + 2 ], center = true);
                    }
                }
            }
            if (isAngled)
            {
                translate([ 0.5 * length, 0, -0.5 * thickness ]) rotate([ 0, 55, 0 ])
                    cube([ length / (2 * sin(55)), 2 * width, 5 * thickness ], center = true);
            }
        }
    }
    module doClip()
    {
        generateClip(isFemale ? clip_default_male_female_delta : 0);
    }
    rotate([
        0,                                                    //
        (flipVertical ? 180 : 0) + (!perpendicular ? 90 : 0), //
        0                                                     //
    ])
        translate([
            (flipVertical ? -length : 0) + (!perpendicular ? length / 2 : -(length / 2)) + (length / 2) +
                (flipVertical ? 0 : -(length * 2)),                                              //
            (width / 2),                                                                         //
            -(!perpendicular ? thickness / 2 : (thickness / 2)) + (flipVertical ? 0 : thickness) //
        ])                                                                                       //
    {
        rotate([
            //
            flipHorizontal ? 180 : 0, //
            0,                        //
            0                         //
        ])                            //
            translate([
                //
                0,                                     // flipVertical ? -length : 0,             //
                flipHorizontal ? width - armWidth : 0, //
                0                                      //
            ])                                         //
            doClip();
        if (isDouble)
        {
            translate([ 0.5 * bodyLength, 0, 0 ]) //
                cube([ bodyLength, width, thickness ], center = true);
            translate([ 0, flipHorizontal ? width - armWidth : 0, 0 ]) //
                rotate([ flipHorizontal ? 0 : 180, 0, 0 ])             //
                doClip();
        }
    }
}