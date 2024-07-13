import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signature/signature.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/services/extentions.dart';
import '../../../../../core/utils/app_widgets/check_box.dart';
import '../../../../../core/utils/app_widgets/save_and_cancel_buttons.dart';
import '../../../../../core/utils/common_widgets/error_dialog.dart';
import '../../../../crm/presentation/main_app_bar.dart';
import '../../../../shared_screens/allTabs/settings/settings_view_model.dart';
import '../view_models/delivery_and_receive_view_model.dart';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({Key? key}) : super(key: key);

  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Adjust duration as needed
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleSwitch() {
    setState(() {
      isOpen = !isOpen;
      if (isOpen) {
        _animationController.forward(); // Play forward animation
      } else {
        _animationController.reverse(); // Play reverse animation
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppbar(
        context: context,
        isHideLogOut: true,
        text: "Delivery and Receive".localized(),
      ),
      body: Consumer(builder: (context, ref, child) {
        final _viewModel = ref.watch(deliveryAndReceiveViewModel);
        final _isDark=ref.watch(settingsViewModelProvider).isDark;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Signature(
                  controller: _viewModel.signatureController,
                  height: 50.h,
                  width: 100.w,
                  backgroundColor: Colors.grey[400]!,
                ),
                const SizedBox(
                  height: 30,
                ),
                buildCheckBoxView(
                  isDark:_isDark ,
                  value:_viewModel.isChecked ,
                  onTap: ()=>_viewModel.onCheck(!_viewModel.isChecked),
                  title:"refuse to sign".localized() 
                ),
                SizedBox(
                  height: 5.h,
                ),
                saveAndCancelButtons(
                  context,
                  secondButtonName: "clear".localized(),
                  _viewModel.isLoading,
                  onCancel: () {
                    _viewModel.signatureController.clear();
                  },
                  onSave: () async {
                    if (_viewModel.signatureController.isEmpty&&!_viewModel.isChecked) {
                      showErrorDialog(message: "sign empty".localized());
                    } else {
                      final _signeture =
                          await _viewModel.signatureController.toPngBytes();
                      _viewModel.generatePDF(_signeture, context);
                    }
                  },
                ),
               
              ],
            ),
          ),
        );
      }),
    );
  }
}
