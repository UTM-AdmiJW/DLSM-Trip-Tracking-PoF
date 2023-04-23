
import 'package:flutter/material.dart';


/// Register the RouteObserver as a navigation observer in the main app widget.
/// 
/// So that in the widgets that need to be aware of navigation changes, they can use the `RouteAware` 
/// mixin and implement methods like `didPush`, `didPop`, `didPopNext`, `didPushNext`.
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
