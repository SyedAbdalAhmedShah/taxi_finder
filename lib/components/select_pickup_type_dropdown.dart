import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:taxi_finder/blocs/user_map_bloc/shuttle_finder_bloc/bloc/shuttle_finder_bloc.dart';
import 'package:taxi_finder/constants/app_strings.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({super.key});

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  final List<String> dropdownItems = [
    pickMeUp,
    meetInTown,
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final shuttleFinderBloc = context.read<ShuttleFinderBloc>();
    return BlocBuilder<ShuttleFinderBloc, ShuttleFinderState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: shuttleFinderBloc
                  .pickUpFromMyLocation, // Currently selected value
              hint: Text("Select an option"), // Placeholder text
              icon: Icon(Icons.arrow_drop_down), // Dropdown arrow
              iconSize: 28,
              isExpanded: true, // Makes dropdown take full width
              borderRadius:
                  BorderRadius.circular(8.0), // Circular radius for dropdown
              style: TextStyle(
                  color: Colors.black, fontSize: 16), // Dropdown text style
              onChanged: (String? newValue) {
                shuttleFinderBloc.add(
                    PickMeUpFromMyLocationByUser(pickUpType: newValue ?? ""));
              },
              items: dropdownItems.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
