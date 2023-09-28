import 'package:cinema/infrastruture/datasource/isar_datasource_impl.dart';
import 'package:cinema/infrastruture/repositories/local_storage_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// inmutable
final localStorageRepositoryProvider = Provider((ref) {
  return LocalStorageRepositoryImpl(datasource: IsarDatasourceImpl());
});
