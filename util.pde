int[] cycleColors = {
  0xFFCD00E5,
  0xFF8B51FF,
  0xFF006EFF,
  0xFF007FB6,
  0xFF008494,
  0xFF008772,
  0xFF008A35,
  0xFF6C8000,
  0xFF957300,
  0xFFB46300,
  0xFFEA2100,
  0xFFE7007A
};

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
