import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.fourRotatingDots(
        color: const Color(0xFF1D75B1),
        size: 50,
      ),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({Key? key, required this.isLoading, required this.child})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const LoadingWidget(),
          ),
      ],
    );
  }
}

class ErrorText extends StatelessWidget {
  final String error;
  final TextStyle? style;

  const ErrorText({Key? key, required this.error, this.style})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (error.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        error,
        style: style ?? const TextStyle(color: Colors.red, fontSize: 14.0),
        textAlign: TextAlign.center,
      ),
    );
  }
}
