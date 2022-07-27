class DurationView {
  final String hours;
  final String minutes;
  final String seconds;
  final String days;

  const DurationView({
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });
  static String dur(String days, String hours, String minutes, String seconds) {
    List<String> durat = [];
    if (days != '0') {
      durat.add('$days d ');
    }
    if (hours != '0') {
      durat.add('$hours h ');
    }
    if (minutes != '0') {
      durat.add('$minutes m ');
    }

    durat.add('$seconds s ');
    String str = '';
    for (int i = 0; i < durat.length; i++) {
      str = str + durat[i];
    }
    return str;
  }
}
