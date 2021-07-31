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
using LightGraphs: SimpleDiGraph, vertices, edges

export Graph, add_vertex!, add_edge!, rem_vertex!, rem_edge!
export to_graphviz, render
export compile!, show!

function Graph()
    g = PropertyGraph{Any}()
    graph_attrs = Dict(
                       :rankdir => "LR",
                       :dpi => "288.0",
                      )
    node_attrs = Dict(
                      :fontname => "Courier",
                      :shape => "triangle",
                      :orientation => "30",
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

function convert_to_catlab_graph(g::SimpleDiGraph)
    cgraph = Graph()
    for v in vertices(g)
        add_vertex!(cgraph)
    end
    for e in edges(g)
        src = e.src
        tg = e.dst
        add_edge!(cgraph, Int64(src), Int64(tg))
    end
    return cgraph
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
