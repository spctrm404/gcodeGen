double b3p0(double t, double p) {
  double k = 1 - t;
  return k * k * k * p;
}

double b3p1(double t, double p) {
  double k = 1 - t;
  return 3 * k * k * t * p;
}

double b3p2(double t, double p) {
  double k = 1 - t;
  return 3 * k * t * t * p;
}

double b3p3(double t, double p) {
  return t * t * t * p;
}

double b3(
  double t,
  double p0, double p1,
  double p2, double p3) {
  return b3p0(t, p0) + b3p1(t, p1) + b3p2(t, p2) + b3p3(t, p3);
}

double[] bezierCurve_8(
  double t,
  double x1, double y1,
  double cx1, double cy1,
  double cx2, double cy2,
  double x2, double y2) {
  double[] pt = {b3(t, x1, cx1, cx2, x2), b3(t, x1, cx1, cx2, x2)};
  return pt;
}


double[] bezierCurve(
  double t,
  double[] pt1, double[] cp1,
  double[] cp2, double[] pt2) {
  return bezierCurve_8(t, pt1[0], pt1[1], cp1[0], cp1[1], cp2[0], cp2[1], pt2[0], pt2[1]);
}

double arclength_approx(
  int subdivisions,
  double x1, double y1,
  double cp1x, double cp1y,
  double cp2x, double cp2y,
  double x2, double y2) {
  double px = x1;
  double py = y1;
  double length = 0;
  for (int i = 1; i <= subdivisions; i++) {
    float t = i / subdivisions;
    double tx = b3(t, x1, cp1x, cp2x, x2);
    double ty = b3(t, y1, cp1y, cp2y, y2);
    length += distance_4(px, py, tx, ty);
    px = tx;
    py = ty;
  }
  return length;
}
