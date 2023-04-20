
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/permissions_state.dart';
import '../widgets/permissions_list.dart';



class PermissionsPage extends ConsumerStatefulWidget {
  const PermissionsPage({super.key});
  @override ConsumerState<PermissionsPage> createState() => _PermissionsPageState();
}


class _PermissionsPageState extends ConsumerState<PermissionsPage> with WidgetsBindingObserver {

  void updatePermissions() async {
    final permissionStateNotifier = ref.read(permissionsStateProvider.notifier);
    await permissionStateNotifier.updatePermissions();
  }


  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(permissionsStateProvider.notifier).updatePermissions();
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
        onRefresh: ref.read(permissionsStateProvider.notifier).updatePermissions,
        child: permissions.when(
          data: (permissions)=> PermissionsList(permissions: permissions),
          error: (err, stack)=> const Center(child: Text('Error')),
          loading: ()=> const Center(child: CircularProgressIndicator())
        )
      )
    );
  }
}