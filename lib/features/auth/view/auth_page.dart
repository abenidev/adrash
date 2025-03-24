import 'package:adrash/core/constants/app_enums.dart';
import 'package:adrash/core/utils/ui_utils.dart';
import 'package:adrash/core/widgets/loader_manager.dart';
import 'package:adrash/features/Home/view/pages/home_page.dart';
import 'package:adrash/features/auth/view/register_page.dart';
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
            LoaderManager().showStretchedDots(context);
            UserAuthStatus userAuthStatus = await ref.read(authViewmodelProvider.notifier).signInWithGoogle();
            LoaderManager().hide();
            if (context.mounted) {
              if (userAuthStatus == UserAuthStatus.registered) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
              }
              if (userAuthStatus == UserAuthStatus.unregistered) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterPage()));
              }
              if (userAuthStatus == UserAuthStatus.unauthorized) {
                showCustomSnackBar(context, 'User already registered as driver, please use another email address!', bgColor: Colors.red, textColor: Colors.white);
              }
              if (userAuthStatus == UserAuthStatus.initial) {}
            }
          },
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}
