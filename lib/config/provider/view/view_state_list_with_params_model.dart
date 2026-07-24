import 'package:cardifly/core/models/query_parameters.dart';

import 'view_state_model.dart';

abstract class ViewStateListWithParamsModel<T> extends ViewStateModel {
  List<T> list = [];

  Future<void> initData(QueryParameters params) async {
    setBusy();
    await refresh(init: true, params: params);
  }

  Future<void> refresh({
    bool init = false,
    required QueryParameters params,
  }) async {
    try {
      final data = await loadData(pageNum: 1, params: params);
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

  Future<List<T>> loadData({int? pageNum, QueryParameters? params});

  void onCompleted(List<T> data) {}
}
