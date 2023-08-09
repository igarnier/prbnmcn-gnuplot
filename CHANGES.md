## 0.0.5
- Remove calls to `Unix.fork`, making the library multicore-friendly
- Expose implementation of `rN` types as tuples of floats
- Breaking: remove `silent` optional argument
- Breaking: remove now useless `tupN` functions

## 0.0.4
- add `xrange, yrange, zrange` options
- Add `get_targets` to get all available terminal types.
- Fix error in README.md example (report by ego@anentropic.com)

## 0.0.3
- Add circle plots
- Add `exec_detach` target, allows to plot several windows.
- Add `silent` optional argument, allows to silence gnuplot errors

## 0.0.2
- Add facilities to specify xtics, ytics and ztics
- Set horizontal rather than vertical layout for `Line.line`
- Simple box plots
- Remove useless `plot_matrix` type
- Remove `plot` and labelled argument for `run`
- Add `tup_r2, tup_r3`

## 0.0.1
- First release
