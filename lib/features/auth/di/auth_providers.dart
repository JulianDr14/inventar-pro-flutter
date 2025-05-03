import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intentary_pro/core/database/sqlite_database.dart';
import 'package:intentary_pro/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:intentary_pro/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:intentary_pro/features/auth/domain/usecases/login_usecase.dart';
import 'package:intentary_pro/features/auth/presentation/viewmodels/auth_viewmodel.dart';

// 1. Proveedor de la DB singleton
final sqliteDbProvider = Provider<SqliteDatabase>((ref) {
  return SqliteDatabase();
});

// 2. Proveedor del DataSource local
final authLocalDataSourceProvider =
Provider<AuthLocalDataSource>((ref) {
  final db = ref.read(sqliteDbProvider);
  return AuthLocalDataSourceImpl(db);
});

// 3. Proveedor del repositorio de Auth
final authRepositoryProvider =
Provider<AuthRepositoryImpl>((ref) {
  final local = ref.read(authLocalDataSourceProvider);
  return AuthRepositoryImpl(localDataSource: local);
});

// 4. Proveedor del caso de uso Login
final loginUseCaseProvider =
Provider<LoginUseCase>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return LoginUseCase(repo);
});

// 5. Proveedor del ViewModel (StateNotifier)
final authViewModelProvider =
StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final uc = ref.read(loginUseCaseProvider);
  return AuthViewModel(uc);
});
