import 'package:adrash_rider/core/constants/app_enums.dart';
import 'package:adrash_rider/features/auth/model/user_data.dart';
import 'package:adrash_rider/features/auth/repositories/auth_remote_repository.dart';
import 'package:adrash_rider/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isSigningInProvider = StateProvider<bool>((ref) {
  return false;
});

final authViewmodelProvider = StateNotifierProvider<AuthViewmodelNotifier, UserData?>((ref) {
  final authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
  final isSigningInStateProvider = ref.watch(isSigningInProvider.notifier);
  return AuthViewmodelNotifier(
    authRemoteRepository: authRemoteRepository,
    isSigningInProvider: isSigningInStateProvider,
  );
});

class AuthViewmodelNotifier extends StateNotifier<UserData?> {
  AuthRemoteRepository authRemoteRepository;
  StateController<bool> isSigningInProvider;
  AuthViewmodelNotifier({required this.authRemoteRepository, required this.isSigningInProvider}) : super(null);

  Future<UserAuthStatus> signInWithGoogle() async {
    try {
      isSigningInProvider.state = true;
      User? user = await authRemoteRepository.signInWithGoogle();
      if (user != null) {
        UserData? userData = await getUserDataByEmail(user.email!, setState: false);
        isSigningInProvider.state = false;
        if (userData == null) {
          return UserAuthStatus.unregistered;
        }
        if (userData.role.toUserRole == UserRole.rider) {
          await signOut();
          return UserAuthStatus.unauthorized;
        }
        state = userData;
        return UserAuthStatus.registered;
      }
      return UserAuthStatus.initial;
    } catch (e) {
      logger.e('Error occured while signing in with Google: $e');
      isSigningInProvider.state = false;
      return UserAuthStatus.initial;
    }
  }

  Future<UserAuthStatus> getUserAuthStatus() async {
    try {
      isSigningInProvider.state = true;
      User? user = getFirebaseAuthUser();
      if (user != null) {
        UserData? userData = await getUserDataByEmail(user.email!);
        isSigningInProvider.state = false;
        if (userData == null) {
          return UserAuthStatus.unregistered;
        }
        return UserAuthStatus.registered;
      }
      return UserAuthStatus.initial;
    } catch (e) {
      logger.e('Error occured while signing in with Google: $e');
      isSigningInProvider.state = false;
      return UserAuthStatus.initial;
    }
  }

  Future<bool> signOut() async {
    try {
      await authRemoteRepository.signOut();
      state = null;
      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  User? getFirebaseAuthUser() {
    return authRemoteRepository.getFirebaseAuthUser();
  }

  Future<UserData?> getUserDataByEmail(String email, {bool setState = true}) async {
    UserData? userData = await authRemoteRepository.getUserDataByEmail(email);
    if (setState) state = userData;
    return userData;
  }

  Future<UserData> addUserData(UserData userData) async {
    try {
      UserData addedUserData = await authRemoteRepository.addUserData(userData);
      state = addedUserData;
      return addedUserData;
    } catch (e) {
      rethrow;
    }
  }

  UserRole getUserRole() {
    if (state == null) throw Exception('User is not signed in');
    return state!.role.toUserRole;
  }
}
