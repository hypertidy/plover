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
inside_clipper_loop  <- function(pts, coordsx, coordsy, extent = NULL) {
  if (is.null(extent)) {
    extent <- replicate(length(coordsx), 0, simplify = FALSE);
  }
  inside_loop(pts[,1], pts[,2], coordsx, coordsy, extent)
}
