import 'package:fcp_srt2xml/date/core.dart';
import 'package:fcp_srt2xml/ui/component.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String srtPath = '';
  double fps = 30;
  String destinationPath = '';
  bool isCustomEffectChecked = false;
  String customEffectPath = '';

  Future<void> convertFile() async {
    String result =
        generateFcpxml(srtPath, fps, destinationPath,isCustomEffectChecked, customEffectPath);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> selectSrtFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['srt'],
    );

    if (result != null) {
      setState(() {
        srtPath = result.files.single.path!;
      });
    }
  }

  Future<void> selectDestinationFolder() async {
    String? path = await FilePicker.platform.getDirectoryPath();
    if (path != null) {
      setState(() {
        destinationPath = path;
      });
    }
  }

  Future<void> selectEffectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['fcpxml'],
    );

    if (result != null) {
      setState(() {
        customEffectPath = result.files.single.path!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Srt to Fcpxml Convertor"),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Input',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        onPressed: selectSrtFile,
                        buttonText: 'Select SRT File',
                      ),
                      if (srtPath.isNotEmpty)
                        CustomText(text: 'Selected SRT: $srtPath'),
                      const SizedBox(height: 20),
                      Text(
                        'FPS:',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<double>(
                          //怎么修改选中后的颜色不要加上灰色阴影？？

                          value: fps,
                          items: [
                            23.98,
                            24.0,
                            25.0,
                            29.97,
                            30.0,
                            50.0,
                            59.94,
                            60.0
                          ].map((double value) {
                            return DropdownMenuItem<double>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text('$value'),
                              ),
                            );
                          }).toList(),
                          onChanged: (double? newValue) {
                            if (newValue != null) {
                              setState(() {
                                fps = newValue;
                              });
                            }
                          },
                          style: Theme.of(context).textTheme.bodyMedium,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Output',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        onPressed: selectDestinationFolder,
                        buttonText: 'Select Destination Folder',
                      ),
                      if (destinationPath.isNotEmpty)
                        CustomText(
                            text: 'Selected Destination: $destinationPath'),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Checkbox(
                            value: isCustomEffectChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isCustomEffectChecked = value ?? false;
                              });
                            },
                          ),
                          Text(
                            'Custom Effect XML',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      if (isCustomEffectChecked)
                        CustomButton(
                          onPressed: selectEffectFile,
                          buttonText: 'Select Title FCPXML File',
                        ),
                      if (isCustomEffectChecked && customEffectPath.isNotEmpty)
                        CustomText(
                            text: 'Selected Effect: $customEffectPath'),
                        
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: convertFile,
                child: const Text('Convert'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
