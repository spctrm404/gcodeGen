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

boolean isTargettedSvgTag(String name) {
  for (String targettedSvgTag : tagettedSvgTagList)
    if (name.equals(targettedSvgTag))
      return true;
  return false;
}

XML[] getTargettedSvgTagsAsXmlArry(XML svg, ArrayList<XML> extractedSvgTagList) {
  if (extractedSvgTagList == null)
    extractedSvgTagList = new ArrayList<> ();
  if (isTargettedSvgTag(svg.getName())) {
    extractedSvgTagList.add(svg);
  } else if (svg.hasChildren()) {
    XML[] children = svg.getChildren();
    for (XML child : children)
      getTargettedSvgTagsAsXmlArry(child, extractedSvgTagList);
  }
  return extractedSvgTagList.toArray(new XML[0]);
}

HashMap<String, String> getViewBoxInfoAsHm(XML svg) {
  HashMap<String, String> hm = new HashMap<>();
  if (svg.hasAttribute("viewBox")) {
    String attrValStr = formatStr(svg.getString("viewBox"));
    hm.put("viewBox", attrValStr);
  }
  return hm;
}

boolean isSupportedTfSyntax(String transformStr) {
  for (String supportedTfSyntax : supportedTransformSyntaxList)
    if (transformStr.contains(supportedTfSyntax))
      return true;
  return false;
}

String getSupportedTfSyntax(String transformStr) {
  for (String supportedTfSyntax : supportedTransformSyntaxList)
    if (transformStr.contains(supportedTfSyntax))
      return supportedTfSyntax;
  return "";
}

void putSvgAttrOnHm(XML svg, String attrName, HashMap hm) {
  if (svg.hasAttribute(attrName)) {
    String attrValStr = formatStr(svg.getString(attrName).trim());
    if (attrName.equals("transform")) {
      String[] splitted = leaveValOnly(attrValStr).split(",");
      double[] attrVal = new double[splitted.length];
      for (int i = 0; i < splitted.length; i++)
        attrVal[i] = Double.parseDouble(splitted[i]);
      boolean isSupported = isSupportedTfSyntax(attrValStr);
      double[] matrix = {1, 0, 0, 0, 1, 0};
      if (isSupported)
        matrix = convertTransformToMarix(getSupportedTfSyntax(attrValStr), attrVal);
      String matrixStr = "";
      for (int i = 0; i < matrix.length; i++) {
        matrixStr += matrix[i];
        if (i != matrix.length - 1)
          matrixStr += ",";
      }
      hm.put(attrName, matrixStr);
    } else {
      hm.put(attrName, attrValStr);
    }
  }
}

HashMap<String, String> getSvgAttrAsHm(XML svg) {
  HashMap<String, String> hm = new HashMap<>();
  String name = svg.getName();
  if (isTargettedSvgTag(name)) {
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

void recursiveSvgToHmConversion(XML[] extractedSvgArry, ArrayList<HashMap> svgHmList, double[] matrix) {
  for (XML svgElem : extractedSvgArry) {
    HashMap<String, String> hm = getSvgAttrAsHm(svgElem);
    if (hm != null) {
      double[] matrix_c = {1, 0, 0, 0, 1, 0};
      if (!hm.get("name").equals("g")) {
        svgHmList.add(hm);
      } else if (svgElem.hasChildren()) {
        double[] matrix_p = matrix.clone();
        if (hm.containsKey("transform")) {
          String[] matrix_m_Str = hm.get("transform").split(",");
          double[] matrix_m = new double[matrix_m_Str.length];
          for (int i = 0; i < matrix_m_Str.length; i++)
            matrix_m[i] = Double.parseDouble(matrix_m_Str[i]);
          matrix_c = matrixMult(matrix_p, matrix_m);
        }
        XML[] children = svgElem.getChildren();
        recursiveSvgToHmConversion(children, svgHmList, matrix_c);
      }
    }
  }
}

void printHmList(ArrayList<HashMap> hmList) {
  println("print");
  for (HashMap<String, String> hm : hmList) {
    println("----------");
    for (Map.Entry entry : hm.entrySet()) {
      print(entry.getKey() + " = ");
      println(entry.getValue());
    }
  }
}
