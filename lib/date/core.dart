import 'dart:io';
import 'package:fcp_srt2xml/date/custom_reader.dart';
import 'package:xml/xml.dart';

//时间->帧数
//Ex.srtTime="00:00:01,234"
int srtTimeToFrame(String srtTime, double fps) {
  int ms = int.parse(srtTime.substring(srtTime.length - 3));
  List<String> parts = srtTime.substring(0, srtTime.length - 4).split(':');
  int totalMs = int.parse(parts[0]) * 3600 * 1000 +
      int.parse(parts[1]) * 60 * 1000 +
      int.parse(parts[2]) * 1000 +
      ms;
  return (totalMs / (1000 / fps)).floor();
}

// 生成 FCPXML 文件
void fcpxml(String srtPath, double fps, String destinationPath,
    bool isCustomEffectChecked, String customEffectPath) {
  String projectName = srtPath.split('/').last.replaceAll('.srt', '');
  String data = File(srtPath).readAsStringSync();
  List<String> subtitles = data.trim().split(RegExp(r'\r?\n\r?\n'));

  String hundredfoldFps = (fps * 100).toInt().toString();
  String totalSrtTime = subtitles.last
      .trim()
      .split('\n')[1]
      .split(' --> ')[1]
      .replaceAll('\r', '');
  int totalFrame = srtTimeToFrame(totalSrtTime, fps);
  String hundredfoldTotalFrame = (100 * totalFrame).toString();


  Map<String, dynamic> customEffectData = {};
  if (isCustomEffectChecked && customEffectPath.isNotEmpty) {
    customEffectData = readCustomEffect(customEffectPath);
  }

  var builder = XmlBuilder();
  builder.processing('xml', 'version="1.0" encoding="UTF-8"');


  builder.element('fcpxml', attributes: {'version': '1.9'}, nest: () {
    builder.element('resources', nest: () {
      builder.element('format', attributes: {
        'id': 'r1',
        'name': 'FFVideoFormat1080p$hundredfoldFps',
        'frameDuration': '100/$hundredfoldFps',
        'width': '1920',
        'height': '1080',
        'colorSpace': '1-1-1 (Rec. 709)'
      });
      
      // 创建effect标签
      if (isCustomEffectChecked && customEffectData['effect']?.isNotEmpty == true) {
        createEffectElement(builder, customEffectData['effect']);
      } else {
        builder.element('effect', attributes: {
          'id': 'r2',
          'name': 'Basic Title',
          'uid': '.../Titles.localized/Bumper:Opener.localized/Basic Title.localized/Basic Title.moti'
        });
      }
    });



    builder.element('library', nest: () {
      builder.element('event', attributes: {'name': 'srt2subtitles-cli'},
          nest: () {
        builder.element('project', attributes: {'name': projectName}, nest: () {
          builder.element('sequence', attributes: {
            'format': 'r1',
            'tcStart': '0s',
            'tcFormat': 'NDF',
            'audioLayout': 'stereo',
            'audioRate': '48k',
            'duration': '$hundredfoldTotalFrame/${hundredfoldFps}s'
          }, nest: () {

            builder.element('spine', nest: () {

              builder.element('gap', attributes: {
                'name': 'Gap',
                'offset': '0s',
                'duration': '$hundredfoldTotalFrame/${hundredfoldFps}s'
              }, nest: () {
                // 遍历每个字幕块
                for (int i = 0; i < subtitles.length; i++) {
                  List<String> subtitle = subtitles[i].trim().split('\n');
                  List<String> times = subtitle[1].split(' --> ');
                  String offset = times[0].replaceAll('\r', '');
                  String end = times[1].replaceAll('\r', '');
                  int offsetFrame = srtTimeToFrame(offset, fps);
                  int endFrame = srtTimeToFrame(end, fps);
                  int durationFrame = endFrame - offsetFrame;
                  String hundredfoldOffsetFrame = (100 * offsetFrame).toString();
                  String hundredfoldDurationFrame = (100 * durationFrame).toString();
                  String subtitleContent = subtitle
                      .sublist(2)
                      .map((item) => item
                          .replaceAll('\r', '')
                          .replaceAll('<i>', '')
                          .replaceAll('</i>', ''))
                      .join('\n');

                  // 创建 title 标签
                  if (isCustomEffectChecked && 
                     customEffectData['effect']?.isNotEmpty == true && 
                     customEffectData['titleParams']?.isNotEmpty == true) {
                    

                    String effectName = customEffectData['effect']['name'] ?? 'Basic Title';
                    
                    createTitleElement(
                      builder,
                      ref: customEffectData['effect']['id'] ?? 'r2',
                      lane: '1',
                      offset: '$hundredfoldOffsetFrame/${hundredfoldFps}s',
                      duration: '$hundredfoldDurationFrame/${hundredfoldFps}s',
                      name: '$subtitleContent - $effectName',
                      params: List<Map<String, String>>.from(customEffectData['titleParams'] ?? []),
                      subtitleContent: subtitleContent,
                      textStyleId: 'ts$i',
                      textStyleAttributes: Map<String, String>.from(customEffectData['textStyle'] ?? {
                        'font': 'Helvetica',
                        'fontSize': '45',
                        'fontFace': 'Regular',
                        'fontColor': '1 1 1 1',
                        'bold': '1',
                        'shadowColor': '0 0 0 0.75',
                        'shadowOffset': '4 315',
                        'alignment': 'center'
                      }),
                    );
                  } else {
                    builder.element('title', attributes: {
                      'ref': 'r2',
                      'lane': '1',
                      'offset': '$hundredfoldOffsetFrame/${hundredfoldFps}s',
                      'duration': '$hundredfoldDurationFrame/${hundredfoldFps}s',
                      'name': '$subtitleContent - Basic Title'
                    }, nest: () {
                      builder.element('param', attributes: {
                        'name': 'Position',
                        'key': '9999/999166631/999166633/1/100/101',
                        'value': '0 -465'
                      });
                      builder.element('param', attributes: {
                        'name': 'Flatten',
                        'key': '999/999166631/999166633/2/351',
                        'value': '1'
                      });
                      builder.element('param', attributes: {
                        'name': 'Alignment',
                        'key': '9999/999166631/999166633/2/354/999169573/401',
                        'value': '1 (Center)'
                      });
                      builder.element('text', nest: () {
                        builder.element('text-style', attributes: {'ref': 'ts$i'},
                            nest: () {
                          builder.text(subtitleContent);
                        });
                      });
                      builder.element('text-style-def',
                          attributes: {'id': 'ts$i'}, nest: () {
                        builder.element('text-style', attributes: {
                          'font': 'Helvetica',
                          'fontSize': '45',
                          'fontFace': 'Regular',
                          'fontColor': '1 1 1 1',
                          'bold': '1',
                          'shadowColor': '0 0 0 0.75',
                          'shadowOffset': '4 315',
                          'alignment': 'center'
                        });
                      });
                    });
                  }
                }
              });
            });
          });
        });
      });
    });
  });

  // 生成
  String xml = builder.buildDocument().toXmlString(pretty: true);

  if (destinationPath.endsWith('/')) {
    destinationPath = destinationPath.substring(0, destinationPath.length - 1);
  }
  File('$destinationPath/$projectName.fcpxml').writeAsStringSync(xml);
}

String generateFcpxml(String srtPath, double fps, String destinationPath,
    bool isCustomEffectChecked, String customEffectPath) {
  if (!srtPath.endsWith('.srt')) {
    return 'Please enter the correct SRT file';
  }

  try {
    fcpxml(srtPath, fps, destinationPath, isCustomEffectChecked, customEffectPath);
    String projectName = srtPath.split('/').last.replaceAll('.srt', '');
    File fcpxmlFile = File('$destinationPath/$projectName.fcpxml');
    if (fcpxmlFile.existsSync()) {
      return 'created $projectName.fcpxml';
    } else {
      return 'An error occurred while generating the fcpxml file.';
    }
  } on FileSystemException catch (e) {
    return 'file system error: ${e.message}';
  } catch (e) {
    return 'unknown: $e';
  }
}