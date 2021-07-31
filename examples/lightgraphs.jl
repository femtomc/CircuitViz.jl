module LightGraphConvert

using CircuitViz
using LightGraphs

g = SimpleDiGraph()
LightGraphs.add_vertex!(g)
LightGraphs.add_vertex!(g)
LightGraphs.add_vertex!(g)
LightGraphs.add_edge!(g, 1, 2)
LightGraphs.add_edge!(g, 1, 3)

new = CircuitViz.convert_to_catlab_graph(g)
compile!(new)

end # module
