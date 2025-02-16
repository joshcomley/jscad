include <agentscad/lib-screw.scad>
use <agentscad/mx-screw.scad>
use <agentscad/mx-thread.scad>

use <agentscad/extensions.scad>
use <agentscad/lib-spiral.scad>
use <agentscad/mesh.scad>
use <agentscad/printing.scad>
use <list-comprehension-demos/skin.scad>
use <scad-utils/lists.scad>
use <scad-utils/transformations.scad>

module mxNutAllen(p = M2(), bt = true, bb = false)
{
    tool_r = p[I_ATS] / (2 * cos(30)) + gap();
    tool_l = p[I_AHL] * 2 / 3;
    cylinder(r = tool_r, h = tool_l, $fn = 6);
}

module knob(
    // knob parameters
    knobHeight = 15,   //
    knobDiameter = 30, //

    // screw parameters
    includeScrew = false,      //
    screwHeadFaceToFace = 8,   //
    screwHeadDepth = 12,       //
    throughHoleDiameter = 4,   //
    throughHoleHeight = undef, //

    // grippy cutouts parameters
    gripCutoutsCount = 20,          //
    gripCutoutsDiameter = 4,        //
    gripCutoutsRadiusAdjustment = 1 //
)
{
    module faceToFaceHex(width, height)
    {

        cube([ width / sqrt(3), width, height ], center = true, $fn = 64);
        rotate([ 0, 0, 120 ]) cube([ width / sqrt(3), width, height ], center = true);
        rotate([ 0, 0, 240 ]) cube([ width / sqrt(3), width, height ], center = true);
    }
    // a=angle, r=radius of rotation
    module rotate_on_circle(angle, radius)
    {
        dx = radius * sin(angle);
        dy = radius * cos(angle);
        translate([ dx, dy, 0 ]) children();
    }

    translate([ 0, 0, screwHeadDepth ]) //
        difference()
    {

        // Knob
        union()
        {
            translate([ 0, 0, -(((knobHeight - screwHeadDepth) / 2) + 0.01) ])
                cylinder(r = knobDiameter / 2, h = knobHeight, center = true, $fn = 64);
            // translate([ 0, 0, -(((knobHeight - screwHeadDepth + knobHeight) / 2)) ])
            // {
            //     cylinder(r = knobDiameter / 4, h = knobHeight / 2, center = true, $fn = 64);
            // }
        };

        // screw
        union()
        {
            // screwHead
            if (includeScrew)
            {
                faceToFaceHex(screwHeadFaceToFace, screwHeadDepth);
            }
            // screwHole
            translate([ 0, 0, -(((knobHeight + screwHeadDepth) / 2) + 0.001) ])
                cylinder(r = throughHoleDiameter / 2,                  //
                         h = throughHoleHeight == undef                //
                                 ? knobHeight + knobHeight / 2 + 0.001 //
                                 : throughHoleHeight,                  //
                         center = true,                                //
                         $fn = 64);
        };

        // grippyCutouts
        for (i = [1:gripCutoutsCount])
        {

            rot_angle = (360 / gripCutoutsCount) * i;
            translate([ 0, 0, -(((knobHeight - screwHeadDepth) / 2) + 0.01) ])
                rotate_on_circle(rot_angle, (knobDiameter / 2) + gripCutoutsRadiusAdjustment)
                    cylinder(r = gripCutoutsDiameter / 2, h = knobHeight + 0.01, center = true, $fn = 64);
        };

        // top filet
        translate([ 0, 0, -(((knobHeight - screwHeadDepth) / 2) - 0.1) ]) //
            rotate_extrude()                                              //
            polygon(points =                                              //
                    [
                        //
                        [ knobDiameter, knobHeight ], //
                        [ 0, knobHeight + 2 ],        //
                        [ 0, knobHeight ],            //
                        [ knobDiameter / 1.29, 0 ]    //
                    ],                                //
                    $fn = 100);
        // down filet
        translate([ 0, 0, -(((knobHeight - screwHeadDepth) / 2) + 0.1) ]) rotate_extrude()
            polygon(points =
                        [
                            [ -knobDiameter, -knobHeight ], [ 0, -knobHeight - 2 ], [ 0, -knobHeight ],
                            [ -knobDiameter / 1.29, 0 ]
                        ],
                    $fn = 100);
    }
}

module grub(screw, length = 8)
{
    difference()
    {
        rotate([ 0, 180, 0 ])            //
            translate([ 0, 0, -length ]) //
            mxThreadExternal(screw, l = length);
        translate([ 0, 0, length ]) //
        {
            driveThickness = 1.5;
            translate([ -driveThickness / 2, -5, -1.5 ]) //
                linear_extrude(height = 10)              //
                square([ driveThickness, 10 ]);
        }
    }
}