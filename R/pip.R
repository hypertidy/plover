#' Title
#'
#' @param pts
#' @param coords
#'
#' @return
#' @export
#'
#' @examples
inside_clipper <- function(pts, coords, extent = NULL) {
  if (is.null(extent)) {
    extent <- 0;
  }
  InPoly_clipper(pts[,1], pts[,2], coords[,1], coords[,2], extent)
}

#' Title
#'
#' @param pts
#' @param coordsx
#' @param coordsy
#' @param extent
#'
#' @return
#' @export
#'
#' @examples
inside_clipper_loop_x_y  <- function(pts, coordsx, coordsy) {
  inside_loop_x_y(pts[,1], pts[,2], coordsx, coordsy)
}

#' Title
#'
#' @param pts
#' @param coordsx
#' @param coordsy
#' @param extent
#'
#' @return
#' @export
#'
#' @examples
inside_clipper_loop_mat  <- function(pts, lcoords) {
  inside_loop_mat(pts[,1], pts[,2], lcoords)
}
