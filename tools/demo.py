#!/usr/bin/env python3
"""Synthetic two-mode illustration of C1; no feline measurements are used.

Each step uses the closed-form exponential of a frozen real-symmetric 2x2
Hamiltonian. This is unitary up to floating-point error, but is only a temporal
approximation to the time-dependent ODE. Python tests are not Lean proofs.
"""
import argparse
import cmath
import json
import math
from pathlib import Path

ACTIONS = ('scratch', 'meow', 'stare', 'loaf', 'knockGlass')
BASE = ((0.7, 0.12), (0.12, -0.4))
HUMAN = ((0.2, 0.3), (0.3, 0.8))

def sigmoid(z):
    if z >= 0:
        return 1 / (1 + math.exp(-z))
    e = math.exp(z)
    return e / (1 + e)

def purr_power(t, amplitude=1.0, frequency=25.0, phase=0.0):
    return (amplitude * math.sin(2 * math.pi * frequency * t + phase)) ** 2

def frozen_step(psi, diagonal_a, off_diagonal, diagonal_d, dt):
    """Exact exp(-i dt H) for a real symmetric 2x2 H, at one frozen time."""
    center = (diagonal_a + diagonal_d) / 2
    split = (diagonal_a - diagonal_d) / 2
    radius = math.hypot(split, off_diagonal)
    c = math.cos(radius * dt)
    s = dt if radius == 0 else math.sin(radius * dt) / radius
    phase = cmath.exp(-1j * dt * center)
    x, y = psi
    return (phase * ((c - 1j * s * split) * x - 1j * s * off_diagonal * y),
            phase * (-1j * s * off_diagonal * x + (c + 1j * s * split) * y))

def expectation(psi, matrix):
    x, y = psi
    value = x.conjugate() * (matrix[0][0] * x + matrix[0][1] * y)
    value += y.conjugate() * (matrix[1][0] * x + matrix[1][1] * y)
    if abs(value.imag) > 1e-10:
        raise ValueError('Observable is not real to tolerance; inspect Hermiticity.')
    return value.real

def choose(scores):
    """First action in ACTIONS wins a tie; the source supplies no tie rule."""
    return max(ACTIONS, key=lambda a: scores[a])

def run(steps=400, dt=0.005):
    psi = (1 + 0j, 0j)
    rows, powers, yields = [], [], []
    max_error = 0.0
    for k in range(steps):
        t = k * dt
        power = purr_power(t + dt / 2)
        a = BASE[0][0] + 0.4 * power * HUMAN[0][0]
        b = BASE[0][1] + 0.4 * power * HUMAN[0][1]
        d = BASE[1][1] + 0.4 * power * HUMAN[1][1]
        psi = frozen_step(psi, a, b, d, dt)
        total = sum(abs(z) ** 2 for z in psi)
        max_error = max(max_error, abs(total - 1))
        y = expectation(psi, HUMAN)
        powers.append(power); yields.append(y)
        mean_p = sum(powers[-40:]) / len(powers[-40:])
        mean_y = sum(yields[-40:]) / len(yields[-40:])
        prob = sigmoid(-1 + 0.8 * mean_p + 1.2 * mean_y)
        if (k + 1) % 40 == 0:
            rows.append(dict(time=(k + 1) * dt, mode0_probability=abs(psi[0]) ** 2,
                mode1_probability=abs(psi[1]) ** 2, mean_purr_power=mean_p,
                mean_yield=mean_y, predicted_compliance=prob, state_power=total))
    treat = dict(zip(ACTIONS, [0.1, 0.8, 0.4, 0.2, 0.0]))
    status = dict(zip(ACTIONS, [0.2, 0.1, 0.3, 0.0, -0.5]))
    signals = dict(zip(ACTIONS, [-0.5, 0.4, 0.1, 0.2, -0.8]))
    scores = {a: treat[a] + 0.2 * status[a] + 0.6 * sigmoid(-1 + 0.8 * mean_p +
              1.2 * (mean_y + signals[a])) for a in ACTIONS}
    return dict(status='SYNTHETIC DEMONSTRATION; NOT FITTED OR EMPIRICALLY VALIDATED',
        modes=['mode0', 'mode1'], steps=steps, dt=dt,
        integrator='midpoint-frozen real-symmetric 2x2 exponential',
        coefficients=dict(intercept=-1, powerGain=0.8, yieldGain=1.2, gamma=0.4),
        max_norm_power_error=max_error, samples=rows, final_utility=scores,
        selected_action=choose(scores), tie_rule='first in ACTIONS')

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    result = run()
    rendered = json.dumps(result, indent=2) + '\n'
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(rendered)
    print(rendered)
