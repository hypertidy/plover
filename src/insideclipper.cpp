#include <cpp11.hpp>
using namespace cpp11;

#include "clipper.h"

// fixme could be per dataset
// clipper only works with integers, so double values have to be multiplied by
// this amount before converting to int:
const long long mult = 1e6;


[[cpp11::register]]
integers InPoly_clipper(doubles xx, doubles yy, doubles px, doubles py) {

  ClipperLib::Path path;
  int n = xx.size();
  for (size_t j = 0; j < px.size (); j++) {
    path << ClipperLib::IntPoint (round (px [j] * mult),
                                  round (py [j] * mult));
  }

  writable::integers out(n);
  for (int j = 0; j < n; j++)
  {
    const ClipperLib::IntPoint pj =
      ClipperLib::IntPoint (round (xx [j] * mult),
                            round (yy [j] * mult));

    int pip = ClipperLib::PointInPolygon (pj, path);
    //int pip = 0;
    if (pip != 0) {

    out[j] = 1;
    } else {
      out[j] = 0;
    }
  }
  return out;
}
