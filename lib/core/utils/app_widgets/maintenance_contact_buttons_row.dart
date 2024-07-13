import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_colors.dart';
import 'package:trust_location/trust_location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class MaintenanceContactButtonsRow {
  Widget contactButtonsRow({
    required String email,
    required String phone,
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
        _buildContactbutton( FontAwesomeIcons.whatsapp, () => _openWhatsApp(phone)),
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
