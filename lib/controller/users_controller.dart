import 'package:flutter/foundation.dart';
import 'package:imtihon_4_oy/services/users_firebase_services.dart';

class UsersController extends ChangeNotifier{
  final usersFirebaseService=UsersFirebaseServices();

  Future<void> removeLike(String userId,String eventId) async {
    await usersFirebaseService.removeLikedEvent(userId, eventId);
    notifyListeners();
  }

  Future<void> addLike(String userId,String eventId) async {
    await usersFirebaseService.addLikedEvent(userId, eventId);
    notifyListeners();
  }

  // Future<Map<String, dynamic>> getUserById(String userId) async {
  //   final user = await usersFirebaseService.getUserById(userId);
  //   return user!;
  // }
}