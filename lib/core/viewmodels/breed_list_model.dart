import 'package:cardifly/config/provider/view/view_state_refresh_list_model.dart';
import 'package:cardifly/core/models/breed.dart';
import 'package:cardifly/core/services/breed_service.dart';

/// Paginated breeds view-model backed by the Dog API v2.
///
/// Inherits pull-to-refresh + infinite-scroll orchestration from
/// [ViewStateRefreshListModel] — only the data-loading strategy is
/// implemented here.
class BreedListModel extends ViewStateRefreshListModel<Breed> {
  @override
  Future<List<Breed>> loadData({int? pageNum}) {
    return BreedService.list(
      page: pageNum ?? ViewStateRefreshListModel.pageNumFirst,
      pageSize: ViewStateRefreshListModel.pageSize,
    );
  }
}
