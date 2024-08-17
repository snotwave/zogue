const pow = @import("std").math.pow;
const sqrt = @import("std").math.sqrt;

pub fn euc_dist(x1: usize, x2: usize) usize {
    var dist: usize = 0;

    if (x1 > x2) {
        dist = x1 - x2;
    } else if (x1 < x2) {
        dist = x2 - x1;
    } else dist = 0;

    return dist;
}

pub fn cartesian_distance(x1: usize, y1: usize, x2: usize, y2: usize) usize {
    const dist = sqrt(pow(usize, euc_dist(y2, y1), 2) + pow(usize, euc_dist(x2, x1), 2));

    return dist;
}
