# Package Compatibility Guide

This table outlines the platform support for the keys packages used in this template.

| Package | Android | iOS | macOS | Web | Linux | Windows | Notes |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :--- |
| **flutter_riverpod** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Core state management. Pure Dart. |
| **go_router** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Declarative routing. |
| **logger** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Pure Dart logging. |
| **internet_connection_checker_plus** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Checks reachability. |
| **connectivity_plus** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Checks network interface status. |
| **permission_handler** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Unified permission API. |
| **flutter_secure_storage** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Keychain/Keystore wrapper. |
| **flutter_dotenv** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Environment config. |
| **firebase_core** | ✅ | ✅ | ✅ | ✅ | ❌ | ⚠️ | Firebase init. Windows support covers only a subset of Firebase plugins; no Linux support. Disabled by default (`FirebaseConfig.enabled`). |
| **firebase_auth** | ✅ | ✅ | ✅ | ✅ | ❌ | ⚠️ | Firebase Auth impl of `AuthRepository`. Not bound by default (stub is). |
| **google_sign_in** | ✅ | ✅ | ✅ | ⚠️ | ❌ | ❌ | Native Google flow. On web the Firebase popup flow is used instead (handled automatically by `FirebaseFederatedSignIn`). |
| **freezed** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Code generation (Dev dependency). |
| **json_serializable** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Code generation (Dev dependency). |

## Legend
*   ✅ : Fully Supported
*   ⚠️ : Partially Supported or requires manual config
*   ❌ : Not Supported or irrelevant for platform
