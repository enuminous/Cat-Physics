import importlib.util
import math
from pathlib import Path
import unittest
spec = importlib.util.spec_from_file_location('demo', Path(__file__).resolve().parents[1] / 'tools/demo.py')
demo = importlib.util.module_from_spec(spec)
spec.loader.exec_module(demo)

class DemoChecks(unittest.TestCase):
    def test_unitary_evolution(self):
        result = demo.run(steps=2000)
        self.assertLess(result['max_norm_power_error'], 1e-10)
        for row in result['samples']:
            self.assertAlmostEqual(row['mode0_probability'] + row['mode1_probability'], 1, places=10)
            self.assertGreater(row['predicted_compliance'], 0)
            self.assertLess(row['predicted_compliance'], 1)
    def test_eigenstate_and_zero_hamiltonian(self):
        p = (0.6 + 0j, 0.8j)
        self.assertEqual(demo.frozen_step(p, 0, 0, 0, 0.1), p)
        q = demo.frozen_step((1 + 0j, 0j), 2, 0, 3, 0.2)
        self.assertAlmostEqual(abs(q[0]), 1)
        self.assertEqual(q[1], 0)
    def test_ties_and_negative_scores(self):
        self.assertEqual(demo.choose({a: -2 for a in demo.ACTIONS}), 'scratch')
        self.assertEqual(demo.choose(dict(zip(demo.ACTIONS, [-8, -2, -5, -4, -10]))), 'meow')
    def test_logistic_and_gain_direction(self):
        self.assertEqual(demo.sigmoid(0), 0.5)
        self.assertLess(demo.sigmoid(-2), demo.sigmoid(-1))
        self.assertGreater(demo.sigmoid(2), demo.sigmoid(1))
        self.assertAlmostEqual(demo.sigmoid(3) + demo.sigmoid(-3), 1)
        # IEEE floats may saturate at 0/1 for huge scores, unlike the real-valued Lean theorem.
        self.assertEqual(demo.sigmoid(1000), 1)
        self.assertEqual(demo.sigmoid(-1000), 0)
    def test_purr_power_and_sampling(self):
        samples = [demo.purr_power(k / 200) for k in range(200)]
        self.assertAlmostEqual(sum(samples) / len(samples), 0.5, places=12)
        self.assertTrue(all(0 <= x <= 1 for x in samples))
        self.assertAlmostEqual(demo.purr_power(0.01), demo.purr_power(0.01, amplitude=-1))
    def test_euler_counterexample(self):
        dt = 0.1
        self.assertAlmostEqual(abs(1 - 1j * dt) ** 2, 1 + dt ** 2)
        self.assertGreater(abs(1 - 1j * dt), 1)

if __name__ == '__main__':
    unittest.main()
