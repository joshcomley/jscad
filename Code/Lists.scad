function sumListCountOrLength(                                //
    list,                                                     //
    startIndex,                                               //
    count                                                     //
    ) =                                                       //
    is_undef(count) || count > ((len(list) - startIndex) - 1) //
        ? len(list) - startIndex                              //
        : count;

function sumList2(list, startIndex = 0,
                  endIndex = undef) = 0 >= sumListCountOrLength(list, endIndex)
                                          ? (is_list(list[0]) ? [for (a = [0:len(list[0]) - 1]) 0] : 0)
                                      : startIndex <= len(list) - 1
                                          ? list[startIndex] +
                                                sumList(list, startIndex + 1, sumListCountOrLength(list, endIndex) - 1)
                                          : list[startIndex];

function valueOrFirstValue(list) = [for (a = [0:len(list) - 1]) //
                                        is_list(list[a])
                                        ? list[a][0]
                                        : list[a]];
function sumList(list, start = 0, count = undef) = //
    sumListInternal(list, start, sumListCountOrLength(list, start, count));

function sumListInternal(list, start = 0,
                         count = undef) = //
    count <= 0 ?                          //
        (                                 //
            is_list(list[0])              //
                ? [for (a = [0:len(list[0]) - 1]) 0]
                : 0 //
            )
               : start < len(list) - 1 //
                     ?                 //
                     list[start] +     //
                         sumList(list, start + 1, count - 1)
                     : list[start];

function restoreZ(list, source, i) = //
    source[i][2] == undef ?          //
        [ list[0], list[1] ]         //
                          : [ list[0], list[1], source[i][2] ];
function toXyPoints(relativePoints) =      //
    [for (i = [0:len(relativePoints) - 1]) //
        restoreZ(sumList(relativePoints, 0, i + 1), relativePoints, i)];

function indexOfFirstValueGreaterThanOrEqualTo(arr, val) = //
    [for (i = [0:len(arr) - 1]) if (arr[i] >= val) i][0];