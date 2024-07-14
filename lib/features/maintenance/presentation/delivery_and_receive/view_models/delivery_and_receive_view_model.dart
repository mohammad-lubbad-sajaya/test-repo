import "dart:io";
import 'dart:typed_data';

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sajaya_general_app/core/services/extentions.dart';
import 'package:signature/signature.dart';

import '../../check_and_repair/view_model/check_repair_view_model.dart';
import '../../shared_views/pdf_view.dart';

final deliveryAndReceiveViewModel =
    ChangeNotifierProvider.autoDispose((ref) => DeliveryAndReceiveViewModel());

class DeliveryAndReceiveViewModel extends ChangeNotifier {
  TabController? tabController;
  final pieceTextController = TextEditingController();
  final serialNumTextController = TextEditingController();
  final nameTextController = TextEditingController();
  final noteTextControllere = TextEditingController();
  final pieceFocusNode = FocusNode();
  final serialNumFocusNode = FocusNode();
  final nameFocusNode = FocusNode();
  final notesFocusNode = FocusNode();
  final List<String> equipments = ['حاسوب مكتبي', 'لابتوب', 'طابعة'];
  final List<String> accessory = ['لوحة مفاتيح وفأرة', 'شاشة', 'سماعات'];
  final List<String> workers = ["محمد لبد", "أحمد فرهودة", "بشار اليحيى"];
  String? selectedEquipmentType;
  String? selectedAccessory1;
  String? workerName;
  String serialNumber = '';
  String notes = '';
  String receivedBy = '';
  String customerName = '';
  int tabIndex = 0;
  File? pdfFile;
  bool isLoading = false;
  bool isChecked = false;
  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
  );
  initTabController(TickerProvider tickerProvider, int initialIndex) {
    tabController = TabController(
        length: 2, vsync: tickerProvider, initialIndex: initialIndex);
    changeTabIndex(initialIndex);
  }

  changeLoadingState() {
    isLoading = !isLoading;
    notifyListeners();
  }

  setCustomerName(String name) {
    customerName = name;
    notifyListeners();
  }

  changeTabIndex(int val) {
    tabIndex = val;
    notifyListeners();
  }

  changeSelectedEquipmentType(String val) {
    selectedEquipmentType = val;
    notifyListeners();
  }

  changeSelectedAccessory1(String val) {
    selectedAccessory1 = val;
    notifyListeners();
  }

  changeWorkerName(String val) {
    workerName = val;
    notifyListeners();
  }

  onCheck(bool val) {
    isChecked = val;
    notifyListeners();
  }

  Future<void> generatePDF(Uint8List? signature, BuildContext context) async {
    changeLoadingState();
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Delivary Document"),
              pw.SizedBox(height: 50),
              pw.Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
              pw.SizedBox(height: 50),
              pw.Text(nameTextController.text),
              pw.SizedBox(height: 20),
              signature == null
                  ? pw.Container()
                  : pw.Image(pw.MemoryImage(signature),
                      width: 200, height: 100),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    pdfFile = File("${output.path}/Receipt.pdf");
    await pdfFile?.writeAsBytes(await pdf.save()).then((value) {
      changeLoadingState();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewScreen(file: value),
        ),
        (route) => false,
      );
      
      context.read(checkAndRepairViewModel).disposeData();
    });
  }
}
