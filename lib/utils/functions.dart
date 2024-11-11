final List months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

String formatDateAndTime(String inputDate) {
  DateTime date = DateTime.parse(inputDate).toLocal();

  int currentMonth = date.month;
  String month = months[currentMonth - 1];

  int hour = date.hour;
  String minute = date.minute.toString();
  String referTime = "AM";

  if (hour == 0) {
    hour = 12;
  } else if (hour > 12) {
    hour = hour - 12;
    referTime = "PM";
  }

  if (date.minute < 10) {
    minute = '0${date.minute}';
  }

  return '$hour:$minute $referTime · ${date.day} $month ${date.year}';
}
