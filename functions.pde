boolean isDigit(char c) {
  return(c == '0'
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

String stripText(String str) {
  String newStr = "";
  for (int i = 0; i < str.length(); i++) {
    char c = str.charAt(i);
    if (isDigit(c) || c == '.' || c == '-' || c == ',')
      newStr += c;
  }
  return newStr;
}

String formatStr(String str) {
  while (str.contains(" "))
    str = str.replaceAll(" ", ",");
  while (str.contains(",,"))
    str = str.replaceAll(",,", ",");
  String formatted = "";
  for (int i = 0; i < str.length(); i++) {
    char c = str.charAt(i);
    if (i > 0) {
      char pc = str.charAt(i - 1);
      if (c == '-' && isDigit(pc))
        formatted += ",";
    }
    formatted += c;
  }
  return formatted;
}

float[] applyMatrix(float[] coord, float[] matrix, float pxPerMm) {
  float[] newCoord = coord.clone();
  newCoord[0] = pxPerMm * (matrix[0] * newCoord[0] + matrix[1] * newCoord[1] + matrix[2]);
  newCoord[1] = pxPerMm * (matrix[3] * newCoord[0] + matrix[4] * newCoord[1] + matrix[5]);
  return newCoord;
}
