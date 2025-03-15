import 'package:adrash/features/auth/model/user_data.dart';
import 'package:adrash/features/auth/repositories/auth_remote_repository.dart';
import 'package:adrash/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoadingUserDataProvider = StateProvider<bool>((ref) {
  return true;
});

final authViewmodelProvider = StateNotifierProvider<AuthViewmodelNotifier, UserData?>((ref) {
  final authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
  final isLoadingUserDataStateProvider = ref.watch(isLoadingUserDataProvider.notifier);
  return AuthViewmodelNotifier(
    authRemoteRepository: authRemoteRepository,
    isLoadingUserDataProvider: isLoadingUserDataStateProvider,
  );
});

class AuthViewmodelNotifier extends StateNotifier<UserData?> {
  AuthRemoteRepository authRemoteRepository;
  StateController<bool> isLoadingUserDataProvider;
  AuthViewmodelNotifier({required this.authRemoteRepository, required this.isLoadingUserDataProvider}) : super(null);

  Future<void> signInWithGoogle() async {
    try {
      User? user = await authRemoteRepository.signInWithGoogle();
      if (user != null) {
        await getUserDataByEmail(user.email!);
      }
    } catch (e) {
      logger.e('Error occured while signing in with Google: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await authRemoteRepository.signOut();
      state = null;
      isLoadingUserDataProvider.state = true;
    } catch (e) {
      logger.e(e);
    }
  }

  User? getFirebaseAuthUser() {
    return authRemoteRepository.getFirebaseAuthUser();
  }

  Future<UserData?> getUserDataByEmail(String email) async {
    UserData? userData = await authRemoteRepository.getUserDataByEmail(email);
    state = userData;
    return userData;
  }

  Future<UserData?> addUserData(UserData userData) async {
    UserData? addedUserData = await authRemoteRepository.addUserData(userData);
    state = addedUserData;
    return addedUserData;
  }
}
