// Generated by cpp11: do not edit by hand
// clang-format off


#include "cpp11/declarations.hpp"
#include <R_ext/Visibility.h>

// insideclipper.cpp
integers InPoly_clipper(doubles xx, doubles yy, doubles px, doubles py, doubles xyeps);
extern "C" SEXP _insideclipper_InPoly_clipper(SEXP xx, SEXP yy, SEXP px, SEXP py, SEXP xyeps) {
  BEGIN_CPP11
    return cpp11::as_sexp(InPoly_clipper(cpp11::as_cpp<cpp11::decay_t<doubles>>(xx), cpp11::as_cpp<cpp11::decay_t<doubles>>(yy), cpp11::as_cpp<cpp11::decay_t<doubles>>(px), cpp11::as_cpp<cpp11::decay_t<doubles>>(py), cpp11::as_cpp<cpp11::decay_t<doubles>>(xyeps)));
  END_CPP11
}
// insideclipper.cpp
list inside_loop_x_y(doubles xx, doubles yy, list lpx, list lpy, doubles xyeps);
extern "C" SEXP _insideclipper_inside_loop_x_y(SEXP xx, SEXP yy, SEXP lpx, SEXP lpy, SEXP xyeps) {
  BEGIN_CPP11
    return cpp11::as_sexp(inside_loop_x_y(cpp11::as_cpp<cpp11::decay_t<doubles>>(xx), cpp11::as_cpp<cpp11::decay_t<doubles>>(yy), cpp11::as_cpp<cpp11::decay_t<list>>(lpx), cpp11::as_cpp<cpp11::decay_t<list>>(lpy), cpp11::as_cpp<cpp11::decay_t<doubles>>(xyeps)));
  END_CPP11
}
// insideclipper.cpp
list inside_point_cull(doubles xx, doubles yy, list extents);
extern "C" SEXP _insideclipper_inside_point_cull(SEXP xx, SEXP yy, SEXP extents) {
  BEGIN_CPP11
    return cpp11::as_sexp(inside_point_cull(cpp11::as_cpp<cpp11::decay_t<doubles>>(xx), cpp11::as_cpp<cpp11::decay_t<doubles>>(yy), cpp11::as_cpp<cpp11::decay_t<list>>(extents)));
  END_CPP11
}
// insideclipper.cpp
list inside_loop_mat(doubles xx, doubles yy, list lpxy, doubles xyeps);
extern "C" SEXP _insideclipper_inside_loop_mat(SEXP xx, SEXP yy, SEXP lpxy, SEXP xyeps) {
  BEGIN_CPP11
    return cpp11::as_sexp(inside_loop_mat(cpp11::as_cpp<cpp11::decay_t<doubles>>(xx), cpp11::as_cpp<cpp11::decay_t<doubles>>(yy), cpp11::as_cpp<cpp11::decay_t<list>>(lpxy), cpp11::as_cpp<cpp11::decay_t<doubles>>(xyeps)));
  END_CPP11
}

extern "C" {
static const R_CallMethodDef CallEntries[] = {
    {"_insideclipper_InPoly_clipper",    (DL_FUNC) &_insideclipper_InPoly_clipper,    5},
    {"_insideclipper_inside_loop_mat",   (DL_FUNC) &_insideclipper_inside_loop_mat,   4},
    {"_insideclipper_inside_loop_x_y",   (DL_FUNC) &_insideclipper_inside_loop_x_y,   5},
    {"_insideclipper_inside_point_cull", (DL_FUNC) &_insideclipper_inside_point_cull, 3},
    {NULL, NULL, 0}
};
}

extern "C" attribute_visible void R_init_insideclipper(DllInfo* dll){
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);
}