#include <cpp11.hpp>
using namespace cpp11;

#include "clipper.h"

// fixme could be per dataset
// clipper only works with integers, so double values have to be multiplied by
// this amount before converting to int:
const long long mult = 1e6;


[[cpp11::register]]
integers InPoly_clipper(doubles xx, doubles yy, doubles px, doubles py, doubles extent) {

  ClipperLib::Path path;
  int n = xx.size();
  bool do_extent = extent.size() < 4;
  double pxmin, pxmax, pymin, pymax;

  if (do_extent) {
    pxmin = px[0];
    pxmax = px[0];
    pymin = py[0];
    pymax = py[0];
  } else {
    pxmin = extent[0];
    pxmax = extent[1];
    pymin = extent[2];
    pymax = extent[3];

  }
  for (size_t j = 0; j < px.size (); j++) {
    path << ClipperLib::IntPoint (round (px [j] * mult),
                                  round (py [j] * mult));
    if (do_extent) {
     pxmin = std::min(pxmin, px[j]);
     pxmax = std::max(pxmax, px[j]);
     pymin = std::min(pymin, py[j]);
     pymax = std::max(pymax, py[j]);
    }
  }

  writable::integers out(n);
  for (int j = 0; j < n; j++)
  {
    out[j] = 0;
    if (xx[j] >= pxmin & xx[j] <= pxmax & yy[j] >= pymin & yy[j] <= pymax) {
      const ClipperLib::IntPoint pj =
        ClipperLib::IntPoint (round (xx [j] * mult),
                              round (yy [j] * mult));
      int pip = ClipperLib::PointInPolygon (pj, path);
      if (pip != 0) {
        out[j] = 1;
      }
    }
  }
  return out;
}

// #include "cpp11/list.hpp"
//
//
// list inside_extentcull(doubles xx, doubles yy, list px, list py, list extents) {
//   for (int i = 0; i < px.size(); i++)  {
//
//
//     writable::writable pip(px.size());
//     for (int j = 0; j < xx.size(); j++) {
//       if (xx[j] >= extents(i)[0] & xx[j] <= extents(i)[1] & yy[j] >= extents(i)[2] & yy[j] <= extents(i)[3]) {
//
//       }
//     }
//   }
//
//   return out;
// }
