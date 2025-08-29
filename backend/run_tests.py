#!/usr/bin/env python3
"""
Simple Test Runner for Sales Manager Backend.

Just run this script to test everything inside existing containers!
"""

import subprocess
import sys

def run_tests():
    """Run all tests inside the existing backend container."""
    print("🧪 Running all tests inside existing backend container...")
    
    try:
        # Run tests in the running backend container
        result = subprocess.run(
            "docker-compose exec backend python -m pytest tests/ -v",
            shell=True,
            check=True
        )
        print("✅ All tests passed!")
        return True
    except subprocess.CalledProcessError:
        print("❌ Some tests failed!")
        return False

if __name__ == "__main__":
    success = run_tests()
    sys.exit(0 if success else 1)
