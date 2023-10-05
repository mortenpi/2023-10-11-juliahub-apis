# APIs and Custom Julia Development on JuliaHub

> **Note** These resources were used in the [2023-10-11 JuliaHub webinar](https://info.juliahub.com/apis-and-custom-software-development-with-juliahub.jl).

This repository doubles as a package application that can be added to JuliaHub as a "My Application" and launched as a JuliaHub job.

As such, the Julia environment here (`Project.toml` & `Manifest.toml`) has all the dependencies to run both the webinar examples, but also the application.

The scripts demoed at the webinar are located in the `webinar/` directory.
The `src/` and `bin/` directories are only relevant for the demoed Dash application.

## Following along with the webinar

If you want to run the examples in the repository either during or after the webinar, you have two options:

* If you have Julia installed locally, you can clone or download this repository, and run the scripts on your local machine.

* You can also launch a "Julia IDE" on [juliahub.com](https://juliahub.com/) and run the scripts in the VS Code IDE session there.

## Other resources

* JuliaHub.jl manual and API reference: https://help.juliahub.com/julia-api/stable/
* JuliaHub documentation: https://help.juliahub.com/
* [JuliaHub VS Code extension](https://marketplace.visualstudio.com/items?itemName=JuliaComputing.juliahub) ([documentation](https://help.juliahub.com/juliahub/stable/tutorials/vscode_extension/))
