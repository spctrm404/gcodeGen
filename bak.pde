//import java.util.Map;
//import java.util.regex.Matcher;
//import java.util.regex.Pattern;

//boolean isDigit(char c) {
//  return(c == '0'
//    || c== '1'
//    || c== '2'
//    || c== '3'
//    || c== '4'
//    || c== '5'
//    || c== '6'
//    || c== '7'
//    || c== '8'
//    || c== '9');
//}

//String extractNumFromString(String str) {
//  String num = "";
//  for (int i = 0; i < str.length(); i++) {
//    char c = str.charAt(i);
//    if (isDigit(c)) {
//      num +=c;
//    } else if (c == '.') {
//      if (!num.contains(".")) {
//        if (i < str.length() - 1) {
//          if (isDigit(str.charAt(i + 1))) {
//            num +=c;
//          }
//        }
//      }
//    } else if (c == '-') {
//      if (!num.contains("-")) {
//        if (num.length() == 0) {
//          if (i < str.length() - 1) {
//            if (isDigit(str.charAt(i + 1))) {
//              num +=c;
//            }
//          }
//        }
//      }
//    }
//  }
//  return num;
//}

//String[] loadSVGAsStrings(String filename) {
//  String[] svgStrings = loadStrings(filename);
//  for (int i = 0; i < svgStrings.length; i++) {
//    String str = svgStrings[i];
//    println("[" + i + "]: " + str);
//  }
//  return svgStrings;
//}

//String minifyStrings(String[] strs) {
//  String minified = "";
//  for (String str : strs) {
//    boolean prependSpace = false;
//    if (str.length() > 0) {
//      if (str.charAt(0) == ' ' || str.charAt(0) == '\t') {
//        prependSpace = true;
//      }
//      String trimmed = str.trim();
//      while (trimmed.contains("  ")) {
//        trimmed = trimmed.replaceAll("  ", " ");
//      }
//      if (trimmed != "") {
//        minified+= prependSpace ? (" " + trimmed) : trimmed;
//      }
//    }
//  }
//  //println(minified);
//  return minified;
//}

//String svgStringFormatting(String minified) {
//  String formatted = "";
//  for (int i  = 0; i < minified.length(); i++) {
//    if (minified.charAt(i) == '-') {
//      if (i > 0) {
//        if (isDigit(minified.charAt(i - 1))) {
//          formatted += ",";
//        }
//      }
//    }
//    formatted += minified.charAt(i);
//  }
//  //println(formatted);
//  return formatted;
//}

//String[] arrayingSVGString(String svgString) {
//  ArrayList<String> svgArrayList = new ArrayList<String>();
//  String svgCmd = "";
//  for (int i = 0; i < svgString.length(); i++) {
//    char c = svgString.charAt(i);
//    if (c == '<') {
//      if (svgCmd.length() > 0) {
//        svgArrayList.add(svgCmd.trim());
//      }
//      svgCmd = "";
//    } else if (c == '>') {
//    } else if (c == '/') {
//    } else {
//      svgCmd += c;
//    }
//  }
//  String[] arrayed = svgArrayList.toArray(new String[svgArrayList.size()]);
//  // for (int i = 0; i < arrayed.length; i++) {
//  //   String line = arrayed[i];
//  //   println("[" + i + "]: " + line);
//  // }
//  return arrayed;
//}

//String[] arrayingSVGStrings(String[] svgStrings) {
//  return arrayingSVGString(svgStringFormatting(minifyStrings(svgStrings)));
//}

//HashMap<String, String> svgCmdToHashmap(String svgCmd) {
//  HashMap<String, String> hashmap = new HashMap<String, String>();
//  String[] splittedByEqual = svgCmd.split("=");
//  for (int i = 1; i < splittedByEqual.length; i++) {
//    String[] prev = splittedByEqual[i - 1].split(" ");
//    String[] current = splittedByEqual[i].split(" ");
//    String k = prev[prev.length - 1].trim();
//    String v = "";
//    if (current.length == 1) {
//      v = current[0];
//    } else {
//      for (int j = 0; j < current.length - 1; j++) {
//        v += current[j];
//        v += " ";
//      }
//    }
//    v = v.trim();
//    while (v.contains("\"")) {
//      v = v.replaceAll("\"", "");
//    }
//    hashmap.put(k, v);
//    if (i == 1) {
//      String customK = "svgCmd";
//      String customV = prev[0].trim();
//      hashmap.put(customK, customV);
//    }
//  }
//  // for (Map.Entry entry : hashmap.entrySet()) {
//  //   println(entry.getKey() + ": " + entry.getValue());
//  // }
//  return hashmap;
//}

//void addHashmap(String svgCmd, ArrayList<HashMap<String, String>> svgHashmaps) {
//  String[] splitted = svgCmd.split(" ");
//  if (splitted.length > 0) {
//    if (splitted[0].equals("rect")) {
//      svgHashmaps.add(svgCmdToHashmap(svgCmd));
//    } else if (splitted[0].equals("circle")) {
//      svgHashmaps.add(svgCmdToHashmap(svgCmd));
//    } else if (splitted[0].equals("ellipse")) {
//      svgHashmaps.add(svgCmdToHashmap(svgCmd));
//    } else if (splitted[0].equals("line")) {
//      svgHashmaps.add(svgCmdToHashmap(svgCmd));
//    } else if (splitted[0].equals("polyline")) {
//      svgHashmaps.add(svgCmdToHashmap(svgCmd));
//    } else if (splitted[0].equals("polygon")) {
//      svgHashmaps.add(svgCmdToHashmap(svgCmd));
//    } else if (splitted[0].equals("path")) {
//      svgHashmaps.add(svgCmdToHashmap(svgCmd));
//    } else if (splitted[0].equals("svg")) {
//    } else {
//    }
//  }
//}

//ArrayList<HashMap<String, String>> svgHashmaps;

//void setup() {
//  size(800, 800);
//  background(255);
//  noFill();
//  stroke(0);
//  String[] svgStrings = arrayingSVGStrings(loadSVGAsStrings("sample1_ink.svg"));
//  svgHashmaps = new ArrayList<HashMap<String, String>> ();
//  for (int i = 0; i < svgStrings.length; i++) {
//    String svgString = svgStrings[i];
//    addHashmap(svgString, svgHashmaps);
//  }
//  for (int i = 0; i < svgHashmaps.size(); i++) {
//    HashMap<String, String>svgHashmap = svgHashmaps.get(i);
//    convertToGCode(svgHashmap);
//  }
//}

//void convertToGCode(HashMap<String, String>svgHashmap) {
//  float[] matrix = {1, 0, 0, 1, 0, 0};
//  if (svgHashmap.containsKey("transform")) {
//    String[] matrixVals = svgHashmap.get("transform").split(" ");
//    for (int i = 0; i < matrixVals.length; i++) {
//      String number = extractNumFromString(matrixVals[i]);
//      matrix[i] = Float.parseFloat(number);
//      println(i + ": " + matrix[i]);
//    }
//  }
//  String svgCmd = svgHashmap.get("svgCmd");
//  applyMatrix(matrix[0], matrix[2], matrix[4],
//    matrix[1], matrix[3], matrix[5]);
//  switch(svgCmd) {
//  case "rect":
//    println("rect");
//    printMatrix();
//    float x = Float.parseFloat(svgHashmap.get("x"));
//    float y = Float.parseFloat(svgHashmap.get("y"));
//    float width = Float.parseFloat(svgHashmap.get("width"));
//    float height = Float.parseFloat(svgHashmap.get("height"));
//    rect(x, y, width, height);
//    break;
//  case "ellipse":
//    println("ellipse");
//    printMatrix();
//    float cx = Float.parseFloat(svgHashmap.get("cx"));
//    float cy = Float.parseFloat(svgHashmap.get("cy"));
//    float rx = Float.parseFloat(svgHashmap.get("rx"));
//    float ry = Float.parseFloat(svgHashmap.get("ry"));
//    ellipse(cx, cy, rx, ry);
//    break;
//  case "path":
//    println("path");
//    String d = svgHashmap.get("d");
//    String[] dCmdArray = arrayingDCmd(d, extractDCmdIdx(d));
//    //for (String dCmd : dCmdArray) {
//    //  println(dCmd);
//    //}
//    interpreteDCmd(dCmdArray);
//    break;
//  }
//  resetMatrix();
//}

//boolean isDCmd(char c) {
//  return c == 'M'
//    || c == 'm'
//    || c == 'L'
//    || c == 'l'
//    || c == 'H'
//    || c == 'h'
//    || c == 'V'
//    || c == 'v'
//    || c == 'Z'
//    || c == 'z'
//    || c == 'C'
//    || c == 'c'
//    || c == 'S'
//    || c == 's'
//    || c == 'Q'
//    || c == 'q'
//    || c == 'T'
//    || c == 't'
//    || c == 'A'
//    || c == 'a';
//}

//int[] extractDCmdIdx(String d) {
//  ArrayList<Integer> idxArrayList = new ArrayList<Integer>();
//  for (int i = 0; i < d.length(); i++) {
//    char c = d.charAt(i);
//    if (isDCmd(c)) {
//      idxArrayList.add(i);
//    }
//  }
//  int[] idxArray = new int[idxArrayList.size()];
//  for (int i = 0; i < idxArrayList.size(); i++) {
//    idxArray[i] = idxArrayList.get(i);
//  }
//  return idxArray;
//}

//String[] arrayingDCmd(String d, int[] dCmdIdx) {
//  String[] array = new String[dCmdIdx.length];
//  for (int i = 0; i < dCmdIdx.length; i++) {
//    int beginIdx = dCmdIdx[i];
//    int endIdx = (i == dCmdIdx.length - 1)? d.length() : dCmdIdx[i + 1];
//    array[i] = d.substring(beginIdx, endIdx);
//  }
//  return array;
//}

//float rotate180(float curr, float mid) {
//  return 2 * mid - curr;
//}

//void interpreteDCmd(String[] dCmdArray) {
//  float[] origin = {0, 0};
//  float[] pos = {0, 0};
//  float[] ppos = {0, 0};
//  float[] pcp = {0, 0};
//  beginShape();
//  for (int i = 0; i < dCmdArray.length; i++) {
//    char c = dCmdArray[i].charAt(0);
//    String[] values = dCmdArray[i].substring(1).split(",");
//    if (i == 0) {
//      origin[0] = Float.parseFloat(values[0]);
//      origin[1] = Float.parseFloat(values[1]);
//    }
//    if (c == 'M' || c == 'm') {
//      pos[0] = Float.parseFloat(values[0]);
//      pos[1] = Float.parseFloat(values[1]);
//      if (c == 'M') {
//        vertex(pos[0], pos[1]);
//        ppos[0] = pos[0];
//        ppos[1] = pos[1];
//      } else {
//        vertex(ppos[0] + pos[0], ppos[1] + pos[1]);
//        ppos[0] = ppos[0] + pos[0];
//        ppos[1] = ppos[1] + pos[1];
//      }
//    } else if (c == 'L' || c == 'l') {
//      pos[0] = Float.parseFloat(values[0]);
//      pos[1] = Float.parseFloat(values[1]);
//      if (c == 'L') {
//        vertex(pos[0], pos[1]);
//        ppos[0] = pos[0];
//        ppos[1] = pos[1];
//      } else {
//        vertex(ppos[0] + pos[0], ppos[1] + pos[1]);
//        ppos[0] = ppos[0] + pos[0];
//        ppos[1] = ppos[1] + pos[1];
//      }
//    } else if (c == 'H' || c == 'h') {
//      pos[0] = Float.parseFloat(values[0]);
//      if (c == 'H') {
//        vertex(pos[0], pos[1]);
//        ppos[0] = pos[0];
//        ppos[1] = pos[1];
//      } else {
//        vertex(ppos[0] + pos[0], ppos[1] + pos[1]);
//        ppos[0] = ppos[0] + pos[0];
//        ppos[1] = ppos[1] + pos[1];
//      }
//      ppos[0] = pos[0];
//    } else if (c == 'V' || c == 'v') {
//      pos[1] = Float.parseFloat(values[0]);
//      if (c == 'V') {
//        vertex(pos[0], pos[1]);
//        ppos[0] = pos[0];
//        ppos[1] = pos[1];
//      } else {
//        vertex(ppos[0] + pos[0], ppos[1] + pos[1]);
//        ppos[0] = ppos[0] + pos[0];
//        ppos[1] = ppos[1] + pos[1];
//      }
//    } else if (c == 'Z' || c == 'z') {
//      vertex(origin[0], origin[1]);
//    } else if (c == 'C' || c == 'c') {
//      pos[0] = Float.parseFloat(values[4]);
//      pos[1] = Float.parseFloat(values[5]);
//      if (c == 'C') {
//        bezierVertex(Float.parseFloat(values[0]), Float.parseFloat(values[1]),
//          Float.parseFloat(values[2]), Float.parseFloat(values[3]),
//          pos[0], pos[1]);
//        pcp[0] = Float.parseFloat(values[2]);
//        pcp[1] = Float.parseFloat(values[3]);
//        ppos[0] = pos[0];
//        ppos[1] = pos[1];
//      } else {
//        bezierVertex(ppos[0] + Float.parseFloat(values[0]), ppos[1] + Float.parseFloat(values[1]),
//          ppos[0] + Float.parseFloat(values[2]), ppos[1] + Float.parseFloat(values[3]),
//          ppos[0] + pos[0], ppos[1] + pos[1]);
//        pcp[0] = ppos[0] + Float.parseFloat(values[2]);
//        pcp[1] = ppos[1] + Float.parseFloat(values[3]);
//        ppos[0] = ppos[0] + pos[0];
//        ppos[1] = ppos[1] + pos[1];
//      }
//    } else if (c == 'S' || c == 's') {
//      pos[0] = Float.parseFloat(values[2]);
//      pos[1] = Float.parseFloat(values[3]);
//      if (c == 'S') {
//        bezierVertex(rotate180(pcp[0], ppos[0]), rotate180(pcp[1], ppos[1]),
//          Float.parseFloat(values[0]), Float.parseFloat(values[1]),
//          pos[0], pos[1]);
//        pcp[0] = Float.parseFloat(values[2]);
//        pcp[1] = Float.parseFloat(values[3]);
//        ppos[0] = pos[0];
//        ppos[1] = pos[1];
//      } else {
//        bezierVertex(rotate180(pcp[0], ppos[0]), rotate180(pcp[1], ppos[1]),
//          ppos[0] + Float.parseFloat(values[0]), ppos[1] + Float.parseFloat(values[1]),
//          ppos[0] + pos[0], ppos[1] + pos[1]);
//        pcp[0] = ppos[0] + Float.parseFloat(values[2]);
//        pcp[1] = ppos[1] + Float.parseFloat(values[3]);
//        ppos[0] = ppos[0] + pos[0];
//        ppos[1] = ppos[1] + pos[1];
//      }
//    } else if (c == 'Q' || c == 'q') {
//    } else if (c == 'T' || c == 't') {
//    } else if (c == 'A' || c == 'a') {
//    }
//  }
//  endShape();
//}

//void draw() {
//}
