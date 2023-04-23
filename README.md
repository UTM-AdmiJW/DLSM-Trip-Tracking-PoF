# DLSM Proof of Concept - Trip Tracking 🚗

## Structural and Naming Conventions 🏷️

- This project follows **Feature first approach** for file structure. Directly under the `lib` directory is the features like `dashboard`, `trip_tracking`, `common` and so on.

- Each feature directory should have a `index.dart` file that exports all the required files in that directory. Other features should ever only import from the `index.dart` file. Do not import files from internal directories of a feature.

- Follow flutter naming convention. Directories and files should be named in `lowercase_with_underscores` format. The same goes for files. For classes, use `UpperCamelCase` format.

- When using riverpod, there should be 2 types of providers:

    **1. Services**

    Services are singleton objects that contain reusable logic. For example, `TripTrackingService` that provides methods to start and stop trip tracking.

    - Services are provided the simplest provider type: `Provider`. 

    - Services should be suffixed with `Service`, as such:

        - File name follows `lowercase_with_underscores` format. For example, `trip_tracking_service.dart`.
        - For classes, use the usual `UpperCamelCase` format. For example, `TripTrackingService`.
        - The provider should be named suffixed with `provider`. For example, `tripTrackingServiceProvider`.

    - All Services should extend `RiverpodService` abstract class in `lib/common/interfaces/riverpod_service.dart`. This is to ensure that all services have `ProviderRef` property.

    - For accessing Services, use `ref.read` instead of `ref.watch`. This is to minimize the possibility of circular dependencies between services.

    <br>

    **2. States**

    States are the single source of truth, singleton objects that contain the state of the application. For example, `PermissionState` that provides the current permission status of the app.

    - States are provided using `StateNotifierProvider` provider type.

    - States should be suffixed with `State`, as such:

        - File name follows `lowercase_with_underscores` format. For example, `permissions_state.dart`.
        - The provider should be named suffixed with `provider`. For example, `permissionsStateProvider`.

    - All State's Notifier class should extend `RiverpodStateNotifier` abstract class in `lib/common/interfaces/riverpod_state_notifier.dart`. This is to ensure that all state notifiers have `ProviderRef` property to access other services.

    - Only use `ref.watch` to access States. This is to ensure that the state is updated when it changes.
    
    - If only the state's notifier is needed, and not the state itself, use `ref.read` instead of `ref.watch`. This is to ensure that the state is not updated when it changes.

<br>

- And there will be specialized services:

    **1. Data Access / Repository**

    Data Access / Repository services are services that provide access to data. For example, `TripPointDA` that provides access to the trip tracking data.

    - Data Access / Repository services should be suffixed with `DA`, as such:

        - File name follows `lowercase_with_underscores` format. For example, `trip_point_da.dart`.
        - For classes, use the usual `UpperCamelCase` format. For example, `TripPointDA`.
        - The provider should be named suffixed with `provider`. For example, `tripPointDAProvider`.

    - All Data Access / Repository services should extend `SqfliteDA` abstract class in `lib/common/interfaces/sqflite_da.dart`. This is to ensure that all Data Access classes have the `ProviderRef` property, as well as register itself to the `SqfliteService`.