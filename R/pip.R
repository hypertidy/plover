#' Title
#'
#' @param pts
#' @param coords
#'
#' @return
#' @export
#'
#' @examples
inside_clipper <- function(pts, coords) {
  InPoly_clipper(pts[,1], pts[,2], coords[,1], coords[,2])
}
