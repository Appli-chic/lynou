import 'package:timeago/timeago.dart';

class FrShortMessages implements LookupMessages {
  String prefixAgo() => '';
  String prefixFromNow() => "";
  String suffixAgo() => '';
  String suffixFromNow() => '';
  String lessThanOneMinute(int seconds) => "maintenant";
  String aboutAMinute(int minutes) => '1 min';
  String minutes(int minutes) => '$minutes min';
  String aboutAnHour(int minutes) => '1 h';
  String hours(int hours) => '$hours h';
  String aDay(int hours) => '1 j';
  String days(int days) => '$days j';
  String aboutAMonth(int days) => '1 m';
  String months(int months) => '$months m';
  String aboutAYear(int year) => '1 an';
  String years(int years) => '$years ans';
  String wordSeparator() => ' ';
}