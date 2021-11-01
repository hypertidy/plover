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
