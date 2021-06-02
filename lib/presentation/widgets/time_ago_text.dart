import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimeagoText extends StatelessWidget {
  const TimeagoText(this.dateTime);

  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('th', timeago.ThMessages());
    return Text(
      timeago.format(dateTime, locale: "th"),
      style: Theme.of(context).textTheme.caption,
    );
  }
}
