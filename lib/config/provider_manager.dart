import 'package:cardifly/core/viewmodels/breed_list_model.dart';
import 'package:cardifly/core/viewmodels/local_view_model.dart';
import 'package:cardifly/core/viewmodels/query_parameters_model.dart';
import 'package:cardifly/core/viewmodels/theme_model.dart';
import 'package:cardifly/core/viewmodels/user_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => LocaleModel()),
  ChangeNotifierProvider(create: (_) => ThemeModel()),
  ChangeNotifierProvider(create: (_) => UserModel()),
  ChangeNotifierProvider(create: (_) => QueryParametersModel()),
  ChangeNotifierProvider(create: (_) => BreedListModel()),
];
