# coords = structure(c(0.191915028329653, 0.242440023683676,
#                      0.435140005964137, 0.750039977007818, 0.794689972902072,
#                      0.569089993646897, 0.308240017633102, 0.191915028329653,
#                      0.303924266802157, 0.661208259237305, 0.7774331724391,
#                      0.725777655460525, 0.340513591328648, 0.179090100770599,
#                      0.224288678126852, 0.303924266802157), .Dim = c(8L, 2L
#                      ))
#
# pts <- structure(c(0.193090028221607, 0.134340033623905, 0.194265028113561,
#                    0.358765012987125, 0.527964997428506, 0.829939969660693, 0.896914963502072,
#                    0.146805402658989, 0.461043130945324, 0.74514847432749, 0.626771247918254,
#                    0.306076580009597, 0.187699353600361, 0.506241708301578), .Dim = c(7L,
#                                                                                       2L), .Dimnames = list(NULL, c("x", "y")))
#
#
#
# insideclipper:::InPoly_clipper(pts[,1], pts[,2], coords[,1], coords[,2], extent = 0)
#

data("wrld_simpl", package = "maptools")
sfx <- sf::st_as_sf(wrld_simpl)
df <- sfheaders::sf_to_df(sfx)
df$ring_id <- paste(df$multipolygon_id, df$polygon_id, df$linestring_id)


## query points
nn <- 3e3
pts <- cbind(runif(nn, min(df$x), max(df$x)),
             runif(nn, min(df$y), max(df$y)))

## list ofs
system.time({
# poly ring x,y
lpx <- unname(split(df$x, df$ring_id))
lpy <- unname(split(df$y, df$ring_id))
# ring range x,y
lxr <- lapply(lpx, range)
lyr <- lapply(lpy, range)
})

# #
# system.time({
# ## now we limit out pip test *internally*
# lpip <- vector('list', length(lpx))
# for (i in seq_along(lpx)) {
#
#    lpip [[i]] <-  insideclipper::inside_clipper(pts, cbind(lpx[[i]], lpy[[i]]), extent = c(lxr[[i]], lyr[[i]]))
#   #if (sum(lpip[[i]]) > 0) points(pts[lpip[[i]] > 0, , drop = FALSE], pch = ".")
#
# }
#
# })




## now in C++: pts, list of polygon rings, list of extents

lex <- lxr
for (i in seq_along(lex)) lex[[i]] <- c(lex[[i]], lyr[[i]])

system.time({
oo <- inside_clipper_loop(pts, lpx, lpy, lex)
})

wrld_simpl@proj4string@projargs[1] <- NA_character_
library(sp)
system.time(over(SpatialPoints(pts), as(wrld_simpl, "SpatialPolygons")))
