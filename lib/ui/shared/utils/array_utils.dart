class ArrayUtils<T> {
  List<List<T>> chunk(List<T> array, int chunkSize) {
    final List<List<T>> chunks = [];
    for (var i = 0; i < array.length; i += chunkSize) {
      chunks.add(array.sublist(i, (i + chunkSize > array.length) ? array.length : (i + chunkSize)));
    }
    return chunks;
  }
}