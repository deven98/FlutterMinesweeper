import 'dart:math';
import 'dart:async';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Video Glimpse', () {
    FlutterDriver driver;

    findRandomSquare([String type = 'Safe']) async {
      final RenderTree renderTree = await driver.getRenderTree();
      RegExp exp = (type == 'Bomb')
          ? RegExp(r"__BoardSquare_([0-4]|1[1-3])x\d*_Bomb__")
          : RegExp(r"__BoardSquare_\d[0-3]*x\d*_Safe__");

      Iterable<Match> matches = exp.allMatches(renderTree.tree);

      String match = (matches.length > 0)
          ? matches
          .elementAt(Random().nextInt(matches.length))
          .group(0)
          : '__App_Root__';

      return find.byValueKey(match);
    }

    longPress(target) async {
      await driver.scroll(target, 0, 0, Duration(milliseconds: 500));
    }

    tapOnSquareAndWait({
      SerializableFinder target,
      Duration wait = const Duration(milliseconds: 200)
    }) async {
      await driver.tap(target);
      await Future.delayed(wait);
    }

    longPressOnSquareAndWait({
      SerializableFinder target,
      Duration wait = const Duration(milliseconds: 200)
    }) async {
      await longPress(target);
      await Future.delayed(wait);
    }

    // Connect to the Flutter driver before running any tests
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await Future.delayed(Duration(milliseconds: 400));
    });

    // Close the connection to the driver after the tests have completed
    tearDownAll(() async {
      await driver?.close();
    });

    test('Do couple of actions to showcase the app', () async {
      await tapOnSquareAndWait(target: await findRandomSquare());
      await longPressOnSquareAndWait(target: await findRandomSquare());
      await tapOnSquareAndWait(target: await findRandomSquare());
      await longPressOnSquareAndWait(target: await findRandomSquare());
      await tapOnSquareAndWait(target: await findRandomSquare());
      await tapOnSquareAndWait(
          target: await findRandomSquare('Bomb'),
          wait: Duration(seconds: 2)
      );
    });
  });
}