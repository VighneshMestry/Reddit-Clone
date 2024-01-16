import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/theme/pallete.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({
    super.key,
    required this.type,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  File? bannerFile;

  void selectBannerImage() async {
    final res = await pickImages();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add ${widget.type}"),
        actions: [TextButton(onPressed: () {}, child: Text("share"))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              maxLength: 30,
              decoration: const InputDecoration(
                filled: true,
                hintText: 'Enter title here',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(18),
              ),
            ),
            const SizedBox(height: 10),
            if (isTypeImage)
              DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                dashPattern: const [10, 4],
                strokeCap: StrokeCap.round,
                color: currentTheme.textTheme.bodyText2!.color!,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: bannerFile != null
                      ? Image.file(bannerFile!)
                      : const Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 40,
                          ),
                        ),
                ),
              ),
            if (isTypeText)
              TextField(
                controller: descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Enter description',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18),
                ),
              ),
            if (isTypeLink)
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Enter link',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18),
                ),
              ),
            const SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }
}
