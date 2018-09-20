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


if __name__ == '__main__':
    unittest.main()
