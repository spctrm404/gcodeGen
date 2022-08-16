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
    if (isTargettedSvgTag(name)) {
      float[] matrix = {1, 0, 0, 0, 1, 0};
      if (hm.containsKey("transform")) {
        String[] matrixStr = hm.get("transform").split(",");
        for (int j = 0; j < matrixStr.length; j++)
          matrix[j] = Float.parseFloat(matrixStr[j]);
      }
      if (name.equalsIgnoreCase("rect")) {
        float x = Float.parseFloat(hm.get("x"));
        float y = Float.parseFloat(hm.get("y"));
        float width = Float.parseFloat(hm.get("width"));
        float height = Float.parseFloat(hm.get("height"));
        gCodes += gRect(x, y, width, height, matrix, pxPerMm);
      } else if (name.equalsIgnoreCase("circle")) {
      } else if (name.equalsIgnoreCase("ellipse")) {
      } else if (name.equalsIgnoreCase("line")) {
      } else if (name.equalsIgnoreCase("polyline")) {
      } else if (name.equalsIgnoreCase("polygon")) {
      } else if (name.equalsIgnoreCase("path")) {
        String d = hm.get("d");
        String[] dCmdArry = getDCmdAsStrArry(d);
        gCodes += gPath(dCmdArry, matrix, pxPerMm);
      }
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

boolean isSupportedDCmd(char dCmd) {
  for (char supportedDCmd : supportedDCmdList)
    if (dCmd == supportedDCmd)
      return true;
  return false;
}

int[] getDCmdIdxAsArry(String d) {
  ArrayList<Integer> idxList = new ArrayList<>();
  for (int i = 0; i < d.length(); i++) {
    char c = d.charAt(i);
    if (isSupportedDCmd(c))
      idxList.add(i);
  }
  int[] idxArry = new int[idxList.size()];
  for (int i = 0; i < idxArry.length; i++)
    idxArry[i] = idxList.get(i);
  return idxArry;
}

String[] getDCmdAsStrArry(String d) {
  int[] dCmdIdx = getDCmdIdxAsArry(d);
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
