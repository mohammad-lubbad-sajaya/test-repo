import "package:flutter/material.dart";

import "../theme/app_colors.dart";

floatingActionButton({required void Function()? onPressed}) {
  return SizedBox(
    width: 60.0,
    height: 60.0,
    child: FloatingActionButton(
      backgroundColor: secondaryColor,
      onPressed: onPressed,
      child: const Icon(Icons.add),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        side: BorderSide(color: Colors.white, width: 5),
      ),
      splashColor: primaryColor,
      elevation: 3.0,
    ),
  );
}
