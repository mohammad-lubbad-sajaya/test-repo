import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import '../../../../../core/services/configrations/general_configrations.dart';
import '../../../../../core/services/extentions.dart';
import '../../../../../core/utils/app_widgets/custom_app_text.dart';
import '../../../../../core/utils/app_widgets/custom_row_app.dart';
import '../../../../../core/utils/app_widgets/save_and_cancel_buttons.dart';
import '../../../../../core/utils/common_widgets/audio_player/audio_player_screen.dart';
import '../../../../../core/utils/common_widgets/custom_app_text_field.dart';
import '../../../../../core/utils/common_widgets/voice_recorder_sheet.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../procedure_information/procedure_information_screen.dart';
import '../procedure_place_view_model.dart';

meetingView({
  required BuildContext context,
  required bool isDark,
  required ProcedurePlaceViewModel viewModel,
 
}) {
  return Container(
    padding: const EdgeInsets.symmetric(
      vertical: 20,
      horizontal: 16,
    ),
    decoration: BoxDecoration(
      color: isDark ? darkModeBackGround : backGroundColor,
      borderRadius: const BorderRadius.all(Radius.circular(14)),
    ),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDark ? darkCardColor : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(14)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: viewModel.isTimerFinished
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                if (!viewModel.isEditProcedure &&!viewModel.isFromCheckAndRepair&&
                    !viewModel.isTimerFinished) ...[
                  customRowApp(
                    isDark: isDark,
                    isBold: true,
                    isTextField: true,
                    keyboardType: TextInputType.number,
                    text: "Duration".localized(),
                    subText: viewModel
                        .durationValue, //"${int.parse(viewModel.durationValue ?? "0")}",
                    onChanged: viewModel.durationText,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 2,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    child: Text(
                      viewModel.getTimerText(),
                      style: const TextStyle(
                        color: Color(0xffff830f),
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    viewModel.getElapsedText(),
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) => const Color(0xffffeed9),
                      ),
                    ),
                    child: Icon(
                      viewModel.isStopTimer
                          ? Icons.stop_circle
                          : Icons.play_circle,
                      color: const Color(0xffff830f),
                      size: 50,
                    ),
                    onPressed: () {
                      if (viewModel.isStopTimer) {
                        //  _buildClosingWayDialog(context, isDark, viewModel);
                        viewModel.timerFinished();
                        viewModel.stopTimer();
                      } else {
                        viewModel.startTimer();
                      }
                    },
                  ),
                ],

                if (!viewModel.isEditProcedure&&!viewModel.isFromCheckAndRepair) ...[
                 
                  addNewCheckBox(
                    isDark: isDark,
                    horizontal: 0,
                    value: viewModel.isAddNewProcedure,
                    onChanged: (value) {
                      viewModel.changeIsAddNewProcedure(value);
                    },
                  ),
                  customRowApp(
                    isDark: isDark,
                    isBold: false,
                    flex: 1,
                    text: "Duration".localized(),
                    subText: viewModel.durationValue ?? "",
                    maxLength: 7,
                  ),
                  const SizedBox(height: 10),
                ],
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: secondaryColor,
                      child: IconButton(
                        icon: const Icon(
                          Icons.voice_chat,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          showSheet(
                            VoiceRecorderSheet(
                              context: context,
                              voiceFileName:
                                  "${DateTime.now().microsecondsSinceEpoch}",
                              onSelected: (value) {
                                if (GeneralConfigurations().isDebug) {
                                  log("THIS==== METHOD=========IS==================== CALLED ===================================");
                                }
                                viewModel.getVoiceFile(value);
                                Navigator.of(context).pop();
                              },
                              onError: (value) {},
                            ),
                            context,
                            isDismissible: false,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    selectedAudiosListView(viewModel, isDark),
                    const SizedBox(height: 15),
                    Row(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: secondaryColor,
                          child: IconButton(
                            icon: const Icon(
                              Icons.upload_file,
                              color: Colors.white,
                            ),
                            onPressed: viewModel.selectImages,
                          ),
                        ),
                        const SizedBox(width: 10),
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: secondaryColor,
                          child: IconButton(
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              viewModel.captureImageOrViedo(isImage: true);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: secondaryColor,
                          child: IconButton(
                            icon: const Icon(
                              Icons.video_call,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              viewModel.captureImageOrViedo(isImage: false);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    selectedImagesListView(viewModel, isDark),
                    if (viewModel.isTimerFinished) ...[
                      const SizedBox(height: 20),
                      customTextApp(
                        color: isDark ? backGroundColor : Colors.black,
                        text: "Desc".localized(),
                        size: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 10),
                      customAppTextField(
                        textColor: isDark ? backGroundColor : Colors.black,
                        bgColor: isDark ? darkDialogsColor : textFieldBgColor,
                        isExpand: true,
                        textController: TextEditingController(
                          text: viewModel.noteValue,
                        ),
                        contentHorizontalPadding: 12,
                        fontSize: 12,
                        hintText: "".localized(),
                        onChanged: viewModel.noteText,
                        maxLength: 500,
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 20),
                if (viewModel.isTimerFinished || viewModel.isEditProcedure||viewModel.isFromCheckAndRepair) ...[
                  saveAndCancelButtons(
                    context,
                    viewModel.isLoadingAdress,
                    onSave: () {
                      if(viewModel.isFromCheckAndRepair){
                        Navigator.pop(context);
                      }else{
                      viewModel.save();
                      }
                    },
                    onCancel: () {
                      viewModel.isTimerFinished = false;
                      viewModel.stopTimer();
                      viewModel.changeSelectedTab(0);
                    },
                  ),
                ]
                //  ]
                //  else ...[
                // dropDownHorizontalButton(
                //   isBold: true,
                //   selectedColor: Colors.black,
                //   hintText: "Duration".localized(),
                //   selectedItem: viewModel.selectedDuration?.id,
                //   items: viewModel.durationnList,
                //   didSelectItem: (value) {
                //     viewModel.setSelectedDuration(value);
                //   },
                // ),

                // ],
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// _buildClosingWayDialog(
//     BuildContext context, bool isDark, ProcedurePlaceViewModel viewModel) {
//   showConfirmationDialog(
//       context: context,
//       barrierDismissible: false,
//       isDark: isDark,
//       title: "closing way".localized(),
//       contentWidget: Container(
//         color: isDark ? darkDialogsColor : Colors.white,
//         height: viewModel.isManual ? 220 : 140,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomRaisedButton(
//               child: customTextApp(
//                   text: "manual".localized(), color: Colors.white),
//               color: secondaryColor,
//               onTap: () {
//                 viewModel.changeIsManual(true);
//                 viewModel.changeIsResetManual(false);
//                 Navigator.pop(context);
//                 _buildClosingWayDialog(context, isDark, viewModel);
//               },
//               colors: const [secondaryColor, secondaryColor],
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             CustomRaisedButton(
//               child:
//                   customTextApp(text: "auto".localized(), color: Colors.white),
//               color: secondaryColor,
//               onTap: () {
//                 viewModel.changeIsResetManual(true);

//                 viewModel.changeIsManual(false);

//                 viewModel.timerFinished();
//                 viewModel.stopTimer();
//               },
//               colors: const [secondaryColor, secondaryColor],
//             ),
//             if (viewModel.isManual) ...[
//               const SizedBox(
//                 height: 10,
//               ),
//               customAppTextField(
//                   keyboardType: TextInputType.number,
//                   hintText: "duration in sec".localized(),
//                   textController: viewModel.durationController)
//             ],
//           ],
//         ),
//       ),
//       actions: [
//         if (viewModel.isManual) ...[
//           TextButton(
//               onPressed: () {
//                 viewModel.changeIsResetManual(true);

//                 viewModel.changeIsManual(false);

//                 viewModel.timerFinished(
//                     manualSec: int.parse(viewModel.durationController.text));
//                 viewModel.stopTimer();
//                 Navigator.pop(context);
//               },
//               child: Text("Enter".localized()))
//         ],
//         TextButton(
//           onPressed: () {
//             viewModel.changeIsResetManual(true);

//             viewModel.changeIsManual(false);
//             Navigator.pop(context);
//           },
//           child: customTextApp(
//               text: "Close".localized(),
//               color: isDark ? backGroundColor : primaryColor),
//         ),
//       ]);
// }

selectedAudiosListView(ProcedurePlaceViewModel viewModel, bool isDark) {
  return Container(
    //height: 120,
    padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
    decoration: BoxDecoration(
      border: Border.all(
        color: viewModel.allAudios.isNotEmpty
            ? Colors.transparent
            : isDark
                ? backGroundColor
                : Colors.black26,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(14)),
    ),
    child: viewModel.allAudios.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: customTextApp(
                text: "No sound recorded yet".localized(),
                size: 14,
                color: isDark ? backGroundColor : Colors.black54,
              ),
            ),
          )
        : ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: viewModel.allAudios.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return AudioPlayerScreen(viewModel.allAudios[index], () {
                viewModel.deleteVoice(index);
              });
            },
          ),
  );
}

selectedImagesListView(ProcedurePlaceViewModel viewModel, bool isDark) {
  return Container(
    height: 120,
    decoration: BoxDecoration(
      border: Border.all(
        color: viewModel.selectedFiles.isNotEmpty
            ? Colors.transparent
            : isDark
                ? backGroundColor
                : Colors.black26,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(14)),
    ),
    child: viewModel.selectedFiles.isEmpty
        ? Center(
            child: customTextApp(
              text: "No photos selected yet".localized(),
              size: 14,
              color: isDark ? backGroundColor : Colors.black54,
            ),
          )
        : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.selectedFiles.length,
            itemBuilder: (context, index) {
              if (viewModel.selectedFiles[index].path.getFileType() ==
                  FileTypeValue.video) {
                return FutureBuilder<Uint8List?>(
                  future: viewModel
                      .loadVideoThumbnail(viewModel.selectedFiles[index].path),
                  builder: (context, snapshot) {
                    return GestureDetector(
                      onTap: () {
                        OpenFile.open(viewModel.selectedFiles[index].path);
                      },
                      child: showAttachment(
                        child: (snapshot.data != null)
                            ? Image.memory(snapshot.data!)
                            : const Center(child: CircularProgressIndicator()),
                        onDeletePressed: () => viewModel.deleteImage(index),
                      ),
                    );
                  },
                );
              } else if (viewModel.selectedFiles[index].path.getFileType() ==
                  FileTypeValue.image) {
                return GestureDetector(
                    onTap: () {
                      OpenFile.open(viewModel.selectedFiles[index].path);
                    },
                    child: showAttachment(
                      child: Image.file(
                        viewModel.selectedFiles[index],
                      ),
                      onDeletePressed: () => viewModel.deleteImage(index),
                    ));
              } else {
                return GestureDetector(
                  onTap: () {
                    OpenFile.open(viewModel.selectedFiles[index].path);
                  },
                  child: showAttachment(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        border: Border.all(color: primaryColor, width: 2.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customTextApp(
                            size: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            text: viewModel.selectedFiles[index].path
                                .getFileExtension(),
                          ),
                          customTextApp(
                            maxLine: 2,
                            size: 12,
                            align: TextAlign.center,
                            color: Colors.white,
                            text: viewModel.selectedFiles[index].path
                                .getFileName(),
                          ),
                        ],
                      ),
                    ),
                    onDeletePressed: () => viewModel.deleteImage(index),
                  ),
                );
              }
            },
          ),
  );
}

showAttachment({
  required Widget child,
  required void Function()? onDeletePressed,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Stack(
          children: [
            child,
            Positioned(
              top: -10,
              right: -8,
              child: Container(
                width: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.delete_outlined,
                    size: 25,
                  ),
                  onPressed: onDeletePressed,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );

/// show sheet
void showSheet(Widget widget, BuildContext context,
    {bool isDismissible = true}) {
  showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isDismissible: isDismissible,
      builder: (BuildContext context) {
        return widget;
      });
}
