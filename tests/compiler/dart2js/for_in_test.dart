// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:expect/expect.dart';
import 'package:async_helper/async_helper.dart';
import 'compiler_helper.dart';

const String TEST_ONE = r"""
foo(a) {
  int x = 0;
  for (int i in a) {
    x += i;
  }
  return x;
}
""";

const String TEST_TWO = r"""
foo(a) {
  int x = 0;
  for (int i in a) {
    if (i == 5) continue;
    x += i;
  }
  return x;
}
""";

main() {
  runTests({bool useKernel}) async {
    await compile(TEST_ONE, entry: 'foo', check: (String generated) {
      Expect.isTrue(!generated.contains(r'break'));
    }, useKernel: useKernel);
    await compile(TEST_TWO, entry: 'foo', check: (String generated) {
      Expect.isTrue(generated.contains(r'continue'));
    }, useKernel: useKernel);
  }

  asyncTest(() async {
    print('--test from ast---------------------------------------------------');
    await runTests(useKernel: false);
    print('--test from kernel------------------------------------------------');
    await runTests(useKernel: true);
  });
}
