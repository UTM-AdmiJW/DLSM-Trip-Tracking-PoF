
import 'package:flutter/material.dart';


// Register the RouteObserver as a navigation observer.
// So that in the widgets that need to be aware of navigation changes,
// we can use `with RouteAware` mixin
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
