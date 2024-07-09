


import 'package:flutter/material.dart';
import '../../services/extentions.dart';

import '../../../features/crm/presentation/procedure_place/procedure_place_view_model.dart';
import '../theme/app_colors.dart';


showConfirmationDialog({
  required BuildContext context,
  String title = "",
  String content = "",
  Widget? contentWidget,
  bool isDark=false,
  bool barrierDismissible = true,
  String textButton = "yes",
  Function()? onAccept,
  List<Widget>? actions,
  Function()? onError,
}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        onPopInvoked: (pop)  { 
          if(context.read(procedurePlaceViewModelProvider).isResetManual){
          context.read(procedurePlaceViewModelProvider).changeIsManual(false);
          }
          Future.value(false);},
        child: AlertDialog(
        
          backgroundColor: isDark?darkDialogsColor:Colors.white,
          title: Text(title,style: TextStyle(color: isDark?backGroundColor:Colors.black),),
          content:contentWidget?? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(content,style: TextStyle(color: isDark?backGroundColor:Colors.black),),
            ],
          ),
          actions:actions?? <Widget>[
            if (barrierDismissible) ...[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                  if (onError != null) {
                    onError();
                  }
                },
                child: Text("no".localized(),style: TextStyle(color: isDark?backGroundColor:Colors.black),),
              ),
            ],
            TextButton(
              onPressed: onAccept,
              child: Text(textButton.localized(),style: TextStyle(color: isDark?backGroundColor:Colors.black),),
            ),
          ],
        ),
      );
    },
  );
}
