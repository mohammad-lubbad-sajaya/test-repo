 import"package:flutter/material.dart";
import "package:sajaya_general_app/core/services/extentions.dart";
import "package:sizer/sizer.dart";

import "../../../features/crm/data/models/check_repair_model.dart";
import "../theme/app_colors.dart";
import "custom_app_text.dart";
 
 Widget buildCheckRepairProcedureCard(CheckRepairModel? _object, bool _isDark,{List<Widget>?childrenList}) {
    return SizedBox(
      width: 100.w,
      child: Card(
                color: Colors.grey[200],
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:childrenList??
                       [
                      customTextApp(
                        color: secondaryColor,
                        size: 22,
                        fontWeight: FontWeight.bold,
                        text: _object!.serviceType,
                      ),
                      customTextApp(
                        color: _isDark ? backGroundColor : Colors.black,
                        size: 15,
                        fontWeight: FontWeight.w500,
                        text: _object.serviceLocation,
                      ),
                      customTextApp(
                        color: _isDark ? backGroundColor : Colors.black,
                        size: 15,
                        fontWeight: FontWeight.w500,
                        text: _object.action,
                      ),
                      customTextApp(
                        color: _isDark ? backGroundColor : Colors.black,
                        size: 15,
                        fontWeight: FontWeight.w500,
                        text: _object.startDate
                            .toStringFormat("yyyy-MM-ddTHH:mm:ss"),
                      ),
                      customTextApp(
                        color: _isDark ? backGroundColor : Colors.black,
                        size: 15,
                        fontWeight: FontWeight.w500,
                        text: _object.endDate
                            .toStringFormat("yyyy-MM-ddTHH:mm:ss"),
                      )
                    ],
                    
      
                  ),
                ),
              ),
    );
  }