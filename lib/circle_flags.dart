library circle_flags;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// a rounded flag
class CircleFlag extends StatelessWidget {
  final double size;
  final String? assetName;
  final Uint8List? asset;

  CircleFlag(String isoCode, {super.key, this.size = 48})
      : assetName = computeAssetName(isoCode),
        asset = null;

  CircleFlag.fromMemory(this.asset, {super.key, this.size = 48})
      : assetName = null;

  static Future<List<Uint8List>> preload(Iterable<String> isoCodes) {
    final imagesBytes = <Future<Uint8List>>[];
    for (final isoCode in isoCodes) {
      final assetName = computeAssetName(isoCode);
      final bytes = loadAsset(assetName);
      imagesBytes.add(bytes);
    }
    return Future.wait(imagesBytes);
  }

  static loadAsset(String assetName) {
    return rootBundle
        .load(assetName)
        .then((data) => Uint8List.sublistView(data))
        // on error try to use the question mark flag
        .catchError((e) => rootBundle
            .load(computeAssetName('xx'))
            .then((data) => Uint8List.sublistView(data)));
  }

  static String computeAssetName(String isoCode) {
    return 'packages/circle_flags/assets/svg/${isoCode.toLowerCase()}.svg';
  }

  @override
  Widget build(BuildContext context) {
    final asset = this.asset;
    return ClipOval(
      child: asset != null
          ? SvgPicture.memory(
              asset,
              width: size,
              height: size,
            )
          : SvgPicture.asset(
              assetName ?? '',
              width: size,
              height: size,
            ),
    );
  }
}
