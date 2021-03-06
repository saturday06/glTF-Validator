/*
 * # Copyright (c) 2016-2017 The Khronos Group Inc.
 * # Copyright (c) 2016 Alexey Knyazev
 * #
 * # Licensed under the Apache License, Version 2.0 (the "License");
 * # you may not use this file except in compliance with the License.
 * # You may obtain a copy of the License at
 * #
 * #     http://www.apache.org/licenses/LICENSE-2.0
 * #
 * # Unless required by applicable law or agreed to in writing, software
 * # distributed under the License is distributed on an "AS IS" BASIS,
 * # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * # See the License for the specific language governing permissions and
 * # limitations under the License.
 */

import 'dart:io';

import 'package:test/test.dart';
import 'package:gltf/gltf.dart';
import 'package:gltf/src/errors.dart';

import '../utils.dart';

void main() {
  group('Texture', () {
    test('Empty array', () async {
      final reader =
          GltfJsonReader(File('test/base/data/texture/empty.gltf').openRead());

      final context = Context()
        ..path.add('textures')
        ..addIssue(SchemaError.emptyEntity);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Empty object', () async {
      final reader = GltfJsonReader(
          File('test/base/data/texture/empty_object.gltf').openRead(),
          ignoreUnusedContext);

      await reader.read();

      expect(reader.context.issues, isEmpty);
    });

    test('Custom Property', () async {
      final reader = GltfJsonReader(
          File('test/base/data/texture/custom_property.gltf').openRead(),
          ignoreUnusedContext);

      final context = Context()
        ..path.add('textures')
        ..path.add('0')
        ..addIssue(SchemaError.unexpectedProperty, name: 'customProperty');

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });

    test('Valid', () async {
      final reader = GltfJsonReader(
          File('test/base/data/texture/valid_full.gltf').openRead(),
          ignoreUnusedContext);

      final result = await reader.read();

      expect(reader.context.issues, isEmpty);

      expect(result.gltf.textures.toString(),
          '[{sampler: 0, source: 0, extensions: {}}]');
    });

    test('Unresolved references', () async {
      final reader = GltfJsonReader(
          File('test/base/data/texture/unresolved_references.gltf').openRead(),
          ignoreUnusedContext);

      final context = Context()
        ..path.add('textures')
        ..path.add('0')
        ..addIssue(LinkError.unresolvedReference, name: 'source', args: [0])
        ..addIssue(LinkError.unresolvedReference, name: 'sampler', args: [0]);

      await reader.read();

      expect(reader.context.issues, unorderedMatches(context.issues));
    });
  });
}
