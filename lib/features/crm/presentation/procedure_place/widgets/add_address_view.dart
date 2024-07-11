import 'package:flutter/material.dart';
import '../../../../../core/services/extentions.dart';

import '../../../../../core/utils/app_widgets/custom_row_app.dart';
import '../../../../../core/utils/app_widgets/drop_horizontal_down_button.dart';
import '../../../../../core/utils/app_widgets/save_and_cancel_buttons.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../../shared_screens/allTabs/inquiry/filter_inquiry/filter_inquiry_screen.dart';
import '../procedure_place_view_model.dart';

addAddressView({
  required BuildContext context,
  required bool isDark,
  required ProcedurePlaceViewModel viewModel,
}) =>
    Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ),
      decoration:  BoxDecoration(
        color:isDark?darkModeBackGround: backGroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(14)),
      ),
      child: Column(
        children: [
          sectionTitle(
            isDark: isDark,
            title: viewModel.isEditAdress
                ? "Edit Address".localized()
                : "Add Address".localized(),
          ),
          Container(
            decoration:  BoxDecoration(
              color:isDark?darkCardColor: Colors.white,
              borderRadius:const  BorderRadius.all(Radius.circular(14)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Column(
                children: [
                  customRowApp(
                    isDark: isDark,
                    flex: 1,
                    isBold: true,
                    isTextField: true,
                    text: "Arabic Name".localized(),
                    subText: viewModel.nameA ?? "",
                    onChanged: viewModel.nameAText,
                  ),
                  customRowApp(
                                        isDark: isDark,

                    flex: 1,
                    isBold: true,
                    isTextField: true,
                    text: "English Name".localized(),
                    subText: viewModel.nameE ?? "",
                    onChanged: viewModel.nameEText,
                  ),
                  dropDownHorizontalButton(
                                        isDark: isDark,

                    isBold: true,
                    selectedColor: Colors.black,
                    hintText: "Country".localized(),
                    selectedItem: viewModel.selectedCountry?.id,
                    items: viewModel.countriesDropDownList,
                    didSelectItem: (value) {
                      viewModel.setSelectedCountry(value);
                    },
                  ),
                  dropDownHorizontalButton(
                                        isDark: isDark,

                    isBold: true,
                    selectedColor: Colors.black,
                    hintText: "City".localized(),
                    selectedItem: viewModel.selectedCity?.id,
                    items: viewModel.citiesDropDownList,
                    didSelectItem: (value) {
                      viewModel.setSelectedCity(value);
                    },
                  ),
                  dropDownHorizontalButton(
                                        isDark: isDark,

                    isBold: true,
                    selectedColor: Colors.black,
                    hintText: "Area".localized(),
                    selectedItem: viewModel.selectedArea?.id ?? "",
                    items: viewModel.areasDropDownList,
                    didSelectItem: (value) {
                      viewModel.setSelectedArea(value);
                    },
                  ),
                  customRowApp(
                                        isDark: isDark,

                    flex: 1,
                    isBold: true,
                    text: "North Coordinates".localized(),
                    subText: viewModel.isEditAdressLocation
                        ? viewModel.currentLocation?.latitude.toString() ?? ""
                        : viewModel.selectedCustomerAddress?.locationNorth ??
                            "",
                  ),
                  customRowApp(
                                        isDark: isDark,

                    flex: 1,
                    isBold: true,
                    text: "East Coordinates".localized(),
                    subText: viewModel.isEditAdressLocation
                        ? viewModel.currentLocation?.longitude.toString() ?? ""
                        : viewModel.selectedCustomerAddress?.locationEast ?? "",
                    hideSeparator: true,
                  ),
                ],
              ),
            ),
          ),
          saveAndCancelButtons(
            context,
            viewModel.isLoadingAdress,
            onSave: () {
              if (!viewModel.isLoadingAdress) {
                viewModel.editOrAddnew();
              }
            },
            onCancel: () {
              viewModel.changeSelectedTab(0);
            },
          ),
        ],
      ),
    );
