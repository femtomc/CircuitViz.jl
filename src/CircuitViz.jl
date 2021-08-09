module CircuitViz

using Catlab.WiringDiagrams
using Catlab.Graphs
using Catlab.Graphics: LeftToRight
import Catlab.Graphics.GraphvizGraphs: to_graphviz
using Catlab.Graphs
import Catlab.Graphs: PropertyGraph, add_vertex!, 
                      add_edge!, rem_vertex!,
                      rem_edge!
using Catlab.Graphics: Graphviz
using JSON
import Base: show

export Graph, add_vertex!, add_edge!, rem_vertex!, rem_edge!
export to_graphviz, render
export compile!, show!

function Graph()
    g = PropertyGraph{Any}()
    graph_attrs = Dict(
                       :rankdir => "LR",
                       :dpi => "288.0",
                       :nodesep => "0.15",
                       :pack => "true",
                       :ratio => "compress",
                      )
    node_attrs = Dict(
                      :fontname => "Courier",
                      :shape => "triangle",
                      :orientation => "30",
                      :penwidth => "3.0",
                     )
    edge_attrs = Dict(
                      :fontname => "Courier",
                      :labelangle => "25",
                      :labeldistance => "2",
                      :penwidth => "1.2",
                     )
    set_gprop!(g, :graph, graph_attrs)
    set_gprop!(g, :node, node_attrs)
    set_gprop!(g, :edge, edge_attrs)
    return g
end

function add_vertex!(g::PropertyGraph{T}) where T
    return add_vertex!(g, Dict{Symbol, T}())
end

function add_edge!(g::PropertyGraph{T}, src::Int, tg::Int) where T
    return add_edge!(g, src, tg, Dict{Symbol, T}())
end

function restrict_to_edges(g)
    vs = Set([])
    for v in Graphs.vertices(g)
        isempty(Graphs.inneighbors(g, v)) &&
        isempty(Graphs.outneighbors(g, v)) &&
        continue
        push!(vs, v)
    end
    return Graphs.induced_subgraph(g, vs)
end

function render(graph)
    g = to_graphviz(graph)
    return g
end

function compile!(graph; 
        base_path = "$(gensym("digraph"))",
        format = :png)
    dot_path = base_path * ".dot"
    output_path = base_path * ".$(format)"
    open(dot_path, "w") do io
        g = render(graph)
        Graphviz.pprint(io, g)
    end
    run(pipeline(`dot -Gdpi=288 -T$(format) $(dot_path)`, stdout=output_path))
end

end # module
