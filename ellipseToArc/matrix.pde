double[] applyMatrix(double[] coord, double[] matrix, double pxPerMm) {
  double[] newCoord = coord.clone();
  for (int i = 0; i < newCoord.length; i += 2) {
    newCoord[i % 2] = pxPerMm * (matrix[0] * coord[i % 2] + matrix[1] * coord[(i + 1) % 2] + matrix[2]);
    newCoord[(i + 1) % 2] = pxPerMm * (matrix[3] * coord[i % 2] + matrix[4] * coord[(i + 1) % 2] + matrix[5]);
  }
  return newCoord;
}

double[] convertTransformToMarix(String transform, double[] attrVal) {
  double[] matrix = {1, 0, 0, 0, 1, 0};
  if (transform.equalsIgnoreCase("matrix")) {
    matrix[0] = attrVal[0];
    matrix[1] = attrVal[2];
    matrix[2] = attrVal[4];
    matrix[3] = attrVal[1];
    matrix[4] = attrVal[3];
    matrix[5] = attrVal[5];
  } else if (transform.equalsIgnoreCase("translate")) {
    matrix[2] = attrVal[0];
    matrix[5] = attrVal[1];
  } else if (transform.equalsIgnoreCase("scale")) {
    matrix[0] = attrVal[0];
    matrix[4] = attrVal.length == 2 ? attrVal[1] : attrVal[0];
  } else if (transform.equalsIgnoreCase("rotate")) {
    double sin = Math.sin(Math.toRadians(attrVal[0]));
    double cos = Math.cos(Math.toRadians(attrVal[0]));
    matrix[0] = cos;
    matrix[1] = -sin;
    matrix[3] = sin;
    matrix[4] = cos;
    if (attrVal.length == 3) {
      matrix[2] = attrVal[1] * (1 - cos) + attrVal[2] * sin;
      matrix[5] = attrVal[2] * (1 - cos) - attrVal[1] * sin;
    }
  } else if (transform.equalsIgnoreCase("skewX")) {
    double tan = Math.tan(Math.toRadians(attrVal[0]));
    matrix[1] = tan;
  } else if (transform.equalsIgnoreCase("skewY")) {
    double tan = Math.tan(Math.toRadians(attrVal[0]));
    matrix[3] = tan;
  }
  return matrix;
}

double[] matrixMult(double[] matrix_p, double[] matrix_m) {
  double[] newMatrix = new double[6];
  newMatrix[0] = matrix_p[0] * matrix_m[0] + matrix_p[2] * matrix_m[1] + 0;
  newMatrix[2] = matrix_p[0] * matrix_m[2] + matrix_p[2] * matrix_m[3] + 0;
  newMatrix[4] = matrix_p[0] * matrix_m[4] + matrix_p[2] * matrix_m[5] + matrix_p[4];
  newMatrix[1] = matrix_p[1] * matrix_m[0] + matrix_p[3] * matrix_m[1] + 0;
  newMatrix[3] = matrix_p[1] * matrix_m[2] + matrix_p[3] * matrix_m[3] + 0;
  newMatrix[5] = matrix_p[1] * matrix_m[4] + matrix_p[3] * matrix_m[5] + matrix_p[5];
  return newMatrix;
}
