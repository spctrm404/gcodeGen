//>>> G3X202.4221Y421.2506I13624728.6845J-227370381.8265F6000
//ok
//>>> G2X135.8861Y417.9554I-217.4286J3716.8451F6000
//[Error] An error was detected while sending 'G3X202.4221Y421.2506I13624728.6845J-227370381.8265F6000': error: Invalid gcode ID:33. Streaming has been paused.
//**** The communicator has been paused ****

//**** Pausing file transfer. ****

//[Error] An error was detected while sending 'G2X135.8861Y417.9554I-217.4286J3716.8451F6000': error: Invalid gcode ID:33. Streaming has been paused.
//**** The communicator has been paused ****

//**** Pausing file transfer. ****

// to do
// check for
// check equal and contain (case)

import java.util.Calendar;
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

//String fileName = "sz_print_01-ai.svg";
//String fileName = "sz_print_02-ai.svg";
// String fileName = "sz_print_01-ai_alt.svg";
// float pxPerMm = 0.35277849670096045553691224446998;
String fileName = "testPatt1-01.svg";
float pxPerMm = 0.1;
//float pxPerMm = 0.5;
int xyFeedrate = 6000;
int zFeedrate = 2000;
float g1z = -0.5;
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
  saveStrings("output/" + timestamp() + ".gcode", gCodeSave);
  println("done");
}

void draw() {
}
