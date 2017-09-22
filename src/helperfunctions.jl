function getintdict(arg::Vector, numcols::Int, colnames::Vector{String})
    @assert length(arg) == numcols
    return Dict(i => arg[i] for i in 1:length(arg))
end

function getintdict{T}(arg::Dict{String, T}, numcols::Int, colnames::Vector{String})
    @assert !isempty(colnames)
    return Dict(findfirst(colnames, k) => v for (k,v) in arg)
end

function getintdict{T}(arg::Dict{Int, T}, numcols::Int, colnames::Vector{String})
    return arg
end

function getintdict(arg, numcols::Int, colnames::Vector{String})
    return Dict(i => arg for i in 1:numcols)
end

function Base.parse(T::Type{String}, x)
    string(x)
end

function handlemalformed(expected::Int, observed::Int, currentline::Int, skipmalformed::Bool)
    if skipmalformed
        warn("""
             Parsed $observed fields on row $currentline. Expected $expected. Skipping...
             """)
    else
        error("""
              Parsed $observed fields on row $currentline. Expected $expected.
              Possible fixes may include:
                1. including $currentline in the `skiprows` argument
                2. setting `skipmalformed=true`
                3. if this line is a comment, set the `comment` argument
                4. fixing the malformed line in the source or file
              """)
    end
end

function _readline(source::IO, comment::Null)
    line = readline(source)
    while isempty(line) && !eof(source)
        line = readline(source)
    end
    return line
end

function _readline(source::IO, comment)
    line = readline(source)
    while startswith(line, comment) || isempty(line) && !eof(source)
        line = readline(source)
    end
    return line
end

function DataFrames.DataFrame(data, colnames::Vector{String})
    DataFrames.DataFrame(data, Symbol.(colnames))
end