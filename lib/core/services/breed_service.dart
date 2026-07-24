import 'package:cardifly/config/net/dog_api.dart';
import 'package:cardifly/core/models/breed.dart';
import 'package:cardifly/core/services/base_service.dart';

/// Facade over the Dog API v2 `/breeds` endpoint.
class BreedService extends BaseService {
  /// Fetches a paginated list of breeds.
  ///
  /// The Dog API uses the JSON:API sparse-fieldset conventions
  /// (`page[number]=X`, `page[size]=Y`). We match the app-wide page size so
  /// [ViewStateRefreshListModel] can detect the last page via
  /// `list.length < pageSize`.
  static Future<List<Breed>> list({int page = 1, int pageSize = 8}) async {
    final res = await dogHttp.get<Map<String, dynamic>>(
      'breeds',
      queryParameters: {
        'page[number]': page,
        'page[size]': pageSize,
      },
    );
    final payload = res.data;
    if (payload == null) return const [];
    final rows = (payload['data'] as List<dynamic>? ?? const []);
    return rows
        .map((raw) => Breed.fromJson(raw as Map<String, dynamic>))
        .toList();
  }

  /// Fetches a single breed by its UUID.
  static Future<Breed> byId(String id) async {
    final res = await dogHttp.get<Map<String, dynamic>>('breeds/$id');
    final data = res.data?['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw StateError('Breed $id not found');
    }
    return Breed.fromJson(data);
  }
}
