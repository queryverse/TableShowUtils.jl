using TableShowUtils
using NamedTuples
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

@testset "TableShowUtils" begin

source = [@NT(a=1,b="A"),@NT(a=2,b="B")]

@test sprint(TableShowUtils.printtable, source, "foo file") == """
2x2 foo file
a │ b
──┼──
1 │ A
2 │ B"""

@test sprint(TableShowUtils.printHTMLtable, source) == """
<table><thead><tr><th>a</th><th>b</th></tr></thead><tbody><tr><td>1</td><td>&quot;A&quot;</td></tr><tr><td>2</td><td>&quot;B&quot;</td></tr></tbody></table>"""

end
