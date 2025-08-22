# Technology Stack Documentation Report (Updated)

## Principles

- **Industry-Standard Modularization**: Clean Architecture (presentation/domain/data), feature-based modules, package reuse.
- **Three-Layer Deployment**: Client apps → Public API (FastAPI) → Private Data Layer (Middleware + MySQL).
- **Multi-Tenant by Design**: `tenant_id` on all entities; role + tenant scoping at every boundary.
- **Reusability**: White-label ready (branding, features, configs).

---

## Flutter Frontend

### Purpose
Cross-platform (mobile/desktop) Flutter app using **Clean Architecture + MVVM** to maximize separation of concerns, testability, and reuse.

### Key Packages
- **Riverpod** — state management & DI for ViewModels and use-cases.
- **flutter_secure_storage** — secure token storage.
- **dio** — HTTP client with interceptors (JWT attach/refresh, retry).
- **sms_autofill** — OTP auto-read (where supported).
- **pin_code_fields** — OTP input UX.
- **flutter_otp_timer** — OTP countdown via Riverpod providers.
- **freezed** — immutable models, sealed states.

### App Modular Structure (example)
/app
/core (theme, routing, env, errors)
/shared (widgets, utils)
/features
/auth (MVVM: screens, viewmodels, usecases, repos)
/shops
/routes
/visits
/analytics
/approvals
/data (DTOs, remote sources via dio)
/domain (entities, repositories, use-cases)
/presentation (screens, widgets)

markdown
Copy
Edit

### Environment Config
- `.env.dev`, `.env.staging`, `.env.prod` with base URLs, feature flags.
- Dev OTP: **user enters OTP shown in backend console logs**.

---

## FastAPI — Public API Layer

### Purpose
High-performance async gateway for clients. Enforces **auth, RBAC, validation, rate limits**, and calls the **Private Data Layer** over mTLS.

### Libraries
- **FastAPI**, **Pydantic** (v2), **Auth (JWT)**, **SQLModel** (for shared models if needed), **httpx/uvicorn**.
- **RBAC**: role + tenant claim checks per endpoint.
- **Background Tasks**: enqueue sync/ETL jobs.

### Modules
- `auth`, `users`, `tenants`, `territories`, `shops`, `routes`, `visits`, `analytics`, `approvals`, `files`, `sync`

### OTP & SMS
- **Prod**: use **in-house SMS** (AWS hosted).
- **Dev**: generate OTP and **log to console** (no SMS dispatch).

---

## Private Data Layer — Middleware Service

### Purpose
Resides with the production DB in a **private network**. Sole component permitted to perform DB operations in production.

### Responsibilities
- Repository/DAL using **SQLModel/SQLAlchemy** to MySQL.
- **ETL/Synchronization** with client’s Tally-like API (daily).
- Build/refresh **materialized analytics** tables.
- Strict **tenant scoping** and performance-cached reads.
- Exposes a **narrow internal API** (mTLS) to Public API Layer.

---

## MySQL Database

- Production DB lives **inside private network** (no external access).
- Every table includes `tenant_id`, audit columns (`created_at`, `created_by`, etc.).
- Indices on `(tenant_id, foreign_keys)` and time-series columns.
- Backup/restore (PITR), migrations (Alembic).

---

## Containerization & Environments

- **Docker**: dev parity via `docker-compose` (API, Data Layer, MySQL, mock client API).
- **CI/CD**: lint → tests → security scan → staged deploys.
- **Secrets**: Cloud Secret Manager (no secrets in env files).

---

## Analytics & Sync (Client Finance System)

- Daily pull from client API: **products, shops, orders, payments, outstandings**.
- Middleware normalizes & loads into reporting tables.
- No write-backs; analytics-only consumption in app.

---

## Security & Compliance

- JWT with role + tenant claims; short-lived access, refresh tokens.
- mTLS between layers; service accounts, least privilege.
- Full **audit logging** of admin actions, approvals, and data changes.
- **No hidden logins**. Use **break-glass** emergency access (time-bound, fully audited).

---

## Conclusion

This stack and structure ensure:
- Strict Clean Architecture and modularization,
- Three-layer isolation for production DB,
- Reusable, white-label capability,
- Secure OTP with in-house SMS (and console OTP in dev),
- Robust analytics via a controlled middleware and ETL pipeline.