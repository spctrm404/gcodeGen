double distance_4(
  double x1, double y1,
  double x2, double y2) {
  return Math.sqrt(Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2));
}

double distance(double[] pt1, double[] pt2) {
  return distance_4(pt1[0], pt1[1], pt2[0], pt2[1]);
}

double[] midpoint_4(
  double x1, double y1,
  double x2, double y2) {
  double[] midpoint = {(x1 + x2) / 2, (y1 + y2) / 2};
  return midpoint;
}

double[] midpoint(double[] pt1, double[] pt2) {
  return midpoint_4(pt1[0], pt1[1], pt2[0], pt2[1]);
}

double[] perpendicularToLine_4(
  double x1, double y1,
  double x2, double y2) {
  double[] perpendicular = {
    x2 - (999999999 * (y1 - y2)) / distance_4(x1, y1, x2, y2),
    y2 + (999999999 * (x1 - x2)) / distance_4(x1, y1, x2, y2)};
  return perpendicular;
}

double[] perpendicularToLine(double[] pt1, double[] pt2) {
  return perpendicularToLine_4(pt1[0], pt1[1], pt2[0], pt2[1]);
}

double[] circleFromThreePoints_6(
  double x1, double y1,
  double x2, double y2,
  double x3, double y3) {
  double[] mpt0 = midpoint_4(x1, y1, x2, y2);
  double[] mpt1 = midpoint_4(x1, y1, x3, y3);
  double[] perp0 = perpendicularToLine_4(x1, y1, mpt0[0], mpt0[1]);
  double[] perp1 = perpendicularToLine_4(x1, y1, mpt1[0], mpt1[1]);

  double[] center = lineLineIntersection_4(perp0, mpt0, perp1, mpt1);
  double radius = distance_4(center[0], center[1], x1, y1);

  double[] circle = {center[0], center[1], radius};
  return circle;
}

double[] circleFromThreePoints(double[] pt0, double[] pt1, double[] pt2) {
  return circleFromThreePoints_6(pt0[0], pt0[1], pt1[0], pt1[1], pt2[0], pt2[1]);
}

double[] lineLineIntersection_8(
  double x1, double y1,
  double x2, double y2,
  double x3, double y3,
  double x4, double y4) {
  double nx = (x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4);
  double ny = (x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4);
  double d = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);

  // if d == 1, the lines are paralllel.
  double[] intersection = {nx / d, ny / d};
  return intersection;
}

double[] lineLineIntersection_4(
  double[] pt1, double[] pt2,
  double[] pt3, double[] pt4) {
  return lineLineIntersection_8(pt1[0], pt1[1], pt2[0], pt2[1], pt3[0], pt3[1], pt4[0], pt4[1]);
}

double[] lineLineIntersection(double[][] line1, double[][] line2) {
  return lineLineIntersection_4(line1[0], line1[1], line2[0], line2[1]);
}

double angle_4(
  double x1, double y1,
  double x2, double y2) {
  double dx = x2 - x1;
  double dy = y2 - y1;
  return Math.atan2(dy, dx);
}

double angle(double[] pt1, double[] pt2) {
  return angle_4(pt1[0], pt1[1], pt2[0], pt2[1]);
}

boolean isCw_6(
  double cx, double cy,
  double x1, double y1,
  double x2, double y2) {
  double d = (x1 - cx) * (y2 - cy) - (x2 - cx) * (y1 - cy);
  // if d == 0, the point 1, 2, 3 is colinear.
  return d < 0;
}

boolean isCw(double[] cp, double[] pt1, double[] pt2) {
  return isCw_6(cp[0], cp[1], pt1[0], pt1[1], pt2[0], pt2[1]);
}

double[] pointSymetry_4(double x, double y, double sx, double sy) {
  double[] symetry = {2 * sx * x, 2 * sy - y};
  return symetry;
}

double[] pointSymetry(double[] pt, double[] symPt) {
  return pointSymetry_4(pt[0], pt[1], symPt[0], symPt[1]);
}
