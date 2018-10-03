import queue

class Graph:

    def __init__(self, V):
        self.adjList = [[] for i in range(V)]
        self.V = V
        self.E = 0

    #adds a directed edge from u to v
    def add_edge(self, u, v):
        if not(u < 0 or u > self.V - 1 or v < 0 or v > self.V - 1):
            self.adjList[u].append(v)
            self.E = self.E + 1

    #TODO: currently if two paths of equal length from the root
    #to a node exist, only one of them is recorded, but the LCA
    #for two nodes could be in the other path. Fix
    #IDEA: run BFS from each of the nodes. Each BFS run gets its own
    #arrays. If x is marked when running BFS from y, then y is the LCA,
    #and vice-versa. Otherwise proceed as before
    def get_lca(self, root, x, y):
        xMarked = [False for v in range(self.V)]
        xDistTo = [0 for v in range(self.V)]
        xParent = [None for v in range(self.V)]
        self.bfs(x, xMarked, xDistTo, xParent)
        if xMarked[y]:
            return x

        yMarked = [False for v in range(self.V)]
        yDistTo = [0 for v in range(self.V)]
        yParent = [None for v in range(self.V)]
        self.bfs(y, yMarked, yDistTo, yParent)
        if yMarked[x]:
            return y

        rootMarked = [False for v in range(self.V)]
        rootDistTo = [0 for v in range(self.V)]
        rootParent = [None for v in range(self.V)]
        self.bfs(root, rootMarked, rootDistTo, rootParent)
        if not(rootMarked[x] or rootMarked[y]):
            return None
        #lowerV is the vertex deepest in the graph
        lowerV = y
        higherV = x
        if rootDistTo[x] > rootDistTo[y]:
            lowerV = x
            higherV = y
        depthDiff = rootDistTo[lowerV] - rootDistTo[higherV]
        while depthDiff > 0:
            lowerV = rootParent[lowerV]
            depthDiff = depthDiff - 1
        while lowerV != higherV:
            lowerV = rootParent[lowerV]
            higherV = rootParent[higherV]
        return lowerV

    def bfs(self, v, marked, distTo, parent):
        #caller should do the initialisation
        #marked = [False for v in range(self.V)]
        #distTo = [0 for v in range(self.V)]
        #parent = [None for v in range(self.V)]
        vertexQueue = queue.Queue()
        vertexQueue.put(v)
        marked[v] = True
        while not vertexQueue.empty():
            u = vertexQueue.get()
            for child in self.adjList[u]:
                if not marked[child]:
                    vertexQueue.put(child)
                    parent[child] = u
                    marked[child] = True
                    distTo[child] = 1 + distTo[u]
