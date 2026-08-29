using Documenter, TableShowUtils

makedocs(
	modules = [TableShowUtils],
	sitename = "TableShowUtils.jl",
	format = Documenter.HTML(analytics = "UA-132838790-1"),
	warnonly = [:missing_docs],
	pages = [
        "Introduction" => "index.md"
    ]
)

deploydocs(
    repo = "github.com/queryverse/TableShowUtils.jl.git"
)
