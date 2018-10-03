import unittest
from graph import Graph

class LCATest(unittest.TestCase):

    def setUp(self):
        self.graphSize = 10
        self.aGraph = Graph(self.graphSize)

    def test_create_graph(self):
        self.assertEqual(len(self.aGraph.adjList), self.graphSize)

    def test_add_edge(self):
        self.aGraph.add_edge(0, 1)
        self.assertEqual(self.aGraph.E, 1)
        self.assertEqual(self.aGraph.adjList[0], [1])

    def test_add_multiple_edges(self):
        self.aGraph.add_edge(0, 1)
        self.aGraph.add_edge(0, 2)
        self.aGraph.add_edge(3, 4)
        self.aGraph.add_edge(9, 1)
        self.aGraph.add_edge(6, 4)
        self.aGraph.add_edge(4, 6)
        self.assertEqual(self.aGraph.E, 6)
        adjList = [[] for x in range(self.graphSize)]
        adjList[0].append(1)
        adjList[0].append(2)
        adjList[3].append(4)
        adjList[9].append(1)
        adjList[6].append(4)
        adjList[4].append(6)
        self.assertEqual(self.aGraph.adjList, adjList)
        self.aGraph.add_edge(-2, 4)
        self.aGraph.add_edge(4, 23)
        self.assertEqual(self.aGraph.E, 6)
        self.assertEqual(self.aGraph.adjList, adjList)

    def test_bfs(self):
        root = 0
        self.aGraph.bfs(root)
        marked = [True] + [False for x in range(1, self.graphSize)]
        distTo = [0 for x in range(self.graphSize)]
        parent = [None for x in range(self.graphSize)]
        self.assertEqual(self.aGraph.marked, marked)
        self.assertEqual(self.aGraph.distTo, distTo)
        self.assertEqual(self.aGraph.parent, parent)

        self.aGraph.add_edge(0, 1)
        self.aGraph.bfs(root)
        marked[1] = True
        distTo[1] = 1
        parent[1] = 0
        self.assertEqual(self.aGraph.marked, marked)
        self.assertEqual(self.aGraph.distTo, distTo)
        self.assertEqual(self.aGraph.parent, parent)

        self.aGraph.add_edge(0, 2)
        self.aGraph.bfs(root)
        marked[2] = True
        distTo[2] = 1
        parent[2] = 0
        self.assertEqual(self.aGraph.marked, marked)
        self.assertEqual(self.aGraph.distTo, distTo)
        self.assertEqual(self.aGraph.parent, parent)

        self.aGraph.add_edge(2, 3)
        self.aGraph.bfs(root)
        marked[3] = True
        distTo[3] = 2
        parent[3] = 2
        self.assertEqual(self.aGraph.marked, marked)
        self.assertEqual(self.aGraph.distTo, distTo)
        self.assertEqual(self.aGraph.parent, parent)

        self.aGraph.add_edge(3, 4)
        self.aGraph.bfs(root)
        marked[4] = True
        distTo[4] = 3
        parent[4] = 3
        self.assertEqual(self.aGraph.marked, marked)
        self.assertEqual(self.aGraph.distTo, distTo)
        self.assertEqual(self.aGraph.parent, parent)

        self.aGraph.add_edge(1, 5)
        self.aGraph.bfs(root)
        marked[5] = True
        distTo[5] = 2
        parent[5] = 1
        self.assertEqual(self.aGraph.marked, marked)
        self.assertEqual(self.aGraph.distTo, distTo)
        self.assertEqual(self.aGraph.parent, parent)

        self.aGraph.add_edge(4, 5)
        self.aGraph.bfs(root)
        self.assertEqual(self.aGraph.marked, marked)
        self.assertEqual(self.aGraph.distTo, distTo)
        self.assertEqual(self.aGraph.parent, parent)

    def test_get_lca(self):
        self.assertEqual(None, self.aGraph.get_lca(0, 1, 2))
        self.aGraph.add_edge(0, 1)
        self.aGraph.add_edge(0, 2)
        self.assertEqual(0, self.aGraph.get_lca(0, 1, 2))
        self.aGraph.add_edge(1, 3)
        self.aGraph.add_edge(1, 4)
        self.aGraph.add_edge(4, 6)
        self.aGraph.add_edge(4, 7)
        self.aGraph.add_edge(3, 5)
        self.aGraph.add_edge(5, 8)
        self.aGraph.add_edge(8, 9)
        self.assertEqual(1, self.aGraph.get_lca(0, 9, 7))
        self.assertEqual(0, self.aGraph.get_lca(0, 6, 2))
        self.assertEqual(5, self.aGraph.get_lca(0, 5, 8))
        self.assertEqual(0, self.aGraph.get_lca(0, 0, 1))
        self.assertEqual(9, self.aGraph.get_lca(0, 9, 9))

    def test_get_dag_lca(self):
        self.aGraph.add_edge(0, 1)
        self.aGraph.add_edge(0, 2)
        self.aGraph.add_edge(1, 3)
        self.aGraph.add_edge(2, 3)
        self.aGraph.add_edge(3, 4)
        self.assertEqual(1, self.aGraph.get_lca(0, 4, 1))

if __name__ == '__main__':
    unittest.main()
