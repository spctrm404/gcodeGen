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

boolean render = true;

String fileName = "sample1_ai.svg";
float pxPerMm = 1;
int xyFeedrate = 6000;
int zFeedrate = 2000;
float g1z = -1;
float g0z = 5;
float g4 = 0.05; //50ms

float bezierInterpolationTolerance = 0.1;

void setup() {
  size(800, 800);
  noFill();
  XML svg;
  svg = loadXML(fileName);
  println("----- raw svg");
  println(svg);
  printXmlStructure(svg, 0, "");
  XML[] extractedSvgTagArry = getTargettedSvgTagsAsXmlArry(svg, null);
  println("----- extracted svg tags");
  printArray(extractedSvgTagArry);
  ArrayList<HashMap> svgHmList = new ArrayList<>();
  svgHmList.add(getViewBoxInfoAsHm(svg));
  double[] matrix = {1, 0, 0, 0, 1, 0};
  recursiveSvgToHmConversion(extractedSvgTagArry, svgHmList, matrix);
  printHmList(svgHmList);
  String gCodes = convertSvgToGCode(svgHmList);
  println("----- created gcode");
  println(gCodes);
}

void draw() {
}
