import 'package:cardifly/config/provider/provider_request.dart';
import 'package:cardifly/core/models/query_parameters.dart';

class QueryParametersModel extends ProviderRequest {
  QueryParameters params = QueryParameters();

  void setParams(QueryParameters query) {
    params = query;
    setSuccess();
  }
}
