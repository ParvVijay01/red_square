import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// The main application widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Padding(
        padding: EdgeInsets.all(32.0),
        child: SquareAnimation(),
      ),
    );
  }
}

/// A widget that demonstrates a square moving left, right, and to the center
/// of the screen when buttons are pressed.
class SquareAnimation extends StatefulWidget {
  const SquareAnimation({super.key});

  @override
  State<SquareAnimation> createState() {
    return SquareAnimationState();
  }
}

/// State for [SquareAnimation] that controls the position and animation
/// of a red square.
class SquareAnimationState extends State<SquareAnimation> {
  static const double _squareSize = 50.0; // The size of the moving square
  double _squarePosition = 0.0; // The current horizontal position of the square
  bool _isAnimating = false; // Flag to prevent multiple animations

  // Position constants for left, center, and right
  double get _leftPosition => -MediaQuery.of(context).size.width / 4;
  double get _centerPosition => 0.0;
  double get _rightPosition => MediaQuery.of(context).size.width / 4;

  /// Moves the square to the rightmost position within bounds.
  void _moveRight() {
    if (_isAnimating) return;
    _animateSquare(_rightPosition);
  }

  /// Moves the square to the leftmost position.
  void _moveLeft() {
    if (_isAnimating) return;
    _animateSquare(_leftPosition);
  }

  /// Moves the square to the center of the screen.
  void _moveToCenter() {
    if (_isAnimating) return;
    _animateSquare(_centerPosition);
  }

  /// Animates the square to a target horizontal position.
  /// Sets [_isAnimating] to true during the animation to prevent
  /// conflicting animations, and then resets it when the animation completes.
  ///
  /// - Parameter targetPosition: The position to move the square to.
  void _animateSquare(double targetPosition) {
    setState(() {
      _isAnimating = true;
      _squarePosition = targetPosition;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isAnimating = false;
      });
    });
  }

  /// Checks if the square is at a given position with a small margin of error.
  bool _isAtPosition(double position) {
    const double tolerance = 1.0; // Allowable error in position
    return (_squarePosition - position).abs() < tolerance;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                transform: Matrix4.translationValues(_squarePosition, 0, 0),
                width: _squareSize,
                height: _squareSize,
                decoration: BoxDecoration(
                  color: Colors.red,
                  border: Border.all(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: (_isAnimating || _isAtPosition(_leftPosition))
                  ? null
                  : _moveLeft,
              child: const Text('Left'),
            ),
            ElevatedButton(
              onPressed: (_isAnimating || _isAtPosition(_centerPosition))
                  ? null
                  : _moveToCenter,
              child: const Text('Center'),
            ),
            ElevatedButton(
              onPressed: (_isAnimating || _isAtPosition(_rightPosition))
                  ? null
                  : _moveRight,
              child: const Text('Right'),
            ),
          ],
        ),
      ],
    );
  }
}
