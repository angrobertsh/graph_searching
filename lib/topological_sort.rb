require_relative 'graph'

# Implementing topological sort using both Khan's and Tarian's algorithms

# Khan
def topological_sort(vertices)

  # # Determine the in-degree of each node.
  # in_degrees = []
  #
  # vertices.each do |vertex|
  #   in_degrees.push(vertex.in_edges.length)
  # end
  #
  # # Collect nodes with zero in-degree in a queue.
  # queue = []
  # in_degrees.each_with_index do |degree, idx|
  #   queue.push(vertices[idx]) if degree == 0
  # end
  #
  # deletelist = []
  # # While the queue is not empty:
  # while(queue.length != 0)
  #   # Pop node u from queue,
  #   u = queue.shift()
  #   # remove u from the graph,
  #   vertices.delete(u)
  #   # We maintain a list that records in which order the nodes are removed.
  #   deletelist.push(u)
  #   u.out_edges.each {|edge| edge.destroy!}
  #
  #   # check if there is a new node with in-degree zero (among the neighbors of u)
  #   in_degrees = []
  #   vertices.each do |vertex|
  #     in_degrees.push(vertex.in_edges.length)
  #   end
  #   # If yes, put that node into the queue.
  #   in_degrees.each_with_index do |degree, idx|
  #     queue.push(vertices[idx]) if (degree == 0) && (queue.include?(vertices[idx]) == false)
  #   end
  # end
  #
  # # If the queue is empty:
  # # if we removed all nodes from the graph, return the list
  # return deletelist if vertices == []
  #
  # # else we return an empty list that indicates that an order is not possible due to a cycle
  # return []

  #I tried but I don't understand what the spec is saying
  in_edge_counts = {}
  queue = []

  vertices.each do |v|
    in_edge_counts[v] = v.in_edges.count
    queue << v if v.in_edges.empty?
  end

  sorted_vertices = []

  until queue.empty?
    vertex = queue.shift
    sorted_vertices << vertex

    vertex.out_edges.each do |e|
      to_vertex = e.to_vertex

      in_edge_counts[to_vertex] -= 1
      queue << to_vertex if in_edge_counts[to_vertex] == 0
    end
  end

  sorted_vertices

  # The time complexity of this implementation is O(2v + 2e)

end



#tarjan

def t_sort_2(vertices)
  # An alternative algorithm for topological sorting is based on depth-first search.

  paths = []
  vertices.each_with_index do |vertex, idx|
    paths[idx] = get_paths(vertex, vertex)
  end

  retarray = []
  paths.each do |path|
    path.each do |vertex|
      retarray = visit(vertex, retarray)
    end
  end


end

def get_paths(current, original, returned = false)
  # The algorithm loops through each node of the graph, in an arbitrary order,
  if((returned && current == original) || current.out_edges == [])
    return []
  end
  # initiating a depth-first search that terminates when it hits any node that has already been visited
  # since the beginning of the topological sort or the node has no outgoing edges (i.e. a leaf node):
  current.out_edges.each do |out_edge|
    return [current].concat(get_paths(out_edge.to_vertex, original, true))
  end
end

def visit(vertex, retarray)
  # Each node n gets prepended to the output list L only after considering all other nodes which depend on n
  # (all descendants of n in the graph). Specifically, when the algorithm adds node n, we are guaranteed that all nodes
  # which depend on n are already in the output list L: they were added to L either by the recursive call to visit() which
  # ended before the call to visit n, or by a call to visit() which started even before the call to visit n.
  if retarray.include?(vertex) == false || vertex.out_edges == []
    retarray.push(vertex)
  end
  retarray
end
