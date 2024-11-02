import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_finder/blocs/user_map_bloc/user_map_bloc.dart';
import 'package:taxi_finder/components/app_text_field.dart';

class AutoComExampple extends StatelessWidget {
  const AutoComExampple({super.key});

  @override
  Widget build(BuildContext context) {
    UserMapBloc userMapBloc = context.read<UserMapBloc>();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<UserMapBloc, UserMapState>(
            builder: (context, state) {
              return Autocomplete(
                // fieldViewBuilder: (context, textEditingController, focusNode,
                //     onFieldSubmitted) {
                //   return AppTextField(
                //       fillColor: Colors.white,
                //       hintText: "Destination",
                //       controller: textEditingController);
                // },
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return <String>[];
                  } else {
                    // userMapBloc.add(
                    //     OnLocationSearchEvent(query: textEditingValue.text));
                    // return <Prediction>[...userMapBloc.searchLocations];
                    return <String>["Bag", "boll", "abdal"];
                  }
                },
              );
            },
          )
        ],
      ),
    );
  }
}
