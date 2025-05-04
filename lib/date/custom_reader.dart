import 'dart:io';
import 'package:xml/xml.dart';


Map<String, dynamic> readCustomEffect(String customEffectPath) {
  try {

    File file = File(customEffectPath);
    if (!file.existsSync()) {
      throw FileSystemException('Custom effect file not found: $customEffectPath');
    }

    String xmlContent = file.readAsStringSync();
    final document = XmlDocument.parse(xmlContent);


    Map<String, dynamic> effectData = {};
    final effectElements = document.findAllElements('effect');
    if (effectElements.isNotEmpty) {
      final effectElement = effectElements.first;
      effectData['id'] = effectElement.getAttribute('id') ?? 'r2';
      effectData['name'] = effectElement.getAttribute('name') ?? 'Basic Title';
      effectData['uid'] = effectElement.getAttribute('uid') ?? '';
      effectData['src'] = effectElement.getAttribute('src') ?? '';
    }


    List<Map<String, String>> titleParams = [];
    final titleElements = document.findAllElements('title');
    if (titleElements.isNotEmpty) {
      for (var paramElement in titleElements.first.findAllElements('param')) {
        titleParams.add({
          'name': paramElement.getAttribute('name') ?? '',
          'key': paramElement.getAttribute('key') ?? '',
          'value': paramElement.getAttribute('value') ?? '',
        });
      }
    }
/*
仔细观察.fcpxml文件可以发现
我们往往需要的是'text-style-def'里面的'text-style'(包含文本字体等参数)*/
    Map<String, String> textStyleAttributes = {};
    final textStyleDefElements = document.findAllElements('text-style-def');
    if (textStyleDefElements.isNotEmpty) {

      final textStyleElements = textStyleDefElements.first.findAllElements('text-style');
      if (textStyleElements.isNotEmpty) {
        final textStyleElement = textStyleElements.first;
        textStyleElement.attributes.forEach((attr) {
          textStyleAttributes[attr.name.local] = attr.value;
        });
      }
    }

    return {
      'effect': effectData,
      'titleParams': titleParams,
      'textStyle': textStyleAttributes,
    };
  } catch (e) {
    print('Error reading custom effect: $e');
    return {
      'effect': {},
      'titleParams': [],
      'textStyle': {},
    };
  }
}


void createEffectElement(XmlBuilder builder, Map<String, dynamic> effectData) {
  Map<String, String> attributes = {
    'id': effectData['id'] ?? 'r2',
    'name': effectData['name'] ?? 'Basic Title',
  };
  
  if (effectData['uid'] != null && effectData['uid'].isNotEmpty) {
    attributes['uid'] = effectData['uid'];
  }
  
  if (effectData['src'] != null && effectData['src'].isNotEmpty) {
    attributes['src'] = effectData['src'];
  }
  
  builder.element('effect', attributes: attributes);
}


void createTitleElement(XmlBuilder builder, {
  required String ref,
  required String lane,
  required String offset,
  required String duration,
  required String name,
  required List<Map<String, String>> params,
  required String subtitleContent,
  required String textStyleId,
  required Map<String, String> textStyleAttributes,
}) {
  builder.element('title', attributes: {
    'ref': ref,
    'lane': lane,
    'offset': offset,
    'duration': duration,
    'name': '$subtitleContent - ${name.split(' - ').last}'
  }, nest: () {

    for (var param in params) {
      builder.element('param', attributes: {
        'name': param['name'] ?? '',
        'key': param['key'] ?? '',
        'value': param['value'] ?? '',
      });
    }


    builder.element('text', nest: () {
      builder.element('text-style', attributes: {'ref': textStyleId}, nest: () {
        builder.text(subtitleContent);
      });
    });


    builder.element('text-style-def', attributes: {'id': textStyleId}, nest: () {
      builder.element('text-style', attributes: textStyleAttributes);
    });
  });
}