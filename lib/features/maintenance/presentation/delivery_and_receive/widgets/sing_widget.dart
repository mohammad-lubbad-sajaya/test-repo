import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajaya_general_app/core/services/extentions.dart';
import 'package:sizer/sizer.dart';
import 'package:signature/signature.dart';

import '../../../../../core/utils/theme/app_colors.dart';
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
    return Consumer(builder: (context, ref, child) {
      final _viewModel = ref.watch(deliveryAndReceiveViewModel);
      return Column(
        children: [
          GestureDetector(
            onTap: toggleSwitch,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
               isOpen?"close sign".localized():"open sign".localized(),
                  style:const TextStyle(fontSize: 13)
                ),
                Icon(
                  isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          if(isOpen)...[
            const SizedBox(height: 6,)
          ],
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isOpen ? 300 : 0, // Adjust height as needed
            curve: Curves.easeInOut,
            child: isOpen
                ? Stack(
                    children: [
                      Signature(
                        controller: _viewModel.signatureController,
                        height: 300,
                        width: 80.w,
                        backgroundColor: Colors.grey[400]!,
                      ),
                      Positioned(
                        top: 10,
                        right: -15,
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: secondaryColor,
                          ),
                          onPressed: () =>
                              _viewModel.signatureController.clear(),
                        ),
                      ),
                    ],
                  )
                : null,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      );
    });
  }
}
