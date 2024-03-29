library(jsonlite)
library(dotenv)
source("logger.R")
source("RFunction.R")

inputFileName = "App-Output Workflow_Instance_001__Movebank__2022-07-01_09-21-15.rds" #important to set to NULL for movebank-download
outputFileName = "output.rds"

args <- list()
#################################################################
########################### Arguments ###########################
# The data parameter will be added automatically if input data is available
# The name of the field in the vector must be exaclty the same as in the r function signature
# Example:
# rFunction = function(username, password)
# The paramter must look like:
#    args[["username"]] = "any-username"
#    args[["password"]] = "any-password"
load_dot_env(file='akoelzsch.env')

# Add your arguments of your r function here
args[["time_now"]] = "2021-11-25T12:00:00.000Z" #NULL
#args[["posi_lon"]] = NULL
#args[["posi_lat"]] = NULL
#args[["attribs"]] = c("location_lat","tag_voltage","ground_speed")
args[["time_dur"]] = 8
args[["stamen_key"]] = Sys.getenv("STADIA_API")

#################################################################
#################################################################
inputData <- NULL
if(!is.null(inputFileName) && inputFileName != "" && file.exists(inputFileName)) {
  cat("Loading file from", inputFileName, "\n")
  inputData <- readRDS(file = inputFileName)
} else {
  cat("Skip loading: no input File", "\n")
}

# Add the data paramter if input data is available
if (!is.null(inputData)) {
  args[["data"]] <- inputData
}

result <- tryCatch({
    do.call(rFunction, args)
  },
  error = function(e) { #if in RFunction.R some error are silenced, they come back here and break the app... (?)
    print(paste("ERROR: ", e))
    stop(e) # re-throw the exception
  }
)

if(!is.null(outputFileName) && outputFileName != "" && !is.null(result)) {
  cat("Storing file to", outputFileName, "\n")
  saveRDS(result, file = outputFileName)
} else {
  cat("Skip store result: no output File or result is missing", "\n")
}