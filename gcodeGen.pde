import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

boolean isNumber(char c) {
  return (c == '0'
    || c == '1'
    || c == '2'
    || c == '3'
    || c == '4'
    || c == '5'
    || c == '6'
    || c == '7'
    || c == '8'
    || c == '9');
}

String numExtractor(String str) {
  String num = "";
  for (int i = 0; i < str.length(); i++) {
    char c = str.charAt(i);
    if (isNumber(c)
      || c == '.'
      || c == '+'
      || c == '-') {
      if (c == '.'
        && (num.contains(".")
        || (i < str.length() - 1
        && !isNumber(str.charAt(i))))) {
      } else if (c == '+' && (num.contains("+") || num.length() > 0)) {
      } else if (c == '-' && (num.contains("-") || num.length() > 0)) {
      }
      num += c;
    }
  }
  return num;
}

String[] loadSvgCmds(String filename) {
  String[] svgCmds = loadStrings(filename);
  for (int i = 0; i < svgCmds.length; i++) {
    String line = svgCmds[i];
    println("[" + i + "]: " + line);
  }
  return svgCmds;
}

String minifySVG(String[] svg) {
  String minified = "";
  for (String line : svg) {
    boolean prependSpace = false;
    if (line.length() > 0) {
      if (line.charAt(0) == ' ' || line.charAt(0) == '\t') {
        prependSpace = true;
      }
      String trimmed = line.trim();
      while (trimmed.contains("  ")) {
        trimmed = trimmed.replaceAll("  ", " ");
      }
      if (trimmed != "") {
        minified += prependSpace? (" " + trimmed) : trimmed;
      }
    }
  }
  //println(minified);
  return minified;
}

String formattingSVG(String minified) {
  String formatted = "";
  for (int i  = 0; i < minified.length(); i++) {
    if (minified.charAt(i) == '-'
      && i > 0
      && (isNumber(minified.charAt(i - 1)))) {
      formatted += ",";
    }
    formatted += minified.charAt(i);
  }
  //println(formatted);
  return formatted;
}

String[] arrayingSVG(String minifiedSVG) {
  ArrayList<String> cmds = new ArrayList<String>();
  String cmd = "";
  for (int i = 0; i < minifiedSVG.length(); i++) {
    char c = minifiedSVG.charAt(i);
    if (c == '<') {
      if (!cmd.equals("")) {
        cmds.add(cmd.trim());
      }
      cmd = "";
    } else if (c == '>') {
    } else if (c == '/') {
    } else {
      cmd += c;
    }
  }
  String[] arrayed = cmds.toArray(new String[cmds.size()]);
  for (int i = 0; i < arrayed.length; i++) {
    String line = arrayed[i];
    println("[" + i + "]: " + line);
  }
  return arrayed;
}

String[] arrayingSVG(String[] svg) {
  return arrayingSVG(formattingSVG(minifySVG(svg)));
}

HashMap<String, String> svgCmdToHashmap(String svgCmd) {
  HashMap<String, String> hashmap = new HashMap<String, String>();
  String[] splittedByEqual = svgCmd.split("=");
  for (int i = 1; i < splittedByEqual.length; i++) {
    String[] prev = splittedByEqual[i - 1].split(" ");
    String[] current = splittedByEqual[i].split(" ");
    String k = prev[prev.length - 1].trim();
    String v = "";
    if (current.length == 1) {
      v = current[0];
    } else {
      for (int j = 0; j < current.length - 1; j++) {
        v += current[j];
        v += " ";
      }
    }
    v = v.trim();
    while (v.contains("\"")) {
      v = v.replaceAll("\"", "");
    }
    hashmap.put(k, v);
    if (i == 1) {
      String customK = "SVGcmd";
      String customV = prev[0].trim();
      hashmap.put(customK, customV);
    }
  }
  for (Map.Entry entry : hashmap.entrySet()) {
    println(entry.getKey() + ": " + entry.getValue());
  }
  return hashmap;
}

void addHashmap(String svgCmd, ArrayList<HashMap<String, String>> svgHashmaps) {
  String[] splitted = svgCmd.split(" ");
  if (splitted.length > 0) {
    if (splitted[0].equals("rect")) {
      svgHashmaps.add(svgCmdToHashmap(svgCmd));
    } else if (splitted[0].equals("circle")) {
      svgHashmaps.add(svgCmdToHashmap(svgCmd));
    } else if (splitted[0].equals("ellipse")) {
      svgHashmaps.add(svgCmdToHashmap(svgCmd));
    } else if (splitted[0].equals("line")) {
      svgHashmaps.add(svgCmdToHashmap(svgCmd));
    } else if (splitted[0].equals("polyline")) {
      svgHashmaps.add(svgCmdToHashmap(svgCmd));
    } else if (splitted[0].equals("polygon")) {
      svgHashmaps.add(svgCmdToHashmap(svgCmd));
    } else if (splitted[0].equals("path")) {
      svgHashmaps.add(svgCmdToHashmap(svgCmd));
    } else if (splitted[0].equals("svg")) {
    } else {
    }
  }
}

ArrayList<HashMap<String, String>> svgHashmaps;

void setup() {
  size(800, 800);
  background(255);
  noFill();
  stroke(0);
  String[] svgCmds = loadSvgCmds("sample1_ink.svg");
  //String[] svgCmds = loadSvgCmds("sample1_ai.svg");
  svgCmds = arrayingSVG(svgCmds);
  svgHashmaps = new ArrayList<HashMap<String, String>> ();
  for (int i = 0; i < svgCmds.length; i++) {
    String svgCmd = svgCmds[i];
    addHashmap(svgCmd, svgHashmaps);
  }
  for (int i = 0; i < svgHashmaps.size(); i++) {
    HashMap<String, String>svgHashmap = svgHashmaps.get(i);
    anal(svgHashmap);
  }
}

void anal(HashMap<String, String>svgHashmap) {
  float[] matrix = {1, 0, 0, 1, 0, 0};
  if (svgHashmap.containsKey("transform")) {
    String[] matrixVals = svgHashmap.get("transform").split(" ");
    for (int i = 0; i < matrixVals.length; i++) {
      String number = numExtractor(matrixVals[i]);
      matrix[i] = Float.parseFloat(number);
    }
  }
  String svgCmd = svgHashmap.get("SVGcmd");
  applyMatrix(matrix[0], matrix[2], matrix[4],
    matrix[1], matrix[3], matrix[5]);
  switch(svgCmd) {
  case "ellipse":
    float cx = Float.parseFloat(svgHashmap.get("cx"));
    float cy = Float.parseFloat(svgHashmap.get("cy"));
    float rx = Float.parseFloat(svgHashmap.get("rx"));
    float ry = Float.parseFloat(svgHashmap.get("ry"));
    ellipse(cx, cy, rx, ry);
    break;
  case "path":
    String d = svgHashmap.get("d");
    println(d);
    
    break;
  }
  resetMatrix();
}

//get alphabet first

String dAnal(String d, char key) {
  String value = "";
  int idx = d.indexOf(key);
  if (idx != -1) {
    for (int i = idx + 1; i < d.length(); i++) {
      char c = d.charAt(i);
      if (isNumber(c)
        || c == '.' 
        || c == '+' 
        || c == '-' 
        || c == ','
        || c == ' ') {
          value += c;
        } else {
          break;
        }
      }
      return value;
    }
    return value;
  }

  void draw() {
  }
