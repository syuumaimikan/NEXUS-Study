import 'package:flutter/material.dart';

class DrawnLine {
  final List<Offset> path;
  final Color color;
  final double width;

  DrawnLine({required this.path, required this.color, required this.width});
}

class ScratchpadPainter extends CustomPainter {
  final List<DrawnLine> lines;

  ScratchpadPainter({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw subtle grid lines for easy math calculation alignment
    final gridPaint = Paint()
      ..color = const Color(0xFF1E293B).withValues(alpha: 0.5)
      ..strokeWidth = 1.0;

    const gridSize = 24.0;
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw user handwritten lines
    for (final line in lines) {
      if (line.path.length < 2) continue;

      final paint = Paint()
        ..color = line.color
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = line.width
        ..style = PaintingStyle.stroke;

      final path = Path();
      path.moveTo(line.path[0].dx, line.path[0].dy);
      for (int i = 1; i < line.path.length; i++) {
        path.lineTo(line.path[i].dx, line.path[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ScratchpadPainter oldDelegate) => true;
}

class ScratchpadCanvas extends StatefulWidget {
  final VoidCallback? onClose;

  const ScratchpadCanvas({super.key, this.onClose});

  @override
  State<ScratchpadCanvas> createState() => _ScratchpadCanvasState();
}

class _ScratchpadCanvasState extends State<ScratchpadCanvas> {
  final List<DrawnLine> _lines = [];
  DrawnLine? _currentLine;

  Color _selectedColor = const Color(0xFFE2E8F0); // Off-white
  final double _selectedWidth = 2.5;
  bool _isEraser = false;
  double _height = 280.0; // Dynamic resizable height

  final List<Color> _palette = const [
    Color(0xFFE2E8F0), // White
    Color(0xFF38BDF8), // Sky Blue
    Color(0xFFFBBF24), // Amber Yellow
    Color(0xFF34D399), // Mint Green
    Color(0xFFF43F5E), // Rose Red
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        border: Border(
          top: BorderSide(color: const Color(0xFF38BDF8).withValues(alpha: 0.6), width: 2),
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black54, blurRadius: 16, offset: Offset(0, -4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle Bar for resizing height up & down
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: (details) {
              setState(() {
                // Dragging up (negative dy) expands the height; dragging down reduces it
                _height = (_height - details.delta.dy).clamp(180.0, 560.0);
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              color: const Color(0xFF0F172A),
              child: Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),

          // Responsive Toolbar (Never overflows!)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            color: const Color(0xFF0F172A),
            child: Row(
              children: [
                const Icon(Icons.draw, size: 16, color: Color(0xFF38BDF8)),
                const SizedBox(width: 6),
                const Text(
                  '手書きメモ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),

                // Horizontally scrollable palette & tools to guarantee 0 overflow
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Color choices
                        ..._palette.map((c) {
                          final isSelected = !_isEraser && _selectedColor == c;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = c;
                                _isEraser = false;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: c,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? Colors.white : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        }),

                        const SizedBox(width: 6),

                        // Eraser button
                        InkWell(
                          onTap: () => setState(() => _isEraser = true),
                          borderRadius: BorderRadius.circular(6),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.auto_fix_high,
                              size: 17,
                              color: _isEraser ? const Color(0xFFF59E0B) : Colors.white60,
                            ),
                          ),
                        ),

                        // Undo button
                        InkWell(
                          onTap: _lines.isEmpty
                              ? null
                              : () => setState(() => _lines.removeLast()),
                          borderRadius: BorderRadius.circular(6),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.undo,
                              size: 17,
                              color: _lines.isEmpty ? Colors.white24 : Colors.white70,
                            ),
                          ),
                        ),

                        // Clear button
                        InkWell(
                          onTap: _lines.isEmpty
                              ? null
                              : () => setState(() => _lines.clear()),
                          borderRadius: BorderRadius.circular(6),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.delete_outline,
                              size: 17,
                              color: _lines.isEmpty ? Colors.white24 : const Color(0xFFF43F5E),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Close Button (Prominent & Always accessible on the right)
                if (widget.onClose != null)
                  InkWell(
                    onTap: widget.onClose,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.close, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            '閉じる',
                            style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Interactive Canvas Area with Dynamic Resizable Height
          SizedBox(
            height: _height,
            width: double.infinity,
            child: GestureDetector(
              onPanStart: (details) {
                final localPos = details.localPosition;

                setState(() {
                  _currentLine = DrawnLine(
                    path: [localPos],
                    color: _isEraser ? const Color(0xFF090D16) : _selectedColor,
                    width: _isEraser ? 18.0 : _selectedWidth,
                  );
                  _lines.add(_currentLine!);
                });
              },
              onPanUpdate: (details) {
                final localPos = details.localPosition;

                setState(() {
                  if (_currentLine != null) {
                    _currentLine!.path.add(localPos);
                  }
                });
              },
              onPanEnd: (_) {
                setState(() {
                  _currentLine = null;
                });
              },
              child: CustomPaint(
                painter: ScratchpadPainter(lines: _lines),
                size: Size.infinite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
