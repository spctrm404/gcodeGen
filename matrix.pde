float[] applyMatrix(float[] coord, float[] matrix, float pxPerMm) {
  float[] newCoord = coord.clone();
  newCoord[0] = pxPerMm * (matrix[0] * newCoord[0] + matrix[1] * newCoord[1] + matrix[2]);
  newCoord[1] = pxPerMm * (matrix[3] * newCoord[0] + matrix[4] * newCoord[1] + matrix[5]);
  return newCoord;
}

float[] convertTransformToMarix(String transform, float[] attrVal) {
  float[] matrix = {1, 0, 0, 0, 1, 0};
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
    float sin = (float) Math.sin(Math.toRadians(attrVal[0]));
    float cos = (float) Math.cos(Math.toRadians(attrVal[0]));
    matrix[0] = cos;
    matrix[1] = -sin;
    matrix[3] = sin;
    matrix[4] = cos;
    if (attrVal.length == 3) {
      matrix[2] = attrVal[1] * (1 - cos) + attrVal[2] * sin;
      matrix[5] = attrVal[2] * (1 - cos) - attrVal[1] * sin;
    }
  } else if (transform.equalsIgnoreCase("skewX")) {
    float tan = (float) Math.tan(Math.toRadians(attrVal[0]));
    matrix[1] = tan;
  } else if (transform.equalsIgnoreCase("skewY")) {
    float tan = (float) Math.tan(Math.toRadians(attrVal[0]));
    matrix[3] = tan;
  }
  return matrix;
}

float[] matrixMult(float[] matrix_p, float[] matrix_m) {
  float[] newMatrix = new float[6];
  newMatrix[0] = matrix_p[0] * matrix_m[0] + matrix_p[2] * matrix_m[1] + 0;
  newMatrix[2] = matrix_p[0] * matrix_m[2] + matrix_p[2] * matrix_m[3] + 0;
  newMatrix[4] = matrix_p[0] * matrix_m[4] + matrix_p[2] * matrix_m[5] + matrix_p[4];
  newMatrix[1] = matrix_p[1] * matrix_m[0] + matrix_p[3] * matrix_m[1] + 0;
  newMatrix[3] = matrix_p[1] * matrix_m[2] + matrix_p[3] * matrix_m[3] + 0;
  newMatrix[5] = matrix_p[1] * matrix_m[4] + matrix_p[3] * matrix_m[5] + matrix_p[5];
  return newMatrix;
}
