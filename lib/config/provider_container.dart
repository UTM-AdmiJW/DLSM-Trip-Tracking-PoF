import 'package:flutter_riverpod/flutter_riverpod.dart';


// The ProviderContainer is a global object that stores all the providers
// and allows us to read and modify them.
// Although it is a bad practice to read provider values without using ref, the application
// requirements needs this.
final ProviderContainer providerContainer = ProviderContainer();
