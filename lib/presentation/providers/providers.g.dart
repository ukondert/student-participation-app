// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
const appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  const AppDatabaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'appDatabaseProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'8c69eb46d45206533c176c88a926608e79ca927d';

@ProviderFor(classRepository)
const classRepositoryProvider = ClassRepositoryProvider._();

final class ClassRepositoryProvider extends $FunctionalProvider<
    IClassRepository,
    IClassRepository,
    IClassRepository> with $Provider<IClassRepository> {
  const ClassRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'classRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$classRepositoryHash();

  @$internal
  @override
  $ProviderElement<IClassRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IClassRepository create(Ref ref) {
    return classRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IClassRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IClassRepository>(value),
    );
  }
}

String _$classRepositoryHash() => r'ab8f797ae38e57183d4a9042b0b460e6af312552';

@ProviderFor(participationRepository)
const participationRepositoryProvider = ParticipationRepositoryProvider._();

final class ParticipationRepositoryProvider extends $FunctionalProvider<
    IParticipationRepository,
    IParticipationRepository,
    IParticipationRepository> with $Provider<IParticipationRepository> {
  const ParticipationRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'participationRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$participationRepositoryHash();

  @$internal
  @override
  $ProviderElement<IParticipationRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IParticipationRepository create(Ref ref) {
    return participationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IParticipationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IParticipationRepository>(value),
    );
  }
}

String _$participationRepositoryHash() =>
    r'852651c1fc5f0012baa5352bb7258f00d30dbd4b';

@ProviderFor(dataExportService)
const dataExportServiceProvider = DataExportServiceProvider._();

final class DataExportServiceProvider extends $FunctionalProvider<
    DataExportService,
    DataExportService,
    DataExportService> with $Provider<DataExportService> {
  const DataExportServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dataExportServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dataExportServiceHash();

  @$internal
  @override
  $ProviderElement<DataExportService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DataExportService create(Ref ref) {
    return dataExportService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DataExportService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DataExportService>(value),
    );
  }
}

String _$dataExportServiceHash() => r'6d79d71b030bacd33126505fdf31b26a721af4bc';

@ProviderFor(dataImportService)
const dataImportServiceProvider = DataImportServiceProvider._();

final class DataImportServiceProvider extends $FunctionalProvider<
    DataImportService,
    DataImportService,
    DataImportService> with $Provider<DataImportService> {
  const DataImportServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dataImportServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dataImportServiceHash();

  @$internal
  @override
  $ProviderElement<DataImportService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DataImportService create(Ref ref) {
    return dataImportService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DataImportService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DataImportService>(value),
    );
  }
}

String _$dataImportServiceHash() => r'd5879d99b230485a527aeb71437a684fac54cfae';
