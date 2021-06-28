import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/common/enum.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/presentation/journeys/redrot_detail/confirm_button.dart';
import 'package:redrotapp/presentation/logic/cubit/confirm_redrot/confirm_redrot_cubit.dart';
import 'package:redrotapp/presentation/widgets/secondary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonsConfirmContainer extends StatelessWidget {
  const ButtonsConfirmContainer({
    Key? key,
    required this.onCancel,
    required this.redrot,
  }) : super(key: key);
  final VoidCallback onCancel;
  final RedrotEntity redrot;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SecondaryButton(onPressed: onCancel, text: "แก้ไข"),
        SizedBox(
          width: Sizes.dimen_16,
        ),
        Builder(builder: (context) {
          final confirmState = context.watch<ConfirmRedrotCubit>().state;
          ConfirmButtonState buttonState = ConfirmButtonState.Active;

          if (confirmState is ConfirmRedrotInitial) {
            buttonState = ConfirmButtonState.Active;
          }
          if (confirmState is ConfirmRedrotFetchInprogress) {
            buttonState = ConfirmButtonState.Fetching;
          }
          if (confirmState is ConfirmRedrotFetchFailure) {
            buttonState = ConfirmButtonState.Failure;
          }
          if (redrot.status == ProcessStatus.Completed) {
            buttonState = ConfirmButtonState.Confirmed;
          }
          if (redrot.status == ProcessStatus.Error) {
            buttonState = ConfirmButtonState.Disable;
          }

          return ConfirmButton(
            state: buttonState,
            onPressed: () async {
              if (buttonState == ConfirmButtonState.Active) {
                context.read<ConfirmRedrotCubit>().confirm(redrot.redrotId);
              }
            },
          );
        })
      ],
    );
  }
}
