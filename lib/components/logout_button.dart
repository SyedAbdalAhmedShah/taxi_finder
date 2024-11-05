import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_finder/blocs/auth_bloc/auth_bloc.dart';
import 'package:taxi_finder/utils/extensions.dart';
import 'package:taxi_finder/views/bridge/bridge.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is SuccessfullySignOut) {
                context.pushAndRemoveUntil(const BridgeScreen());
              }
            },
            child: IconButton(
                onPressed: () {
                  context.read<AuthBloc>().add(SignouEvent());
                },
                icon: const Icon(Icons.logout)),
          );
  }
}