// helpful functions :)

pub fn euc_dist(x1: usize, x2: usize) usize {
    var dist: usize = 0;

    if (x1 > x2) {
        dist = x1 - x2;
    }
    if (x1 < x2) {
        dist = x2 - x1;
    } else dist = 0;

    return dist;
}
