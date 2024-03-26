include <./CountersunkScrewHole.scad>
include <./Elements/Hook.scad>
include <./Mechanical.scad>
include <./Shapes.scad>

module mRod(size = 5, length = 10, isFemale = false)
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