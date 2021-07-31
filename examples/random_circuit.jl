module RandomCircuit

using CircuitViz

g = Graph()

iter = 1 : 100
for k in iter
    add_vertex!(g)
end

prod = Iterators.product(iter, iter)
for (k, v) in prod
    if rand() > 0.99
        @info (k, v)
        add_edge!(g, k, v)
    end
end

compile!(g)

end # module
