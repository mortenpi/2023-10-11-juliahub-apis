using JuliaHubWebinarApp, JuliaHub
auth = JuliaHub.authenticate()
port = parse(Int, get(ENV, "PORT", "8000"))
JuliaHubWebinarApp.run(; port, auth)
