# # 01: Connecting to JuliaHub
#
# To start using JuliaHub, you should install the package into your Julia environment
# and load the package.
#
# For more information, see the Authentication guide in the JuliaHub.jl documentation:
#
# <https://help.juliahub.com/julia-api/stable/guides/authentication/>

using JuliaHub

# To authenticate, you simply need to call `JuliaHub.authenticate`, pointing it
# to the correct JuliaHub instance. It will either pick up an existing token
# from your computer (`~/.julia/servers`), or it will prompt for interactive
# authentication.

auth = JuliaHub.authenticate("juliahub.com")

# If we call it again now, it should be able to find the local token:

auth = JuliaHub.authenticate("juliahub.com")

# In JuliaHub environments (jobs, IDEs), you don't have to specify the instance, as it
# is able to automatically figure it out for you.
#
# If you also want that experience locally, you can point the `JULIA_PKG_SERVER`
# environment variable to your JuliaHub instance.

ENV["JULIA_PKG_SERVER"] = "juliahub.com"
JuliaHub.authenticate()
