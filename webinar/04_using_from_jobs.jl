# # Using JuliaHub.jl in jobs
#
# Building on top of the APIs described in the previous step, we can build
# a more complex job that uses JuliaHub.jl _within_ the jobs to interact with
# the plaform.
#
# - Documentation: https://help.juliahub.com/julia-api/stable/
#

using JuliaHub
JuliaHub.authenticate("juliahub.com")

# A good way to submit more complex jobs is to submit them as "appbundles".
# This allows you to attach more files than just the Julia script to your job.
# See the documentation for `JuliaHub.appbundle` for more information.
#
# Note: this is a bit more complicated than it needs to be, because of the directory
# structure. We want to pick up the environment from the root of the repository,
# but this script is located in the webinar/ subdirectory. Hence the `dirname()`,
# and the path to the `analysis.jl` script, in turn, must be specified relative to
# the root of the appbundle.
#
# See the `jobs/analysis.jl` script to see what the job actually does.

appbundle = JuliaHub.appbundle(dirname(@__DIR__), "webinar/jobs/analysis.jl")

job = JuliaHub.submit_job(appbundle)
