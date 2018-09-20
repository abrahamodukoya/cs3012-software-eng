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
        pass


if __name__ == '__main__':
    unittest.main()
