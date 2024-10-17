import 'dart:io';

import 'package:flutter/material.dart';

//*packages for take a native photo
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _takePicture() async {
    //*new way
    final imagePicker = ImagePicker();
    final imageFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 400,
    );
    //*old way
    // final imageFile = await ImagePicker.platform.pickImage(
    //   source: ImageSource.gallery,
    //   maxWidth: 600,
    // );
    if (imageFile == null) return;

    setState(() {
      _storedImage = File(imageFile.path);
    });

    //directory device path
    final appDirectory = await syspaths.getApplicationDocumentsDirectory();
    //image path
    final fileName = path.basename(imageFile.path);
    //concatinate system path and image path
    final savedImage =
        await File(imageFile.path).copy('${appDirectory.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage as File,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(Icons.camera),
            label: Text('Take Picture'),
            // textColor: Theme.of(context).primaryColor,
            onPressed: _takePicture,
          ),
        ),
      ],
    );
  }
}
