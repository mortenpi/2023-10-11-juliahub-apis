# # Working with jobs
#
# JuliaHub.jl can be used to start and inspect jobs running on JuliaHub.
#
# - Guide: https://help.juliahub.com/julia-api/stable/guides/jobs/
# - References:
#   - https://help.juliahub.com/julia-api/stable/reference/job-submission/
#   - https://help.juliahub.com/julia-api/stable/reference/jobs/

using JuliaHub
JuliaHub.authenticate("juliahub.com")

# You can list all your jobs with `JuliaHub.jobs()`:

JuliaHub.jobs()

# ## Submitting jobs
#
# Submitting is very easy with the `JuliaHub.submit_job` function.
# The following is all you need to do submit a trivial Julia script that will
# get executed on JuliaHub:

job = JuliaHub.submit_job(
    JuliaHub.script"""
    using Pkg
    Pkg.status()
    """
)

# Note that the `@script_str` macro picks up the currently running environment
# (Project.toml/Manifest.toml) and attaches that to the job.
#
# You can also inspect particular jobs, download their outputs etc.

display(job)

display(job.files)

for job_file in job.files
    @show JuliaHub.download_job_file(job_file, tempname())
end

# You can run `JuliaHub.job()` to update the job status:

job = JuliaHub.job(job)

# Accessing job logs:

JuliaHub.job_logs(job)

# ## Configuring jobs
#
# `submit_job` takes various arguments that can be used to configure the job.
#
# E.g. to submit a distributed JuliaSim batch job on two nodes with (at least) 16 cores each,
# you can run the following:

JuliaHub.batchimages()

JuliaHub.batchimage("juliasim-batch")

# By adding the `noenv` suffix, you can stop JuliaHub.jl from picking up the current environment.
# This can be useful in some circumstances. E.g. in JuliaSim images, a lot of the packages you
# need are already included in the system image, and you might not need to install them.

script = JuliaHub.script"""
using Pkg
Pkg.status()
"""noenv

job = JuliaHub.submit_job(
    JuliaHub.BatchJob(script, image = JuliaHub.batchimage("juliasim-batch")),
    ncpu = 16, nnodes = 2
)
