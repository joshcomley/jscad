include <./../../Round-Anything/polyround.scad>
include <./CountersunkScrewHole.scad>
include <./Elements/Hook.scad>
include <./MechanicalOld.scad>
include <./Shapes.scad>

mRodConeDefaultLength = 5;

module tube(innerDiameter, wallThickness = 3, length = 30)
{
    outerDiameter = innerDiameter + (wallThickness * 2);

    // Subtract inner cylinder from outer cylinder
    difference()
    {
        cylinder(d = outerDiameter, h = length);
        translate([ 0, 0, -0.5 ]) //
            cylinder(d = innerDiameter, h = length + 1);
    }
}

module uShape(height, wallThickness, gapWidth, depth)
{
    translate([ 0, wallThickness, 0 ]) //
        linear_extrude(height = depth) //
        polygon([
            [ 0, -wallThickness ],                              //
            [ 0, height ],                                      //
            [ wallThickness, height ],                          //
            [ wallThickness, 0 ],                               //
            [ wallThickness + gapWidth, 0 ],                    //
            [ wallThickness + gapWidth, height ],               //
            [ (wallThickness * 2) + gapWidth, height ],         //
            [ (wallThickness * 2) + gapWidth, -wallThickness ], //
        ]);
}

function resolveMRodConeLength(coneLength) = //
    is_undef(coneLength)                     //
        ? mRodConeDefaultLength              //
        : coneLength;

module mRodCone(coneLength, threadSize, pointDown = false)
{
    baseDiameter = threadSize * 0.8;
    cylinder(                                  //
        h = resolveMRodConeLength(coneLength), //
        d1 = pointDown ? 0 : baseDiameter,     //
        d2 = pointDown ? baseDiameter : 0      //
    );
}

module mRod(                   //
    size = 5,                  //
    length = 10,               //
    isFemale = false,          //
    coneTopInclude = false,    //
    coneTopLength = undef,     //
    coneBottomInclude = false, //
    coneBottomLength = undef,  //
)
{
    pitch = 0;                                    // thread pitch (0=use ISO pitch based on diameter)
    angle = 30;                                   // ISO thread angle (default 30, 45 for printing)
    fn = 64;                                      // number of faces
    fnstep = 4;                                   // number of steps in pitch stack (fn/fnstep must be >= 16)
    depth = ISO_thread_depth(size, pitch, angle); // thread depth
    taper_arc = 0.25;                             // lead-in thread length (1=full circle)
    profile = ISO_ext_thread_profile();
    // color("silver") hex_screw(                               //
    //     ISO_ext_thread_profile(),                            //
    //     depth,                                               //
    //     length = ht,                                         //
    //     dia = dia,                                           //
    //     rshift = ISO_thread_rshift(dia, pitch, angle) - 0.1, //
    //     pitch = pitch,                                       //
    //     fn = fn,                                             //
    //     fnstep = fnstep,                                     //
    //     taper_arc = taper_arc                                //
    // );
    // color("silver") translate([ dia * 2.2, 0, 0 ]) hex_nut( //
    //     ISO_ext_thread_profile(),                           //
    //     depth,                                              //
    //     dia = dia,                                          //
    //     pitch = pitch,                                      //
    //     rshift = 0.1,                                       //
    //     fn = fn,                                            //
    //     fnstep = fnstep                                     //
    // );
    // translate([0,isFemale?0.1:0,0])//
    if (isFemale)
    {
        minkowski_r = 0;
        r = 0.5 * size;
        translate([ 0, 0, -minkowski_r - 0.1 ])   //
            threaded_rod(                         //
                profile,                          //
                depth,                            //
                length + 2 * (minkowski_r + 0.2), //
                size,                             //
                pitch,                            //
                rshift = 0.1,                     //
                fn,                               //
                fnstep                            //
            );
        // bevel the hole in the nut
        translate([ 0, 0, length - r + minkowski_r ]) //
            cylinder(h = r + 1 + minkowski_r / 2, r1 = 0, r2 = r + 1 + minkowski_r / 2, $fn = fn);
        translate([ 0, 0, -1 - 1.5 * minkowski_r ]) //
            cylinder(h = r + 1 + minkowski_r / 2, r1 = r + 1 + minkowski_r / 2, r2 = 0, $fn = fn);
    }
    else
    {
        threaded_rod(                                             //
            thread_profile = profile,                             //
            thread_depth = depth,                                 //
            length = length,                                      //
            dia = size,                                           //
            pitch = pitch,                                        //
            rshift = ISO_thread_rshift(size, pitch, angle) - 0.1, //
            fn = fn,                                              //
            fnstep = fnstep,                                      //
            taper_arc = taper_arc                                 //
        );
    }

    if (coneTopInclude)
    {
        translate([
            0,                              //
            0,                              //
            length                          //
        ])                                  //
            mRodCone(                       //
                coneLength = coneTopLength, //
                threadSize = size           //
            );
    }
    if (coneBottomInclude)
    {
        translate([
            0,                                       //
            0,                                       //
            -resolveMRodConeLength(coneBottomLength) //
        ])                                           //
            mRodCone(                                //
                coneLength = coneBottomLength,       //
                threadSize = size,                   //
                pointDown = true                     //
            );
    }
}
// counterSunkScrewDefaultHeadHeight = 4.15;
// module counterSunkScrewHole(                        //
//     length = 30,                                    //
//     width = 2.2,                                    //
//     headWidth = 8.1,                                //
//     headHeight = counterSunkScrewDefaultHeadHeight, //
//     cutoutAboveHeight = 10,                         //
//     // this is how round the screw is. Lower this number to
//     // get faster renderings.
//     grani = 32 //
// ) {
//   rotate([ 0, 180, 0 ])                   //
//       counterSunkScrew(length,            //
//                        width,             //
//                        headWidth,         //
//                        headHeight,        //
//                        cutoutAboveHeight, //
//                        grani              //
//       );
// }

// module counterSunkScrew(                            //
//     length = 30,                                    //
//     width = 2.2,                                    //
//     headWidth = 8.1,                                //
//     headHeight = counterSunkScrewDefaultHeadHeight, //
//     cutoutAboveHeight = 10,                         //
//     // this is how round the screw is. Lower this number to
//     // get faster renderings.
//     grani = 32 //
// ) {
//   cutoutAbove = headWidth + 2;
//   union() {
//     translate([ 0, 0, -cutoutAboveHeight ]) color("magenta") cylinder(
//         d1 = cutoutAbove, d2 = cutoutAbove, h = cutoutAboveHeight, $fn =
//         grani);
//     color("red")
//         cylinder(d1 = headWidth, d2 = width, h = headHeight, $fn = grani);

//     cylinder(d1 = width, d2 = width, h = length + headHeight, $fn = grani);
//   }
// }

usbCCutoutWidth = 10;
usbCCutoutHeight = 4;
module usbCCutout(depth = 10, support = false)
{
    supportDelta = 0.005;
    rotate([ 90, 0, 0 ])                                                      //
        linear_extrude(height = support ? 0.2 : depth)                        //
        offset(delta = support ? -supportDelta : 0)                           //
        translate([ 0, support ? -(usbCCutoutHeight * supportDelta) : 0, 0 ]) //
        rounding(r = 1)                                                       //
        square([ usbCCutoutWidth, usbCCutoutHeight ]);
}

module makeMountable(   //
    x = 0,              //
    y = 0,              //
    z = 0,              //
    wallThickness,      //
    invertHole = false, //
    position = "top",   //
    rotateAngle = 90,   //
    width = undef,      //
    length = undef,     //
    ingress = undef     //
)
{
    hookIngress = ingress == undef ? 2.2 : ingress;
    hookTravel = (x + wallThickness);
    hookThickness = wallThickness;
    lengthValue = length == undef ? 10 : length;
    translate([ hookTravel - wallThickness, wallThickness + y, 0 ]) //
        rotate([ rotateAngle, -rotateAngle, 0 ])                    //
    {
        hook(                              //
            forScrew = true,               //
            squareTop = position == "top", //
            invertHole = !invertHole,      //
            width = width,                 //
            length = z + lengthValue       //
        );
        if (position == "top")
        {
            translate([ z + lengthValue + 4, 0, 0 ]) //
                hook(                                //
                    forScrew = true,                 //
                    invertHole = !invertHole,        //
                    width = width,                   //
                    length = lengthValue             //
                );
        }
        if (position == "top+bottom")
        {
            translate([ -(lengthValue * 2), 0, 0 ]) //
                hook(                               //
                    forScrew = true,                //
                    invertHole = !invertHole,       //
                    invertEdges = true,             //
                    width = width,                  //
                    length = lengthValue            //
                );
        }
    }
    children();
}

module squareRounded(size, rounding = 5)
{
    sizeValue = is_list(size) ? size : [ size, size ];
    points = polyRound( //
        [
            [ 0, 0, rounding ],                       //
            [ sizeValue[0], 0, rounding ],            //
            [ sizeValue[0], sizeValue[1], rounding ], //
            [ 0, sizeValue[1], rounding ]             //
        ],                                            //
        30                                            //
    );
    polygon(   //
        points //
    );
}

module mount(                //
    mountHeight = 100,       //
    mountWidth = 50,         //
    wallThickness = 3,       //
    extrudeDepth = 10,       //
    extrudeWidth = 20,       //
    extrudeHeightFront = 10, //
    extrudeHeightBack = 20,  //
    extrudeOffsetY = 0,      //
    screwHoleInsetX = 8,     //
    screwHoleInsetY = 14,    //
    kind = "cleat+screw",    //
    cleatAngle = 45,
    cleatLength = 20,        //
    doHull = true,           //
    cleatTopHeight = 5,      //
    mountVerticalOffset = 0, //
    screwTop = false,        //
)
{
    extrudeTotalHeight = max(extrudeHeightFront, extrudeHeightBack);
    $mountWidth = mountWidth;
    $mountHeight = mountHeight;
    $extrusionTopY = ((mountHeight - extrudeTotalHeight) / 2 + extrudeTotalHeight) + extrudeOffsetY;
    module performHullIfNecessary()
    {
        if (doHull)
        {
            hull()
            {
                children();
            }
        }
        else
        {
            children();
        }
    }
    module screwHole()
    {
        counterSunkScrewHole(headHeight = wallThickness);
    }

    module center()
    {
        translate([
            (mountWidth) / 2, //
            0,                //(mountHeight) / 2, //
            extrudeDepth      //
        ])                    //
        {
            children();
        }
    }

    if (kind == "cleat" || kind == "cleat+screw")
    {
        cleatHeight = cleatLength * sin(cleatAngle);
        cleatDepth = cleatLength * cos(cleatAngle);
        color("pink") //
            translate([ 0, 0, -cleatDepth ])
        {
            difference()
            {
                group()
                {
                    rotate([ 90, -90, 90 ])                 //
                        translate([ 0, -(cleatHeight), 0 ]) //
                    {
                        translate([ 0, -cleatTopHeight, 0 ])    //
                            linear_extrude(height = mountWidth) //
                            polygon([
                                //
                                [ 0, 0 ],                    //
                                [ 0, cleatHeight ],          //
                                [ cleatDepth, cleatHeight ], //
                                [ 0, 0 ],                    //
                            ]);
                    }
                    linear_extrude(height = cleatDepth) //
                        square([ mountWidth, cleatTopHeight ]);
                }
                if (screwTop)
                {
                    rotate([ 90, 0, 0 ])                                 //
                        translate([ mountWidth / 2, cleatDepth / 2, 0 ]) //
                        counterSunkScrewHole(width = 3.5);
                }
            }
        }
    }
    difference()
    {
        translate([ 0, mountVerticalOffset, 0 ])   //
            linear_extrude(height = wallThickness) //
            square([ mountWidth, mountHeight ]);

        if (kind == "screw" || kind == "cleat+screw")
        {
            translate([ 0, 0, wallThickness ]) //
            {
                if (kind == "screw")
                {
                    translate([ screwHoleInsetX, screwHoleInsetY, 0 ]) //
                    {
                        screwHole();
                    }
                    translate([ mountWidth - screwHoleInsetX, screwHoleInsetY, 0 ]) //
                    {
                        screwHole();
                    }
                }
                translate([ mountWidth / 2, mountHeight - screwHoleInsetY, 0 ]) //
                {
                    screwHole();
                }
            }
        }
    }
    difference()
    {
        group()
        {
            translate([ 0, 0, wallThickness ]) //
            {
                performHullIfNecessary()
                {
                    group()
                    {
                        color("pink") //
                            translate([
                                ((mountWidth - extrudeWidth) / 2) + extrudeWidth,          //
                                ((mountHeight - extrudeTotalHeight) / 2) + extrudeOffsetY, //
                                0                                                          //
                            ])                                                             //
                            rotate([ 0, -90, 0 ])                                          //
                            linear_extrude(height = extrudeWidth)                          //
                        {
                            polygon( //
                                [
                                    [ 0, 0 ],                             //
                                    [ 0, extrudeHeightBack ],             //
                                    [ extrudeDepth, extrudeHeightBack ],  //
                                    [ extrudeDepth, extrudeHeightFront ], //
                                ]);
                        }
                    }
                    if ($children > 0)
                    {
                        center() //
                            children(0);
                    }
                }
            }
        }
        if ($children > 1)
        {
            translate([ 0, 0, wallThickness ]) //
                center()                       //
                children(1);
        }
    }
}

module drillGuide(                  //
    thickness = 2,                  //
    height = 12,                    //
    edgeLength = undef,             //
    edgeHeight = 12,                //
    drillGuideInset = 10,           //
    drillGuideInsetX = undef,       //
    drillGuideInsetY = undef,       //
    drillGuidePlatformSize = undef, //
    drillBitGuideHeight = 20,       //
    drillBitSize = 8,               //
    kind = "corner",                //
)
{
    drillSize = drillBitSize + 0.8;
    drillGuideInsetX = drillGuideInsetX == undef ? drillGuideInset : drillGuideInsetX;
    drillGuideInsetY = drillGuideInsetY == undef ? drillGuideInset : drillGuideInsetY;
    drillGuidePlatformSizeValue =
        drillGuidePlatformSize == undef ? max(drillGuideInsetX, drillGuideInsetY) + 30 : drillGuidePlatformSize;
    edgeLengthValue = edgeLength == undef ? drillGuidePlatformSizeValue : edgeLength;
    drillGuideInsetXValue = drillGuideInsetX; // kind == "edge" ? drillGuidePlatformSizeValue / 2 : drillGuideInsetX;
    difference()
    {
        group()
        {
            translate([ 0, -thickness, 0 ])         //
                linear_extrude(height = edgeHeight) //
                square([ edgeLengthValue, thickness ]);
            if (kind == "corner")
            {
                translate([ -thickness, -thickness, 0 ]) //
                    linear_extrude(height = edgeHeight)  //
                    square([ thickness, edgeLengthValue + thickness ]);
            }
            color("pink")                          //
                linear_extrude(height = thickness) //
                square([ drillGuidePlatformSizeValue, drillGuidePlatformSizeValue ]);
            difference()
            {
                translate([
                    drillGuideInsetXValue, //
                    drillGuideInsetY,      //
                    -(drillBitGuideHeight) //
                ])                         //
                    cylinder(h = drillBitGuideHeight, d = drillSize + (thickness * 2));
            }
        }
        translate([
            drillGuideInsetXValue,       //
            drillGuideInsetY,            //
            -(drillBitGuideHeight + 0.5) //
        ])                               //
            cylinder(h = drillBitGuideHeight + thickness + 1, d = drillSize);
        // translate([ drillGuideInsetY, drillGuideInsetY, 0 ]) //
        //     counterSunkScrewHole(reverse = true);
    }
    textDepth = 1.2;

    translate([ 0, 0, -textDepth ]) //
        color("green")              //
        rotate([ 180, 0, 0 ])       //
    {
        if (drillGuideInsetX == drillGuideInsetY)
        {
            rotate([ 0, 0, 180 - 45 ])                             //
                translate([ -drillGuideInsetX / (PI / 2), -5, 0 ]) //
                linear_extrude(height = textDepth)                 //
                text(str(drillGuideInsetX, "mm"), halign = "center");
        }
    }
}