import 'package:dakerni/models/notification_model.dart';
import 'package:dakerni/repositories/notifications_reposiory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationState(notifications: []));
  final NotificationsReposiory _notificationRepository =
      NotificationsReposiory();

  Future<void> loadNotifications() async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      final notifications = await _notificationRepository.getAllNotifications();
      emit(state.copyWith(notifications: notifications));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> addNotification(NotificationModel notification) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      await _notificationRepository.addNotification(notification);
      loadNotifications();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> updateNotification(NotificationModel notification) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      await _notificationRepository.updateNotification(notification);
      loadNotifications();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<NotificationModel> deleteNotification(int id) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      final notification = state.notifications.firstWhere(
        (notif) => notif.id == id,
      );
      await _notificationRepository.deleteNotification(id);
      loadNotifications();
      return notification;
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
      rethrow;
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
