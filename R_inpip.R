sf_over <- function(pts, pol, sfh = TRUE) {
  colnames(pts) <- c("x", "y")
  dpts <- as.data.frame(pts)
  if (!sfh) {
    dpts <-   sf::st_as_sf(dpts, coords= c("x", "y"))}
  else {
    dpts <- sfheaders::sf_point(dpts, x = "x", y = "y")
  }


  ## sf still wins with st_contains()

  # id_sf_list <- sf::st_intersects(dpts, pol)
  # unlist(lapply(id_sf_list, \(.x) .x[1]))

  id_sf_list <- sf::st_contains(pol, dpts)
  isub <- rep(NA_integer_, dim(pts)[1L])
  gt0 <- lengths(id_sf_list) > 0
  element <- unlist(id_sf_list)
  id <- rep(seq_along(id_sf_list), lengths(id_sf_list))
  bad <- duplicated(element)
  isub[element[!bad]] <- id[!bad]
  isub
}



# pts <- geosphere::randomCoordinates(1e5)
# data("wrld_simpl", package = "maptools")
#  grd <- terra::rasterize(terra::vect(wrld_simpl), terra::rast(res = 4), "NAME")
#  pol <- sf::st_set_crs(spex::polygonize(raster::raster(grd)), NA)
# library(basf)
# plot(pol, col = palr::d_pal(pol$NAME), border = NA)


#ic_over(pts, pol)
pol <- sf::st_cast(sf::st_set_crs(silicate::inlandwaters, NA), "POLYGON")
ex <- sf::st_bbox(pol)[c(1, 3, 2, 4)]
n <- 5e5
pts <- cbind(runif(n, ex[1], ex[2]),
             runif(n, ex[3], ex[4]))

gpoly <- geos::as_geos_geometry(pol$geom)
gpts <- geos::geos_make_point(pts[,1], pts[,2])
geos_over <- function(pts, pol) {
  m <- geos::geos_contains_matrix( pol, pts)
  isub <- rep(NA_integer_, length(pts))
  gt0 <- lengths(m) > 0
  element <- unlist(m)
  id <- rep(seq_along(m), lengths(m))
  bad <- duplicated(element)
  isub[element[!bad]] <- id[!bad]
  isub
}
system.time(m <- geos_over(gpts, gpoly))
# rr <- raster::raster(raster::extent(ex), res = 5000)
#
# plot(setValues(rr, ic_over(coordinates(rr), pol)))

rbenchmark::benchmark(
#sp = id_sp <- sp::over(sp::SpatialPoints(pts), as(as_Spatial(pol), "SpatialPolygons")),
sf = id_sf <- sf_over(pts, pol, sfh = F),
ic = id_ic <- ic_over(pts, pol),
gs = id_gs <- geos_over(gpts, gpoly),
replications = 10)


#
#
# #pol0 <- sf::st_geometry(pol)
# #pol0 <- sf::st_sfc(silicate::sfzoo$polygon)
#
# dp <- colourvalues::colour_values
# id_ic <- ic_over(pts, pol)
# plot(pts[!is.na(id_ic), ], col = dp(na.omit(id_ic)), pch = 19, cex = .2)
