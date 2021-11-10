#' Title
#'
#' @param pts
#' @param pol0
#' @param xyeps
#'
#' @return
#' @export
#'
#' @examples
ic_over <- function(pts, pol0, xyeps = NULL) {
  if (inherits(pol0, "sf")) {
    pol0 <- sf::st_geometry(pol0)
  }

  ##bb <- lapply(pol0, \(.x) unname(sf::st_bbox(.x))[c(1, 3, 2, 4)])
  bb <- lapply(pol0, \(.x) {
      rct <- wk::wk_bbox(.x)
     c(vctrs::field(rct, "xmin"), vctrs::field(rct, "xmax"), vctrs::field(rct, "ymin"), vctrs::field(rct, "ymax"))
  })

if (is.null(xyeps)) {
  rct <- wk::wk_bbox(pol0)
  xr <- c(vctrs::field(rct, "xmin"), vctrs::field(rct, "xmax"))
  yr <- c(vctrs::field(rct, "ymin"), vctrs::field(rct, "ymax"))
  xyeps <- c(mean(xr), mean(yr), max(diff(xr), diff(yr))/1e9)
}
  # xr <- lapply(bb, "[", c(1L, 2L))
  # yr <- lapply(bb, "[", c(3L, 4L))

  l <- insideclipper:::inside_point_cull(pts[,1], pts[,2], bb)


  # #ix <- lapply(pol, \(.x) which(rowSums(matrix(unlist(insideclipper:::inside_clipper_loop_mat(pts, .x), use.names = FALSE), nrow = dim(pts)[1L]) > 0) %% 2 != 0))

  idx <- vector("list", length(pol0))
  for (.x in seq_along(idx)) {
                  ix <- l[[.x]];
                  if (length(ix) < 1) next;
#                  browser()
                   if (inherits(pol0, "sfc_MULTIPOLYGON")) {
                    ppi <- unlist(pol0[[.x]], recursive = FALSE)
                   } else {
                    ppi <- pol0[[.x]]
                   }
                 icl <- insideclipper:::inside_clipper_loop_mat(pts[ix, , drop = FALSE], ppi, xyeps = xyeps)

                  icl <- unlist(icl, use.names = FALSE)

                  ix_test <- ix[rowSums(matrix(icl, nrow = length(ix)) > 0) %% 2 != 0]
                  idx[[.x]] <-  ix_test

  }

#browser()
  isub <- rep(NA_integer_, dim(pts)[1L])
  gt0 <- lengths(idx) > 0
  element <- unlist(idx)
  id <- rep(seq_along(idx), lengths(idx))
  bad <- duplicated(element)
  isub[element[!bad]] <- id[!bad]
 isub
}
