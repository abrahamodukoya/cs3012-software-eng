class Graph:

    def __init__(self, V):
        self.adjList = [[] for i in range(V)]
        self.V = V
        self.E = 0

    #adds a directed edge from u to v
    def add_edge(self, u, v):
        self.adjList[u].append(v)
        self.E = self.E + 1
