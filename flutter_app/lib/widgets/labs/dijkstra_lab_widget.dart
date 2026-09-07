import 'package:flutter/material.dart';

class _GraphEdge {
  final int u, v, weight;
  const _GraphEdge(this.u, this.v, this.weight);
}

class DijkstraLabWidget extends StatefulWidget {
  const DijkstraLabWidget({super.key});

  @override
  State<DijkstraLabWidget> createState() => _DijkstraLabWidgetState();
}

class _DijkstraLabWidgetState extends State<DijkstraLabWidget> {
  int _currentStep = 0;

  static const List<String> _nodeLabels = ['S (始点)', 'A', 'B', 'C', 'D', 'G (終点)'];

  static const List<Offset> _nodePositions = [
    Offset(40, 110),  // S: 0
    Offset(120, 40),  // A: 1
    Offset(120, 180), // B: 2
    Offset(210, 50),  // C: 3
    Offset(210, 170), // D: 4
    Offset(290, 110), // G: 5
  ];

  static const List<_GraphEdge> _edges = [
    _GraphEdge(0, 1, 4), // S-A: 4
    _GraphEdge(0, 2, 2), // S-B: 2
    _GraphEdge(1, 2, 1), // A-B: 1
    _GraphEdge(1, 3, 5), // A-C: 5
    _GraphEdge(2, 4, 7), // B-D: 7
    _GraphEdge(3, 4, 1), // C-D: 1
    _GraphEdge(3, 5, 3), // C-G: 3
    _GraphEdge(4, 5, 2), // D-G: 2
  ];

  // Steps in Dijkstra: (visitedNodes, distances, currentFocus, explanation)
  final List<Map<String, dynamic>> _steps = [
    {
      'visited': <int>{},
      'dist': [0, 999, 999, 999, 999, 999],
      'focus': 0,
      'text': '初期状態: 始点 S の距離を 0、それ以外の全ノードを ∞ に設定します。',
    },
    {
      'visited': <int>{0},
      'dist': [0, 4, 2, 999, 999, 999],
      'focus': 0,
      'text': 'S を訪問確定: 隣接ノード A(距離4), B(距離2) の暫定最短距離を更新します。',
    },
    {
      'visited': <int>{0, 2},
      'dist': [0, 3, 2, 999, 9, 999],
      'focus': 2,
      'text': '未訪問で最小の B(距離2) を確定: B経由で A(2+1=3 < 4), D(2+7=9) を更新！',
    },
    {
      'visited': <int>{0, 2, 1},
      'dist': [0, 3, 2, 8, 9, 999],
      'focus': 1,
      'text': '未訪問で最小の A(距離3) を確定: A経由で C(3+5=8) を更新します。',
    },
    {
      'visited': <int>{0, 2, 1, 3},
      'dist': [0, 3, 2, 8, 9, 11],
      'focus': 3,
      'text': '未訪問で最小の C(距離8) を確定: G(8+3=11) を更新します。',
    },
    {
      'visited': <int>{0, 2, 1, 3, 4},
      'dist': [0, 3, 2, 8, 9, 11],
      'focus': 4,
      'text': '未訪問で最小の D(距離9) を確定: D経由の G(9+2=11) は更新なし。',
    },
    {
      'visited': <int>{0, 2, 1, 3, 4, 5},
      'dist': [0, 3, 2, 8, 9, 11],
      'focus': 5,
      'text': 'ゴール G(距離11) に到達・確定！最短経路は S → B → A → C → G (合計コスト 11) です！',
      'path': [0, 2, 1, 3, 5],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final state = _steps[_currentStep];
    final visited = state['visited'] as Set<int>;
    final dist = state['dist'] as List<int>;
    final focus = state['focus'] as int;
    final text = state['text'] as String;
    final path = (state['path'] as List<int>?) ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF818CF8).withValues(alpha: 0.3)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.alt_route, color: Color(0xFF818CF8), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'ダイクストラ法 (最短経路探索アルゴリズム)',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '情報I・共通テスト＆情報科学の超頻出アルゴリズム。\n「未訪問の中で暫定距離が最小のノードを確定し、隣接ノードの距離を緩和（更新）する」ステップを1コマずつ追跡！',
                  style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Graph Canvas
          Container(
            height: 240,
            decoration: BoxDecoration(
              color: const Color(0xFF030712),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CustomPaint(
                painter: _DijkstraGraphPainter(
                  positions: _nodePositions,
                  edges: _edges,
                  visited: visited,
                  focusNode: focus,
                  shortestPath: path,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Step Explanation Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF818CF8).withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF818CF8).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Step $_currentStep / ${_steps.length - 1}',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFA5B4FC)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  text,
                  style: const TextStyle(fontSize: 12, color: Colors.white, height: 1.4, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Distance Table
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_nodeLabels.length, (idx) {
                final d = dist[idx];
                final isFixed = visited.contains(idx);
                return Column(
                  children: [
                    Text(
                      _nodeLabels[idx].split(' ')[0],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isFixed ? const Color(0xFF34D399) : Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      d >= 999 ? '∞' : '$d',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isFixed
                            ? const Color(0xFF34D399)
                            : d < 999
                                ? const Color(0xFF38BDF8)
                                : Colors.white38,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),

          const SizedBox(height: 16),

          // Navigation Controls
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _currentStep > 0 ? () => setState(() => _currentStep--) : null,
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('前のステップ'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () => setState(() => _currentStep = 0),
                icon: const Icon(Icons.replay, color: Colors.white70),
                tooltip: '最初から',
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _currentStep < _steps.length - 1 ? () => setState(() => _currentStep++) : null,
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('次のステップ', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF818CF8),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DijkstraGraphPainter extends CustomPainter {
  final List<Offset> positions;
  final List<_GraphEdge> edges;
  final Set<int> visited;
  final int focusNode;
  final List<int> shortestPath;

  _DijkstraGraphPainter({
    required this.positions,
    required this.edges,
    required this.visited,
    required this.focusNode,
    required this.shortestPath,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Check if edge is in shortest path
    bool isPathEdge(int u, int v) {
      if (shortestPath.length < 2) return false;
      for (int i = 0; i < shortestPath.length - 1; i++) {
        if ((shortestPath[i] == u && shortestPath[i + 1] == v) ||
            (shortestPath[i] == v && shortestPath[i + 1] == u)) {
          return true;
        }
      }
      return false;
    }

    // Draw Edges
    for (final e in edges) {
      final p1 = positions[e.u];
      final p2 = positions[e.v];
      final inPath = isPathEdge(e.u, e.v);

      final edgePaint = Paint()
        ..color = inPath ? const Color(0xFFFBBF24) : Colors.white24
        ..strokeWidth = inPath ? 3.5 : 1.5;

      canvas.drawLine(p1, p2, edgePaint);

      // Weight label in midpoint
      final mid = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);
      final tp = TextPainter(
        text: TextSpan(
          text: '${e.weight}',
          style: TextStyle(
            color: inPath ? const Color(0xFFFBBF24) : Colors.white60,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(mid.dx - 4, mid.dy - 6));
    }

    // Draw Nodes
    const labels = ['S', 'A', 'B', 'C', 'D', 'G'];
    for (int i = 0; i < positions.length; i++) {
      final pos = positions[i];
      final isDone = visited.contains(i);
      final isFocus = focusNode == i;
      final inPath = shortestPath.contains(i);

      Color col = const Color(0xFF1E293B);
      Color borderCol = Colors.white38;

      if (inPath) {
        col = const Color(0xFFFBBF24);
        borderCol = Colors.white;
      } else if (isFocus) {
        col = const Color(0xFF818CF8);
        borderCol = const Color(0xFFA5B4FC);
      } else if (isDone) {
        col = const Color(0xFF064E3B);
        borderCol = const Color(0xFF34D399);
      }

      final nodePaint = Paint()..color = col;
      canvas.drawCircle(pos, 16, nodePaint);
      canvas.drawCircle(pos, 16, Paint()..color = borderCol..style = PaintingStyle.stroke..strokeWidth = 2);

      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(
            color: (inPath || isFocus) ? Colors.black : Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _DijkstraGraphPainter oldDelegate) => true;
}
