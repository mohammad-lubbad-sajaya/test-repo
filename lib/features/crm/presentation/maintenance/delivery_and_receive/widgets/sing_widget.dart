import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/services/extentions.dart';

import 'package:signature/signature.dart';

import '../../../../../../core/utils/common_widgets/custom_raised_button.dart';
import '../../../../../../core/utils/theme/app_colors.dart';
import '../view_models/delivery_and_receive_view_model.dart';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({super.key});

  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final _viewModel = ref.watch(deliveryAndReceiveViewModel);
      return Column(
        children: [
          Signature(
            controller: _viewModel.signatureController,
            height: 300,
            backgroundColor: Colors.grey,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomRaisedButton(
            onTap: () {
              _viewModel.signatureController.clear();
            },
            child: Text(
              "clear".localized(),
              style: const TextStyle(color: secondaryColor),
            ),
          )
        ],
      );
    });
  }
}
