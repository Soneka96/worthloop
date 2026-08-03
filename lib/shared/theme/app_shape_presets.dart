// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';

/// Maps every [CornerStyle] to its corner radius. [CornerStyle.none] falls
/// back to the [CornerStyle.rounded] radius — it's a sentinel value, not a
/// real preset, so it reuses the app's default rather than needing its own
/// radius.
final Map<CornerStyle, double> cornerRadiusPresets = {
  CornerStyle.none: 20.0,
  CornerStyle.rounded: 20.0,
  CornerStyle.square: 4.0,
};
