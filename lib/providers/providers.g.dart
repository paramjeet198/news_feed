// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fireStoreServiceHash() => r'12e553e130bf8e5b53bfe18d153f9f0e84ca6394';

/// See also [fireStoreService].
@ProviderFor(fireStoreService)
final fireStoreServiceProvider = AutoDisposeProvider<FirestoreService>.internal(
  fireStoreService,
  name: r'fireStoreServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fireStoreServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FireStoreServiceRef = AutoDisposeProviderRef<FirestoreService>;
String _$fetchArticleHash() => r'f1ee6e7143e347bb1f14f7a6bb03ec854ff69bb3';

/// See also [fetchArticle].
@ProviderFor(fetchArticle)
final fetchArticleProvider = AutoDisposeFutureProvider<List<Article>>.internal(
  fetchArticle,
  name: r'fetchArticleProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$fetchArticleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchArticleRef = AutoDisposeFutureProviderRef<List<Article>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
