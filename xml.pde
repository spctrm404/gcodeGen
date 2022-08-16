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