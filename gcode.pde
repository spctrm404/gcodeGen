String convertSvgToGCode(ArrayList<HashMap> svgHmList) {
  HashMap<String, String> firstHm = (HashMap<String, String>)svgHmList.get(0);
  double[] viewboxSize = {0, 0};
  if (firstHm.containsKey("viewBox")) {
    String[] viewbox = firstHm.get("viewBox").split(",");
    viewboxSize[0] = Double.parseDouble(viewbox[2]);
    viewboxSize[1] = Double.parseDouble(viewbox[3]);
  }
  println("fileName = " + fileName);
  println("pxPerMm = " + pxPerMm);
  println("canvasWidth(px) = " + (firstHm.containsKey("viewBox") ? viewboxSize[0] : "undefined"));
  println("canvasHeight(px) = " + (firstHm.containsKey("viewBox") ? viewboxSize[1] : "undefined"));
  println("canvasWidth(mm) = " + (firstHm.containsKey("viewBox") ? pxPerMm * viewboxSize[0] : "undefined"));
  println("canvasHeight(mm) = " + (firstHm.containsKey("viewBox") ? pxPerMm * viewboxSize[1] : "undefined"));
  println("xyFeedrate = " + xyFeedrate);
  println("zFeedrate = " + zFeedrate);
  println("g1z = " + g1z);
  println("g0z = " + g0z);
  println("g4 = " + g4);
  String gCodes = "";
  //add safe start cmd;
  for (int i = 1; i < svgHmList.size(); i++) {
    HashMap<String, String> hm = (HashMap<String, String>)svgHmList.get(i);
    String name = hm.get("name");
    if (isTargettedSvgTag(name)) {
      double[] matrix = {1, 0, 0, 0, 1, 0};
      if (hm.containsKey("transform")) {
        String[] matrixStr = hm.get("transform").split(",");
        for (int j = 0; j < matrixStr.length; j++)
          matrix[j] = Double.parseDouble(matrixStr[j]);
      }
      if (name.equalsIgnoreCase("rect")) {
        double x = Double.parseDouble(hm.get("x"));
        double y = Double.parseDouble(hm.get("y"));
        double width = Double.parseDouble(hm.get("width"));
        double height = Double.parseDouble(hm.get("height"));
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

String gRect(double x, double y, double width, double height, double[] matrix, float pxPerMm) {
  String gCode = "";
  double[] coord = {x, y};
  double[] tCoord;
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
  int[] dCmdIdxArry = getDCmdIdxAsArry(d);
  String[] dCmdArry = new String[dCmdIdxArry.length];
  for (int i = 0; i < dCmdIdxArry.length; i++) {
    int beginIdx = dCmdIdxArry[i];
    int endIdx = (i == dCmdIdxArry.length - 1) ? d.length() : dCmdIdxArry[i + 1];
    dCmdArry[i] = d.substring(beginIdx, endIdx);
  }
  return dCmdArry;
}

String gPath(String[] dCmdArry, double[] matrix, float pxPerMm) {
  String gCode = "";
  double[] origin = {0, 0};
  double[] coord = {0, 0};
  double[] pCoord = {0, 0};
  double[] pCp = {0, 0};
  double[] tCoord;
  if (render)
    beginShape();
  for (String dCmd : dCmdArry) {
    char c = dCmd.charAt(0);
    String[] valStr = dCmd.substring(1).split(",");
    if (c == 'M' || c == 'm') {
      if (c == 'M') {
        coord[0] = Double.parseDouble(valStr[0]);
        coord[1] = Double.parseDouble(valStr[1]);
      } else {
        coord[0] += Double.parseDouble(valStr[0]);
        coord[1] += Double.parseDouble(valStr[1]);
      }
      origin = coord.clone();
      tCoord = applyMatrix(coord, matrix, pxPerMm);
      gCode += "G0 x" + tCoord[0] + " Y" + tCoord[1]  + "\n";
      gCode += "G4 P" + g4  + "\n";
      gCode += "G1 Z" + g1z + " F" + zFeedrate  + "\n";
      gCode += "G4 P" + g4  + "\n";
      if (render)
        vertex((float) tCoord[0], (float) tCoord[1]);
      pCoord[0] = coord[0];
      pCoord[1] = coord[1];
    } else if (c == 'L' || c == 'l') {
      if (c == 'L') {
        coord[0] = Double.parseDouble(valStr[0]);
        coord[1] = Double.parseDouble(valStr[1]);
      } else {
        coord[0] += Double.parseDouble(valStr[0]);
        coord[1] += Double.parseDouble(valStr[1]);
      }
      tCoord = applyMatrix(coord, matrix, pxPerMm);
      gCode += "G1 X" + tCoord[0] + " Y" + tCoord[1] + " F" + xyFeedrate  + "\n";
      if (render)
        vertex((float) tCoord[0], (float) tCoord[1]);
      pCoord[0] = coord[0];
      pCoord[1] = coord[1];
    } else if (c == 'H' || c == 'h') {
      if (c == 'H') {
        coord[0] = Double.parseDouble(valStr[0]);
      } else {
        coord[0] += Double.parseDouble(valStr[0]);
      }
      tCoord = applyMatrix(coord, matrix, pxPerMm);
      gCode += "G1 X" + tCoord[0] + " Y" + tCoord[1] + " F" + xyFeedrate  + "\n";
      if (render)
        vertex((float) tCoord[0], (float) tCoord[1]);
      pCoord[0] = coord[0];
      pCoord[1] = coord[1];
    } else if (c == 'V' || c == 'v') {
      if (c == 'V') {
        coord[1] = Double.parseDouble(valStr[0]);
      } else {
        coord[1] += Double.parseDouble(valStr[0]);
      }
      tCoord = applyMatrix(coord, matrix, pxPerMm);
      gCode += "G1 X" + tCoord[0] + " Y" + tCoord[1] + " F" + xyFeedrate  + "\n";
      if (render)
        vertex((float) tCoord[0], (float) tCoord[1]);
      pCoord[0] = coord[0];
      pCoord[1] = coord[1];
    } else if (c == 'Z' || c == 'z') {
      tCoord = applyMatrix(origin, matrix, pxPerMm);
      gCode += "G1 X" + tCoord[0] + " Y" + tCoord[1] + " F" + xyFeedrate  + "\n";
      if (render)
        vertex((float) tCoord[0], (float) tCoord[1]);
      pCoord[0] = origin[0];
      pCoord[1] = origin[1];
    } else if (c == 'C' || c == 'c') {
      double[] bezier = {
        pCoord[0], pCoord[1], //pt1
        pCoord[0], pCoord[1], //cp1
        pCoord[0], pCoord[1], //cp2
        pCoord[0], pCoord[1]}; //pt2
      if (c == 'C') {
        for (int i = 2; i < bezier.length; i++)
          bezier[i] = Double.parseDouble(valStr[i - 2]);
      } else {
        for (int i = 2; i < bezier.length; i++)
          bezier[i] += Double.parseDouble(valStr[i - 2]);
      }
      double[] mBezier = applyMatrix(bezier, matrix, pxPerMm);
      double[][] arcs = bezierTo_circular(
        bezierInterpolationTolerance,
        mBezier[0], mBezier[1],
        mBezier[2], mBezier[3],
        mBezier[4], mBezier[5],
        mBezier[6], mBezier[7]);
      for (int i = 0; i < arcs.length; i++) {
        double[] arc = arcs[i];
        double cx = arc[0];
        double cy = arc[1];
        double bx = arc[2];
        double by = arc[3];
        double ex = arc[4];
        double ey = arc[5];
        double isCw = arc[6];
        gCode += (isCw > 0.5 ? "G2" : "G3") + " X" + ex + " Y" + ey
          + " I" + (cx - bx) + " J" + (cy - by)
          + " F" + xyFeedrate  + "\n";
      }
      if (render)
        bezierVertex(
          (float) mBezier[2], (float) mBezier[3],
          (float) mBezier[4], (float) mBezier[5],
          (float) mBezier[6], (float) mBezier[7]);
      pCoord[0] = bezier[6];
      pCoord[1] = bezier[7];
      pCp[0] = bezier[4];
      pCp[1] = bezier[5];
    } else if (c == 'S' || c == 's') {
      double[] pCpSym = pointSymetry_4(pCp[0], pCp[1], pCoord[0], pCoord[1]);
      double[] bezier = {
        pCoord[0], pCoord[1], //pt1
        pCpSym[0], pCpSym[1], //cp1
        pCoord[0], pCoord[1], //cp2
        pCoord[0], pCoord[1]}; //pt2
      if (c == 'S') {
        for (int i = 4; i < bezier.length; i++)
          bezier[i] = Double.parseDouble(valStr[i - 4]);
      } else {
        for (int i = 4; i < bezier.length; i++)
          bezier[i] += Double.parseDouble(valStr[i - 4]);
      }
      double[] mBezier = applyMatrix(bezier, matrix, pxPerMm);
      double[][] arcs = bezierTo_circular(
        bezierInterpolationTolerance,
        mBezier[0], mBezier[1],
        mBezier[2], mBezier[3],
        mBezier[4], mBezier[5],
        mBezier[6], mBezier[7]);
      for (int i = 0; i < arcs.length; i++) {
        double[] arc = arcs[i];
        double cx = arc[0];
        double cy = arc[1];
        double bx = arc[2];
        double by = arc[3];
        double ex = arc[4];
        double ey = arc[5];
        double isCw = arc[6];
        gCode += (isCw > 0.5 ? "G2" : "G3") + " X" + ex + " Y" + ey
          + " I" + (cx - bx) + " J" + (cy - by)
          + " F" + xyFeedrate  + "\n";
      }
      if (render)
        bezierVertex(
          (float) mBezier[2], (float) mBezier[3],
          (float) mBezier[4], (float) mBezier[5],
          (float) mBezier[6], (float) mBezier[7]);
      pCoord[0] = bezier[6];
      pCoord[1] = bezier[7];
      pCp[0] = bezier[4];
      pCp[1] = bezier[5];
    } else if (c == 'Q' || c == 'q') {
    } else if (c == 'T' || c == 't') {
    } else if (c == 'A' || c == 'a') {
    }
  }

  if (render)
    endShape();

  gCode += "G4 P" + g4  + "\n";
  gCode += "G0 Z" + g0z  + "\n";
  return gCode;
}
