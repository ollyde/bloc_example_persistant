import 'dart:convert';
import 'dart:io';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

class CustomHydratedBlocStorage implements HydratedStorage {
  String _applicationPath;

  static build() async {
    final path = await getApplicationDocumentsDirectory();
    print('Storing docs at ' + path.path);
    return CustomHydratedBlocStorage(path.path);
  }

  CustomHydratedBlocStorage(this._applicationPath);

  @override
  dynamic read(String key) {
    try {
      final jsonFile = File(_applicationPath + '/' + key + '_bloc.json');
      if (!jsonFile.existsSync()) {
        return null;
      }
      final json = jsonDecode(jsonFile.readAsStringSync());
      return json;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Future<void> write(String key, dynamic value) async {
    try {
      final jsonFile = File(_applicationPath + '/' + key + '_bloc.json');
      jsonFile.writeAsStringSync(jsonEncode(value));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      final jsonFile = File(_applicationPath + '/' + key + '_bloc.json');
      jsonFile.deleteSync();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Future<void> clear() async {
    try {
      final files = Directory("$_applicationPath/").listSync();
      files.forEach((element) {
        if (element.path.contains('_bloc.json')) {
          element.deleteSync();
        }
      });
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
