import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mm_book/app/extensions/string_extension.dart';
import 'package:mm_book/app/services/core/dio_services.dart';
import 'package:mm_book/app/widgets/index.dart';

class CacheImage extends StatefulWidget {
  String url;
  String? cachePath;
  double? height;
  double? width;
  BoxFit fit;
  double borderRadius;
  double maxWidth;
  CacheImage({
    super.key,
    required this.url,
    this.cachePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 5,
    this.maxWidth = double.infinity,
  });

  @override
  State<CacheImage> createState() => _CacheImageState();
}

class _CacheImageState extends State<CacheImage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  bool isLoading = false;
  bool isExists = false;

  void init() async {
    try {
      if (widget.cachePath == null) return;
      //check file
      final file = File('${widget.cachePath}/${widget.url.getName()}');
      if (await file.exists()) {
        setState(() {
          isExists = true;
        });
        return;
      }
      //မရှိရင်
      if (!mounted) return;
      setState(() {
        isLoading = true;
      });
      await DioServices.instance.getDio.download(widget.url, file.path);
      if (!mounted) return;
      setState(() {
        isLoading = false;
        isExists = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return TLoader();
    }
    if (isExists) {
      return MyImageFile(
        path: '${widget.cachePath}/${widget.url.getName()}',
        width: widget.height,
        height: widget.height,
        fit: widget.fit,
        borderRadius: widget.borderRadius,
      );
    }
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: widget.maxWidth,
      ),
      child: MyImageUrl(
        url: widget.url,
        width: widget.height,
        height: widget.height,
        fit: widget.fit,
        borderRadius: widget.borderRadius,
      ),
    );
  }
}
