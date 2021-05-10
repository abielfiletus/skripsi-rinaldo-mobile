import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';

import 'package:skripsi_rinaldo/utils/ImageSourceBottonSheet.dart';

class FormBuilderImagePicker extends StatefulWidget {
  final String attribute;
  final List<String Function(dynamic)> validators;
  final List initialValue;
  final bool readOnly;
  @Deprecated('Set the `labelText` within decoration attribute')
  final String title;
  final InputDecoration decoration;
  final ValueTransformer valueTransformer;
  final ValueChanged onChanged;
  final FormFieldSetter onSaved;

  final double imageWidth;
  final double imageHeight;
  final EdgeInsets imageMargin;
  final Color iconColor;

  /// Optional maximum height of image; see [ImagePicker].
  final double maxHeight;

  /// Optional maximum width of image; see [ImagePicker].
  final double maxWidth;

  /// The imageQuality argument modifies the quality of the image, ranging from
  /// 0-100 where 100 is the original/max quality. If imageQuality is null, the
  /// image with the original quality will be returned. See [ImagePicker].
  final int imageQuality;

  /// Use preferredCameraDevice to specify the camera to use when the source is
  /// `ImageSource.camera`. The preferredCameraDevice is ignored when source is
  /// `ImageSource.gallery`. It is also ignored if the chosen camera is not
  /// supported on the device. Defaults to `CameraDevice.rear`. See [ImagePicker].
  final CameraDevice preferredCameraDevice;

  final int maxImages;
  final ImageProvider defaultImage;
  final Widget cameraIcon;
  final Widget galleryIcon;
  final Widget cameraLabel;
  final Widget galleryLabel;
  final EdgeInsets bottomSheetPadding;

  const FormBuilderImagePicker({
    Key key,
    @required this.attribute,
    this.initialValue,
    this.defaultImage,
    this.validators = const [],
    this.valueTransformer,
    this.title,
    this.onChanged,
    this.imageWidth = 130,
    this.imageHeight = 130,
    this.imageMargin,
    this.readOnly = false,
    this.onSaved,
    this.decoration = const InputDecoration(),
    this.iconColor,
    this.maxHeight = 480,
    this.maxWidth = 640,
    this.imageQuality = 50,
    this.preferredCameraDevice = CameraDevice.rear,
    this.maxImages,
    this.cameraIcon = const Icon(Icons.camera_enhance),
    this.galleryIcon = const Icon(Icons.image),
    this.cameraLabel = const Text('Camera'),
    this.galleryLabel = const Text('Gallery'),
    this.bottomSheetPadding = const EdgeInsets.all(0),
  }) : super(key: key);

  @override
  _FormBuilderImagePickerState createState() => _FormBuilderImagePickerState();
}

class _FormBuilderImagePickerState extends State<FormBuilderImagePicker> {
  bool _readOnly = false;
  bool _isPickingImage = false;
  List _initialValue;

  @override
  void initState() {
    _initialValue = widget.initialValue ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _readOnly = widget.readOnly;
    final pattern = new RegExp(r'(^https)');

    return FormField(
      enabled: !_readOnly,
      initialValue: _initialValue,
      validator: FormBuilderValidators.compose(widget.validators),
      onSaved: (val) {
        var transformed;
        if (widget.valueTransformer != null) {
          transformed = widget.valueTransformer(val);
        } else {}
        widget.onSaved?.call(transformed ?? val);
      },
      builder: (field) {
        return InputDecorator(
          decoration: widget.decoration.copyWith(
            enabled: !_readOnly,
            errorText: field.errorText,
            errorMaxLines: 2,
            errorStyle: TextStyle(height: 0.1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (widget.title != null) Text(
                widget.title,
                style: TextStyle(fontWeight: FontWeight.w500),
                maxLines: 2,
              ),
              SizedBox(height: 10),
              Container(
                height: widget.imageHeight,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...(field.value.map<Widget>((item) {
                      return Stack(
                        alignment: Alignment.topRight,
                        children: <Widget>[
                          Container(
                            width: widget.imageWidth,
                            height: widget.imageHeight,
                            margin: widget.imageMargin,
                            child: _initialValue.length > 0
                                ? pattern.hasMatch(_initialValue[0])
                                    ? Image.network(_initialValue[0])
                                    : Image.file(new File(_initialValue[0]), fit: BoxFit.cover)
                                : null,
                          ),
                          if (!_readOnly)
                            InkWell(
                              onTap: () {
                                field.didChange([...field.value]..remove(item));
                                widget.onChanged?.call(field.value);
                              },
                              child: Container(
                                margin: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(.7),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                height: 22,
                                width: 22,
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      );
                    }).toList()),
                    if (!_readOnly && field.value.length < widget.maxImages)
                      GestureDetector(
                        child: widget.defaultImage != null
                            ? Image(
                                width: widget.imageWidth,
                                height: widget.imageHeight,
                                image: widget.defaultImage,
                              )
                            : Container(
                                width: widget.imageWidth,
                                height: widget.imageHeight,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Icon(Icons.camera_alt), Text("Take a Picture")],
                                ),
                              ),
                        onTap: () => _onPickImage(field),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onPickImage(field) async {
    if (_isPickingImage) return;
    _isPickingImage = true;
    await showModalBottomSheet(
      context: context,
      builder: (_) {
        return ImageSourceBottomSheet(
          maxHeight: widget.maxHeight,
          maxWidth: widget.maxWidth,
          imageQuality: widget.imageQuality,
          preferredCameraDevice: widget.preferredCameraDevice,
          cameraIcon: widget.cameraIcon,
          galleryIcon: widget.galleryIcon,
          cameraLabel: widget.cameraLabel,
          galleryLabel: widget.galleryLabel,
          onImageSelected: (image) {
            final imageFile = image.path;
            assert(null != imageFile);
            field.didChange([...field.value, imageFile]);
            widget.onChanged?.call(field.value);
            setState(() => _initialValue = [imageFile]);
            Navigator.of(context).pop();
          },
          onImage: (image) {
            field.didChange([...field.value, image]);
            widget.onChanged?.call(field.value);

            Navigator.of(context).pop();
          },
          bottomSheetPadding: widget.bottomSheetPadding,
        );
      },
    );
    _isPickingImage = false;
  }
}
