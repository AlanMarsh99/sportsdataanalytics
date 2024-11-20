/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/models/user_app.dart';

class UserProvider extends ChangeNotifier {
  UserApp? _user; // User data
  bool _isLoading = false;

  UserApp? get user => _user;
  bool get isLoading => _isLoading;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user data by ID (e.g., UID from Firebase Authentication)
  Future<void> fetchUserData(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        _user = UserApp.fromMap(userDoc.data()!);
      } else {
        _user = null; // Handle user not found if necessary
      }
    } catch (e) {
      print('Error fetching user data: $e');
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setuser(UserApp user) {
    _user = user;
    notifyListeners();
  }

  // Update user data locally and in Firestore
  Future<void> updateUserData(Map<String, dynamic> updatedData) async {
    if (_user == null) return;

    try {
      await _firestore.collection('users').doc(_user!.id).update(updatedData);
      _user = UserApp.fromMap({
        ..._user!.toMap(),
        ...updatedData, // Merge existing data with the updates
      });
      notifyListeners();
    } catch (e) {
      print('Error updating user data: $e');
    }
  }
}
*/