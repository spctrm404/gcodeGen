import java.util.Map;

void printXml(XML xml, int depth, String path) {
  String depthDispStr = "";
  for (int i = 1; i < depth; i++)
    depthDispStr += "  ";
  if (depth > 0)
    depthDispStr += "└ ";
  println(depthDispStr + xml.getName() + " (" + path + ")");
  if (xml.hasChildren()) {
    depth++;
    path += xml.getName() + "/";
    XML[] children = xml.getChildren();
    for (XML child : children)
      printXml(child, depth, path);
  }
}

boolean isSvgExtractingTarget(String name) {
  return name.equalsIgnoreCase("rect")
    || name.equalsIgnoreCase("circle")
    || name.equalsIgnoreCase("ellipse")
    || name.equalsIgnoreCase("line")
    || name.equalsIgnoreCase("polyline")
    || name.equalsIgnoreCase("polygon")
    || name.equalsIgnoreCase("path")
    || name.equalsIgnoreCase("g");
}

void extractTargetedSvgAsList(XML svg, ArrayList extractedSvgList) {
  if (isSvgExtractingTarget(svg.getName())) {
    extractedSvgList.add(svg);
  } else if (svg.hasChildren()) {
    XML[] children = svg.getChildren();
    for (XML child : children)
      extractTargetedSvgAsList(child, extractedSvgList);
  }
}

void addViewBoxInfo(XML svg, ArrayList<HashMap> svgHmList) {
  HashMap<String, String> hm = new HashMap<>();
  if (svg.hasAttribute("viewBox")) {
    String attrValStr = formatStr(svg.getString("viewBox"));
    hm.put("viewBox", attrValStr);
  }
  svgHmList.add(hm);
}

void putSvgAttrOnHm(XML svg, String attrName, HashMap hm) {
  if (svg.hasAttribute(attrName)) {
    String attrValStr = formatStr(svg.getString(attrName).trim());
    if (attrName.equals("transform")) {
      float[] matrix = {1, 0, 0, 0, 1, 0};
      String[] splitted = stripText(attrValStr).split(",");
      if (attrValStr.contains("matrix")) {
        matrix[0] = Float.parseFloat(splitted[0]);
        matrix[1] = Float.parseFloat(splitted[2]);
        matrix[2] = Float.parseFloat(splitted[4]);
        matrix[3] = Float.parseFloat(splitted[1]);
        matrix[4] = Float.parseFloat(splitted[3]);
        matrix[5] = Float.parseFloat(splitted[5]);
      } else if (attrValStr.contains("translate")) {
        matrix[2] = Float.parseFloat(splitted[0]);
        matrix[5] = Float.parseFloat(splitted[1]);
      } else if (attrValStr.contains("scale")) {
        matrix[0] = Float.parseFloat(splitted[0]);
        matrix[4] = splitted.length == 2 ? Float.parseFloat(splitted[1]) : Float.parseFloat(splitted[0]);
      } else if (attrValStr.contains("rotate")) {
        float sin = sin(radians(Float.parseFloat(splitted[0])));
        float cos = cos(radians(Float.parseFloat(splitted[0])));
        matrix[0] = cos;
        matrix[1] = -sin;
        matrix[3] = sin;
        matrix[4] = cos;
        if (splitted.length == 3) {
          matrix[2] = Float.parseFloat(splitted[1]) * (1 - cos) + Float.parseFloat(splitted[2]) * sin;
          matrix[5] = Float.parseFloat(splitted[2]) * (1 - cos) - Float.parseFloat(splitted[1]) * sin;
        }
      } else if (attrValStr.contains("skewX")) {
        float tan = tan(radians(Float.parseFloat(splitted[0])));
        matrix[1] = tan;
      } else if (attrValStr.contains("skewY")) {
        float tan = tan(radians(Float.parseFloat(splitted[0])));
        matrix[3] = tan;
      }
      String matrixStr = "";
      for (int j = 0; j < matrix.length; j++) {
        matrixStr += matrix[j];
        if (j != matrix.length - 1)
          matrixStr += ",";
      }
      //println(matrixStr);
      hm.put(attrName, matrixStr);
    } else {
      //println(attrValStr);
      hm.put(attrName, attrValStr);
    }
  }
}

HashMap<String, String> extractSvgAttrToHm(XML svg) {
  HashMap<String, String> hm = new HashMap<>();
  String name = svg.getName();
  if (isSvgExtractingTarget(name)) {
    hm.put("name", name);
    putSvgAttrOnHm(svg, "transform", hm);
    if (name.equalsIgnoreCase("rect")) {
      putSvgAttrOnHm(svg, "x", hm);
      putSvgAttrOnHm(svg, "y", hm);
      putSvgAttrOnHm(svg, "width", hm);
      putSvgAttrOnHm(svg, "height", hm);
    } else if (name.equalsIgnoreCase("circle")) {
      putSvgAttrOnHm(svg, "cx", hm);
      putSvgAttrOnHm(svg, "cy", hm);
      putSvgAttrOnHm(svg, "r", hm);
    } else if (name.equalsIgnoreCase("ellipse")) {
      putSvgAttrOnHm(svg, "cx", hm);
      putSvgAttrOnHm(svg, "cy", hm);
      putSvgAttrOnHm(svg, "rx", hm);
      putSvgAttrOnHm(svg, "ry", hm);
    } else if (name.equalsIgnoreCase("line")) {
      putSvgAttrOnHm(svg, "x1", hm);
      putSvgAttrOnHm(svg, "y1", hm);
      putSvgAttrOnHm(svg, "x2", hm);
      putSvgAttrOnHm(svg, "y2", hm);
    } else if (name.equalsIgnoreCase("polyline")) {
      putSvgAttrOnHm(svg, "points", hm);
    } else if (name.equalsIgnoreCase("polygon")) {
      putSvgAttrOnHm(svg, "points", hm);
    } else if (name.equalsIgnoreCase("path")) {
      putSvgAttrOnHm(svg, "d", hm);
    } else if (name.equalsIgnoreCase("g")) {
    }
    return hm;
  }
  return null;
}

void recursiveSvgToHmConversion(XML[] extractedSvgArry, ArrayList<HashMap> svgHmList, float[] matrix) {
  for (XML svgElem : extractedSvgArry) {
    HashMap<String, String> hm = extractSvgAttrToHm(svgElem);
    if (hm != null) {
      if (!hm.get("name").equals("g")) {
        svgHmList.add(hm);
      } else if (svgElem.hasChildren()) {
        float[] newMatrix = matrix.clone();
        if (hm.containsKey("transform")) {
          String[] myMatrixVal = hm.get("transform").split(",");
          float[] myMatrix = new float[myMatrixVal.length];
          for (int i = 0; i < myMatrixVal.length; i++)
            myMatrix[i] = Float.parseFloat(myMatrixVal[i]);
          newMatrix[0] = newMatrix[0] * myMatrix[0] + newMatrix[2] * myMatrix[1] + 0;
          newMatrix[2] = newMatrix[0] * myMatrix[2] + newMatrix[2] * myMatrix[3] + 0;
          newMatrix[4] = newMatrix[0] * myMatrix[4] + newMatrix[2] * myMatrix[5] + newMatrix[4];
          newMatrix[1] = newMatrix[1] * myMatrix[0] + newMatrix[3] * myMatrix[1] + 0;
          newMatrix[3] = newMatrix[1] * myMatrix[2] + newMatrix[3] * myMatrix[3] + 0;
          newMatrix[5] = newMatrix[1] * myMatrix[4] + newMatrix[3] * myMatrix[5] + newMatrix[5];
        }
        XML[] children = svgElem.getChildren();
        recursiveSvgToHmConversion(children, svgHmList, newMatrix);
      }
    }
  }
}

void printHmList(ArrayList<HashMap> hmList) {
  for (HashMap<String, String> hm : hmList) {
    println("----------");
    for (Map.Entry entry : hm.entrySet()) {
      print(entry.getKey() + " = ");
      println(entry.getValue());
    }
  }
}

String fileName = "sample1_ai.svg";
float pxPerMm = 1;
int xyFeedrate = 6000;
int zFeedrate = 2000;
float g1z = -1;
float g0z = 5;
float g4 = 0.05; //50ms

void setup() {
  XML svg;
  svg = loadXML(fileName);
  println(svg);
  printXml(svg, 0, "");
  ArrayList<XML> extractedSvgList = new ArrayList<>();
  extractTargetedSvgAsList(svg, extractedSvgList);
  XML[] extractedSvgArry = new XML[extractedSvgList.size()];
  extractedSvgArry = extractedSvgList.toArray(extractedSvgArry);
  ArrayList<HashMap> svgHmList = new ArrayList<>();
  addViewBoxInfo(svg, svgHmList);
  float[] matrix = {1, 0, 0, 0, 1, 0};
  recursiveSvgToHmConversion(extractedSvgArry, svgHmList, matrix);
  printHmList(svgHmList);
  println(convertSvgToGCode(svgHmList));
}

String convertSvgToGCode(ArrayList<HashMap> svgHmList) {
  String[] viewbox = null;
  HashMap<String, String> firstHm = (HashMap<String, String>)svgHmList.get(0);
  if (firstHm.containsKey("viewBox"))
    viewbox = firstHm.get("viewBox").split(",");
  println("fileName = " + fileName);
  println("pxPerMm = " + pxPerMm);
  println("canvasWidth = " + (viewbox == null ? "undefined" : Float.parseFloat(viewbox[2])));
  println("canvasHeight = " + (viewbox == null ? "undefined" : Float.parseFloat(viewbox[3])));
  println("xyFeedrate = " + xyFeedrate);
  println("zFeedrate = " + zFeedrate);
  println("g1z = " + g1z);
  println("g0z = " + g0z);
  println("g4 = " + g4);
  println("----------");
  String gCodes = "";
  //add safe start cmd;
  for (int i = 1; i < svgHmList.size(); i++) {
    HashMap<String, String> hm = (HashMap<String, String>)svgHmList.get(i);
    String name = hm.get("name");
    if (name.equalsIgnoreCase("rect")) {
      float x = Float.parseFloat(hm.get("x"));
      float y = Float.parseFloat(hm.get("y"));
      float width = Float.parseFloat(hm.get("width"));
      float height = Float.parseFloat(hm.get("height"));
      float[] matrix = {1, 0, 0, 0, 1, 0};
      if (hm.containsKey("transform")) {
        String[] matrixStr = hm.get("transform").split(",");
        for (int j = 0; j < matrixStr.length; j++)
          matrix[j] = Float.parseFloat(matrixStr[j]);
      }
      gCodes += gRect(x, y, width, height, matrix, pxPerMm);
    } else if (name.equalsIgnoreCase("circle")) {
    } else if (name.equalsIgnoreCase("ellipse")) {
    } else if (name.equalsIgnoreCase("line")) {
    } else if (name.equalsIgnoreCase("polyline")) {
    } else if (name.equalsIgnoreCase("polygon")) {
    } else if (name.equalsIgnoreCase("path")) {
      String d = hm.get("d");
      float[] matrix = {1, 0, 0, 0, 1, 0};
      if (hm.containsKey("transform")) {
        String[] matrixStr = hm.get("transform").split(",");
        for (int j = 0; j < matrixStr.length; j++)
          matrix[j] = Float.parseFloat(matrixStr[j]);
      }
      String[] dCmdArry = getDCmdArry(d);
      gCodes += gPath(dCmdArry, matrix, pxPerMm);
    }
  }
  return gCodes;
}

String gRect(float x, float y, float width, float height, float[] matrix, float pxPerMm) {
  String gCode = "";

  float[] coord = {x, y};
  float[] tCoord;

  tCoord = applyMatrix(coord, matrix, pxPerMm);
  gCode += "G0 x" + tCoord[0] + " Y" + tCoord[1]  + "\n";
  gCode += "G4 P" + g4  + "\n";
  gCode += "G1 Z" + g1z + " F" + zFeedrate  + "\n";
  gCode += "G4 P" + g4  + "\n";

  coord[0] = x + width;
  tCoord = applyMatrix(coord, matrix, pxPerMm);
  gCode += "G1 X" + tCoord[0] + " Y" + tCoord[1] + " F" + xyFeedrate  + "\n";

  coord[1] = y + height;
  tCoord = applyMatrix(coord, matrix, pxPerMm);
  gCode += "G1 X" + tCoord[0] + " Y" + tCoord[1] + " F" + xyFeedrate  + "\n";

  coord[0] = x;
  tCoord = applyMatrix(coord, matrix, pxPerMm);
  gCode += "G1 X" + tCoord[0] + " Y" + tCoord[1] + " F" + xyFeedrate  + "\n";

  coord[1] = y;
  tCoord = applyMatrix(coord, matrix, pxPerMm);
  gCode += "G1 X" + tCoord[0] + " Y" + tCoord[1] + " F" + xyFeedrate  + "\n";

  gCode += "G4 P" + g4  + "\n";
  gCode += "G0 Z" + g0z  + "\n";

  return gCode;
}

boolean isDCmd(char c) {
  return c == 'M'
    || c == 'm'
    || c == 'L'
    || c == 'l'
    || c == 'H'
    || c == 'h'
    || c == 'V'
    || c == 'v'
    || c == 'Z'
    || c == 'z'
    || c == 'C'
    || c == 'c'
    || c == 'S'
    || c == 's'
    || c == 'Q'
    || c == 'q'
    || c == 'T'
    || c == 't'
    || c == 'A'
    || c == 'a';
}

int[] extractDCmdIdx(String d) {
  ArrayList<Integer> idxList = new ArrayList<>();
  for (int i = 0; i < d.length(); i++) {
    char c = d.charAt(i);
    if (isDCmd(c))
      idxList.add(i);
  }
  int[] idxArry = new int[idxList.size()];
  for (int i = 0; i < idxArry.length; i++)
    idxArry[i] = idxList.get(i);
  return idxArry;
}

String[] getDCmdArry(String d) {
  int[] dCmdIdx = extractDCmdIdx(d);
  String[] dCmdArry = new String[dCmdIdx.length];
  for (int i = 0; i < dCmdIdx.length; i++) {
    int beginIdx = dCmdIdx[i];
    int endIdx = (i == dCmdIdx.length - 1)? d.length() : dCmdIdx[i + 1];
    dCmdArry[i] = d.substring(beginIdx, endIdx);
  }
  return dCmdArry;
}

String gPath(String[] dCmdArry, float[] matrix, float pxPerMm) {
  String gCode = "";

  float[] coord = {0, 0};
  float[] origin = {0, 0};
  float[] tCoord;

  for (String dCmd : dCmdArry) {
    char c = dCmd.charAt(0);
    String[] valStr = dCmd.substring(1).split(",");
    if (c == 'M' || c == 'm') {
      if (c == 'M') {
        coord[0] = Float.parseFloat(valStr[0]);
        coord[1] = Float.parseFloat(valStr[1]);
      } else {
        coord[0] += Float.parseFloat(valStr[0]);
        coord[1] += Float.parseFloat(valStr[1]);
      }
      origin = coord.clone();
      tCoord = applyMatrix(coord, matrix, pxPerMm);
      gCode += "G0 x" + tCoord[0] + " Y" + tCoord[1]  + "\n";
      gCode += "G4 P" + g4  + "\n";
      gCode += "G1 Z" + g1z + " F" + zFeedrate  + "\n";
      gCode += "G4 P" + g4  + "\n";
    } else if (c == 'L' || c == 'l') {
      if (c == 'L') {
        coord[0] = Float.parseFloat(valStr[0]);
        coord[1] = Float.parseFloat(valStr[1]);
      } else {
        coord[0] += Float.parseFloat(valStr[0]);
        coord[1] += Float.parseFloat(valStr[1]);
      }
      tCoord = applyMatrix(coord, matrix, pxPerMm);
      gCode += "G1 X" + tCoord[0] + " Y" + tCoord[1] + " F" + xyFeedrate  + "\n";
    } else if (c == 'H' || c == 'h') {
      if (c == 'H') {
        coord[0] = Float.parseFloat(valStr[0]);
      } else {
        coord[0] += Float.parseFloat(valStr[0]);
      }
      tCoord = applyMatrix(coord, matrix, pxPerMm);
      gCode += "G1 X" + tCoord[0] + " Y" + tCoord[1] + " F" + xyFeedrate  + "\n";
    } else if (c == 'V' || c == 'v') {
      if (c == 'V') {
        coord[1] = Float.parseFloat(valStr[0]);
      } else {
        coord[1] += Float.parseFloat(valStr[0]);
      }
      tCoord = applyMatrix(coord, matrix, pxPerMm);
      gCode += "G1 X" + tCoord[0] + " Y" + tCoord[1] + " F" + xyFeedrate  + "\n";
    } else if (c == 'Z' || c == 'z') {
      tCoord = applyMatrix(origin, matrix, pxPerMm);
      gCode += "G1 X" + tCoord[0] + " Y" + tCoord[1] + " F" + xyFeedrate  + "\n";
    } else if (c == 'C' || c == 'c') {
      if (c == 'C') {
      } else {
      }
    } else if (c == 'S' || c == 's') {
      if (c == 'S') {
      } else {
      }
    } else if (c == 'Q' || c == 'q') {
    } else if (c == 'T' || c == 't') {
    } else if (c == 'A' || c == 'a') {
    }
  }
  gCode += "G4 P" + g4  + "\n";
  gCode += "G0 Z" + g0z  + "\n";
  return gCode;
}

void draw() {
}
