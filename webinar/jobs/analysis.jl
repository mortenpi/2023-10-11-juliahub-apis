# This job demonstrates a slightly non-trivial JuliaHub job workflow.
#
# The job will:
#
# 1. Download the `un-population-data` dataset and do some simple
#    data analysis on it (filtering data, renaming columns), and
#    finally re-casts the data into a different data frame that lists
#    the population and popluations density of each country (area)
#    for each year.
#
# 2. It then writes the new dataset to a CSV and uploads it to JuliaHub
#    as a new dataset with JuliaHub.jl. The generated dataset has a unique
#    name.
#
# 3. Then, again using JuliaHub.jl, it submits _another_ jobs, which
#    downloads the newly uploaded reduced data, and plots some figures
#    (see `plot/plot.jl` for details). It also communicates the name of the
#    new dataset via environment variables.
#
# 4. Finally, it sets some job outputs that will be visible in the UI and
#    finishes.

using DataFrames, CSV, JuliaHub, JSON
import Random

# As this will run on JuliaHub, we do not need to pass the instance
# name here.
let auth = JuliaHub.authenticate()
    @info "Authenticated with JuliaHub" auth
end

# Download the dataset and read it into a dataframe
df = let csv_file = tempname()
    JuliaHub.download_dataset("un-population-data", csv_file)
    CSV.read(csv_file, DataFrame; header = 2)
end

# Clean up the dataframe a little bit. The default column names are not that great.
rename!(df, 1 => "RegionCode", 2 => "Area", 5 => "ValueString")

# Convert the strings in the Value (now ValueString) column into floats.
parse_un_float(s::AbstractString) = parse(Float64, replace(s, "," => ""))
transform!(df, "ValueString" => ByRow(parse_un_float) => :Value)

# We'll produce a new table, where we have, for each area and year, the population
# and population density.
#
# We'll group the data by area and year, which means that within each group
# we will have one row for each _series_ (different data items). This helper
# function will pick out the particular series value from those rows.
function find_value(df, series)
    df = filter(t -> t.Series == series, df)
    if size(df, 1) == 1
        return df[1, :Value]
    elseif size(df, 1) == 0
        @warn "Value missing: $series" df
        return missing
    else
        error("More than one value: $series")
    end
end
populations = combine(groupby(df, [:Area, :Year])) do df
    population_density = find_value(df, "Population density")
    population = find_value(df, "Population mid-year estimates (millions)")
    (; population, population_density)
end

# We'll upload the "reduced" data as a JuliaHub dataset. We will generate
# a unique name every time, by appending a suffix.
dataset_suffix = Random.randstring(10)
dataset = let tmp = tempname()
    CSV.write(tmp, populations)
    dataset_name = "un-population-data-reduced-$(dataset_suffix)"
    JuliaHub.upload_dataset(dataset_name, tmp)
end
@info "Uploaded reduced population dataset" dataset

# Finally, we'll start up a "follow-up" job that
# This job is submitted with a different Manifest that add (somewhat heavy)
# plotting packages to the enviornment.
bundle = JuliaHub.appbundle(joinpath(pwd(), "webinar", "jobs", "plot"), "plot.jl")
# JuliaHub environments store the running job ID in an environement variable.
jobid = get(ENV, "JRUN_NAME", "<missing>")
job = JuliaHub.submit_job(
    bundle,
    alias = "Plotting follow-up to: $(jobid)",
    env = Dict("DATASET_NAME" => dataset.name)
)
@info "Submitted follow-up job" job

# We'll also store the ID of the follow-up job in the job outputs
ENV["RESULTS"] = JSON.json(Dict(
    "dataset_name" => dataset.name,
    "dataset_size" => dataset.size,
    "plot_job_id" => job.id,
))
