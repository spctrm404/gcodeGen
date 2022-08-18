void setup() {
  double[] center = {400, 400};
  double[] radius = {150, 100};
  float angleDeg = 5;
  double[][] trbl = {{center[0] + radius[1] * Math.cos(Math.toRadians(-90 + angleDeg)), center[1] + radius[1] * Math.sin(Math.toRadians(-90 + angleDeg))},
    {center[0] + radius[0] * Math.cos(Math.toRadians(0 + angleDeg)), center[1] + radius[0] * Math.sin(Math.toRadians(0 + angleDeg))},
    {center[0] + radius[1] * Math.cos(Math.toRadians(90 + angleDeg)), center[1] + radius[1] * Math.sin(Math.toRadians(90 + angleDeg))},
    {center[0] + radius[0] * Math.cos(Math.toRadians(180 + angleDeg)), center[1] + radius[0] * Math.sin(Math.toRadians(180 + angleDeg))}};

  size(800, 800);
  background(255);
  noFill();
  strokeWeight(8);
  stroke(196);
  pushMatrix();
  translate((float) center[0], (float) center[1]);
  rotate((float) Math.toRadians(angleDeg));
  ellipse(0, 0, (float) (2 * radius[0]), (float) (2 * radius[1]));
  popMatrix();
  noStroke();
  fill(cycleColors[0]);
  circle((float) trbl[0][0], (float) trbl[0][1], 8);
  circle((float) trbl[1][0], (float) trbl[1][1], 8);
  circle((float) trbl[2][0], (float) trbl[2][1], 8);
  circle((float) trbl[3][0], (float) trbl[3][1], 8);
  double tbLength = distance(trbl[0], trbl[2]);
  double rlLength = distance(trbl[1], trbl[3]);
  double[][] majorAxis = {
    tbLength > rlLength ? trbl[0] : trbl[1],
    tbLength > rlLength ? trbl[2] : trbl[3]}; //A, B
  double[][] minorAxis = {
    tbLength <= rlLength ? trbl[0] : trbl[1],
    tbLength <= rlLength ? trbl[2] : trbl[3]}; //C, D
  double deltaLength = Math.abs(tbLength - rlLength);
  double[] ptF = pointOnLine(minorAxis[0], majorAxis[0], deltaLength * 0.5); //F
  double[] midAF = midpoint(majorAxis[0], ptF);
  double[] perp = perpendicularToLine(ptF, majorAxis[0]);
  double[] interMajor = lineLineIntersection_4(midAF, perp, majorAxis[0], majorAxis[1]); //1
  double[] interMinor = lineLineIntersection_4(midAF, perp, minorAxis[0], minorAxis[1]); //2
  double[] interMajorC = pointSymetry(interMajor, center); //3
  double[] interMinorC = pointSymetry(interMinor, center); //4
  double minorLength = 
  double majorLength = 

  strokeWeight(1);
  stroke(cycleColors[2]);
  line((float) majorAxis[0][0], (float) majorAxis[0][1],
    (float) majorAxis[1][0], (float) majorAxis[1][1]);
  line((float) majorAxis[0][0], (float) majorAxis[0][1],
    (float) minorAxis[0][0], (float) minorAxis[0][1]);
  noStroke();
  fill(0);
  circle((float) ptF[0], (float) ptF[1], 8);
  fill(cycleColors[4]);
  circle((float) midAF[0], (float) midAF[1], 8);
  fill(cycleColors[6]);
  circle((float) interMajor[0], (float) interMajor[1], 8);
  circle((float) interMajorC[0], (float) interMajorC[1], 8);
  fill(0);
  circle((float) interMinor[0], (float) interMinor[1], 8);
  circle((float) interMinorC[0], (float) interMinorC[1], 8);



  // double[] mpTR = midpoint(trbl[0], trbl[1]);
  // double[] perpIn = perpendicularToLine(trbl[1], trbl[0]);
  // double[] interH = lineLineIntersection_4(mpTR, perpIn, trbl[1], trbl[3]);
  // double[] interV = lineLineIntersection_4(mpTR, perpIn, trbl[0], trbl[2]);
  // fill(0, 0, 255);
  // circle((float) interH[0], (float) interH[1], 8);
  // circle((float) interV[0], (float) interV[1], 8);
}

void draw() {
}
