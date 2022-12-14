double[][] bezierTo_circular(
  float tolerance,
  double x1, double y1,
  double cp1x, double cp1y,
  double cp2x, double cp2y,
  double x2, double y2) {
  ArrayList<double[]> arcList = new ArrayList<>();
  float t = 0;
  int cnt = 0;
  while (t < 1) {
    float e = 1;
    while (true) {
      float n = (t + e) / 2;

      double[] pt1 = {x1, y1};
      double[] cp1 = {cp1x, cp1y};
      double[] cp2 = {cp2x, cp2y};
      double[] pt2 = {x2, y2};
      double[] p1 = bezierCurve(t, pt1, cp1, cp2, pt2);
      double[] p2 = bezierCurve(n, pt1, cp1, cp2, pt2);
      double[] p3 = bezierCurve(e, pt1, cp1, cp2, pt2);

      double[] circle = circleFromThreePoints(p1, p2, p3);
      double[] center = {circle[0], circle[1]};
      double radius = circle[2];

      double[] check1 = bezierCurve((t + n) / 2, pt1, cp1, cp2, pt2);
      double[] check2 = bezierCurve((n + e) / 2, pt1, cp1, cp2, pt2);

      double error1 = computeCircularError(check1, center, radius);
      double error2 = computeCircularError(check2, center, radius);
      double maxError = Math.max(error1, error2);

      if (maxError < tolerance) {
        double startAngle = angle(center, p1);
        double middleAngle = angle(center, p2);
        double endAngle = angle(center, p3);
        if (!render) {
          stroke(cycleColors[cnt % 12]);
          arc(
            (float) center[0], (float) center[1],
            (float) (2 * radius), (float) (2 * radius),
            (float) startAngle, (float) endAngle);
        }
        t = e;
        double[] arc = {
          center[0], center[1], //center
          p1[0], p1[1], //begin
          p3[0], p3[1], //end
          isCw(center, p1, p3) ? 1 : 0, //isCw
          2 * radius, //diameter
          startAngle, endAngle}; //beginAngle, EndAngle
        arcList.add(arc);
        cnt++;
        break;
      } else {
        e = n;
      }
    }
  }
  double[][] arcArry = new double[arcList.size()][10];
  for (int i = 0; i < arcList.size(); i++)
    for (int j = 0; j < 10; j++)
      arcArry[i][j] = arcList.get(i)[j];
  return arcArry;
  // return null;
}

double computeCircularError(double[] pointOnCurve, double[] center, double radius) {
  double actual = distance(pointOnCurve, center);
  double expected = radius;
  return Math.abs(actual - expected);
}
