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
  // fixme mult isn't enough, need offset/scale for precision
  for (size_t j = 0; j < px.size (); j++) {
    path << ClipperLib::IntPoint (round (px [j] * mult),
                                  round (py [j] * mult));
  }
  writable::integers out; //(n);
  for (int j = 0; j < n; j++)
  {
    // we aren't doing point in box test here because it's faster to do as a set upfront and pass
    // in only those points here (because we do tests across sets of rings for even/odd)
      const ClipperLib::IntPoint pj =
        ClipperLib::IntPoint (round (xx [j] * mult),
                              round (yy [j] * mult));
      int pip = ClipperLib::PointInPolygon (pj, path);
      // we are return a test for every point because we then compare across sets of rings
      // for even/odd (so, could be sparse here too but needs unpacking outside)
      out.push_back(pip);
  }
  return out;
}

#include "cpp11/list.hpp"
#include "cpp11/matrix.hpp"

// list of coordinate vectors matches split(df$x, df$ring_id)
[[cpp11::register]]
list inside_loop_x_y(doubles xx, doubles yy, list lpx, list lpy) {
  writable::list out;

  for (int i = 0; i < lpx.size(); i++)  {
    doubles polyx = lpx[i];
    doubles polyy = lpy[i];
    out.push_back(InPoly_clipper(xx, yy, polyx, polyy));

  }
  return out;
}

[[cpp11::register]]
list inside_point_cull(doubles xx, doubles yy, list extents) {
  writable::list out;
  for (int i = 0; i < extents.size(); i++)  {
    writable::integers which;
    doubles ext = extents[i];
    for (int j = 0; j < xx.size(); j++) {
      if (xx[j] >= ext[0] && xx[j] <= ext[1] && yy[j] >= ext[2] && yy[j] <= ext[3]) {
        which.push_back(j + 1);
      }
    }
    out.push_back(which);
  }
  return out;
}

// list of matrix polygons matches POLYGON (or unlist(MULTIPOLYGON, recursive = F))
[[cpp11::register]]
list inside_loop_mat(doubles xx, doubles yy, list lpxy) {
  writable::list out;

  for (int i = 0; i < lpxy.size(); i++)  {


    writable::doubles polyx;
    writable::doubles polyy;

    cpp11::doubles_matrix<cpp11::by_column> mat = lpxy[i];
    for (int j = 0; j < mat.nrow(); j++){
     polyx.push_back(mat(j, 0));
     polyy.push_back(mat(j, 1));
    }


    out.push_back(InPoly_clipper(xx, yy, polyx, polyy));

  }
  return out;
}
