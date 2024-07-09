import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/extentions.dart';

import '../../../core/services/routing/navigation_service.dart';
import '../../../core/services/routing/routes.dart';
import '../../../core/services/service_locator/dependency_injection.dart';
import '../../../core/utils/app_widgets/custom_app_text.dart';
import '../../../core/utils/common_widgets/custom_app_text_field.dart';
import '../../../core/utils/common_widgets/custom_raised_button.dart';
import '../../../core/utils/constants/images.dart';
import '../../../core/utils/theme/app_colors.dart';
import '../../crm/presentation/allTabs/settings/settings_view_model.dart';
import 'signup_view_model.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController textEditingController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _licenseFocusNode = FocusNode();
  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _licenseFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, _) {
          final signupViewModel = ref.watch(signupViewModelProvider);
                    final isDark = ref.watch(settingsViewModelProvider).isDark;

          return PopScope(
            canPop: false,
            onPopInvoked: (pop) {
              signupViewModel.backButton(context: context);
            },
            child: Container(
              height: double.infinity,
              decoration:  BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(isDark?darkBackgroundImage: backgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              child:  Icon(Icons.arrow_back,color:isDark?backGroundColor:Colors.black),
                              onTap: () {
                                signupViewModel.backButton(context: context);
                              },
                            ),
                         
                          ],
                        ),

                     
                        const SizedBox(height: 12.0),
                        Image.asset(
                          smallLogo,
                          height: 100,
                        ),
                        const SizedBox(height: 21.0),
                        Container(
                          decoration:  BoxDecoration(
                            color:isDark?darkCardColor: Colors.white,
                            borderRadius:const  BorderRadius.all(Radius.circular(16)),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 16),
                          child: Column(
                            children: [
                              customAppTextField(
                                                                        placeHolderColor:isDark? backGroundColor:placeHolderColor,

                                 borderColor: isDark
                                            ? Colors.transparent
                                            : textFieldBorderColor,
                                  textColor: isDark
                                            ? backGroundColor
                                            : Colors.black,
                                        bgColor: isDark
                                            ? darkDialogsColor
                                            : textFieldBgColor,
                                onFieldSubmitted: (p0) {
                                  FocusScope.of(context)
                                      .requestFocus(_passwordFocusNode);
                                },
                                hintText: 'User Id'.localized(),
                                onChanged: signupViewModel.validateUserId,
                                errorText: signupViewModel.isUserIdValid
                                    ? null
                                    : 'UserId is required'.localized(),
                              ),
                              const SizedBox(height: 16.0),
                              customAppTextField(
                                  borderColor: isDark
                                            ? Colors.transparent
                                            : textFieldBorderColor,
                                  textColor: isDark
                                            ? backGroundColor
                                            : Colors.black,
                                        placeHolderColor:isDark? backGroundColor:placeHolderColor,
                                        bgColor: isDark
                                            ? darkDialogsColor
                                            : textFieldBgColor,
                                focusNode: _passwordFocusNode,
                                onFieldSubmitted: (p0) {
                                  FocusScope.of(context)
                                      .requestFocus(_licenseFocusNode);
                                },
                                hintText: "Password".localized(),
                                onChanged: signupViewModel.validatePassword,
                                errorText: signupViewModel.isPasswordValid
                                    ? null
                                    : 'Password is required'.localized(),
                                isObscureText: signupViewModel.isObscureText,
                                suffixIcon: Image.asset(
                                  color: isDark?backGroundColor:primaryColor,
                                    signupViewModel.isObscureText
                                        ? showEye
                                        : hideEye),
                                suffixIconAction: () {
                                  signupViewModel.obscureText();
                                },
                              ),
                              const SizedBox(height: 24.0),
                              InkWell(
                                onTap: () {
                                  textEditingController.clear();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    customTextApp(
                                      text: 'clear'.localized(),
                                      color: const Color.fromARGB(
                                          255, 255, 127, 118),
                                      size: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    const SizedBox(width: 4),
                                    Image.asset(
                                      claerIcon,
                                      height: 10,
                                    ),
                                    const SizedBox(width: 16),
                                  ],
                                ),
                              ),
                              customAppTextField(
                                  borderColor: isDark
                                            ? Colors.transparent
                                            : textFieldBorderColor,
                                  textColor: isDark
                                            ? backGroundColor
                                            : Colors.black,
                                        placeHolderColor:isDark? backGroundColor:placeHolderColor,
                                        bgColor: isDark
                                            ? darkDialogsColor
                                            : textFieldBgColor,
                                contentHorizontalPadding: 16,
                                focusNode: _licenseFocusNode,
                                textController: textEditingController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z0-9]'),
                                  ),
                                  LengthLimitingTextInputFormatter(28),
                                  CustomTextInputFormatter(),
                                ],
                                textAlign: TextAlign.left,
                                labelText: "License Key".localized(),
                                hintText:
                                    "AAAA  0000  2222  5555  8888  1111  3333",
                                onChanged: signupViewModel.validateLicense,
                                fontSize: 14,
                                errorText: signupViewModel.isLicenseValid
                                    ? null
                                    : 'License Key is required'.localized(),
                              ),
                              const SizedBox(height: 32.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomRaisedButton(
                                      onTap: signupViewModel.isLoading
                                          ? null
                                          : () =>
                                              signupViewModel.signup(context),
                                      child: signupViewModel.isLoading
                                          ? const SizedBox(
                                              width: 15,
                                              height: 15,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.check_circle_outline,
                                                  color: secondaryColor,
                                                ),
                                                const SizedBox(width: 5),
                                                customTextApp(
                                                  text: 'Sign up'.localized(),
                                                  color: secondaryColor,
                                                  size: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: CustomRaisedButton(
                                      colors: const [
                                        secondaryColor,
                                        secondaryColor
                                      ],
                                      onTap: () {
                                        //Navigator.of(context).pop(false);
                                        sl<NavigationService>()
                                            .navigateToAndReplace(loginScreen);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.cancel,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 5),
                                          customTextApp(
                                            text: 'Cancel'.localized(),
                                            color: Colors.white,
                                            size: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
               
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String cleanedText =
        newValue.text.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase();

    StringBuffer formattedText = StringBuffer();

    int separatorCount = 0;
    for (int i = 0; i < cleanedText.length; i += 4) {
      int endIndex = i + 4;
      if (endIndex > cleanedText.length) {
        endIndex = cleanedText.length;
      }
      formattedText.write(cleanedText.substring(i, endIndex));

      separatorCount++;
      if (separatorCount < 7 && endIndex < cleanedText.length) {
        formattedText.write(' ');
      }
    }

    return TextEditingValue(
      text: formattedText.toString(),
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
