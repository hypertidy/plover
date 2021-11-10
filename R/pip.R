
#' Inside with clipper lib
#'
#' Call the clipper lib ...
#'
#' WIP
#' @param pts matrix of points 2 columns x,y
#' @param coords matrix of polygon ring 2 columns x,y
#' @param extent optional extents (WIP)
#'
#' @return integer vector of point in polygon status, see Details
#' @export
#'
#' @examples
#' inside_clipper(matrix(runif(10), ncol = 2), cbind(c(0, .5, .5, 0, 0), c(0, 0, .5, 0, 0)))
inside_clipper <- function(pts, coords, extent = NULL) {
  if (is.null(extent)) {
    extent <- 0;
  }
  InPoly_clipper(pts[,1], pts[,2], coords[,1], coords[,2], extent)
}

#' Loop inside clipper polygon as vectors
#'
#' Loop cliper
#' @param pts matrix of points
#' @param coordsx list of vectors  polygon x
#' @param coordsy list of vectors polygon y
#'
#' @return list
#' @export
#'
#' @examples
#' inside_clipper_loop_x_y(matrix(runif(10), ncol = 2), list(c(0, .5, .5, 0, 0)),
#' list(c(0, 0, .5, 0, 0)))
inside_clipper_loop_x_y  <- function(pts, coordsx, coordsy) {
  inside_loop_x_y(pts[,1], pts[,2], coordsx, coordsy)
}

#' Loop inside clipper polygon as matrixes
#'
#' Loop clipper
#'
#' @param pts matrix of points
#' @param lcoords list of matrixes
#' @param xyeps offset x, offset y, precision
#'
#' @return list
#' @export
#'
#' @examples
#' inside_clipper_loop_mat(matrix(runif(10), ncol = 2),
#'  list(cbind(c(0, .5, .5, 0, 0), c(0, 0, .5, 0, 0))))
inside_clipper_loop_mat  <- function(pts, lcoords, xyeps = NULL) {
  inside_loop_mat(pts[,1], pts[,2], lcoords, xyeps = xyeps)
}
