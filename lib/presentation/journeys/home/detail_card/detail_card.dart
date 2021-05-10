import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/common/enum.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/presentation/journeys/home/detail_card/detail_card_percentage_text.dart';
import 'package:redrotapp/presentation/journeys/home/detail_card/detail_card_progress_bar.dart';
import 'package:redrotapp/presentation/widgets/animated_card.dart';
import 'package:timeago/timeago.dart' as timeago;

class DetailCard extends StatefulWidget {
  final CloneEntity clone;
  final int index;
  static bool isIntial = true;
  DetailCard({required this.clone, required this.index});

  @override
  _DetailCardState createState() => _DetailCardState();
}

class _DetailCardState extends State<DetailCard> {
  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('th', timeago.ThMessages());
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      margin: EdgeInsets.fromLTRB(
        Sizes.dimen_8,
        widget.index == 0 ? Sizes.dimen_16 : Sizes.dimen_8,
        Sizes.dimen_8,
        Sizes.dimen_8,
      ),
      child: AnimatedCard(
        width: double.infinity,
        sensitivity: 0.15,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.dimen_8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.clone.cloneName,
                style: textTheme.headline6,
              ),
              const SizedBox(
                height: Sizes.dimen_8,
              ),
              DetailCardContent(
                redrots: widget.clone.redrot!,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  timeago.format(widget.clone.createdAt, locale: "th"),
                  style: textTheme.caption,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DetailCardContent extends StatelessWidget {
  final List<RedrotEntity> redrots;
  const DetailCardContent({
    Key? key,
    required this.redrots,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    int numCompleted = _getCompletedNum();
    int numAll = redrots.length;
    if (redrots.isEmpty) {
      return Text("โปรดเพิ่มข้อมูล");
    }

    if (numCompleted != numAll) {
      final String percentageText =
          (numCompleted / numAll * 100).toInt().toString();
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              child: DetailCardProgressBar(
                all: numAll,
                completed: numCompleted,
              ),
            ),
          ),
          const SizedBox(
            width: Sizes.dimen_8,
          ),
          DetailCardPercentageText(
            percentage: percentageText,
          )
        ],
      );
    }
    return Text("Yes");
  }

  int _getCompletedNum() {
    return redrots.fold(0, (int previousValue, element) {
      if (element.status == ProcessStatus.Completed) {
        return previousValue + 1;
      }
      return previousValue;
    });
  }

  // double _getPercent() {
  //   return (_getCompletedNum() / redrots.length);
  // }
}
