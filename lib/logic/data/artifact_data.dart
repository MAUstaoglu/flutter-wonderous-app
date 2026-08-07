import 'package:wonders/logic/common/platform_info.dart';

class ArtifactData {
  ArtifactData({
    required this.objectId,
    required this.title,
    required this.image,
    required this.date,
    required this.period,
    required this.country,
    required this.medium,
    required this.dimension,
    required this.classification,
    required this.culture,
    required this.objectType,
    required this.objectBeginYear,
    required this.objectEndYear,
  });
  static const String baseSelfHostedImagePath = 'https://www.wonderous.info/met/';

  final String objectId; // Artifact ID, used to identify through MET server calls.
  final String title; // Artifact title / name
  final String image; // Artifact primary image URL (can have multiple)
  final int objectBeginYear; // Artifact creation year start.
  final int objectEndYear; // Artifact creation year end.
  final String objectType; // Type of thing (coin, basic, cup etc)

  final String date; // Date of creation
  final String period; // Time period of creation
  final String country; // Country of origin
  final String medium; // Art medium
  final String dimension; // Width and height of physical artifact
  final String classification; // Type of artifact
  final String culture; // Culture of artifact

  String get selfHostedImageUrl => getSelfHostedImageUrl(objectId);
  String get selfHostedImageUrlSmall => getSelfHostedImageUrlSmall(objectId);
  String get selfHostedImageUrlMedium => getSelfHostedImageUrlMedium(objectId);

  // On a watch every variant collapses to _600. The originals here are the
  // heaviest images in the app — measured at 968KB and 2.2MB — against a
  // ~200 kB/s link through the paired iPhone, so a single artifact could take
  // ten seconds. _600 is 66-97KB, and at 600px it still exceeds anything a
  // 42/46/49mm screen shows outside the fullscreen viewer, where it costs a
  // little softness for roughly twenty times less data.
  static String getSelfHostedImageUrl(String id) => PlatformInfo.isWatch
      ? getSelfHostedImageUrlSmall(id)
      : '$baseSelfHostedImagePath$id.jpg';
  static String getSelfHostedImageUrlSmall(String id) => '$baseSelfHostedImagePath${id}_600.jpg';
  static String getSelfHostedImageUrlMedium(String id) => PlatformInfo.isWatch
      ? getSelfHostedImageUrlSmall(id)
      : '$baseSelfHostedImagePath${id}_2000.jpg';
}
