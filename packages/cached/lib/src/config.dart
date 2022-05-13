class Config {
  const Config({
    this.limit,
    this.ttl,
    this.syncWrite,
    this.useStaticCache,
    this.onCacheOnError,
  });

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      limit: json['limit'] as int?,
      ttl: json['ttl'] as int?,
      syncWrite: json['syncWrite'] as bool?,
      useStaticCache: json['useStaticCache'] as bool?,
      onCacheOnError: json['onCacheOnError'] as bool?,
    );
  }

  final int? limit;
  final int? ttl;
  final bool? syncWrite;
  final bool? useStaticCache;
  final bool? onCacheOnError;
}
