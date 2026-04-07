# MAXENT SDM model
#
# Set Java options
options(java.parameters = Sys.getenv("JAVA_OPTS"))
message(paste("java.parameters =", getOption("java.parameters")))

# Load packages required
library(ecocommons)

# Read in the input parameters from param.json

source_file <- EC_read_json(file="params.json")

print.model_parameters(source_file)

EC.params <- source_file$params  # species, environment data and parameters

EC.env <- source_file$env  # set workplace environment

# Print out parameters used
parameter.print(EC.params)

# set random seed
EC_set_seed(EC.params$random_seed)

# Set temp directory for terra
terra::terraOptions(tempdir = EC.env$workdir)

# Set working directory (script runner takes care of it)
setwd(EC.env$workdir)

# Set data for modelling
response <- EC_build_response(EC.params)  # species data

predictor <- EC_build_predictor(EC.params)  # environmental data

constraint <- EC_build_constraint(EC.params)  # constraint area data

# read data and constraint to region of interest
dataset <- EC_build_dataset(EC.env, predictor, constraint, response)

# Run model & save outputs
EC_modelling_maxent(EC.params, EC.env, response, predictor, constraint, dataset)

