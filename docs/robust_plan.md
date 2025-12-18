 # Loomday Robustness Foundation Plan

## Overview

Build foundational architecture for a multi-backend, offline-first Flutter app that supports:
- **Backend modes**: Local-only, self-hosted, managed
- **Offline-first** with sync when connected
- **Pluggable authentication** with interface-based providers
- **All platforms**: iOS, Android, Web, Desktop

This groundwork prevents architectural debt that becomes painful to retrofit.

---

## Phase 1: Core Abstractions & Error Handling

**Goal**: Establish typed error handling and core abstractions that everything else builds on.

### 1.1 Result Type (Either Pattern)

Create a `Result<T, E>` type to replace raw exceptions throughout the app.

**Files to create:**
- `lib/core/types/result.dart` - Result<T, E> sealed class with Success/Failure
- `lib/core/types/unit.dart` - Unit type for void-returning Results
- `lib/core/errors/app_error.dart` - Base error hierarchy

```
lib/core/
├── types/
│   ├── result.dart          # Result<T, E> sealed class
│   └── unit.dart            # Unit type for void results
└── errors/
    ├── app_error.dart       # Base AppError + common subtypes
    ├── network_error.dart   # Connection, timeout, server errors
    ├── storage_error.dart   # Database, file system errors
    ├── auth_error.dart      # Authentication/authorization errors
    └── sync_error.dart      # Sync-specific errors
```

**Error hierarchy:**
```
AppError (sealed)
├── NetworkError (connection, timeout, serverError, unauthorized)
├── StorageError (notFound, corrupted, permissionDenied)
├── AuthError (invalidCredentials, tokenExpired, notAuthenticated)
├── SyncError (conflict, versionMismatch, offline)
└── ValidationError (field-level validation errors)
```

### 1.2 Async Result Extensions

Extend Result for async operations and Riverpod integration.

**File:** `lib/core/types/async_result.dart`
- `Future<Result<T, E>>` extensions
- `AsyncValue<T>` ↔ `Result<T, E>` conversions
- `guard()` function for wrapping throwable code

---

## Phase 2: Network Layer

**Goal**: HTTP client abstraction with interceptors, retry, caching, and offline queue.

### 2.1 HTTP Client Abstraction

Don't couple to Dio directly - create an interface.

**Files to create:**
```
lib/core/network/
├── http_client.dart         # Abstract HttpClient interface
├── http_request.dart        # Request model (method, path, headers, body)
├── http_response.dart       # Response model (status, headers, body)
├── dio_http_client.dart     # Dio implementation
├── interceptors/
│   ├── auth_interceptor.dart      # Adds auth headers
│   ├── logging_interceptor.dart   # Request/response logging
│   ├── retry_interceptor.dart     # Retry with backoff (uses existing RetryPolicy)
│   └── cache_interceptor.dart     # Response caching
├── offline_queue.dart       # Queue requests when offline
└── providers.dart           # Riverpod providers
```

**HttpClient interface:**
```dart
abstract class HttpClient {
  Future<Result<HttpResponse, NetworkError>> request(HttpRequest request);
  Future<Result<HttpResponse, NetworkError>> get(String path, {Map<String, dynamic>? query});
  Future<Result<HttpResponse, NetworkError>> post(String path, {Object? body});
  Future<Result<HttpResponse, NetworkError>> put(String path, {Object? body});
  Future<Result<HttpResponse, NetworkError>> delete(String path);
}
```

### 2.2 Connectivity Service

Monitor network status for offline-first behavior.

**Files:**
- `lib/core/network/connectivity_service.dart` - Stream<ConnectivityStatus>
- Uses `connectivity_plus` package

---

## Phase 3: Data Layer Architecture

**Goal**: Repository pattern with pluggable data sources supporting local-only, remote, or hybrid modes.

### 3.1 Data Source Abstraction

**Files to create:**
```
lib/core/data/
├── data_source.dart              # DataSource<T> interface
├── local_data_source.dart        # LocalDataSource base (database operations)
├── remote_data_source.dart       # RemoteDataSource base (API operations)
├── repository.dart               # Repository<T> base class
├── sync/
│   ├── syncable.dart             # Syncable mixin for entities
│   ├── sync_status.dart          # SyncStatus enum (synced, pending, conflict)
│   ├── sync_metadata.dart        # Timestamps, version, dirty flag
│   └── sync_engine.dart          # Coordinates sync operations
└── providers.dart
```

**DataSource interface:**
```dart
abstract class DataSource<T, Id> {
  Future<Result<T?, StorageError>> getById(Id id);
  Future<Result<List<T>, StorageError>> getAll();
  Future<Result<T, StorageError>> save(T entity);
  Future<Result<Unit, StorageError>> delete(Id id);
  Stream<List<T>> watch();  // Reactive updates
}
```

**Repository pattern:**
```dart
abstract class Repository<T, Id> {
  // Reads from local first (offline-first)
  Future<Result<T?, AppError>> getById(Id id);

  // Writes to local, queues for sync
  Future<Result<T, AppError>> save(T entity);

  // Sync operations
  Future<Result<Unit, SyncError>> sync();
  SyncStatus getSyncStatus(Id id);
}
```

### 3.2 Database Setup (Drift - Cross-Platform)

Local database for offline storage with full web support.

**Files:**
```
lib/core/database/
├── database.dart            # AppDatabase class
├── database.g.dart          # Generated
├── connection/
│   ├── connection.dart      # Platform-agnostic connection factory
│   ├── native.dart          # Mobile/Desktop SQLite
│   └── web.dart             # Web SQLite (sql.js WASM)
├── tables/                  # Table definitions
│   └── sync_metadata_table.dart
├── daos/                    # Data access objects
│   └── sync_metadata_dao.dart
├── converters/              # Type converters
│   └── datetime_converter.dart
└── migrations/              # Schema migrations
    └── migrations.dart
```

**Dependencies to add:**
```yaml
dependencies:
  drift: ^2.22.0
  path_provider: ^2.1.5
  path: ^1.9.0

  # Platform-specific SQLite
  sqlite3_flutter_libs: ^0.5.0  # Mobile/Desktop native

dev_dependencies:
  drift_dev: ^2.22.0
```

**Web setup (in web/index.html):**
```html
<script src="https://cdn.jsdelivr.net/npm/sql.js@1.11.0/dist/sql-wasm.min.js"></script>
```

**Platform-aware connection:**
```dart
// lib/core/database/connection/connection.dart
import 'native.dart' if (dart.library.html) 'web.dart' as impl;

QueryExecutor openConnection(String dbName) => impl.openConnection(dbName);
```

### 3.3 Entity Base Classes

**Files:**
```
lib/core/domain/
├── entity.dart              # Base Entity<Id> class
├── syncable_entity.dart     # Entity + sync metadata
└── value_object.dart        # Value object base
```

**Syncable entity:**
```dart
abstract class SyncableEntity<Id> extends Entity<Id> {
  SyncMetadata get syncMetadata;
  DateTime get createdAt;
  DateTime get updatedAt;
  int get version;  // Optimistic locking
}
```

---

## Phase 4: Backend Mode System

**Goal**: Pluggable backend that can switch between local-only, self-hosted, and managed modes.

### 4.1 Backend Provider Interface

**Files:**
```
lib/core/backend/
├── backend_mode.dart            # Enum: local, selfHosted, managed
├── backend_provider.dart        # Abstract interface
├── backend_config.dart          # Configuration per mode
├── providers/
│   ├── local_backend.dart       # Local-only (no network)
│   ├── self_hosted_backend.dart # Custom server URL
│   └── managed_backend.dart     # Official backend
└── providers.dart               # Riverpod provider with mode switching
```

**BackendProvider interface:**
```dart
abstract class BackendProvider {
  BackendMode get mode;
  bool get supportsSync;
  bool get supportsAuth;
  bool get supportsRealtime;

  HttpClient? get httpClient;  // null for local-only
  AuthProvider? get authProvider;
  SyncEngine? get syncEngine;

  Future<Result<Unit, AppError>> initialize();
  Future<void> dispose();
}
```

### 4.2 Backend-Aware Repositories

Repositories that adapt behavior based on backend mode.

```dart
class TaskRepository extends Repository<Task, String> {
  TaskRepository(this._backend, this._localSource);

  final BackendProvider _backend;
  final LocalDataSource<Task, String> _localSource;

  @override
  Future<Result<Task, AppError>> save(Task task) async {
    // Always save locally first
    final localResult = await _localSource.save(task);

    // If backend supports sync, queue for sync
    if (_backend.supportsSync) {
      await _backend.syncEngine?.queueForSync(task);
    }

    return localResult;
  }
}
```

---

## Phase 5: Authentication Infrastructure

**Goal**: Pluggable auth with interface supporting none, OAuth, and custom implementations.

### 5.1 Auth Provider Interface

**Files:**
```
lib/core/auth/
├── auth_provider.dart           # Abstract AuthProvider interface
├── auth_state.dart              # AuthState (unauthenticated, authenticated, loading)
├── auth_user.dart               # User model
├── auth_tokens.dart             # Token storage model
├── providers/
│   ├── no_auth_provider.dart    # For local-only mode
│   ├── oauth_provider.dart      # OAuth 2.0 / OpenID Connect
│   └── custom_auth_provider.dart # Email/password template
├── token_storage.dart           # Secure token persistence
└── providers.dart               # Riverpod providers
```

**AuthProvider interface:**
```dart
abstract class AuthProvider {
  Stream<AuthState> get authStateStream;
  AuthState get currentState;

  Future<Result<AuthUser, AuthError>> signIn(AuthCredentials credentials);
  Future<Result<Unit, AuthError>> signOut();
  Future<Result<AuthTokens, AuthError>> refreshTokens();

  // OAuth-specific
  Future<Result<AuthUser, AuthError>> signInWithProvider(OAuthProvider provider);
}

enum OAuthProvider { google, apple, github }
```

### 5.2 Auth State Management

```dart
@riverpod
class AuthController extends _$AuthController {
  @override
  AuthState build() {
    final backend = ref.watch(backendProvider);
    final authProvider = backend.authProvider;

    if (authProvider == null) {
      return const AuthState.authenticated(AuthUser.anonymous());
    }

    // Listen to auth state changes
    ref.listen(authProvider.authStateStream, (_, state) {
      this.state = state;
    });

    return authProvider.currentState;
  }
}
```

---

## Phase 6: Sync Engine

**Goal**: Offline-first sync with conflict resolution and background sync.

### 6.1 Sync Infrastructure

**Files:**
```
lib/core/sync/
├── sync_engine.dart             # Main sync coordinator
├── sync_queue.dart              # Pending changes queue
├── sync_operation.dart          # Create/Update/Delete operations
├── conflict_resolver.dart       # Conflict resolution strategies
├── sync_status_tracker.dart     # Track sync state per entity
└── providers.dart
```

**Sync strategies:**
```dart
enum ConflictStrategy {
  serverWins,      // Server version always wins
  clientWins,      // Client version always wins
  latestWins,      // Compare timestamps
  manual,          // Surface to user for resolution
}
```

### 6.2 Sync Metadata

Every syncable entity tracks:
```dart
class SyncMetadata {
  final String? serverId;        // Server-assigned ID
  final String localId;          // Client-generated UUID
  final DateTime? lastSyncedAt;
  final int localVersion;
  final int? serverVersion;
  final SyncStatus status;       // synced, pendingCreate, pendingUpdate, pendingDelete, conflict
  final String? conflictData;    // JSON of server version if conflict
}
```

---

## Phase 7: Testing Infrastructure

**Goal**: Enable testing all layers with proper mocks and utilities.

### 7.1 Test Dependencies

```yaml
dev_dependencies:
  mocktail: ^1.0.4
  fake_async: ^1.3.2
  clock: ^1.1.1
  drift: ^2.22.0  # For in-memory test database
```

### 7.2 Test Utilities

**Files:**
```
test/
├── helpers/
│   ├── pump_app.dart            # Widget test helper
│   ├── provider_overrides.dart  # Common test overrides
│   ├── test_logger.dart         # Capturing logger
│   ├── mock_http_client.dart    # HTTP client mock
│   ├── mock_backend.dart        # Backend provider mock
│   └── in_memory_database.dart  # Drift in-memory DB
├── fixtures/
│   ├── entities/                # Sample entity instances
│   └── responses/               # Mock API responses
└── fakes/
    ├── fake_auth_provider.dart
    ├── fake_data_source.dart
    └── fake_sync_engine.dart
```

---

## Phase 8: CI/CD & Error Handling

### 8.1 Global Error Handling

**Files:**
- `lib/core/error/error_handler.dart` - Global error capture
- `lib/core/error/crash_reporter.dart` - Crash reporting interface
- `lib/core/error/mock_crash_reporter.dart` - Local mock (Sentry-ready)
- `lib/main.dart` - Add `runZonedGuarded` and `FlutterError.onError`

### 8.2 CI/CD

**Files:**
- `.github/workflows/ci.yml` - Analyze, test, build all platforms
- `.github/workflows/integration.yml` - Integration tests
- `.github/dependabot.yml` - Dependency updates

---

## Dependencies Summary

```yaml
dependencies:
  # Network
  dio: ^5.7.0
  connectivity_plus: ^6.1.0

  # Database (Cross-Platform)
  drift: ^2.22.0
  sqlite3_flutter_libs: ^0.5.0   # Mobile/Desktop native SQLite
  path_provider: ^2.1.5
  path: ^1.9.0
  # Web uses sql.js via CDN (no package needed)

  # Auth (when needed)
  flutter_appauth: ^7.0.0        # OAuth (add when implementing OAuth)
  flutter_secure_storage: ^9.2.2 # Secure token storage

  # Utilities
  uuid: ^4.5.1                   # Client-side ID generation
  equatable: ^2.0.7              # Value equality for entities
  json_annotation: ^4.9.0        # JSON serialization

dev_dependencies:
  # Existing
  flutter_test: sdk
  build_runner: ^2.7.1
  riverpod_generator: ^3.0.3

  # New - Testing
  mocktail: ^1.0.4
  fake_async: ^1.3.2

  # New - Code Generation
  drift_dev: ^2.22.0
  json_serializable: ^6.8.0
```

**Note on Result type**: Custom implementation (no external package) - gives full control and avoids unnecessary dependencies.

---

## Implementation Order

```
Phase 1: Core Abstractions (2-3 days)
├── Result type, error hierarchy
└── Enables typed errors everywhere

Phase 2: Network Layer (2-3 days)
├── HTTP client abstraction
├── Interceptors (auth, retry, logging)
└── Connectivity service

Phase 3: Data Layer (3-4 days)
├── Database setup (Drift)
├── DataSource interfaces
├── Repository base classes
└── Sync metadata tables

Phase 4: Backend Mode System (2-3 days)
├── BackendProvider interface
├── Local/SelfHosted/Managed implementations
└── Mode switching provider

Phase 5: Auth Infrastructure (2-3 days)
├── AuthProvider interface
├── NoAuth provider (for local mode)
├── OAuth provider shell
└── Token storage

Phase 6: Sync Engine (3-4 days)
├── Sync queue and operations
├── Conflict resolution
├── Status tracking
└── Background sync

Phase 7: Testing Infrastructure (2 days)
├── Test helpers and mocks
├── In-memory database
└── Sample fixtures

Phase 8: CI/CD & Error Handling (1-2 days)
├── Global error handling
├── Mock crash reporter
└── GitHub Actions workflows
```

**Total: ~18-24 days of foundational work**

---

## Critical Files to Modify

| File | Change |
|------|--------|
| `pubspec.yaml` | Add all new dependencies |
| `lib/main.dart` | Add error handling bootstrap |
| `lib/core/di/providers.dart` | Add new infrastructure providers |
| `lib/core/di/config/env.dart` | Add database path, backend mode config |
| `.gitignore` | Add database files, generated files |

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        UI Layer                              │
│                   (HookConsumerWidget)                       │
└─────────────────────────┬───────────────────────────────────┘
                          │ ref.watch
┌─────────────────────────▼───────────────────────────────────┐
│                    Riverpod Providers                        │
│        (Controllers, Notifiers, AsyncNotifiers)              │
└─────────────────────────┬───────────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────────────┐
│                     Repositories                             │
│         (Offline-first, backend-aware)                       │
└───────────┬─────────────────────────────────┬───────────────┘
            │                                 │
┌───────────▼───────────┐       ┌─────────────▼───────────────┐
│   Local Data Source   │       │    Remote Data Source       │
│       (Drift DB)      │       │      (HTTP Client)          │
└───────────────────────┘       └─────────────────────────────┘
            │                                 │
            └────────────┬────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────┐
│                    Backend Provider                          │
│        (Local / Self-Hosted / Managed)                       │
├─────────────────────────────────────────────────────────────┤
│  - AuthProvider (None / OAuth / Custom)                      │
│  - SyncEngine (optional, based on mode)                      │
│  - HttpClient (optional, null for local-only)                │
└─────────────────────────────────────────────────────────────┘
```

---

## What This Enables

After this groundwork:

1. **Add a new feature** → Create entity, table, repository, data sources. Sync "just works".
2. **Switch backends** → Change mode in settings, repositories adapt automatically.
3. **Add new auth provider** → Implement AuthProvider interface, plug in.
4. **Test offline behavior** → Mock connectivity, verify queue and sync.
5. **Debug issues** → Typed errors with context, crash reports with breadcrumbs.
6. **Scale to complexity** → Clean separation, no spaghetti dependencies.
