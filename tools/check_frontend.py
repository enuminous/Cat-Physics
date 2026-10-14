#!/usr/bin/env python3
"""Optional explicit-sysroot checker for the pinned Lean 4.28.0 frontend.

Normal workflow: lake exe cache get; lake build. This helper is supplied to
reproduce the original local proof check when the stock Lean CLI cannot resolve
its own process path. It uses unmodified Lean libraries; it does not replace the
kernel, alter proof terms, or turn off checks. Dependencies/caches must exist.
"""
import argparse
import os
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
MODULES = ['CatPhysics.Harmonics', 'CatPhysics.Operators', 'CatPhysics.Compliance',
           'CatPhysics.Decision', 'CatPhysics.Boundaries', 'CatPhysics.Dynamics', 'CatPhysics']

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--sysroot', type=Path, required=True)
    args = p.parse_args()
    sysroot = args.sysroot.resolve()
    libs = [ROOT / '.lake/build/lib/lean']
    libs += [d / '.lake/build/lib/lean' for d in (ROOT / '.lake/packages').iterdir() if d.is_dir()]
    env = dict(os.environ, LEAN_PATH=os.pathsep.join(map(str, libs)))
    with tempfile.TemporaryDirectory(prefix='cat-physics-frontend-') as td:
        executable = Path(td) / 'frontend'
        subprocess.run(['cc', '-O2', '-I'+str(sysroot/'include'),
                        str(ROOT/'tools/lean_frontend.c'), '-L'+str(sysroot/'lib/lean'),
                        '-Wl,-rpath,'+str(sysroot/'lib/lean'), '-lleanshared', '-o',str(executable)], check=True)
        with (ROOT/'verification/build.log').open('w') as log:
            for module in MODULES:
                relative = module.replace('.', '/')
                source = ROOT / (relative+'.lean')
                output = ROOT / ('.lake/build/lib/lean/'+relative+'.olean')
                output.parent.mkdir(parents=True, exist_ok=True)
                proc = subprocess.run([str(executable), str(sysroot), str(source), module, str(output)],
                                      env=env,capture_output=True,text=True,cwd=ROOT)
                record = f'CHECK {module}: exit {proc.returncode}\n'+proc.stdout+proc.stderr
                print(record, end=''); log.write(record); log.flush()
                proc.check_returncode()
        subprocess.run(['python3',str(ROOT/'tools/audit.py'),'--generate'],check=True)
        proc = subprocess.run([str(executable),str(sysroot),str(ROOT/'CatPhysics/Audit.lean'),
                               'CatPhysics.Audit'],env=env,capture_output=True,text=True,cwd=ROOT)
        (ROOT/'verification/axioms.log').write_text(proc.stdout+proc.stderr)
        proc.check_returncode()
        subprocess.run(['python3',str(ROOT/'tools/audit.py'),'--check-log',
                        str(ROOT/'verification/axioms.log')],check=True)

if __name__ == '__main__': main()
