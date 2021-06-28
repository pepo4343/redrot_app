import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/presentation/logic/cubit/edit_redrot/edit_redrot_cubit.dart';
import 'package:redrotapp/presentation/widgets/secondary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'confirm_button.dart';

class ButtonsEditContainer extends StatelessWidget {
  const ButtonsEditContainer({
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
        Builder(
          builder: (context) {
            final state = context.watch<EditRedrotCubit>().state;
            if (state is EditRedrotSuccess) {
              return SecondaryButton(onPressed: onCancel, text: "ย้อนกลับ");
            }
            return SecondaryButton(onPressed: onCancel, text: "ยกเลิก");
          },
        ),
        SizedBox(
          width: Sizes.dimen_16,
        ),
        Builder(builder: (context) {
          final state = context.watch<EditRedrotCubit>().state;
          ConfirmButtonState _buttonState = ConfirmButtonState.Active;

          if (state is EditRedrotInitial) {
            _buttonState = ConfirmButtonState.Disable;
          }
          if (state is EditRedrotReady) {
            _buttonState = ConfirmButtonState.Active;
          }
          if (state is EditRedrotInProgress) {
            _buttonState = ConfirmButtonState.Fetching;
          }
          if (state is EditRedrotSuccess) {
            _buttonState = ConfirmButtonState.Confirmed;
          }
          if (state is EditRedrotFailure) {
            _buttonState = ConfirmButtonState.Failure;
          }
          return ConfirmButton(
            state: _buttonState,
            onPressed: () async {
              if (state is EditRedrotReady) {
                context.read<EditRedrotCubit>().edit(
                      state.redrotId,
                      state.nodalTransgression,
                      state.lesionWidth,
                      state.color,
                    );
              }
            },
            prefix: "บันทึก",
          );
        })
      ],
    );
  }
}
