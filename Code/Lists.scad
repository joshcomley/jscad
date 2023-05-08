function sumList(list, start = 0, count = undef) =
    0 >= (is_undef(count) ? len(list) - 1 : count)
        ? [for (a = [0:len(list[0]) - 1]) 0]
    : start <= len(list) - 1
        ? list[start] + sumList(list, start + 1,
                                (is_undef(count) ? len(list) - 1 : count) - 1)
        : list[start];