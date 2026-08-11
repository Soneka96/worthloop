/// Coerces a background-refresh engine channel argument into a list of
/// source ids, dropping anything that isn't a `List` or whose entries
/// aren't a `String`.
List<String> sourceIdsFromChannelPayload(Object? arguments) =>
    arguments is List ? arguments.whereType<String>().toList() : const [];

/// Parses a background-refresh engine channel's `enqueueSources` call
/// payload into the source ids to queue and whether to bypass their
/// cooldown, defaulting safely when [arguments] isn't the expected shape.
(List<String> sourceIds, bool bypassCooldown) parseEnqueueSourcesPayload(
  Object? arguments,
) {
  final Map<Object?, Object?> payload = arguments is Map ? arguments : const {};
  return (
    sourceIdsFromChannelPayload(payload['sourceIds']),
    payload['bypassCooldown'] == true,
  );
}
