counterSunkScrewDefaultHeadHeight = 4.15;
module counterSunkScrewHole(                        //
    length = 30,                                    //
    width = 2.2,                                    //
    headWidth = 8.1,                                //
    headHeight = counterSunkScrewDefaultHeadHeight, //
    cutoutAboveHeight = 10,                         //
    counterSinkHeight = undef,                      //
    // this is how round the screw is. Lower this number to
    // get faster renderings.
    grani = 32,     //
    reverse = undef //
)
{
    rotate([ 0, 180, 0 ])                          //
        counterSunkScrew(                          //
            length = length,                       //
            width = width,                         //
            headWidth = headWidth,                 //
            headHeight = headHeight,               //
            cutoutAboveHeight = cutoutAboveHeight, //
            counterSinkHeight = counterSinkHeight, //
            grani = grani,                         //
            reverse = reverse);
}

module counterSunkScrew(                            //
    length = 30,                                    //
    width = 2.2,                                    //
    headWidth = 8.1,                                //
    headHeight = counterSunkScrewDefaultHeadHeight, //
    cutoutAboveHeight = 10,                         //
    counterSinkHeight = undef,                      //
    // this is how round the screw is. Lower this number to
    // get faster renderings.
    grani = 32,     //
    reverse = undef //
)
{
    cutoutAbove = headWidth + 2;
    counterSinkHeightValue = counterSinkHeight == undef ? headHeight : counterSinkHeight;
    module unit()
    {
        translate([ 0, 0, -cutoutAboveHeight - 0.0000001 ]) //
            color("magenta")                                //
            cylinder(d1 = cutoutAbove, d2 = cutoutAbove, h = cutoutAboveHeight, $fn = grani);
        cutoutClearer = 0.01;
        translate([ 0, 0, -(cutoutClearer / 2) ])  //
            color("green")                         //
            linear_extrude(height = cutoutClearer) //
            circle(d = headWidth);
        color("red")                        //
            cylinder(                       //
                d1 = headWidth,             //
                d2 = width,                 //
                h = counterSinkHeightValue, //
                $fn = grani                 //
            );
        translate([ 0, 0, counterSinkHeightValue - cutoutClearer ]) //
            color("Chartreuse")                                     //
            cylinder(                                               //
                d1 = width,                                         //
                d2 = width,                                         //
                h = length,                                         //
                $fn = grani                                         //
            );
    }
    union()
    {
        if (reverse == "reverse")
        {
            rotate([ 180, 0, 0 ])                                                             //
                translate([ 0, 0, -(counterSinkHeightValue + (length - cutoutAboveHeight)) ]) //
                unit();
        }
        else if (reverse == "flip" || reverse == true)
        {
            rotate([ 180, 0, 0 ]) //
                unit();
        }
        else
        {
            unit();
        }
    }
}