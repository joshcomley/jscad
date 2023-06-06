function sumList(list, start = 0, count = undef) =
    0 >= (is_undef(count) ? len(list) : count)
        ? (is_list(list[0]) ? [for (a = [0:len(list[0]) - 1]) 0] : 0)
    : start <= len(list) - 1
        ? list[start] + sumList(list, start + 1,
                                (is_undef(count) ? len(list) : count) - 1)
        : list[start];

function toXyPoints(relativePoints) = [for (i = [0:len(relativePoints) - 1])
        sumList(relativePoints, 0, i + 1)];