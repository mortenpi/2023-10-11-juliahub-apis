using DataFrames, CSV

df = CSV.read(
    joinpath(@__DIR__, "SYB65_1_202209_Population-Surface-Area-and-Density.csv"), DataFrame;
    header = 2,
)
rename!(df, 1 => "RegionCode", 2 => "Area", 5 => "ValueString")
parse_un_float(s::AbstractString) = parse(Float64, replace(s, "," => ""))
transform!(df, "ValueString" => ByRow(parse_un_float) => :value)

SPLIT_DIR = joinpath(@__DIR__, "SYB65")
isdir(SPLIT_DIR) && rm(SPLIT_DIR, recursive=true)
mkdir(SPLIT_DIR)

for (gdf_keys, gdf) in pairs(groupby(df, [:Series, :Year]))
    series = replace(replace(gdf_keys.Series, " " => "-"), r"[^A-Za-z0-9-]" => "")
    year = gdf_keys.Year
    csv_path = joinpath(SPLIT_DIR, series, string(year, ".csv"))
    isdir(dirname(csv_path)) || mkdir(dirname(csv_path))
    @info "Writing: $(csv_path)" size(gdf)
    CSV.write(csv_path, gdf)
end
