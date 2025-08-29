#!/usr/bin/env python3
"""
Docker-Based Test Runner for Sales Manager Backend.

This script runs tests within Docker containers, ensuring consistent
test environments and easy integration with CI/CD pipelines.
"""

import os
import sys
import subprocess
import argparse
from pathlib import Path


def run_docker_command(command: str, description: str = "") -> bool:
    """
    Run a Docker command and return success status.
    
    Args:
        command: Docker command to execute
        description: Description of what the command does
        
    Returns:
        True if command succeeded, False otherwise
    """
    if description:
        print(f"\n🔄 {description}")
    
    print(f"Running: {command}")
    
    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
        print("✅ Command executed successfully")
        if result.stdout:
            print(result.stdout)
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Command failed with exit code {e.returncode}")
        if e.stdout:
            print("STDOUT:", e.stdout)
        if e.stderr:
            print("STDERR:", e.stderr)
        return False


def check_docker_running() -> bool:
    """Check if Docker is running."""
    print("🔍 Checking Docker status...")
    
    try:
        result = subprocess.run("docker info", shell=True, capture_output=True, text=True)
        if result.returncode == 0:
            print("✅ Docker is running")
            return True
        else:
            print("❌ Docker is not running")
            return False
    except Exception as e:
        print(f"❌ Error checking Docker: {e}")
        return False


def check_docker_compose() -> bool:
    """Check if docker-compose is available."""
    print("🔍 Checking docker-compose availability...")
    
    try:
        result = subprocess.run("docker-compose --version", shell=True, capture_output=True, text=True)
        if result.returncode == 0:
            print("✅ docker-compose is available")
            return True
        else:
            print("❌ docker-compose is not available")
            return False
    except Exception as e:
        print(f"❌ Error checking docker-compose: {e}")
        return False


def run_tests_in_container(test_type: str = "all", coverage: bool = False, live: bool = False) -> bool:
    """
    Run tests in a Docker container.
    
    Args:
        test_type: Type of tests to run (all, api, services, core)
        coverage: Whether to run with coverage
        live: Whether to run live tests against running services
        
    Returns:
        True if tests passed, False otherwise
    """
    print(f"\n🧪 Running {test_type} tests in Docker container...")
    
    # Build the test command
    test_cmd = "python -m pytest"
    
    if test_type == "api":
        test_cmd += " tests/api/"
    elif test_type == "services":
        test_cmd += " tests/services/"
    elif test_type == "core":
        test_cmd += " tests/core/"
    else:
        test_cmd += " tests/"
    
    if coverage:
        test_cmd += " --cov=app --cov-report=html --cov-report=term-missing"
    
    if live:
        test_cmd += " -m live"
    
    test_cmd += " -v --tb=short"
    
    # Run tests in backend container
    docker_cmd = f"docker-compose exec -T backend {test_cmd}"
    
    return run_docker_command(docker_cmd, f"Running {test_type} tests")


def run_tests_with_docker_run(test_type: str = "all", coverage: bool = False) -> bool:
    """
    Run tests using docker run (standalone container).
    
    Args:
        test_type: Type of tests to run
        coverage: Whether to run with coverage
        
    Returns:
        True if tests passed, False otherwise
    """
    print(f"\n🧪 Running {test_type} tests in standalone Docker container...")
    
    # Build the test command
    test_cmd = "python -m pytest"
    
    if test_type == "api":
        test_cmd += " tests/api/"
    elif test_type == "services":
        test_cmd += " tests/services/"
    elif test_type == "core":
        test_cmd += " tests/core/"
    else:
        test_cmd += " tests/"
    
    if coverage:
        test_cmd += " --cov=app --cov-report=html --cov-report=term-missing"
    
    test_cmd += " -v --tb=short"
    
    # Create standalone test container
    docker_cmd = f"""docker run --rm \
        -v "$(pwd):/app" \
        -w /app \
        --network sales_manager_default \
        sales_manager_backend:latest \
        {test_cmd}"""
    
    return run_docker_command(docker_cmd, f"Running {test_type} tests in standalone container")


def run_live_tests() -> bool:
    """Run live tests against running Docker services."""
    print("\n🌐 Running live tests against running services...")
    
    # Check if services are running
    check_cmd = "docker-compose ps --services --filter status=running"
    
    try:
        result = subprocess.run(check_cmd, shell=True, capture_output=True, text=True)
        if result.returncode == 0 and "backend" in result.stdout:
            print("✅ Backend service is running")
        else:
            print("❌ Backend service is not running")
            print("Start services with: docker-compose up -d")
            return False
    except Exception as e:
        print(f"❌ Error checking services: {e}")
        return False
    
    # Run live tests
    return run_tests_in_container("all", coverage=False, live=True)


def run_tests_with_coverage() -> bool:
    """Run tests with coverage reporting."""
    print("\n📊 Running tests with coverage...")
    
    return run_tests_in_container("all", coverage=True, live=False)


def run_specific_module(module: str) -> bool:
    """Run tests for a specific module."""
    print(f"\n🧪 Running tests for module: {module}")
    
    return run_tests_in_container(module, coverage=False, live=False)


def build_test_image() -> bool:
    """Build the test Docker image."""
    print("\n🔨 Building test Docker image...")
    
    docker_cmd = "docker-compose build backend"
    return run_docker_command(docker_cmd, "Building backend image with test dependencies")


def install_test_dependencies() -> bool:
    """Install test dependencies in the running container."""
    print("\n📦 Installing test dependencies...")
    
    docker_cmd = "docker-compose exec -T backend pip install -r requirements-test.txt"
    return run_docker_command(docker_cmd, "Installing test dependencies")


def show_test_summary() -> bool:
    """Show summary of available tests."""
    print("\n📚 Test Summary")
    print("=" * 50)
    
    test_files = []
    for test_file in Path("tests").rglob("test_*.py"):
        test_files.append(str(test_file.relative_to("tests")))
    
    if test_files:
        print("Available test modules:")
        for test_file in sorted(test_files):
            print(f"  • {test_file}")
    else:
        print("No test files found in tests/ directory")
    
    print("\nDocker test commands:")
    print("  • docker-compose exec backend python -m pytest tests/ -v")
    print("  • docker-compose exec backend python -m pytest tests/api/ -v")
    print("  • docker-compose exec backend python -m pytest tests/services/ -v")
    
    return True


def clean_test_artifacts() -> bool:
    """Clean test artifacts from Docker containers."""
    print("\n🧹 Cleaning test artifacts...")
    
    commands = [
        "docker-compose exec -T backend python -m pytest --cache-clear",
        "docker-compose exec -T backend rm -rf .pytest_cache",
        "docker-compose exec -T backend rm -rf htmlcov",
        "docker-compose exec -T backend rm -f .coverage",
        "docker-compose exec -T backend rm -f test_report.html"
    ]
    
    success = True
    for cmd in commands:
        if not run_docker_command(cmd, f"Cleaning: {cmd}"):
            print(f"⚠️  Warning: Failed to clean {cmd}")
            success = False
    
    return success


def main():
    """Main function to handle command line arguments."""
    parser = argparse.ArgumentParser(
        description="Docker-Based Test Runner for Sales Manager Backend",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python run_tests_docker.py                    # Run all tests in Docker
  python run_tests_docker.py --module api       # Run API tests only
  python run_tests_docker.py --coverage         # Run with coverage
  python run_tests_docker.py --live            # Run live tests
  python run_tests_docker.py --standalone      # Use standalone container
  python run_tests_docker.py --build           # Build test image first
        """
    )
    
    parser.add_argument(
        "--module", "-m",
        choices=["all", "api", "services", "core"],
        default="all",
        help="Run tests for specific module (default: all)"
    )
    
    parser.add_argument(
        "--coverage", "-c",
        action="store_true",
        help="Run tests with coverage report"
    )
    
    parser.add_argument(
        "--live",
        action="store_true",
        help="Run live tests against running services"
    )
    
    parser.add_argument(
        "--standalone",
        action="store_true",
        help="Use standalone Docker container instead of docker-compose exec"
    )
    
    parser.add_argument(
        "--build",
        action="store_true",
        help="Build Docker image before running tests"
    )
    
    parser.add_argument(
        "--install-deps",
        action="store_true",
        help="Install test dependencies in running container"
    )
    
    parser.add_argument(
        "--summary",
        action="store_true",
        help="Show test summary"
    )
    
    parser.add_argument(
        "--clean",
        action="store_true",
        help="Clean test artifacts from containers"
    )
    
    args = parser.parse_args()
    
    # Check if we're in the right directory
    if not Path("tests").exists():
        print("❌ Error: tests/ directory not found")
        print("Make sure you're running this script from the backend directory")
        sys.exit(1)
    
    # Check Docker prerequisites
    if not check_docker_running():
        print("❌ Docker is not running. Please start Docker and try again.")
        sys.exit(1)
    
    if not check_docker_compose():
        print("❌ docker-compose is not available. Please install it and try again.")
        sys.exit(1)
    
    # Handle different options
    success = True
    
    if args.summary:
        show_test_summary()
        return
    
    if args.clean:
        clean_test_artifacts()
        return
    
    if args.build:
        if not build_test_image():
            sys.exit(1)
    
    if args.install_deps:
        if not install_test_dependencies():
            sys.exit(1)
    
    # Run tests based on arguments
    if args.live:
        success = run_live_tests()
    elif args.coverage:
        success = run_tests_with_coverage()
    elif args.module != "all":
        success = run_specific_module(args.module)
    else:
        # Default: run all tests
        if args.standalone:
            success = run_tests_with_docker_run("all", args.coverage)
        else:
            success = run_tests_in_container("all", args.coverage, False)
    
    # Final result
    if success:
        print("\n🎉 All test operations completed successfully!")
        sys.exit(0)
    else:
        print("\n💥 Some test operations failed!")
        sys.exit(1)


if __name__ == "__main__":
    main()

