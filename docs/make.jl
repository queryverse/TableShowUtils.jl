using Documenter, TableShowUtils

makedocs(
	modules = [TableShowUtils],
	sitename = "TableShowUtils.jl",
	analytics="UA-132838790-1",
	pages = [
        "Introduction" => "index.md"
    ]
)

deploydocs(
    repo = "github.com/queryverse/TableShowUtils.jl.git"
)
