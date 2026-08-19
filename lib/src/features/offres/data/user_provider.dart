import 'package:local_share/src/features/offres/domain/user.dart';
import 'package:riverpod/legacy.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  void setUser(Map<String, dynamic> userData) {
    state = User.fromJson(userData);
  }

  void logout() {
    state = null;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});
