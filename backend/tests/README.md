# 🧪 Test Framework for Sales Manager Backend

This directory contains comprehensive tests for the Sales Manager Backend application. The test framework is designed to be maintainable, extensible, and provide fast feedback during development.

## 📁 Directory Structure

```
tests/
├── __init__.py              # Test package initialization
├── conftest.py              # Pytest configuration and shared fixtures
├── README.md                # This file
├── api/                     # API endpoint tests
│   └── v1/                 # Version 1 API tests
│       └── test_users.py   # User Management API tests
├── services/                # Service layer tests
│   └── test_user_service.py # User Service tests
├── core/                    # Core functionality tests
├── utils/                   # Test utilities
│   └── auth_utils.py       # Authentication test utilities
└── data/                    # Test data fixtures
```

## 🚀 Quick Start

### 1. Install Test Dependencies

```bash
# Install test requirements
pip install -r requirements-test.txt

# Or use the test runner script
python run_tests.py --install-deps
```

### 2. Run Tests

```bash
# Run all tests
python run_tests.py

# Run specific module tests
python run_tests.py --module api

# Run with coverage
python run_tests.py --coverage

# Run only fast tests (unit tests)
python run_tests.py --fast

# Run live API tests
python run_tests.py --live
```

### 3. Alternative: Direct pytest

```bash
# Run all tests
pytest

# Run specific test file
pytest tests/api/v1/test_users.py

# Run with coverage
pytest --cov=app --cov-report=html
```

## 🧪 Test Types

### **Unit Tests** (`@pytest.mark.unit`)
- Test individual functions and methods
- Use mocks for external dependencies
- Fast execution
- Located in `tests/services/` and `tests/core/`

### **API Tests** (`@pytest.mark.api`)
- Test HTTP endpoints
- Use FastAPI TestClient
- Can run with mocks or live backend
- Located in `tests/api/`

### **Integration Tests** (`@pytest.mark.integration`)
- Test component interactions
- May use test database
- Slower execution
- Marked with `@pytest.mark.slow`

### **Live Tests** (`@pytest.mark.live`)
- Test against running backend
- Require Docker services to be running
- Use `@pytest.mark.live` marker

## 🎯 Test Categories

### **User Management Tests**
- ✅ User CRUD operations
- ✅ Profile management
- ✅ Approval workflow
- ✅ Role-based access control
- ✅ Authentication flows

### **Service Layer Tests**
- ✅ Business logic validation
- ✅ Authorization checks
- ✅ Error handling
- ✅ Data transformation

### **API Endpoint Tests**
- ✅ HTTP status codes
- ✅ Request/response validation
- ✅ Authentication requirements
- ✅ Permission checks

## 🔧 Test Configuration

### **Pytest Configuration** (`pytest.ini`)
- Test discovery patterns
- Markers definition
- Asyncio mode configuration
- Warning filters

### **Shared Fixtures** (`conftest.py`)
- Mock services
- Test data
- Database connections
- Authentication tokens

### **Test Utilities** (`tests/utils/`)
- Token generation
- Test data builders
- Common assertions
- Mock helpers

## 📊 Test Coverage

The test framework provides comprehensive coverage reporting:

```bash
# Generate coverage report
python run_tests.py --coverage

# View HTML coverage report
open htmlcov/index.html
```

## 🏷️ Test Markers

Use markers to categorize and selectively run tests:

```python
@pytest.mark.slow
def test_integration_with_database():
    """This test will be skipped with --fast flag."""
    pass

@pytest.mark.mock
def test_with_mocked_dependencies():
    """This test uses mocks."""
    pass

@pytest.mark.live
def test_live_api():
    """This test requires running backend."""
    pass
```

## 🚨 Running Tests in CI/CD

### **GitHub Actions Example**
```yaml
- name: Run Tests
  run: |
    pip install -r requirements-test.txt
    pytest --cov=app --cov-report=xml
    
- name: Upload Coverage
  uses: codecov/codecov-action@v3
  with:
    file: ./coverage.xml
```

### **Docker Testing**
```bash
# Run tests in Docker container
docker run --rm -v $(pwd):/app -w /app python:3.11 \
  pip install -r requirements-test.txt && pytest
```

## 📝 Adding New Tests

### **1. Create Test File**
```python
# tests/api/v1/test_new_feature.py
import pytest
from fastapi.testclient import TestClient

class TestNewFeature:
    def test_new_endpoint(self, client: TestClient):
        response = client.get("/api/v1/new-feature")
        assert response.status_code == 200
```

### **2. Add Test Markers**
```python
@pytest.mark.api
@pytest.mark.unit
def test_new_functionality():
    pass
```

### **3. Update Test Runner**
Add new test categories to `run_tests.py` if needed.

## 🔍 Debugging Tests

### **Verbose Output**
```bash
pytest -v -s --tb=long
```

### **Debug Specific Test**
```bash
pytest tests/api/v1/test_users.py::TestUserManagementAPI::test_create_user_success -v -s
```

### **Run Tests with Debugger**
```python
import pdb; pdb.set_trace()  # Add breakpoint in test
```

## 📈 Performance Testing

### **Benchmark Tests**
```python
@pytest.mark.benchmark
def test_user_creation_performance(benchmark):
    def create_user():
        # User creation logic
        pass
    
    result = benchmark(create_user)
    assert result.stats.mean < 0.1  # Should complete in < 100ms
```

## 🧹 Test Maintenance

### **Clean Test Artifacts**
```bash
python run_tests.py --clean
```

### **Update Test Dependencies**
```bash
pip install -r requirements-test.txt --upgrade
```

### **Regenerate Test Data**
```bash
# If using Faker for test data generation
python -c "from tests.utils.test_data import generate_test_data; generate_test_data()"
```

## 🤝 Contributing to Tests

### **Test Naming Conventions**
- Test files: `test_*.py`
- Test classes: `Test*`
- Test methods: `test_*`

### **Test Documentation**
- Each test should have a descriptive docstring
- Explain what is being tested and why
- Include examples for complex test scenarios

### **Test Data Management**
- Use fixtures for reusable test data
- Avoid hardcoded values
- Use factories for complex object creation

### **Mock Strategy**
- Mock external dependencies (databases, APIs)
- Use realistic mock data
- Test both success and failure scenarios

## 📚 Additional Resources

- [Pytest Documentation](https://docs.pytest.org/)
- [FastAPI Testing Guide](https://fastapi.tiangolo.com/tutorial/testing/)
- [Python Testing Best Practices](https://realpython.com/python-testing/)
- [Test-Driven Development](https://en.wikipedia.org/wiki/Test-driven_development)

## 🆘 Troubleshooting

### **Common Issues**

1. **Import Errors**: Ensure you're running from the `backend` directory
2. **Missing Dependencies**: Run `python run_tests.py --install-deps`
3. **Test Discovery Issues**: Check `pytest.ini` configuration
4. **Async Test Failures**: Verify `@pytest.mark.asyncio` decorators

### **Getting Help**

- Check test output for detailed error messages
- Use `-v` flag for verbose output
- Review `conftest.py` for fixture issues
- Check test markers and configuration

---

**Happy Testing! 🎉**
