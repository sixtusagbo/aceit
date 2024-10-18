import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FormInputSkeleton extends StatelessWidget {
  const FormInputSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Container(
        height: 50.0,
        width: double.infinity,
        color: Colors.green,
      ),
    );
  }
}
