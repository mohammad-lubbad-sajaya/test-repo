import 'package:flutter/material.dart';
import 'package:sajaya_general_app/features/shared_screens/allTabs/settings/settings_view_model.dart';

import '../../../../../core/services/extentions.dart';
import '../../../../../core/utils/theme/app_colors.dart';

class ServiceDetailsCard extends StatelessWidget {
  const ServiceDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Card(
        color: context.read(settingsViewModelProvider).isDark?darkCardColor:null,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
               "service request details".localized(),
                style:  TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: context.read(settingsViewModelProvider).isDark?backGroundColor: primaryColor, // Dark blue from the logo
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow("piece num".localized(), '12345',context),
              _buildDetailRow("piece name".localized(), "HP-VICTUS",context),
              _buildDetailRow("serial number".localized(), 'SN78901234',context),
              _buildDetailRow("Customer".localized(), 'محمد أحمد',context),
              _buildDetailRow("Address".localized(), 'شارع عبدالله غوشه',context),
              _buildDetailRow("required service".localized(), 'صيانة دورية',context),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: secondaryColor, // Dark blue from the logo
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style:  TextStyle(color: context.read(settingsViewModelProvider).isDark?backGroundColor: Color(0xFF4B5563)), // Dark gray
            ),
          ),
        ],
      ),
    );
  }
}