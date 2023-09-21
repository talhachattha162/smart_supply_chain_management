String formatTime(DateTime time) {
  String period = 'AM';
  int hour = time.hour;
  if (hour >= 12) {
    period = 'PM';
    if (hour > 12) {
      hour -= 12;
    }
  }
  String minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute $period';
}