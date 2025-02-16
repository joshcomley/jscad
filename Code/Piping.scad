include <Lists.scad>

s = 0;
function calculateRotationalPosition(paths, i) = [
    paths[i][0],                                                                                //
    -(0 * cos(sumList(paths, 0, i + 1)[1]) - (paths[i][s] * sin(sumList(paths, 0, i + 1)[1]))), //
    (0 * sin(sumList(paths, 0, i + 1)[1]) + (paths[i][s] * cos(sumList(paths, 0, i + 1)[1])))
];
function calculatePositions(path) = [for (a = [0:len(pathPoints) - 1]) calculateRotationalPosition(pathPoints, a)];
function calculateXFromPath(path) = sumList(calculatePositions(path), 0, len(path) - 1)[1];

module pipePath(paths, cs, kind)
{
    s = 0;
    r = 1;

    function findWidth(arrOrNumber) = len(arrOrNumber) > 0 ? arrOrNumber[0] : arrOrNumber;
    function findHeight(arrOrNumber) = len(arrOrNumber) > 0 ? arrOrNumber[1] : arrOrNumber;

    newDefs = [for (a = [0:len(paths) - 1]) calculateRotationalPosition(paths, a)];

    for (i = [0:len(newDefs) - 1])
    {
        length = newDefs[i][0];
        union()
        {
            translate([ sumList(newDefs, 0, i)[1], 0, sumList(newDefs, 0, i)[2] ]) rotate([
                sumList(paths, 0, i + 1)[2], //
                sumList(paths, 0, i + 1)[1], //
                sumList(paths, 0, i + 1)[3]
            ]) linear_extrude(height = length)
            {
                if (kind == "square")
                {
                    square(size = cs);
                }
                else
                {
                    circle(r = findWidth(cs) / 2);
                }
            }
            if (i > 0)
            {
                if (kind == "square")
                {
                    h = findHeight(cs);
                    w = findWidth(cs);
                    deg = paths[i][1];
                    totalDeg = sumList(paths, 0, i)[1];
                    triangle_points = [ [ 0, 0 ], [ 0, w ], [ ((-w * sin(deg))), -(-w * cos(deg)) ] ];
                    // color("red")
                    translate([ sumList(newDefs, 0, i)[1], 0, sumList(newDefs, 0, i)[2] ]) rotate([ 180, 270, 90 ])
                        rotate([ 0, 0, totalDeg ]) linear_extrude(height = findHeight(cs))
                            polygon(points = triangle_points);
                }
                else
                {
                    translate([ sumList(newDefs, 0, i)[1], 0, sumList(newDefs, 0, i)[2] ]) sphere(findWidth(cs) / 2);
                }
            }
        }
    }
}

module pipePath2(paths, cs, kind)
{
    s = 0;
    r = 1;

    function findWidth(arrOrNumber) = len(arrOrNumber) > 0 ? arrOrNumber[0] : arrOrNumber;
    function findHeight(arrOrNumber) = len(arrOrNumber) > 0 ? arrOrNumber[1] : arrOrNumber;

    newDefs = [for (a = [0:len(paths) - 1]) calculateRotationalPosition(paths, a)];
    // echo(newDefs);

    for (i = [0:len(newDefs) - 1])
    {
        length = newDefs[i][0];
        union()
        {
            translate([ sumList(newDefs, 0, i)[1], 0, sumList(newDefs, 0, i)[2] ])
                rotate([ sumList(paths, 0, i + 1)[2], sumList(paths, 0, i + 1)[1], sumList(paths, 0, i + 1)[3] ])
                    linear_extrude(height = length)
            {
                if (kind == "square")
                {
                    square(size = cs);
                }
                else
                {
                    circle(r = findWidth(cs) / 2);
                }
            }
            if (i > 0)
            {
                if (kind == "square")
                {
                    h = findHeight(cs);
                    w = findWidth(cs);
                    deg = paths[i][1];
                    totalDeg = sumList(paths, 0, i)[1];
                    triangle_points = [ [ 0, 0 ], [ 0, w ], [ ((-w * sin(deg))), -(-w * cos(deg)) ] ];
                    // color("red")
                    translate([ sumList(newDefs, 0, i)[1], 0, sumList(newDefs, 0, i)[2] ]) rotate([ 180, 270, 90 ])
                        rotate([ 0, 0, totalDeg ]) linear_extrude(height = findHeight(cs))
                            polygon(points = triangle_points);
                }
                else
                {
                    translate([ sumList(newDefs, 0, i)[1], 0, sumList(newDefs, 0, i)[2] ]) sphere(findWidth(cs) / 2);
                }
            }
        }
    }
}

// e.g.
// pipePath(
//     [
//       [ 50, 11 ], [ 50, 25 ], [ 50, 35 ], [ 100, 45 ], [ 100, 45 ], [ 200,
//       -45 ]
//     ],
//     50);