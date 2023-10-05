# # Working with datasets
#
# JuliaHub.jl allows you to programmatically work with datasets (e.g. listing, uploading,
# downloading, and updating them).
#
# - Guide: https://help.juliahub.com/julia-api/stable/guides/datasets/
# - Reference: https://help.juliahub.com/julia-api/stable/reference/datasets/

using JuliaHub
JuliaHub.authenticate("juliahub.com")

# ## Listing datasets
#
# As an example of the most basic operation, you can list the datasets on JuliaHub:

dataset_list = JuliaHub.datasets()

# If you pass `shared=true`, you can list all the dataset that have been shared with you
# (e.g. public datasets, datasets shared via projects etc.).

dataset_list = JuliaHub.datasets(; shared=true)

# You can perform bulk operations on datasets. See the docstring of `JuliaHub.Dataset`
# to see what information JuliaHub.jl exposes about each datasets.

for dataset in dataset_list
    @info "[$(dataset.uuid)] $(dataset.owner) / $(dataset.name): $(dataset.size) bytes"
end

# ## Uploading data
#
# The `JuliaHub.upload_dataset` can be used to upload data. For example, when uploading data
# from your local machine or cluster to JuliaHub. Or when uploading computational results
# as datasets (e.g. from jobs or IDEs).

JuliaHub.upload_dataset(
    "un-population-data",
    joinpath(@__DIR__, "datasets", "SYB65_1_202209_Population-Surface-Area-and-Density.csv"),
)

# If the dataset exists already, then by default JuliaHub.jl will not overwrite it.
# Calling the function again will lead to an error.
#
# However, JuliaHub datasets support versions, and you can as JuliaHub.jl to upload a
# new version if you want, by passing `update = true` to it:

JuliaHub.upload_dataset(
    "un-population-data",
    joinpath(@__DIR__, "datasets", "SYB65_1_202209_Population-Surface-Area-and-Density.csv"),
    update = true,
)

# !!! note
#
#     The UN data was downloaded from <http://data.un.org/Default.aspx>
#
# You can also upload directories, and they end up as `BlobTree` type datasets.
# Essentially, filesystem trees.

JuliaHub.upload_dataset(
    "un-population-data-split",
    joinpath(@__DIR__, "datasets", "SYB65"),
)

# ## Downloading data
#
# Of course, you can also download the data you have access to on JuliaHub:

JuliaHub.download_dataset("un-population-data", tempname())

# You can also download datasets that belong to other users that have been shared with you.
# For example, the following call downloads the JuliaSim tutorial data, which is shared
# as a public datasets on juliahub.com:

JuliaHub.download_dataset(
    ("juliasimtutorials", "ball_beam_data"),
    tempname()
)

# ## Deleting datasets

JuliaHub.delete_dataset("un-population-data")
JuliaHub.delete_dataset("un-population-data-split")

# ## Footnote: DataSets.jl
#
# JuliaHub IDEs and jobs also automatically integrate with the DataSets.jl, which
# provides a different, but convenient interface for accessing (but not writing)
# datasets:
#
# * https://github.com/JuliaComputing/DataSets.jl
# * https://help.juliahub.com/juliahub/stable/tutorials/datasets_intro/
# * https://help.juliahub.com/juliahub/stable/tutorials/datasets_advanced/
