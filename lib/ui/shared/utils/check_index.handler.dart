/// Check index
T checkIndex<T, S>(
  S index, {
  required S compareIndex,
  required T onTrue,
  required T onFalse,
}) {
  return compareIndex == index ? onTrue : onFalse;
}
