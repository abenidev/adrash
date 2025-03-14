import 'package:adrash/features/auth/model/user_data.dart';
import 'package:adrash/features/auth/repositories/auth_remote_repository.dart';
import 'package:adrash/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authViewmodelProvider = StateNotifierProvider<AuthViewmodelNotifier, UserData?>((ref) {
  final authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
  return AuthViewmodelNotifier(
    authRemoteRepository: authRemoteRepository,
  );
});

class AuthViewmodelNotifier extends StateNotifier<UserData?> {
  AuthRemoteRepository authRemoteRepository;
  AuthViewmodelNotifier({required this.authRemoteRepository}) : super(null);

  Future<void> signInWithGoogle() async {
    try {
      User? user = await authRemoteRepository.signInWithGoogle();
      if (user != null) {
        final userData = await _getUserDataByEmail(user.email!);
        state = userData;
      }
    } catch (e) {
      logger.e('Error occured while signing in with Google: $e');
    }
  }

  Future<void> signOut() async {
    return authRemoteRepository.signOut();
  }

  User? getFirebaseAuthUser() {
    return authRemoteRepository.getFirebaseAuthUser();
  }

  Future<UserData?> _getUserDataByEmail(String email) async {
    return await authRemoteRepository.getUserDataByEmail(email);
  }
}
