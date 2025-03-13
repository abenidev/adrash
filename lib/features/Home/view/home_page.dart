import 'package:adrash/core/widgets/loader_manager.dart';
import 'package:adrash/features/Home/view/widgets/map_widget.dart';
import 'package:adrash/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(),
          child: Stack(
            children: [
              MapWidget(),
              IconButton(
                onPressed: () async {
                  LoaderManager().show(context);
                  await ref.read(authViewmodelProvider.notifier).signOut();
                  LoaderManager().hide();
                },
                icon: Icon(Icons.remove),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
