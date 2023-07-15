@testitem "TableShowUtils" begin
    using DataValues, Dates

    source = [(a=1,b="A"),(a=2,b="B")]

    @test sprint(TableShowUtils.printtable, source, "foo file") == """
    2x2 foo file
    a │ b
    ──┼──
    1 │ A
    2 │ B"""

    @test sprint(TableShowUtils.printHTMLtable, source) == """
    <table><thead><tr><th>a</th><th>b</th></tr></thead><tbody><tr><td>1</td><td>&quot;A&quot;</td></tr><tr><td>2</td><td>&quot;B&quot;</td></tr></tbody></table>"""

    @test sprint((stream) -> TableShowUtils.printtable(stream, source, "foo file", force_unknown_rows = true)) == "?x2 foo file\na │ b\n──┼──\n1 │ A\n2 │ B\n... with more rows"

    source_with_many_columns = [(a0=1,b0=1,c0=1,a1=1,b1=1,c1=1,a2=1,b2=1,c2=1,a3=1,b3=1,c3=1,a4=1,b4=1,c4=1,a5=1,b5=1,c5=1,a6=1,b6=1,c6=1,a7=1,b7=1,c7=1,a8=1,b8=1,c8=1,a9=1,b9=1,c9=1,a10=1,b10=1,c10=1)]
    @test sprint(TableShowUtils.printtable, source_with_many_columns, "foo file") == "1x33 foo file\na0 │ b0 │ c0 │ a1 │ b1 │ c1 │ a2 │ b2 │ c2 │ a3 │ b3 │ c3 │ a4 │ b4 │ c4 │ a5\n───┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼────┼───\n1  │ 1  │ 1  │ 1  │ 1  │ 1  │ 1  │ 1  │ 1  │ 1  │ 1  │ 1  │ 1  │ 1  │ 1  │ 1 \n... with 17 more columns: b5, c5, a6, b6, c6, a7, b7, c7, a8, b8, c8, a9, b9, c9, a10, b10, c10"

    source_with_NA = [(a=1,b="A"),(a=2,b=NA)]
    @test sprint(TableShowUtils.printtable, source_with_NA, "foo file") == "2x2 foo file\na │ b  \n──┼────\n1 │ A  \n2 │ #NA"

    @test sprint((stream) -> TableShowUtils.printHTMLtable(stream, source, force_unknown_rows = true)) == "<table><thead><tr><th>a</th><th>b</th></tr></thead><tbody><tr><td>1</td><td>&quot;A&quot;</td></tr><tr><td>2</td><td>&quot;B&quot;</td></tr><tr><td>&vellip;</td><td>&vellip;</td></tr></tbody></table><p>... with more rows.</p>"

    @test sprint(TableShowUtils.printdataresource, source) == "{\"schema\":{\"fields\":[{\"name\":\"a\",\"type\":\"integer\"},{\"name\":\"b\",\"type\":\"string\"}]},\"data\":[{\"a\":1,\"b\":\"A\"},{\"a\":2,\"b\":\"B\"}]}"

    @test sprint(TableShowUtils.printdataresource, source_with_NA) == "{\"schema\":{\"fields\":[{\"name\":\"a\",\"type\":\"string\"},{\"name\":\"b\",\"type\":\"string\"}]},\"data\":[{\"a\":1,\"b\":\"A\"},{\"a\":2,\"b\":null}]}"

    @test TableShowUtils.julia_type_to_schema_type(AbstractFloat) == "number"
    @test TableShowUtils.julia_type_to_schema_type(Bool) == "boolean"
    @test TableShowUtils.julia_type_to_schema_type(Dates.Time) == "time"
    @test TableShowUtils.julia_type_to_schema_type(Dates.Date) == "date"
    @test TableShowUtils.julia_type_to_schema_type(Dates.DateTime) == "datetime"
    @test TableShowUtils.julia_type_to_schema_type(DataValues.DataValue{Integer}) == "integer"
end

@testitem "DateTime" begin
    using Dates, DataValues

    source = [(a=1,b=DateTime(2010, 5, 6)),(a=2,b=DateTime(2011, 5, 6))]

    @test sprint(TableShowUtils.printHTMLtable, source) == """
    <table><thead><tr><th>a</th><th>b</th></tr></thead><tbody><tr><td>1</td><td>2010-05-06T00:00:00</td></tr><tr><td>2</td><td>2011-05-06T00:00:00</td></tr></tbody></table>"""

    source2 = [(a=1,b=DataValue(DateTime(2010, 5, 6))),(a=2,b=NA)]

    @test sprint(TableShowUtils.printHTMLtable, source2) == """
    <table><thead><tr><th>a</th><th>b</th></tr></thead><tbody><tr><td>1</td><td>2010-05-06T00:00:00</td></tr><tr><td>2</td><td>#NA</td></tr></tbody></table>"""
end
