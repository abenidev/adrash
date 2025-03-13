import 'package:adrash/features/auth/repositories/auth_remote_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authViewmodelProvider = StateNotifierProvider<AuthViewmodelNotifier, bool>((ref) {
  final authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
  return AuthViewmodelNotifier(
    authRemoteRepository: authRemoteRepository,
  );
});

class AuthViewmodelNotifier extends StateNotifier<bool> {
  AuthRemoteRepository authRemoteRepository;
  AuthViewmodelNotifier({required this.authRemoteRepository}) : super(false);

  Future<User?> signInWithGoogle() async {
    return await authRemoteRepository.signInWithGoogle();
  }

  Future<void> signOut() async {
    return authRemoteRepository.signOut();
  }
}
