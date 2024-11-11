# greenshare

Share files more consciously

## Getting Started


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
