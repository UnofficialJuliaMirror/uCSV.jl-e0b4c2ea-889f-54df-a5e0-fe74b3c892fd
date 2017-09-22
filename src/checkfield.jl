function checkfield(field, quotes::Char, escape::Char, trimwhitespace::Bool)
    isquoted = false
    inquotes = false
    escaped = false
    toskip = Vector{Int}(0)
    for (i, c) in enumerate(field)
        if escaped
            escaped = false
        elseif !inquotes
            if trimwhitespace && ismatch(r"\s", c)
                push!(toskip, i)
            elseif c == quotes
                inquotes = true
                isquoted = true
                push!(toskip, i)
            elseif c == escape
                escaped = true
                push!(toskip, i)
            else
               continue
            end
        else    # inquotes
            if c == quotes
                if quotes != escape || length(find(c -> c == quotes, field[chr2ind(field,i):end])) == 1
                    inquotes = false
                    push!(toskip, i)
                else
                    escaped = true
                    push!(toskip, i)
                end
            elseif c == escape
                escaped = true
                push!(toskip, i)
            else
               continue
            end
        end
    end
    return inquotes, escaped, toskip, isquoted
end

function checkfield(field, quotes::Char, escape::Null, trimwhitespace::Bool)
    isquoted = false
    inquotes = false
    escaped = false
    toskip = Vector{Int}(0)
    for (i, c) in enumerate(field)
        if !inquotes
            if trimwhitespace && ismatch(r"\s", c)
                push!(toskip, i)
            elseif c == quotes
                inquotes = true
                isquoted = true
                push!(toskip, i)
            else
               continue
            end
        else    # inquotes
            if c == quotes
                inquotes = false
                push!(toskip, i)
            else
               continue
            end
        end
    end
    return inquotes, escaped, toskip, isquoted
end

function checkfield(field, quotes::Null, escape::Char, trimwhitespace::Bool)
    isquoted = false
    inquotes = false
    escaped = false
    toskip = Vector{Int}(0)
    for (i, c) in enumerate(field)
        if escaped
            escaped = false
        elseif c == escape
            escaped = true
            push!(toskip, i)
        elseif trimwhitespace && ismatch(r"\s", c)
            push!(toskip, i)
        else
            continue
        end
    end
    return inquotes, escaped, toskip, isquoted
end

function checkfield(field, quotes::Null, escape::Null, trimwhitespace::Bool)
    isquoted = false
    inquotes = false
    escaped = false
    toskip = Vector{Int}(0)
    if trimwhitespace
        for (i, c) in enumerate(field)
            if ismatch(r"\s", c)
                push!(toskip, i)
            else
               continue
            end
        end
    end
    return inquotes, escaped, toskip, isquoted
end