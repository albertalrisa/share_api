# Change Log (share_api)

## 0.0.6
* **iOS Implementation**
* Add iOS implementation for Facebook Story and Instagram Story

## 0.0.5
* **Nullable Problem Fix**
* Fix some variables being declared as nullable where a non-nullable one is expected

## 0.0.4
* **Provider Authorities**
* Change the provider authorities to match the project package name, reducing chance of collision (breaking change)
* Fix an error caused by Kotlin implicitly convert the arguments from Flutter into a nullable type
* Documentation is updated to match the new provider authorities setting

## 0.0.3

* **Instagram Share Result Fix and Default Function Removal**
* Instagram should now return `ShareResult.unknown` instead of `ShareResult.canceled` (breaking change)
* Built in `platformVersion()` function from Flutter default plugin example has been removed (breaking change)
* Documentation now includes the return value explanation

## 0.0.2

* **Documentation Revamp**
* Improve the documentation, especially on adding FileProvider in Android

## 0.0.1

* **Initial Release**
* Add System UI, Facebook Story, and Instagram Story API functions
* Compatible only on Android