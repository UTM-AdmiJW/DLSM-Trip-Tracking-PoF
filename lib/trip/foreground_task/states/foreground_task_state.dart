
import 'package:flutter/material.dart';

import '../enums/foreground_task_status.dart';
import '../services/foreground_task_service.dart';

import 'package:dlsm_pof/common/index.dart';
import 'package:dlsm_pof/permissions/index.dart';



final foregroundTaskStateProvider = StateNotifierProvider<ForegroundTaskStateNotifier, AsyncValue<ForegroundTaskState>>((ref) {
  AsyncValue<PermissionsState> permissionsState = ref.watch(permissionsStateProvider);

  return ForegroundTaskStateNotifier(permissionsState, ref);
});



// ForegroundTaskState will be automatically updated when the 
// permissionsState changes due to dependency injection

@immutable
class ForegroundTaskState {
  final ForegroundTaskStatus status;

  const ForegroundTaskState({
    this.status = ForegroundTaskStatus.stopped,
  });
}



class ForegroundTaskStateNotifier extends RiverpodStateNotifier<AsyncValue<ForegroundTaskState>> {
  final AsyncValue<PermissionsState> _permissionsState;

  ForegroundTaskService get _foregroundTaskService => ref.read(foregroundTaskServiceProvider);


  ForegroundTaskStateNotifier(
    this._permissionsState,
    StateNotifierProviderRef ref
  ): super(const AsyncValue.loading(), ref) {
    updateForegroundTaskState();
  }


  // Note: this method does not update the permissionsState. To update the permissionsState,
  // call the permissionsStateNotifier.updatePermissionsState() method. Then the foregroundTaskState
  // will also be updated automatically 
  void updateForegroundTaskState() {
    _permissionsState.when(
      loading: () => state = const AsyncValue.loading(),
      error: (error, stack) => state = AsyncValue.error(error, stack),
      data: (data) async {
        if (data.hasPermissions) {
          state = await _foregroundTaskService.isRunning ?
            const AsyncValue.data(ForegroundTaskState(status: ForegroundTaskStatus.running)) :
            const AsyncValue.data(ForegroundTaskState(status: ForegroundTaskStatus.stopped));
        } else {
          state = const AsyncValue.data(ForegroundTaskState(status: ForegroundTaskStatus.noPermission));
        }
      },
    );
  }
}