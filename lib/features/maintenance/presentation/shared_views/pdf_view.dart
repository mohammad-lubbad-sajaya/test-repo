import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import '../../../../core/services/routing/navigation_service.dart';
import '../../../../core/services/routing/routes.dart';
import '../../../../core/services/service_locator/dependency_injection.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/utils/theme/app_colors.dart';

class PdfViewScreen extends StatefulWidget {
  const PdfViewScreen({Key? key, required this.file}) : super(key: key);

  final File file;

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Preview"),
        actions: [
          IconButton(
              onPressed: () {
                sl<NavigationService>().navigateToAndReplace(tabBarScreen);
              },
              icon:const Icon(Icons.close))
        ],
      ),
      body: PDFView(
        filePath: widget.file.path,
        onViewCreated: (controller) {
          widget.file.readAsBytes();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: secondaryColor,
        child: const Center(
          child: Icon(
            Icons.share,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          Share.shareXFiles(
            [XFile(widget.file.path, name: "Receipt.pdf")],
          );
        },
      ),
    );
  }
}
