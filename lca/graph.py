import queue

class Graph:

    def __init__(self, V):
        self.adjList = [[] for i in range(V)]
        self.V = V
        self.E = 0
        self.marked = [False for v in range(self.V)]
        self.distTo = [0 for v in range(self.V)]
        self.parent = [None for v in range(self.V)]

    #adds a directed edge from u to v
    def add_edge(self, u, v):
        if not(u < 0 or u > self.V - 1 or v < 0 or v > self.V - 1):
            self.adjList[u].append(v)
            self.E = self.E + 1

    #TODO: currently if two paths of equal length from the root
    #to a node exist, only one of them is recorded, but the LCA
    #for two nodes could be in the other path. Fix
    def get_lca(self, root, x, y):
        self.bfs(root)
        if not(self.marked[x] or self.marked[y]):
            return None
        #lowerV is the vertex deepest in the graph
        lowerV = y
        higherV = x
        if self.distTo[x] > self.distTo[y]:
            lowerV = x
            higherV = y
        depthDiff = self.distTo[lowerV] - self.distTo[higherV]
        while depthDiff > 0:
            lowerV = self.parent[lowerV]
            depthDiff = depthDiff - 1
        while lowerV != higherV:
            lowerV = self.parent[lowerV]
            higherV = self.parent[higherV]
        return lowerV

    def bfs(self, v):
        self.marked = [False for v in range(self.V)]
        self.distTo = [0 for v in range(self.V)]
        self.parent = [None for v in range(self.V)]
        vertexQueue = queue.Queue()
        vertexQueue.put(v)
        self.marked[v] = True
        while not vertexQueue.empty():
            u = vertexQueue.get()
            for child in self.adjList[u]:
                if not self.marked[child]:
                    vertexQueue.put(child)
                    self.parent[child] = u
                    self.marked[child] = True
                    self.distTo[child] = 1 + self.distTo[u]
