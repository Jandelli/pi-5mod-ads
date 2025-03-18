import 'package:flutter/material.dart';

enum SwipeDirection { left, right, up, down, none }

class SwipeCard extends StatefulWidget {
  final int cardCount;
  final Widget Function(BuildContext context, int index) cardBuilder;
  final Function(int index)? onSwipeRight;
  final Function(int index)? onSwipeLeft;
  final Function(int index, SwipeDirection direction)? onCardRemoved;

  const SwipeCard({
    super.key,
    required this.cardCount,
    required this.cardBuilder,
    this.onSwipeRight,
    this.onSwipeLeft,
    this.onCardRemoved,
  });

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  double _dragStartPosition = 0;
  double _dragPosition = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  SwipeDirection _lastSwipeDirection = SwipeDirection.none;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(_animationController);
    _animationController.addListener(() {
      setState(() {});
    });
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_lastSwipeDirection != SwipeDirection.none) {
          if (_lastSwipeDirection == SwipeDirection.right &&
              widget.onSwipeRight != null) {
            widget.onSwipeRight!(_currentIndex);
          } else if (_lastSwipeDirection == SwipeDirection.left &&
              widget.onSwipeLeft != null) {
            widget.onSwipeLeft!(_currentIndex);
          }

          if (widget.onCardRemoved != null) {
            widget.onCardRemoved!(_currentIndex, _lastSwipeDirection);
          }

          if (_currentIndex < widget.cardCount - 1) {
            _currentIndex++;
            _dragPosition = 0;
            _dragStartPosition = 0;
            _lastSwipeDirection = SwipeDirection.none;
            setState(() {});
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cardCount == 0) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        // Background card (next card)
        if (_currentIndex < widget.cardCount - 1)
          Positioned.fill(
            child: widget.cardBuilder(context, _currentIndex + 1),
          ),

        // Current card (top card)
        if (_currentIndex < widget.cardCount)
          Positioned.fill(
            child: GestureDetector(
              onHorizontalDragStart: _onDragStart,
              onHorizontalDragUpdate: _onDragUpdate,
              onHorizontalDragEnd: _onDragEnd,
              child: Transform.translate(
                offset: Offset(_dragPosition + _animation.value, 0),
                child: Transform.rotate(
                  angle: (_dragPosition + _animation.value) / 800,
                  child: widget.cardBuilder(context, _currentIndex),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _onDragStart(DragStartDetails details) {
    _dragStartPosition = details.localPosition.dx;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragPosition = details.localPosition.dx - _dragStartPosition;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (_dragPosition.abs() > screenWidth * 0.4) {
      _lastSwipeDirection =
          _dragPosition > 0 ? SwipeDirection.right : SwipeDirection.left;
      _animation = Tween<double>(
        begin: 0,
        end: _dragPosition > 0 ? screenWidth : -screenWidth,
      ).animate(_animationController);
      _animationController.reset();
      _animationController.forward();
    } else {
      _lastSwipeDirection = SwipeDirection.none;
      _animation = Tween<double>(
        begin: _dragPosition,
        end: 0,
      ).animate(_animationController);
      _animationController.reset();
      _animationController.forward();
      _dragPosition = 0;
    }
  }
}
