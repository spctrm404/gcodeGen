boolean isDigit(char c) {
  return (c == '0'
    || c== '1'
    || c== '2'
    || c== '3'
    || c== '4'
    || c== '5'
    || c== '6'
    || c== '7'
    || c== '8'
    || c== '9');
}

String leaveValOnly(String str) {
  String newStr = "";
  for (int i = 0; i < str.length(); i++) {
    char c = str.charAt(i);
    if (isDigit(c) || c == '.' || c == '-' || c == ',')
      newStr += c;
  }
  return newStr;
}

String formatStr(String str) {
  String copied = "";
  copied += str;
  while (copied.contains(" "))
    copied = copied.replaceAll(" ", ",");
  while (copied.contains(",,"))
    copied = copied.replaceAll(",,", ",");
  String newStr = "";
  for (int i = 0; i < copied.length(); i++) {
    char c = copied.charAt(i);
    if (i > 0) {
      char pc = copied.charAt(i - 1);
      if (c == '-' && isDigit(pc))
        newStr += ",";
    }
    newStr += c;
  }
  return newStr;
}
