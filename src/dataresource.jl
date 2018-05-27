using IteratorInterfaceExtensions, TableTraits, JSON, DataValues

export add_dataresource_mimi_type_to_type

Base.Multimedia.istextmime(::MIME{Symbol("application/vnd.dataresource+json")}) = true

julia_type_to_schema_type(::Type{T}) where {T<:AbstractFloat} = "number"
julia_type_to_schema_type(::Type{T}) where {T<:Integer} = "integer"
julia_type_to_schema_type(::Type{T}) where {T<:Bool} = "boolean"
julia_type_to_schema_type(::Type{T}) where {T<:Dates.Time} = "time"
julia_type_to_schema_type(::Type{T}) where {T<:Dates.Date} = "date"
julia_type_to_schema_type(::Type{T}) where {T<:Dates.DateTime} = "datetime"
julia_type_to_schema_type(::Type{T}) where {T<:AbstractString} = "string"
julia_type_to_schema_type(::Type{T}) where {S<:AbstractString, T<:DataValue{S}} = julia_type_to_schema_type(S)

function printdataresource(io::IO, source)
    col_names = String.(fieldnames(eltype(source)))
    col_types = [i for i in eltype(source).parameters]

    schema = Dict("fields" => [Dict("name"=>string(i[1]), "type"=>julia_type_to_schema_type(i[2])) for i in zip(col_names, col_types)])

    print(io, "{")
    JSON.print(io, "schema")
    print(io, ":")
    JSON.print(io,schema)
    print(io,",")
    JSON.print(io, "data")
    print(io, ":[")

    for (row_i, row) in enumerate(source)
        if row_i>1
            print(io, ",")
        end

        print(io, "{")
        for col in 1:length(col_names)
            if col>1
                print(io, ",")
            end
            JSON.print(io, col_names[col])
            print(io, ":")
            # TODO This is not type stable, should really unroll the loop in a generated function
            JSON.print(io, row[col])
        end
        print(io, "}")
    end

    print(io, "]}")
 end

function add_dataresource_mimi_type_to_type(t::Type)
    eval(quote
        function Base.show(io::IO, m::MIME"application/vnd.dataresource+json", x::$t)
            _show(io, x)
        end
    end)
end
