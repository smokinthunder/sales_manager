# 🧪 Simple Testing

## **How to Test**

### **1. Start your app (in one terminal):**
```bash
docker-compose up -d
```

### **2. Run tests (in another terminal):**
```bash
cd backend
python run_tests.py
```

That's it! 🎉

## **What Happens**

- Tests run **inside the existing backend container**
- No new containers created
- All your existing tests are executed
- Results show in the terminal
- Exit code 0 = success, 1 = failure

## **Behind the Scenes**

The script simply runs:
```bash
docker-compose exec backend python -m pytest tests/ -v
```

## **Need to Debug?**

```bash
# Run tests with more output:
docker-compose exec backend python -m pytest tests/ -v -s

# Run specific test file:
docker-compose exec backend python -m pytest tests/api/v1/test_users.py -v

# Run specific test function:
docker-compose exec backend python -m pytest tests/api/v1/test_users.py::TestUserManagementAPI::test_create_user_success -v
```

---

**Super simple! 🚀**
