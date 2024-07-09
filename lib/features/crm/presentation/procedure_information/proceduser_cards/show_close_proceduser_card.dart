import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/services/extentions.dart';

import '../../../../../core/services/app_translations/app_translations.dart';
import '../../../../../core/utils/app_widgets/custom_app_text.dart';
import '../../../../../core/utils/app_widgets/custom_row_app.dart';
import '../../../../../core/utils/app_widgets/drop_horizontal_down_button.dart';
import '../../../../../core/utils/common_widgets/custom_app_text_field.dart';
import '../../../../../core/utils/constants/images.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../data/models/procedure.dart';
import '../procedure_information_view_model.dart';


class ShowCloseProcedureCard extends StatefulWidget {
  const ShowCloseProcedureCard({
    super.key,
    required this.obj,
    required this.isDark,
  });

  final Procedure? obj;
final bool isDark;
  @override
  State<ShowCloseProcedureCard> createState() => _ShowCloseProcedureCardState();
}

class _ShowCloseProcedureCardState extends State<ShowCloseProcedureCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final viewModel = ref.watch(procInfoViewModelProvider);
        return Container(
          decoration:  BoxDecoration(
            color:widget.isDark? darkCardColor:Colors.white,
            borderRadius:const  BorderRadius.all(Radius.circular(14)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    viewModel.selectDateTime(context);
                  },
                  child: customRowApp(
                    isDark: widget.isDark,
                    text: "Date and time".localized(),
                    subText: viewModel.selectedDateTime
                        .toStringFormat("hh:mm:ss dd/MM/yyyy"),
                    subTitleTextColor: Colors.black,
                    image: downArrow,
                    imageWidth: 9,
                  ),
                ),
                if (widget.obj?.eventId != null) ...[
                  customRowApp(
                                        isDark: widget.isDark,

                    text: "Proc No".localized(),
                    subText: widget.obj?.eventId?.toString(),
                  ),
                ],
                customRowApp(
                                      isDark: widget.isDark,

                  text: "User".localized(),
                  subText: widget.obj?.enteredByUser,
                ),
                customRowApp(
                                      isDark: widget.isDark,

                  text: "Repres".localized(),
                  subText: isEnglish()
                      ? widget.obj?.representiveNameE
                      : widget.obj?.representiveNameA,
                ),
                customRowApp(
                                      isDark: widget.isDark,

                  text: "Cust".localized(),
                  subText: isEnglish()
                      ? widget.obj?.custNameE
                      : widget.obj?.custNameA,
                  image:
                      (widget.obj?.isWalkIn ?? false) ? bodyWalkIcon : bodyIcon,
                  imageWidth: 16,
                ),
                customRowApp(
                                      isDark: widget.isDark,

                  text: "Address".localized(),
                  subText: isEnglish()
                      ? widget.obj?.addressNameE
                      : widget.obj?.addressNameA,
                ),
                customRowApp(
                                      isDark: widget.isDark,

                  text: "Contact".localized(),
                  subText: widget.obj?.contactPerson,
                ),
                dropDownHorizontalButton(
                                      isDark: widget.isDark,

                  isBold: true,
                  selectedColor: Colors.black,
                  hintText: "Type".localized(),
                  selectedItem: viewModel.selectedType,
                  items: viewModel.typesDropDownList,
                  didSelectItem: (value) {
                    viewModel.setSelectedType(value);
                  },
                ),
                dropDownHorizontalButton(
                                      isDark: widget.isDark,

                  isBold: true,
                  selectedColor: Colors.black,
                  hintText: "Nature".localized(),
                  selectedItem: viewModel.selectedNature,
                  items: viewModel.natureDropDownList,
                  didSelectItem: (value) {
                    viewModel.setSelectedNature(value);
                  },
                ),
                customRowApp(
                                      isDark: widget.isDark,

                  isBold: true,
                  keyboardType: TextInputType.number,
                  isTextField: true,
                  text: "Duration".localized(),
                  subText:
                      widget.obj?.eventDuration?.toInt().toString() ?? "60",
                  onChanged: viewModel.durationText,
                  maxLength: 7,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customTextApp(
                      color: widget.isDark?backGroundColor:Colors.black,
                      text: "Desc".localized(),
                      size: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    customAppTextField(
                      bgColor: widget.isDark?darkDialogsColor:textFieldBgColor,
                      textColor:widget.isDark?backGroundColor:Colors.black ,
                      isExpand: true,
                      textController: TextEditingController(
                        text: widget.obj?.eventDesc,
                      ),
                      contentHorizontalPadding: 12,
                      fontSize: 12,
                      //initialValue: widget.obj?.eventDesc,
                      hintText: "".localized(),
                      onChanged: viewModel.noteText,
                      maxLength: 500,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
