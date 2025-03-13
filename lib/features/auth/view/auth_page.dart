import 'package:adrash/core/widgets/loader_manager.dart';
import 'package:adrash/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            LoaderManager().show(context);
            await ref.read(authViewmodelProvider.notifier).signInWithGoogle();
            LoaderManager().hide();
          },
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}
