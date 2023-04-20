
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/foreground_task_service.dart';
import '../enums/foreground_task_status.dart';

import 'package:dlsm_pof/permissions/index.dart';



final foregroundTaskStateProvider = StateNotifierProvider<ForegroundTaskStateNotifier, AsyncValue<ForegroundTaskState>>((ref) {
  ForegroundTaskService foregroundTaskService = ref.watch(foregroundTaskServiceProvider);
  AsyncValue<PermissionsState> permissionsState = ref.watch(permissionsStateProvider);
  return ForegroundTaskStateNotifier(foregroundTaskService, permissionsState);
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



class ForegroundTaskStateNotifier extends StateNotifier<AsyncValue<ForegroundTaskState>> {
  final ForegroundTaskService _foregroundTaskService;
  final AsyncValue<PermissionsState> _permissionsState;

  ForegroundTaskStateNotifier(
    this._foregroundTaskService,
    this._permissionsState,
  ): super(const AsyncValue.loading()) {
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
          state = await _foregroundTaskService.isRunning() ?
            const AsyncValue.data(ForegroundTaskState(status: ForegroundTaskStatus.running)) :
            const AsyncValue.data(ForegroundTaskState(status: ForegroundTaskStatus.stopped));
        } else {
          state = const AsyncValue.data(ForegroundTaskState(status: ForegroundTaskStatus.noPermission));
        }
      },
    );
  }
}