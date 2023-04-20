import 'package:flutter_riverpod/flutter_riverpod.dart';


// Top level provider container, which is used to provide dependencies to the entire app.
// Intiialized here since the foreground task service needs it to access the foreground handler.
ProviderContainer providerContainer = ProviderContainer();
