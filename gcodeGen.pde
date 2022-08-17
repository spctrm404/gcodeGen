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
  XML[] extractedSvgArry = getTargettedSvgTagsAsXmlArry(svg, null);
  ArrayList<HashMap> svgHmList = new ArrayList<>();
  svgHmList.add(getViewBoxInfoAsHm(svg));
  for (XML xml : extractedSvgArry) {
    println(xml);
  }
  double[] matrix = {1, 0, 0, 0, 1, 0};
  recursiveSvgToHmConversion(extractedSvgArry, svgHmList, matrix);
  printHmList(svgHmList);
  println(convertSvgToGCode(svgHmList));
}

void draw() {
}
