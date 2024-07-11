import 'package:flutter/material.dart';

import '../../../../core/services/extentions.dart';
import '../../../../core/utils/app_widgets/floating_action_button.dart';
import '../../../crm/presentation/main_app_bar.dart';
import 'widget/service_card.dart';

class ServiceInfoScreen extends StatelessWidget {
  const ServiceInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppbar(
        context: context,
        isHideLogOut: true,
        text: "service info".localized(),
      ),
      body: const ServiceDetailsCard(),
      floatingActionButton: floatingActionButton(onPressed: (){},iconData: Icons.edit),
    );
  }
}
