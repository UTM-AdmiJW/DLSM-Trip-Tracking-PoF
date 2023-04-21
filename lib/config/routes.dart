
import 'package:flutter/material.dart';

import 'package:dlsm_pof/dashboard/index.dart';
import 'package:dlsm_pof/permissions/index.dart';


final routes = <String, WidgetBuilder>{
  '/': (BuildContext context) => const DashboardPage(),
  '/permissions': (BuildContext context) => const PermissionsPage(),
};
