import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/utils/theme/app_colors.dart';

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
         
          Share.shareXFiles([XFile(widget.file.path, name: "Receipt.pdf")],
        
           
              );
        },
      ),
    );
  }
}
