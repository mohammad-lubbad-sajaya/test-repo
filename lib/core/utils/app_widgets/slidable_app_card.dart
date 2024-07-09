import 'package:flutter/material.dart';
import '../../services/extentions.dart';
import '../../../features/crm/data/models/procedure.dart';

import '../../../features/crm/data/models/service_request.dart';
import 'app_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Widget slidable({
  Procedure? obj,
  bool isSelected = false,
  bool isTimerIcon = true,
  required bool isDark,
  double horizontal = 20.0,
  Function()? ontap,
  Function()? onTimerTap,
  Function(BuildContext)? editFunc,
  Function(BuildContext)? confirmFunc,
  Function(BuildContext)? closeFunc,
}) =>
    Slidable(
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),

      // The start action pane is the one at the left or the top side.
      startActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),

        // A pane can dismiss the Slidable.
        // dismissible: DismissiblePane(
        //   closeOnCancel: true,
        //   motion: const ScrollMotion(),
        //   confirmDismiss: () {
        //     return Future.value(false);
        //   },
        //   onDismissed: () {
        //     editFunc;
        //   },
        // ),

        // All actions are defined in the children parameter.
        children: [
          SlidableAction(
            onPressed: editFunc,
            backgroundColor: const Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit'.localized(),
          ),
        ],
      ),

      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        // dismissible: DismissiblePane(
        //   closeOnCancel: true,
        //   motion: const ScrollMotion(),
        //   confirmDismiss: () {
        //     return Future.value(false);
        //   },
        //   onDismissed: () {
        //     editFunc;
        //   },
        // ),
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: closeFunc,
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.close,
            label: 'Cancel'.localized(),
          ),
          SlidableAction(
            // An action can be bigger than the others.
            //flex: 2,

            onPressed: confirmFunc,
            backgroundColor: const Color.fromARGB(255, 74, 201, 255),
            foregroundColor: Colors.white,
            icon: Icons.check_box_outlined,
            label: 'Close'.localized(),
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: appCard(
        obj: obj,
        isDark: isDark,
        isTimerIcon: isTimerIcon,
        horizontal: horizontal,
        onTimerTap: onTimerTap,
        isSelected: isSelected,
        ontap: ontap,
      ),
    );

    Widget serviceRequestSlidable({
  ServiceRequest? obj,
  bool isSelected = false,
  required bool isDark,
  double horizontal = 20.0,
  Function()? ontap,
  Function()? onRepairTap,
  Function(BuildContext)? editFunc,
  Function(BuildContext)? deliveryAndCollectionFun,
}) =>
    Slidable(
      key: const ValueKey(0),
      // The start action pane is the one at the left or the top side.
      startActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),   
        children: [
          SlidableAction(
            onPressed: editFunc,
            backgroundColor: const Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit'.localized(),
          ),
        ],
      ),
      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed:deliveryAndCollectionFun  ,
            backgroundColor:  const Color.fromARGB(255, 74, 201, 255),
            foregroundColor: Colors.white,
            label: 'Delivery and Receive'.localized(),
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child:
       appCard(
        servObj: obj,
        isDark: isDark,
        horizontal: horizontal,
        isSelected: false,
        isTimerIcon: false,
        ontap: (){},
      ),
    );
