import 'package:cardifly/core/models/query_parameters.dart';
import 'package:cardifly/ui/components/app_pull_to_refresh.dart';
import 'package:flutter/foundation.dart';

import 'view_state_list_with_params_model.dart';

abstract class ViewStateRefreshListWithParamsModel<T>
    extends ViewStateListWithParamsModel<T> {
  static const int pageNumFirst = 1;
  static const int pageSize = 15;

  final AppRefreshController _refreshController = AppRefreshController();
  AppRefreshController get refreshController => _refreshController;

  int _currentPageNum = pageNumFirst;

  @override
  Future<List<T>?> refresh({bool init = false, QueryParameters? params}) async {
    try {
      _currentPageNum = pageNumFirst;
      final data = await loadData(pageNum: pageNumFirst, params: params);
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

  Future<List<T>?> reload({int? pageNum, QueryParameters? params}) async {
    try {
      if (pageNum != null &&
          pageNum > 1 &&
          list.length == ((pageNum - 1) * pageSize) + 1) {
        pageNum = pageNum - 1;
        _currentPageNum--;
      }
      final effectivePage =
          (pageNum ?? _currentPageNum) > _currentPageNum
              ? _currentPageNum
              : (pageNum ?? _currentPageNum);
      final data = await loadData(pageNum: effectivePage, params: params);
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
      _refreshController.refreshFailed();
      setError(e, s, message: '');
      return null;
    }
  }

  Future<List<T>?> loadMore(QueryParameters params) async {
    try {
      final data = await loadData(pageNum: ++_currentPageNum, params: params);
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
  Future<List<T>> loadData({int? pageNum, QueryParameters? params});

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
