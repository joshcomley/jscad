include <./CountersunkScrewHole.scad>
include <./Elements/Hook.scad>
include <./Mechanical.scad>
include <./Shapes.scad>

module mRod(size = 5, length = 10) {
  pitch = 0;  // thread pitch (0=use ISO pitch based on diameter)
  angle = 45; // ISO thread angle (default 30, 45 for printing)
  fn = 64;    // number of faces
  fnstep = 4; // number of steps in pitch stack (fn/fnstep must be >= 16)
  depth = ISO_thread_depth(size, pitch, angle); // thread depth
  taper_arc = 0.25; // lead-in thread length (1=full circle)

  threaded_rod(                                   //
      ISO_ext_thread_profile(),                   //
      depth,                                      //
      length,                                     //
      size,                                       //
      pitch,                                      //
      ISO_thread_rshift(size, pitch, angle) - 0.1, //
      fn,                                         //
      fnstep,                                     //
      taper_arc                                   //
  );
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