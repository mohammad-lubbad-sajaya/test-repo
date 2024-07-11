import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/extentions.dart';
import '../../../../core/services/routing/navigation_service.dart';
import '../../../../core/services/routing/routes.dart';
import '../../../../core/services/service_locator/dependency_injection.dart';
import '../../../../core/utils/app_widgets/custom_app_text.dart';
import '../../../../core/utils/common_widgets/change_language_view.dart';
import '../../../../core/utils/common_widgets/custom_app_text_field.dart';
import '../../../../core/utils/common_widgets/custom_raised_button.dart';
import '../../../../core/utils/constants/endpoints.dart';
import '../../../../core/utils/constants/images.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../allTabs/settings/settings_view_model.dart';
import 'login_view_model.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends ConsumerState<LoginScreen> {
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, _) {
          final loginViewModel = ref.watch(loginViewModelProvider);
          final isRememberMe = ref.watch(isRememberMeProvider) ?? false;
          final isDark = ref.watch(settingsViewModelProvider).isDark;
          String userId = '';
          loginViewModel.context = context;
          if (isRememberMe) {
            userId = ref.watch(userIdProvider).trim();
            loginViewModel.userId = userId;
          }

          return Container(
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage(isDark ? darkBackgroundImage : backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 26),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20.0),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const ChangeLanguageView(),
                                const SizedBox(height: 65.0),
                                Image.asset(
                                  logo,
                                  height: 100,
                                ),
                                const SizedBox(height: 20.0),
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        isDark ? darkCardColor : Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(16)),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 16),
                                  child: Column(
                                    children: [
                                      customAppTextField(
                                        textColor: isDark
                                            ? backGroundColor
                                            : Colors.black,
                                        placeHolderColor: isDark
                                            ? backGroundColor
                                            : placeHolderColor,
                                        bgColor: isDark
                                            ? darkDialogsColor
                                            : textFieldBgColor,
                                        onFieldSubmitted: (p0) {
                                          FocusScope.of(context)
                                              .requestFocus(_passwordFocusNode);
                                        },
                                        borderColor: isDark
                                            ? Colors.transparent
                                            : textFieldBorderColor,
                                        initialValue: userId,
                                        hintText: 'User Id'.localized(),
                                        errorText: loginViewModel.isUserIdValid
                                            ? null
                                            : 'UserId is required'.localized(),
                                        onChanged: (value) {
                                          ref.read(userIdProvider.state).state =
                                              value;
                                          loginViewModel.validateUserId(value);
                                        },
                                      ),
                                      const SizedBox(height: 20.0),
                                      customAppTextField(
                                        placeHolderColor: isDark
                                            ? backGroundColor
                                            : placeHolderColor,
                                        borderColor: isDark
                                            ? Colors.transparent
                                            : textFieldBorderColor,
                                        textColor: isDark
                                            ? backGroundColor
                                            : Colors.black,
                                        bgColor: isDark
                                            ? darkDialogsColor
                                            : textFieldBgColor,
                                        focusNode: _passwordFocusNode,
                                        hintText: "Password".localized(),
                                        onChanged:
                                            loginViewModel.validatePassword,
                                        errorText:
                                            loginViewModel.isPasswordValid
                                                ? null
                                                : 'Password is required'
                                                    .localized(),
                                        isObscureText:
                                            loginViewModel.isObscureText,
                                        suffixIcon: Image.asset(
                                            color:
                                                isDark ? backGroundColor : null,
                                            loginViewModel.isObscureText
                                                ? showEye
                                                : hideEye),
                                        suffixIconAction: () {
                                          loginViewModel.obscureText();
                                        },
                                      ),
                                      const SizedBox(height: 16.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              InkWell(
                                                child: Container(
                                                  height: 18,
                                                  width: 18,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: secondaryColor,
                                                          width: 1.3),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4)),
                                                  child: isRememberMe
                                                      ? Center(
                                                          child: Icon(
                                                            Icons.check,
                                                            color: isDark
                                                                ? backGroundColor
                                                                : primaryColor,
                                                            size: 15,
                                                          ),
                                                        )
                                                      : Container(),
                                                ),
                                                onTap: () {
                                                  ref
                                                      .read(isRememberMeProvider
                                                          .state)
                                                      .state = !isRememberMe;
                                                  loginViewModel
                                                      .checkRememberMe(
                                                          !isRememberMe);
                                                },
                                              ),
                                              const SizedBox(width: 5),
                                              customTextApp(
                                                color: isDark
                                                    ? backGroundColor
                                                    : Colors.black,
                                                text: "Remember me".localized(),
                                                size: 15,
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                            child: customTextApp(
                                              color: isDark
                                                  ? backGroundColor
                                                  : Colors.black,
                                              text: 'Forgot Password?'
                                                  .localized(),
                                              size: 15,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            onTap: () {
                                              // sl<NavigationService>().navigateTo(signupScreen);
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16.0),
                                      CustomRaisedButton(
                                        child: loginViewModel.isLoading
                                            ? const SizedBox(
                                                width: 15,
                                                height: 15,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                ),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    login,
                                                    height: 20,
                                                  ),
                                                  const SizedBox(width: 14),
                                                  customTextApp(
                                                    text: 'Login'.localized(),
                                                    color: secondaryColor,
                                                    size: 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ],
                                              ),
                                        onTap: loginViewModel.isLoading
                                            ? null
                                            : () =>
                                                loginViewModel.login(context),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                customTextApp(
                                  text: "Don’t have an account?".localized(),
                                  size: 14,
                                  color:
                                      isDark ? backGroundColor : primaryColor,
                                ),
                                const SizedBox(width: 5),
                                InkWell(
                                  child: customTextApp(
                                    text: 'Sign up'.localized(),
                                    size: 14,
                                    color: secondaryColor,
                                  ),
                                  onTap: () {
                                    sl<NavigationService>()
                                        .navigateToAndReplace(signupScreen);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            customTextApp(
                              text:
                                  "${"Version".localized()} ${sl<Endpoints>().version}",
                              color: placeHolderColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
