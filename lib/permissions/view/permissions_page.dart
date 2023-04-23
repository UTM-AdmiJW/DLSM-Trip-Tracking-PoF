
import 'package:dlsm_pof/permissions/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/permissions_state.dart';
import '../widgets/permissions_list.dart';



class PermissionsPage extends ConsumerStatefulWidget {
  const PermissionsPage({super.key});
  @override ConsumerState<PermissionsPage> createState() => _PermissionsPageState();
}


class _PermissionsPageState extends ConsumerState<PermissionsPage> with WidgetsBindingObserver {

  PermissionsStateNotifier get _permissionsStateNotifier => ref.read(permissionsStateProvider.notifier);


  void updatePermissions() async {
    _permissionsStateNotifier.updatePermissions();
  }


  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _permissionsStateNotifier.updatePermissions();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    updatePermissions();
  }


  @override
  Widget build(BuildContext context) {
    AsyncValue<PermissionsState> permissions = ref.watch(permissionsStateProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Permissions'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _permissionsStateNotifier.updatePermissions,
        child: permissions.when(
          data: (permissions)=> PermissionsList(permissions: permissions),
          error: (err, stack)=> const Center(child: Text('Error')),
          loading: ()=> const Center(child: CircularProgressIndicator())
        )
      )
    );
  }
}