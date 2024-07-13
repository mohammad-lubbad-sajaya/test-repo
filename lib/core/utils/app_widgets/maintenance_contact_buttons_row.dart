import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sajaya_general_app/core/services/extentions.dart';
import 'package:sajaya_general_app/core/services/routing/navigation_service.dart';
import 'package:sajaya_general_app/core/services/routing/routes.dart';
import 'package:sajaya_general_app/core/services/service_locator/dependency_injection.dart';
import 'package:sajaya_general_app/features/maintenance/presentation/check_and_repair/view_model/check_repair_view_model.dart';
import 'package:sajaya_general_app/features/shared_screens/allTabs/settings/settings_view_model.dart';
import 'package:trust_location/trust_location.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common_widgets/show_confirmation_dialog.dart';
import '../theme/app_colors.dart';

class MaintenanceContactButtonsRow {
  Widget contactButtonsRow({
    required String email,
    required String phone,
    required BuildContext context,
    required LatLongPosition latLongPosition,
  }) {
    return Row(
      children: [
        _buildContactbutton(Icons.call, () async {
          final Uri launchUri = Uri(
            scheme: 'tel',
            path: phone,
          );
          await launchUrl(launchUri);
        }),
        _buildContactbutton(Icons.email, () async {
          final Uri emailLaunchUri = Uri(
            scheme: 'mailto',
            path: email,
          );

          await launchUrl(emailLaunchUri);
        }),
        _buildContactbutton(
            Icons.location_on,
            () => _openGoogleMaps(
                latitude: double.parse(latLongPosition.latitude ?? ""),
                longitude: double.parse(latLongPosition.longitude ?? ""))),
        _buildContactbutton(
            FontAwesomeIcons.whatsapp, () => _openWhatsApp(phone)),
        const Spacer(),
        _buildContactbutton(Icons.pin_drop, () {
          showConfirmationDialog(
              context: context,
              isDark: context.read(settingsViewModelProvider).isDark,
              onAccept: () {
                context.read(checkAndRepairViewModel).checkIn();
                Navigator.pop(context);
             sl<NavigationService>().navigateTo(checkAndRepair);
              },
              onError: () {},
              title: "you arrived".localized(),
              content: "want to check in".localized());
        }),
      ],
    );
  }

  Widget _buildContactbutton(IconData iconData, void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _openGoogleMaps(
      {required double latitude, required double longitude}) async {
    String googleUrl;
    if (Platform.isAndroid) {
      googleUrl =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    } else if (Platform.isIOS) {
      googleUrl = 'https://maps.apple.com/?q=$latitude,$longitude';
    } else {
      googleUrl =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    }

    final Uri googleMapsUrl = Uri.parse(googleUrl);

    await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
  }

  void _openWhatsApp(String phoneNumber) async {
    // Construct the WhatsApp URL
    final Uri whatsappUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: phoneNumber,
    );

    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  }
}
