

String time12to24Format(String time) {

  int h = int.parse(time.split(":").first);
  int m = int.parse(time.split(":").last.split(" ").first);
  String meridium = time.split(":").last.split(" ").last.toLowerCase();
  if (meridium == "pm") {
    if (h != 12) {
      h = h + 12;
    }
  }
  if (meridium == "am") {
    if (h == 12) {
      h = 00;
    }
  }
  String newTime = "${h == 0 ? "00" : h < 10 ? '0$h' : h }:${m == 0 ? "00" : m.bitLength < 10? '0$m' : m}";

  return '${newTime}:00';
}