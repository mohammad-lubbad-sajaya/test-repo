import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/extentions.dart';

import '../../../../core/utils/constants/images.dart';
import 'pre_app_view_model.dart';


class PreAppScreen extends StatefulWidget {
  const PreAppScreen({super.key});

  @override
  State<PreAppScreen> createState() => _PreAppScreenState();
}

class _PreAppScreenState extends State<PreAppScreen> {
  //late AnimationController _animation;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read(preAppViewModelProvider).getMain();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, _) {
          //final preAppViewModel = ref.watch(preAppViewModelProvider);

          //preAppViewModel.getMain();
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Image.asset(
                      logo,
                      height: 90,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
