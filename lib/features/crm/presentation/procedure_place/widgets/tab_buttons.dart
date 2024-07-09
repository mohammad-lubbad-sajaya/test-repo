import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/images.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../procedure_place_view_model.dart';


tabButtons(
  ProcedurePlaceViewModel viewModel,
  BuildContext context,
  bool isDark
) =>
    Row(
      children: [
        if (viewModel.selectedTab != 5) ...[
          SizedBox(
            height: 80,
            width: 80,
            child: IconButton(
              icon: Image.asset(relodIcon,color: isDark?backGroundColor:null,),
              iconSize: 20,
              onPressed: () {
                viewModel.changeSelectedTab(0);
              },
            ),
          ),
          SizedBox(
            height: 80,
            width: 80,
            child: IconButton(
              icon: Image.asset(nearbyIcon,color: isDark?backGroundColor:null,),
              iconSize: 20,
              onPressed: () {
                viewModel.changeSelectedTab(1);
              },
            ),
          ),
          SizedBox(
            height: 80,
            width: 80,
            child: IconButton(
              icon: Image.asset(proceduresIcon,color: isDark?backGroundColor:null,),
              iconSize: 20,
              onPressed: () {
                viewModel.changeSelectedTab(2);
              },
            ),
          ),
          SizedBox(
            height: 80,
            width: 80,
            child: IconButton(
              icon: Image.asset(adressIcon,color: isDark?backGroundColor:null,),
              iconSize: 20,
              onPressed: () {
                viewModel.changeSelectedTab(3);
              },
            ),
          ),
        ],
        const Spacer(),
        InkWell(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: Image.asset(
              arrow,
              matchTextDirection: true,
              color: isDark?backGroundColor:null,
            ),
          ),
          onTap: () {
            if (viewModel.selectedTab != 5) {
              Navigator.maybePop(context);
            } else {
              viewModel.changeSelectedTab(0);
              viewModel.stopTimer();
            }
          },
        ),
      ],
    );
