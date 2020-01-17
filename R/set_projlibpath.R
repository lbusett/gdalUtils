#' @title set_projlibpath
#' @description Function needed to avoid problems related to side effects upon loading
#'  of rgdal/sf on Windows systems with GDAL 3 installed (see https://github.com/r-spatial/discuss/issues/31)
#' @return The function is used for its side effects
#' @details The function automatically resets the PROJ_LIB environment variable to the 
#'  "correct" folder for a GDAL3 installation, and restores the previous value upon 
#'  exiting from the caller function. 
#' @rdname set_projlibpath

set_projlibpath <- function() {
    # reset properly the PROJ_LIB environment library
    if (substr(getOption("gdalUtils_gdalPath")[[1]]$version, 1, 1) >= 3 && Sys.info()[["sysname"]] == "Windows") {
        rgdal_projlibpath <- Sys.getenv("PROJ_LIB")
        projlib_path_ok <- file.path(dirname(getOption("gdalUtils_gdalPath")[[1]]$path), "share/proj")
        Sys.setenv("PROJ_LIB" =  projlib_path_ok)
        do.call(on.exit,
                list(substitute(Sys.setenv("PROJ_LIB"  = rgdal_projlibpath))),
                envir = parent.frame()
        )
    }
}
