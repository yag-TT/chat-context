/// Mock Repositoryが受け取ったListを固定化します。
///
/// テストで注入元Listを後から変更しても、Repositoryの返却値が変わらない
/// ようにするための小さな共通処理です。
List<T> snapshotRepositoryList<T>(Iterable<T> values) {
  return List<T>.unmodifiable(values);
}
