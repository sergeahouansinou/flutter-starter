import 'package:cardifly/ui/components/app_pull_to_refresh.dart';
import 'package:flutter/foundation.dart';

import 'view_state_list_model.dart';

/// Paginated list ViewModel backed by [AppRefreshController].
/// No third-party pull-to-refresh dependency.
abstract class ViewStateRefreshListModel<T> extends ViewStateListModel<T> {
  static const int pageNumFirst = 1;
  static const int pageSize = 8;

  final AppRefreshController _refreshController = AppRefreshController();

  AppRefreshController get refreshController => _refreshController;

  int _currentPageNum = pageNumFirst;

  @override
  Future<List<T>?> refresh({bool init = false}) async {
    try {
      _currentPageNum = pageNumFirst;
      final data = await loadData(pageNum: pageNumFirst);
      if (data.isEmpty) {
        list.clear();
        setEmpty();
      } else {
        onCompleted(data);
        list
          ..clear()
          ..addAll(data);
        if (data.length < pageSize) {
          _refreshController.loadNoData();
        } else {
          _refreshController.loadComplete();
        }
        setIdle();
      }
      _refreshController.refreshCompleted();
      return data;
    } catch (e, s) {
      if (init) list.clear();
      _refreshController.refreshFailed();
      setError(e, s, message: '');
      return null;
    }
  }

  Future<List<T>?> loadMore() async {
    try {
      final data = await loadData(pageNum: ++_currentPageNum);
      if (data.isEmpty) {
        _currentPageNum--;
        _refreshController.loadNoData();
      } else {
        onCompleted(data);
        list.addAll(data);
        if (data.length < pageSize) {
          _refreshController.loadNoData();
        } else {
          _refreshController.loadComplete();
        }
        notifyListeners();
      }
      return data;
    } catch (e, s) {
      _currentPageNum--;
      _refreshController.loadFailed();
      debugPrint('loadMore error --> $e\n$s');
      return null;
    }
  }

  @override
  Future<List<T>> loadData({int? pageNum});

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
