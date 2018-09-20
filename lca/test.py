import unittest
from graph import Graph

class LCATest (unittest.TestCase):

    def test_create_graph(self):
        aGraph = Graph(5)
        self.assertEqual(len(aGraph.adjList), 5)


if __name__ == '__main__':
    unittest.main()
