# DLSM Proof of Concept - Trip Tracking 🚗

## Structural and Naming Conventions 🏷️

- This project follows **Feature first approach** for file structure. Directly under the `lib` directory is the features like `dashboard`, `trip_tracking`, `common` and so on.

- Each feature directory should have a `index.dart` file that exports all the required files in that directory. Other features should ever only import from the `index.dart` file. Do not import files from internal directories of a feature.

- Follow flutter naming convention. Directories and files should be named in `lowercase_with_underscores` format. The same goes for files. For classes, use `UpperCamelCase` format.

- When using providers, there should be 2 types:

    **1. Services**

    Services are singleton objects that contain reusable logic. For example, `TripTrackingService` that provides methods to start and stop trip tracking.

    > Services should be suffixed with `Service`.

    - File name follows `lowercase_with_underscores` format. For example, `trip_tracking_service.dart`.
    - For classes, use the usual `UpperCamelCase` format. For example, `TripTrackingService`.
    - The provider should be named suffixed with `provider`. For example, `tripTrackingServiceProvider`.

    **2. States**

    States are the single source of truth, singleton objects that contain the state of the application. For example, `PermissionState` that provides the current permission status of the app.

    > States should be suffixed with `State`.

    - File name follows `lowercase_with_underscores` format. For example, `permissions_state.dart`.
    - The provider should be named suffixed with `provider`. For example, `permissionsStateProvider`.

