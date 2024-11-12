# greenshare

Share files more consciously

## Frontend Overview

The frontend is developed using [Flutter](https://github.com/flutter/flutter), an open-source framework for building cross-platform applications. Below are some of the main features and techniques used in our application:

### Use of BLoC (Business Logic Component)
Use [BLoC pattern](https://github.com/felangel/bloc/tree/master/packages/flutter_bloc) to manage the business logic of the application. This pattern helps separate business logic from the UI, making the codebase more maintainable and testable. BLoC assists us in managing the application's states in a predictable manner.

### Use of Freezed
Use the [freezed](https://pub.dev/packages/freezed) package to simplify data modeling by automatically generating immutable data classes, along with methods like `fromJson()` and `toJson()`. This approach reduces boilerplate code and eases maintenance by handling JSON serialization for us.

### Dependency Injection
Dependency injection is used to enhance the modularity and testability of our code. We use libraries such as [get_it](https://github.com/fluttercommunity/get_it) and [injectable](https://github.com/Milad-Akarie/injectable) to manage dependencies, allowing us to easily inject services and configurations into our Flutter components.

### Golden Tests
To ensure a consistent user interface and to prevent regressions, golden tests have been implemented. These tests capture visual snapshots of widgets in various states and compare them to reference snapshots. This helps us quickly detect undesirable changes in the UI.

### Backend Approach
For backend management, we have chosen a solution based on backend services like Firebase or Supabase. This approach allows us to focus on developing front-end features without having to build a custom backend from the start.

## Getting Started

### Configure firebase

Prerequisites: Have some knowledge about Firebase and have the Firebase CLI installed.

1. Create a new project in Firebase.
2. Configure the project to use Firebase Authentication, Firebase Realtime Database and Firestore.
3. Configure firebase in the project:
```bash
flutterfire configure && mv firebase_options.dart lib/config/firebase
```

## Building Files for Injectable and Localization

To generate files for dependency injection with `injectable` and `localization`, run the following command:

```bash
dart run build_runner build --delete-conflicting-outputs && flutter pub get
```

Note: `flutter pub get` is here to refresh `arb` file in flutter project.

## Run Tests
```bash
flutter test
```

## Update Golden Tests
```bash
flutter test --update-goldens --tags=golden
```
