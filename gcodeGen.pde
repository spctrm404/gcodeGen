//to do
// check for
// check equal and contain (case)

import java.util.Map;

String[] tagettedSvgTagList = {
  "rect",
  "circle",
  "ellipse",
  "line",
  "polyline",
  "polygon",
  "path",
  "g"
};

String[] supportedTransformSyntaxList = {
  "matrix",
  "translate",
  "scale",
  "rotate",
  "skewX",
  "skewY"
};

char[] supportedDCmdList = {
  'M', 'm',
  'L', 'l',
  'H', 'h',
  'V', 'v',
  'Z', 'z',
  'C', 'c',
  'S', 's',
  'Q', 'q',
  'T', 't',
  'A', 'a'
};

boolean debug = false;
boolean render = true;

String fileName = "sz_print_01_unged.svg";
//String fileName = "sample1_ai.svg";
float pxPerMm = 0.42333418000169333672000677334688;
//float pxPerMm = 0.5;
//float pxPerMm = 1;
int xyFeedrate = 6000;
int zFeedrate = 2000;
float g1z = -1;
float g0z = 5;
float g4 = 0.05; //50ms

float bezierInterpolationTolerance = 0.1;

void setup() {
  size(960, 1920);
  noFill();
  XML svg;
  svg = loadXML(fileName);
  println("----- raw svg");
  println(svg);
  //printXmlStructure(svg, 0, "");
  XML[] extractedSvgTagArry = getTargettedSvgTagsAsXmlArry(svg, null);
  //println("----- extracted svg tags");
  //printArray(extractedSvgTagArry);
  ArrayList<HashMap> svgHmList = new ArrayList<>();
  svgHmList.add(getViewBoxInfoAsHm(svg));
  double[] matrix = {1, 0, 0, 0, 1, 0};
  recursiveSvgToHmConversion(extractedSvgTagArry, svgHmList, matrix);
  //printHmList(svgHmList);
  String gCode = convertSvgToGCode(svgHmList);
  //println("----- created gcode");
  //println(gCode);
  String[] gCodeSave = gCode.split("\n");
  saveStrings("output.gcode", gCodeSave);
  println("done");
}

void draw() {
}
