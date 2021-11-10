#' insidclipper 'over(pts, polygons)' point in polygon lookup
#'
#' point in polygon
#' @param pts matrix of points
#' @param pol0 list of polygon matrices (or sf, sfc_M/POLYGON)
#' @param xyeps offset,precision (WIP)
#'
#' @return integer of polygon
#' @export
#'
#' @examples
#' ic_over(matrix(runif(10), ncol = 2), list(c(0, .5, .5, 0, 0)))
ic_over <- function(pts, pol0, xyeps = NULL) {
  if (inherits(pol0, "sf")) {
    pol0 <- pol0[[attr(pol0, "sf_column")]]
  }
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

  l <- inside_point_cull(pts[,1], pts[,2], bb)

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
                 icl <- inside_clipper_loop_mat(pts[ix, , drop = FALSE], ppi, xyeps = xyeps)
                  icl <- unlist(icl, use.names = FALSE)


                  idx[[.x]] <-  ix[rowSums(matrix(icl, nrow = length(ix)) > 0) %% 2 != 0]

  }

  isub <- rep(NA_integer_, dim(pts)[1L])
  gt0 <- lengths(idx) > 0
  element <- unlist(idx)
  id <- rep(seq_along(idx), lengths(idx))
  bad <- duplicated(element)

  isub[element[!bad]] <- id[!bad]
 isub
}
