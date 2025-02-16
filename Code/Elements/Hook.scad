include <../CountersunkScrewHole.scad>

module hook(              //
    wallThickness = 3,    //
    width = undef,        //
    length = undef,       //
    holeDiameter = undef, //
    forScrew = false,     //
    squareTop = false,    //
    invertHole = false,   //
    invertEdges = false)
{
    widthValue = width == undef ? 18 : width;
    lengthValue = length == undef ? 10 : length;
    function holeDiameterCalc() = widthValue - (wallThickness * 2);
    translate([ 0, -(widthValue / 2), 0 ]) //
    {
        difference()
        {
            group()
            {
                translate([ invertEdges ? lengthValue : 0, 0, 0 ]) //
                    linear_extrude(height = wallThickness)         //
                    square([ lengthValue, widthValue ]);
                translate([ lengthValue, widthValue / 2, 0 ]) //
                    linear_extrude(wallThickness)             //
                    circle(d = widthValue);
                if (squareTop)
                {
                    translate([ lengthValue, 0, 0 ])  //
                        linear_extrude(wallThickness) //
                        square([ widthValue / 2, widthValue ]);
                }
            }
            translate([ lengthValue, widthValue / 2, -1 ]) //
            {
                if (forScrew)
                {                                                                  //
                    rotate([ invertHole ? 180 : 0, 0, 0 ])                         //
                        translate([ 0, 0, invertHole ? -(wallThickness + 1) : 1 ]) //
                        counterSunkScrew(width = holeDiameter);
                }
                else
                {
                    echo(holeDiameterCalc());
                    linear_extrude(wallThickness + 2)   //
                        circle(d =                      //
                               is_undef(holeDiameter)   //
                                   ? holeDiameterCalc() //
                                   : holeDiameter       //
                        );
                }
            }
        }
    }
}