import(file = "Lists");

module pipePath(paths, cs) {
  s = 0;
  r = 1;

  function calculateRotationalPosition(i) = [
    paths[i][0],
    -(0 * cos(sumList(paths, 0, i + 1)[1]) -
      (paths[i][s] * sin(sumList(paths, 0, i + 1)[1]))),
    (0 * sin(sumList(paths, 0, i + 1)[1]) +
     (paths[i][s] * cos(sumList(paths, 0, i + 1)[1])))
  ];

  newDefs = [for (a = [0:len(paths) - 1]) calculateRotationalPosition(a)];
  echo(newDefs);

  for (i = [0:len(newDefs) - 1]) {
    length = newDefs[i][0];
    union() {
      translate([ sumList(newDefs, 0, i)[1], 0, sumList(newDefs, 0, i)[2] ])
          rotate([ 0, sumList(paths, 0, i + 1)[1], 0 ])
              linear_extrude(height = length) circle(r = cs / 2);
      if (i > 0) {
        translate([ sumList(newDefs, 0, i)[1], 0, sumList(newDefs, 0, i)[2] ])
            sphere(cs / 2);
      }
    }
  }
}
// e.g.
// pipePath(
//     [
//       [ 50, 11 ], [ 50, 25 ], [ 50, 35 ], [ 100, 45 ], [ 100, 45 ], [ 200, -45 ]
//     ],
//     50);