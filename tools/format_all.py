#! coding=utf-8
# Format all code files according to .clang-format
# @Author: Wenyi Tang
# @Email: wenyi.tang@intel.com

import argparse
import re
import subprocess
from pathlib import Path


def CollectFilesFromDir(path, recurse=False):
    """Glob all files (recursively) in the given path"""

    path = Path(path).absolute().resolve()
    if not path.exists():
        return None
    files = []
    for postfix in ('*.h', '*.hpp', '*.cc', '*.cpp', '*.c', '*.cxx'):
      if recurse:
          files += list(path.rglob(postfix))
      else:
          files += list(path.glob(postfix))
    return files


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('dir')
    parser.add_argument('--formatter', default='clang-format')
    parser.add_argument('--style', default='file')
    parser.add_argument('--exclude', nargs='*', default=[])
    param = parser.parse_args()

    def exclude_file(x):
        x = Path(x).resolve().absolute()
        if not x.exists():
            return False
        for expat in param.exclude:
            if re.findall(expat, str(x)):
                return False
        return True

    files = CollectFilesFromDir(param.dir, True)
    for f in filter(exclude_file, files):
        cmd = f"{param.formatter} -style={param.style} -i {str(f)}"
        cmd += " --fallback-style=google"
        subprocess.call(cmd, stdout=None, shell=True)
