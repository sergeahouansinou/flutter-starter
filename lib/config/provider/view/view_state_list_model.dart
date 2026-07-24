import 'view_state_model.dart';

abstract class ViewStateListModel<T> extends ViewStateModel {
  List<T> list = [];

  Future<void> initData() async {
    setBusy();
    await refresh(init: true);
  }

  Future<void> refresh({bool init = false}) async {
    try {
      final data = await loadData();
      if (data.isEmpty) {
        list.clear();
        setEmpty();
      } else {
        onCompleted(data);
        list
          ..clear()
          ..addAll(data);
        setIdle();
      }
    } catch (e, s) {
      if (init) list.clear();
      setError(e, s, message: '');
    }
  }

  Future<List<T>> loadData({int? pageNum});

  void onCompleted(List<T> data) {}
}
