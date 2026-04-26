import 'dart:developer';

import 'package:dakerni/models/notification_model.dart';
import 'package:dakerni/repositories/notifications_reposiory.dart';
import 'package:dakerni/services/notificatio_service.dart';
import 'package:dakerni/utils/exceptions.dart';
import 'package:dakerni/utils/general_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationState(notifications: []));
  final _notificationRepository = NotificationsReposiory();
  final _notificationService = NotificationService.instance;

  Future<void> loadNotifications() async {
    try {
      if (!state.isLoading) {
        emit(state.copyWith(isLoading: true, errorMessage: null));
      }
      final notifications = await _notificationRepository.getAllNotifications();
      emit(state.copyWith(notifications: notifications));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<NotificationModel> addNotification(
    NotificationModel notification,
  ) async {
    int? insertedId;
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      insertedId = await _notificationRepository.addNotification(notification);
      log("Added notification id: $insertedId");
      final addedNotification = await _notificationRepository
          .getNotificationById(insertedId);

      if (addedNotification == null) {
        throw NotificationNotFoundException(
          "Failed to retrieve added notification with id: $insertedId",
        );
      }

      await _notificationService.scheduleReminder(
        id: addedNotification.id,
        title: "Remember",
        body: addedNotification.content.isEmpty
            ? "You didn't type anything, but I will remind you anyway."
            : addedNotification.content,
        scheduledDate: convertToTZDateTime(addedNotification.scheduledDate),
      );

      await loadNotifications();
      return addedNotification;
    } on NotificationException catch (e) {
      if (insertedId != null) {
        await _notificationRepository.deleteNotification(insertedId);
      }
      emit(state.copyWith(errorMessage: e.toString()));
      rethrow;
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
      rethrow;
    } finally {
      if (state.isLoading) {
        emit(state.copyWith(isLoading: false));
      }
    }
  }

  Future<void> updateNotification(NotificationModel notification) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      await _notificationRepository.updateNotification(notification);
      await loadNotifications();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    } finally {
      if (state.isLoading) {
        emit(state.copyWith(isLoading: false));
      }
    }
  }

  Future<NotificationModel> deleteNotification(int id) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      final notification = await _notificationRepository.getNotificationById(
        id,
      );
      if (notification == null) {
        throw NotificationNotFoundException(
          "Notification not found for id: $id",
        );
      }

      await _notificationService.cancelNotification(notification.id);
      await _notificationRepository.deleteNotification(id);

      await loadNotifications();
      return notification;
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
      rethrow;
    } finally {
      if (state.isLoading) {
        emit(state.copyWith(isLoading: false));
      }
    }
  }
}
