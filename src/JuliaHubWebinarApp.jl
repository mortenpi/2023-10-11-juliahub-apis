module JuliaHubWebinarApp
using Dash
using Sockets
using JuliaHub

function run(; port, auth::JuliaHub.Authentication)
    @info "JuliaHubWebinarApp.run()" port auth

    # Fetch the list of datasets from JuliaHub.
    # TODO: this is only fetched once, when the app starts. Ideally we'd refresh this,
    # either on schedule or on some user input, like a button click.
    dss = JuliaHub.datasets(; shared=true, auth)

    app = dash()

    app.layout = html_div() do
        dataset_options = [
            Dict("value" => "$(ds.owner):$(ds.name)", "label" => "$(ds.owner) / $(ds.name)")
            for ds in dss
        ]
        html_h1("Dataset Size App"),
        html_div(
            children = [
                "Dataset: ",
                dcc_dropdown(id = "datasets", options = dataset_options)
            ],
        ),
        html_hr(),
        html_div(id = "dataset-information")
    end

    # This callback fires every time the user selects a new dataset in the dataset selector.
    # It then fetches the dataset information from JuliaHub and shows it
    callback!(app, Output("dataset-information", "children"), Input("datasets", "value")) do value
        if isnothing(value)
            return "Dataset not selected"
        end
        owner, dataset = split(value, ":")
        ds = JuliaHub.dataset((owner, dataset))
        @show ds
        names_and_values = [("v$(v.id) ($(v.timestamp))", v.size) for v in ds.versions]
        labels, values = zip(names_and_values...)
        versions_pie = dcc_graph(
            id = "dataset-version-sizes",
            figure = (
                data = [
                    (; labels, values, type = "pie", name = "SF")
                ],
                layout = (title = "Version sizes: $(owner) / $(dataset)",)
            )
        )
        (
            information_div("Dataset owner", ds.owner),
            information_div("Dataset name ", ds.name),
            information_div("Total size (bytes)", ds.size),
            versions_pie
        )
    end

    # Note: if we run in debug mode on JuliaHub, we need to disable the hot reload feature.
    run_server(app, "0.0.0.0", port; debug=true, dev_tools_hot_reload=false)
end

information_div(key, value) = html_div(; children = [
    html_strong(; children = [string(key) * ":"]),
    " ",
    string(value)
])

end
