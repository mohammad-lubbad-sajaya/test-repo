import 'package:flutter/material.dart';
import '../../services/app_translations/app_translations.dart';
import 'package:sizer/sizer.dart';

import '../../../features/crm/data/models/drop_down_obj.dart';
import '../theme/app_colors.dart';
import 'custom_app_text.dart';

// Widget dropDownHorizontalButton({
//   double? height,
//   double? width,
//   String? hintText,
//   bool isDark=false,
//   Color backgroundColor = Colors.white,
//   required List<DropdownObj>? items,
//   String? selectedItem,
//   double horizontalPadding = 0,
//   bool isEnabled = true,
//   bool isBold = false,
//   Color? selectedColor,
//   Color? separatorColor,
//   bool hideSeparator = true,
//   required Function(String?) didSelectItem,
//   void Function()? onTap,
// }) =>
//     Container(
//         height: 60,
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               customTextApp(
//                 text: hintText ?? "-",
//                 size: 16,
//                 color: isDark?backgroundColor:Colors.black,
//                 fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: horizontalPadding, vertical: 6),
//                   height: height ?? 31,
//                   // width: width,
//                   decoration: const BoxDecoration(
//                     //color:isDark?darkDialogsColor: backgroundColor,
//                     borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       dropdownColor: isDark?darkCardColor:null,
//                       enableFeedback: isEnabled,
//                       isExpanded: true,
//                       value: selectedItem,

//                       elevation: 4,
//                       borderRadius: const BorderRadius.all(Radius.circular(16.0)),
//                       icon: Image.asset(
//                         color: isDark?backGroundColor:Colors.black,
//                         downArrow,
//                         width: 9,
//                       ),
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.normal,
//                         color: selectedColor ?? subTitleColor,
//                       ),
//                       items: items
//                           ?.map<DropdownMenuItem<String>>((DropdownObj value) {
//                         return DropdownMenuItem<String>(
//                           enabled: isEnabled,
//                           value: value.id,
//                           child: Row(
//                             children: [
//                               //const Spacer(),
//                               Expanded(
//                                 child: customTextApp(
//                                   align: isEnglish()
//                                       ? TextAlign.right
//                                       : TextAlign.left,
//                                   maxLine: 3,
//                                   text: value.name ?? "",
//                                   size: 14,
//                                   fontWeight: FontWeight.normal,
//                                   color:isDark?backGroundColor: selectedColor ?? subTitleColor,

//                                   //selectedItem == value.id
//                                   //  ? primaryColor
//                                   // : textFiledBackgroundColor,
//                                 ),
//                               ),
//                               const SizedBox(width: 4),
//                             ],
//                           ),
//                         );
//                       }).toList(),
//                       onChanged: didSelectItem,

//                       onTap: onTap,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           // if (hideSeparator == false) ...[
//           //   const SizedBox(height: 8),
//           //   Container(
//           //     height: 0.5,
//           //     color: separatorColor ?? lineColor,
//           //   ),
//           //   const SizedBox(height: 4),
//           // ],
//         ],
//       ),
//     );
dropDownHorizontalButton({
  double? height,
  double? width,
  String? hintText,
  bool isDark = false,
  bool isIgnore = false,
  Color backgroundColor = Colors.white,
  required List<DropdownObj>? items,
  String? selectedItem,
  double horizontalPadding = 0,
  bool isEnabled = true,
  bool isBold = false,
  Color? selectedColor,
  Color? separatorColor,
  bool hideSeparator = true,
  required Function(String?) didSelectItem,
  void Function()? onTap,
}) {
  return Container(
    height: 50,
    width: 100.w,
    margin: const EdgeInsets.symmetric(vertical: 10),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(8),
    ),
    child: IgnorePointer(
      ignoring: isIgnore,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration.collapsed(hintText: ''),
          value: selectedItem,
          iconEnabledColor: isIgnore ? Colors.grey : null,
          hint: Text(
            hintText ?? "",
            style: const TextStyle(fontSize: 13),
          ),
          items: items?.map((DropdownObj item) {
            return DropdownMenuItem<String>(
              value: item.id,
              child: SizedBox(
                width: 300,
                child: Align(
                  alignment: isEnglish() ?Alignment.centerLeft: Alignment.centerRight,
                  child: customTextApp(
                    align: isEnglish() ? TextAlign.right : TextAlign.left,
                    maxLine: 3,
                    text: item.name ?? "",
                    size: 14,
                    fontWeight: FontWeight.normal,
                    color: isDark
                        ? backGroundColor
                        : selectedColor ?? subTitleColor,
                  
                    //selectedItem == value.id
                    //  ? primaryColor
                    // : textFiledBackgroundColor,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: didSelectItem,
          onTap: onTap,
        ),
      ),
    ),
  );
}
