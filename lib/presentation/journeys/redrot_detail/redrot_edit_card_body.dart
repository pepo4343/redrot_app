import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/presentation/journeys/redrot_detail/redrot_detail_divider.dart';
import 'package:redrotapp/presentation/logic/cubit/edit_redrot/edit_redrot_cubit.dart';
import 'package:redrotapp/presentation/widgets/secondary_button.dart';
import 'package:redrotapp/presentation/widgets/tap_detector.dart';
import '../../themes/app_theme.dart';
import 'cane.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RedrotEditCardBody extends StatefulWidget {
  RedrotEditCardBody({
    Key? key,
    required this.initialNode,
    required this.initialSpread,
    required this.initialColor,
    required this.redrotEntity,
  }) : super(key: key);

  final int initialNode;
  final double initialSpread;
  final int initialColor;
  final RedrotEntity redrotEntity;

  @override
  _RedrotEditCardBodyState createState() => _RedrotEditCardBodyState();
}

class _RedrotEditCardBodyState extends State<RedrotEditCardBody> {
  late int _node = widget.initialNode;

  late double _spread = widget.initialSpread / 100;

  late int _color = widget.initialColor;

  String get _percentText => (_spread * 100).toStringAsFixed(0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Cane(
            color: _color.toDouble(),
            node: _node.toDouble(),
            spread: _spread * 100,
            isShowCase: false,
          ),
          RedrotDetailDivider(
            title: "จำนวนข้อ",
          ),
          SizedBox(
            height: Sizes.dimen_16,
          ),
          NodeButtonsContainer(
            onSelected: (double node) {
              setState(() {
                _node = node.toInt();
              });
              _updateState();
            },
            initialNode: widget.initialNode,
          ),
          SizedBox(
            height: Sizes.dimen_16,
          ),
          RedrotDetailDivider(
            title: "ความกว้างแผล",
          ),
          SizedBox(
            height: Sizes.dimen_16,
          ),
          Container(
            height: 56,
            child: Text(
              "$_percentText%",
              style: theme.textTheme.headline2!.copyWith(
                height: 1.25,
                fontWeight: FontWeight.w300,
                color: theme.colorScheme.secondaryTextColor,
              ),
            ),
          ),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
            ),
            child: Slider(
              value: _spread,
              onChanged: (value) {
                setState(() {
                  _spread = value;
                });
                _updateState();
              },
              inactiveColor: theme.colorScheme.whisperColor,
              activeColor: theme.colorScheme.secondary,
            ),
          ),
          RedrotDetailDivider(
            title: "สีบาดแผล",
          ),
          SizedBox(
            height: Sizes.dimen_16,
          ),
          ColorButtonsContainer(
            onSelected: (double node) {
              setState(() {
                _color = node.toInt();
              });
              _updateState();
            },
            initialColor: widget.initialColor,
          ),
        ],
      ),
    );
  }

  void _updateState() {
    context.read<EditRedrotCubit>().set(
          widget.redrotEntity.redrotId,
          _node,
          _spread * 100,
          _color,
        );
  }
}

class NodeButtonsContainer extends StatefulWidget {
  NodeButtonsContainer(
      {Key? key, required this.onSelected, required this.initialNode})
      : super(key: key);
  final Function(double) onSelected;
  final int initialNode;
  @override
  _NodeButtonsContainerState createState() => _NodeButtonsContainerState();
}

class _NodeButtonsContainerState extends State<NodeButtonsContainer> {
  late int selectedNode = widget.initialNode;

  void _onPressed(int node) {
    setState(() {
      selectedNode = node;
    });
    widget.onSelected(node.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SelectButton(
            isSelected: selectedNode == 0,
            onPressed: () => _onPressed(0),
            text: "0",
          ),
        ),
        SizedBox(
          width: Sizes.dimen_8,
        ),
        Expanded(
          child: SelectButton(
            isSelected: selectedNode == 1,
            onPressed: () => _onPressed(1),
            text: "1",
          ),
        ),
        SizedBox(
          width: Sizes.dimen_8,
        ),
        Expanded(
          child: SelectButton(
            isSelected: selectedNode == 2,
            onPressed: () => _onPressed(2),
            text: "2",
          ),
        ),
        SizedBox(
          width: Sizes.dimen_8,
        ),
        Expanded(
          child: SelectButton(
            onPressed: () => _onPressed(3),
            isSelected: selectedNode == 3,
            text: "3",
          ),
        )
      ],
    );
  }
}

class ColorButtonsContainer extends StatefulWidget {
  ColorButtonsContainer({
    Key? key,
    required this.onSelected,
    required this.initialColor,
  }) : super(key: key);
  final Function(double) onSelected;
  final int initialColor;
  @override
  _ColorButtonsContainerState createState() => _ColorButtonsContainerState();
}

class _ColorButtonsContainerState extends State<ColorButtonsContainer> {
  late int selectedButton = widget.initialColor;
  void _onPressed(int node) {
    setState(() {
      selectedButton = node;
    });
    widget.onSelected(node.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SelectButton(
            isSelected: selectedButton == 0,
            style: SelectButtonStyle.Disable,
            onPressed: () => _onPressed(0),
            text: "ไม่มีสี",
          ),
        ),
        SizedBox(
          width: Sizes.dimen_8,
        ),
        Expanded(
          child: SelectButton(
            isSelected: selectedButton == 1,
            onPressed: () => _onPressed(1),
            style: SelectButtonStyle.Red,
            text: "แดง",
          ),
        ),
        SizedBox(
          width: Sizes.dimen_8,
        ),
        Expanded(
          child: SelectButton(
            isSelected: selectedButton == 2,
            style: SelectButtonStyle.Black,
            onPressed: () => _onPressed(2),
            text: "ดำ",
          ),
        ),
      ],
    );
  }
}

enum SelectButtonStyle {
  Primary,
  Red,
  Black,
  Disable,
}

class SelectButton extends StatefulWidget {
  SelectButton({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
    this.style = SelectButtonStyle.Primary,
  }) : super(key: key);
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;
  final SelectButtonStyle style;

  @override
  _SelectButtonState createState() => _SelectButtonState();
}

class _SelectButtonState extends State<SelectButton> {
  Color get _color {
    final theme = Theme.of(context);
    if (widget.style == SelectButtonStyle.Primary) {
      return theme.colorScheme.secondary;
    }
    if (widget.style == SelectButtonStyle.Red) {
      return theme.colorScheme.errorColor;
    }
    if (widget.style == SelectButtonStyle.Black) {
      return theme.colorScheme.darkColor;
    }
    if (widget.style == SelectButtonStyle.Disable) {
      return theme.colorScheme.disableColor;
    }
    return Colors.transparent;
  }

  List<BoxShadow> get _boxShadows {
    final theme = Theme.of(context);
    if (widget.style == SelectButtonStyle.Primary) {
      return theme.secondaryBoxShadows;
    }
    if (widget.style == SelectButtonStyle.Red) {
      return theme.errorBoxShadows;
    }
    if (widget.style == SelectButtonStyle.Black) {
      return theme.darkBoxShadows;
    }
    if (widget.style == SelectButtonStyle.Disable) {
      return theme.disableBoxShadows;
    }
    return [];
  }

  BoxDecoration get _decoration {
    final theme = Theme.of(context);
    if (widget.isSelected) {
      return BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        boxShadow: _boxShadows,
      );
    }
    return BoxDecoration(
      color: theme.colorScheme.cardColor,
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
      border: Border.all(
        color: _color,
        width: 1,
      ),
      boxShadow: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TapDetector(
      onPressed: widget.onPressed,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: _decoration,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Sizes.dimen_2),
          child: Center(
            child: Text(
              widget.text,
              style: theme.textTheme.bodyText2!.copyWith(
                color:
                    widget.isSelected ? theme.colorScheme.onSecondary : _color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
