import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_places_autocomplete_widgets/widgets/address_autocomplete_textfield.dart';
import 'package:taxi_finder/constants/app_colors.dart';
import 'package:taxi_finder/utils/api_keys.dart';

class AutoCompleteMapField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final FocusNode? focusNode;
  final String countryISO;
  final Function(Place)? onLocationSelected;
  const AutoCompleteMapField(
      {required this.controller,
      required this.countryISO,
      required this.hint,
      this.focusNode,
      this.onLocationSelected,
      super.key});

  @override
  Widget build(BuildContext context) {
    log("countryISO    === $countryISO");
    return AddressAutocompleteTextField(
      // onTapOutside: (event) => FocusScope.of(context).unfocus(),

      mapsApiKey: ApiKeys().placesApiKey,
      debounceTime: 400,
      maxLines: 1,
      onSuggestionClick: onLocationSelected,
      clearButton: const Icon(Icons.clear),
      // isLatLngRequired: true,
      // autocorrect: false,
      // keyboardAppearance: Brightness.dark,

      // getPlaceDetailWithLatLng: (p) {
      //   FocusScope.of(context).unfocus();
      //   controller.text = p.description ?? "";
      //   onLocationSelected ?? (p);
      // },
      // itmClick: (p) {
      //   FocusScope.of(context).unfocus();
      //   controller.text = p.description!;
      //   controller.selection = TextSelection.fromPosition(
      //       TextPosition(offset: p.description?.length ?? 0));
      // },
      componentCountry: countryISO,
      controller: controller,

      focusNode: focusNode,
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: textColorSecondary),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          )),
    );
  }
}
