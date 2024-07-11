import 'package:flutter/material.dart';

import '../../../../../core/services/extentions.dart';
import '../../../../../core/utils/theme/app_colors.dart';

class ServiceDetailsCard extends StatelessWidget {
  const ServiceDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Card(
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
                style:const  TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor, // Dark blue from the logo
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow("piece num".localized(), '12345'),
              _buildDetailRow("piece name".localized(), "HP-VECTOS"),
              _buildDetailRow("serial number".localized(), 'SN78901234'),
              _buildDetailRow("Customer".localized(), 'محمد أحمد'),
              _buildDetailRow("Address".localized(), 'شارع عبدالله غوشه'),
              _buildDetailRow("required service".localized(), 'صيانة دورية'),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
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
              style: const TextStyle(color: Color(0xFF4B5563)), // Dark gray
            ),
          ),
        ],
      ),
    );
  }
}