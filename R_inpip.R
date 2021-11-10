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

dp <- colourvalues::colour_values
id_ic <- ic_over(pts, pol)
plot(pts[!is.na(id_ic), ], col = dp(na.omit(id_ic)), pch = 19, cex = .2)
