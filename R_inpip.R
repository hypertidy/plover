sf_over <- function(pts, pol) {
  colnames(pts) <- c("x", "y")
  dpts <- as.data.frame(pts)
  # dpts <-   sf::st_as_sf(dpts, coords= c("x", "y"))
  dpts <- sfheaders::sf_point(dpts, x = "x", y = "y")
  id_sf_list <- st_intersects(dpts, pol)
  unlist(lapply(id_sf_list, \(.x) .x[1]))
}


pts <- geosphere::randomCoordinates(1e5)
data("wrld_simpl", package = "maptools")
grd <- terra::rasterize(terra::vect(wrld_simpl), terra::rast(res = 4), "NAME")
pol <- sf::st_set_crs(spex::polygonize(raster::raster(grd)), NA)
library(basf)
plot(pol, col = palr::d_pal(pol$NAME), border = NA)


#ic_over(pts, pol)
pol <- st_cast(sf::st_set_crs(silicate::inlandwaters, NA), "POLYGON")
ex <- sf::st_bbox(pol)[c(1, 3, 2, 4)]
n <- 1e5
pts <- cbind(runif(n, ex[1], ex[2]),
             runif(n, ex[3], ex[4]))

# rr <- raster::raster(raster::extent(ex), res = 5000)
#
# plot(setValues(rr, ic_over(coordinates(rr), pol)))

rbenchmark::benchmark(
sp = id_sp <- sp::over(sp::SpatialPoints(pts), as(as_Spatial(pol), "SpatialPolygons")),
sf = id_sf <- sf_over(pts, pol),
ic = id_ic <- ic_over(pts, pol),
replications = 1)


#pol0 <- sf::st_geometry(pol)
#pol0 <- sf::st_sfc(silicate::sfzoo$polygon)
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

  isub <- rep(NA_integer_, dim(pts)[1L])
  gt0 <- lengths(idx) > 0
  element <- unlist(idx)
  id <- rep(seq_along(idx), lengths(idx))
  bad <- duplicated(element)
  isub[element[!bad]] <- id[!bad]
 isub
}

dp <- colourvalues::colour_values
id_ic <- ic_over(pts, pol)
plot(pts[!is.na(id_ic), ], col = dp(na.omit(id_ic)), pch = 19, cex = .2)
