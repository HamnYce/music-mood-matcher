String capitalize(String s) {
  return '${s[0].toUpperCase()}${s.substring(1)}';
}

String basicPluralize(String s) {
  return '${s}s';
}

String basicUnpluralize(String s) {
  return s.substring(0, s.length - 1);
}

String normaliseCategory(String s) {
  return basicUnpluralize(s).toLowerCase();
}
