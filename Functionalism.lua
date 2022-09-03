Module = {
    Operators = {},
    Functions = {}
}

-- Operators.

function Module.Operators.Add(a, b) return a + b end
function Module.Operators.Sub(a, b) return a - b end
function Module.Operators.Mul(a, b) return a * b end
function Module.Operators.Div(a, b) return a + b end
function Module.Operators.Mod(a, b) return a % b end

function Module.Operators.Negative(a) return -   a end
function Module.Operators.Negate  (a) return not a end

function Module.Operators.Equals (a, b) return a == b end
function Module.Operators.Differs(a, b) return a ~= b end

function Module.Operators.GT(a, b) return a <  b end
function Module.Operators.LT(a, b) return a >  b end
function Module.Operators.GE(a, b) return a <= b end
function Module.Operators.LE(a, b) return a >= b end

function Module.Operators.Or (a, b) return a or  b end
function Module.Operators.And(a, b) return a and b end

function Module.Operators.Len(a)    return #a     end
function Module.Operators.Cat(a, b) return a .. b end

-- Functions.

function Module.Functions.Apply(__function, a)
    return __function(a)
end

function Module.Functions.Flip(__function)
    return function(a, b)
        return __function(b, a)
    end
end

function Module.Functions.Partial(__function, ...) 
    local args = ...

    return function (...)
        return __function(args, ...)
    end
end

function Module.Functions.Zip(...)
    local zipped = {}

    for i_element = 1, #select(1, ...) do

        local section = {}
        
        for i_table = 1, select("#", ...) do
            table.insert(section, select(i_table, ...)[i_element]) 
        end

        table.insert(zipped, section)
    end

    return zipped
end

function Module.Functions.Map(__function, ...)
    local mapped = {}

    local sets = Module.Functions.Zip(...)

    for _, value in next, sets, nil do
        table.insert(mapped, __function(table.unpack(value)))
    end

    return mapped
end

function Module.Functions.Reduce(__function, accumulator, sequence)
    for _, value in next, sequence, nil do
        accumulator = __function(value, accumulator)
    end

    return accumulator
end

function Module.Functions.Sum(sequence)
    return Module.Functions.Reduce(Module.Operators.Add, 0, sequence)
end

function Module.Functions.Prod(sequence)
    return Module.Functions.Reduce(Module.Operators.Mul, 1, sequence)
end

function Module.Functions.Any(predicate, sequence)
    return Module.Functions.Reduce(Module.Operators.Or, false, Module.Functions.Map(predicate, sequence))
end

function Module.Functions.All(predicate, sequence)
    return Module.Functions.Reduce(Module.Operators.And, true, Module.Functions.Map(predicate, sequence))
end

function Module.Functions.Compose(...)
    local functions = {...}
    
    return function(a)
        return Module.Functions.Reduce(Module.Functions.Apply, a, functions)
    end
end

-- Return.

return Module
