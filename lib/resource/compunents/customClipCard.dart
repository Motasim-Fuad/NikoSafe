import 'package:flutter/material.dart';

class CustomClipCard extends StatelessWidget {
  final CustomClipper<Path> clipper;
  final Widget child;

  const CustomClipCard({
    super.key,
    required this.clipper,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: clipper,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: child,
          ),
        ),
        // Top border as a curved teal strip
        Positioned(
          top: 31,
          left: 0,
          right: 0,
          child: ClipPath(
            clipper: clipper,
            child: Container(
              height: 4,
              color: Colors.teal,
            ),
          ),
        ),
      ],
    );
  }
}



class DefaultClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TopDefaultClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // You can customize this path as needed
    path.lineTo(0, 20); // start top-left
    path.quadraticBezierTo(size.width / 2, 0, size.width, 20); // curve at top
    path.lineTo(size.width, size.height); // right edge
    path.lineTo(0, size.height); // bottom
    path.close(); // left edge

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}






class TopDiagonalClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, 40); // Start from left, a bit down
    path.lineTo(size.width, 0); // Slant upward to top-right
    path.lineTo(size.width, size.height); // Down to bottom-right
    path.lineTo(0, size.height); // Bottom-left
    path.close(); // Complete

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class DiagonalClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class WaveClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.85);
    path.quadraticBezierTo(
        size.width * 0.25, size.height, size.width * 0.5, size.height * 0.85);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.7, size.width, size.height * 0.85);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
class TopWaveClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 30); // Start a bit down from top-left
    path.quadraticBezierTo(
        size.width * 0.25, 0, size.width * 0.5, 30); // First curve
    path.quadraticBezierTo(
        size.width * 0.75, 60, size.width, 30); // Second curve
    path.lineTo(size.width, size.height); // Right down to bottom-right
    path.lineTo(0, size.height); // Then to bottom-left
    path.close(); // Close the path

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}



//
// CustomClipCard(
// imageUrl: 'https://via.placeholder.com/80',
// color: Colors.purple,
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: const [
// Text('Title', style: TextStyle(color: Colors.white, fontSize: 18)),
// SizedBox(height: 8),
// Text('Subtitle', style: TextStyle(color: Colors.white70)),
// ],
// ),
// clipper: WaveClipPath(), // 👈 change shape here
// )
