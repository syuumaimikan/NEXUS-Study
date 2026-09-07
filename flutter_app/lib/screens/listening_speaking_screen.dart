import 'dart:async';
import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ListeningQuestion {
  final String id;
  final String title;
  final String situation;
  final String audioScript;
  final String japaneseTranslation;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const ListeningQuestion({
    required this.id,
    required this.title,
    required this.situation,
    required this.audioScript,
    required this.japaneseTranslation,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class SpeakingTurn {
  final String speaker;
  final String text;
  final String translation;
  final List<String> userOptions;
  final String hint;

  const SpeakingTurn({
    required this.speaker,
    required this.text,
    required this.translation,
    required this.userOptions,
    required this.hint,
  });
}

class ListeningSpeakingScreen extends StatefulWidget {
  const ListeningSpeakingScreen({super.key});

  @override
  State<ListeningSpeakingScreen> createState() => _ListeningSpeakingScreenState();
}

class _ListeningSpeakingScreenState extends State<ListeningSpeakingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  // Listening State
  int _currentListeningIdx = 0;
  bool _isPlaying = false;
  double _playbackSpeed = 1.0;
  bool _showScript = false;
  int? _selectedOption;
  bool _hasAnswered = false;
  double _playProgress = 0.0;
  Timer? _audioTimer;

  // Speaking State
  int _speakingStep = 0;
  final List<String> _conversationLog = [];

  final List<ListeningQuestion> _listeningQuestions = [
    const ListeningQuestion(
      id: 'l1',
      title: '第1問: キャンパスでの講義日程に関する対話',
      situation: '大学の図書館前で、二人の学生が課題の提出期限について話しています。',
      audioScript: 'Woman: Hi Ken, have you finished the physics report for Professor Davis yet?\n'
          'Man: Not completely, Sarah. I thought it was due next Monday, but someone said it was moved forward to Friday.\n'
          'Woman: Actually, Professor Davis sent an email this morning saying the deadline is extended to Wednesday because of the lab maintenance.\n'
          'Man: What a relief! That gives us two extra days.',
      japaneseTranslation: '女性: こんにちはケン、デイビス教授の物理のレポートはもう終わった？\n'
          '男性: まだ全部は終わってないよ、サラ。来週月曜が期限だと思ってたけど、金曜に前倒しされたって聞いたよ。\n'
          '女性: 実は今朝デイビス教授からメールが来て、研究室のメンテがあるから水曜日に延長されたのよ。\n'
          '男性: よかった！これで2日余分に時間ができたね。',
      question: 'When is the final deadline for the physics report?',
      options: ['Friday', 'Next Monday', 'Next Wednesday', 'Two weeks later'],
      correctIndex: 2,
      explanation: '教授からの最新のメールで、提出期限は「水曜日（Wednesday）」に延長されたと述べられています。',
    ),
    const ListeningQuestion(
      id: 'l2',
      title: '第2問: 気候変動と再生可能エネルギーの講義',
      situation: '大学の環境科学の講義で、教授が洋上風力発電について解説しています。',
      audioScript: 'Professor: While onshore wind turbines are cost-effective, offshore wind farms possess several crucial advantages. '
          'First, marine winds are stronger and much more consistent than terrestrial ones. '
          'Second, offshore installations avoid visual and noise pollution in residential areas. '
          'However, the initial engineering cost for deep-sea anchoring remains a considerable hurdle.',
      japaneseTranslation: '教授: 陸上風力タービンは費用対効果が高いですが、洋上風力発電にはいくつかの決定的な利点があります。'
          '第1に、海上の風は陸上の風よりも強く、はるかに安定的です。'
          '第2に、洋上施設は住宅地の景観や騒音問題を回避できます。'
          'しかしながら、深海での係留に関わる初期建設コストは依然として大きな障壁となっています。',
      question: 'What is mentioned as a primary challenge for offshore wind energy?',
      options: [
        'Lack of wind speed over oceans',
        'High initial costs for deep-sea engineering',
        'Noise complaints from coastal residents',
        'Interference with terrestrial power grids'
      ],
      correctIndex: 1,
      explanation: '深海での係留・建設に関わる初期費用（initial engineering cost）が大きな障壁（considerable hurdle）であると明言されています。',
    ),
  ];

  final List<SpeakingTurn> _speakingScenario = [
    const SpeakingTurn(
      speaker: 'Alex (留学生パートナー)',
      text: 'Hey! Are you heading to the international exchange seminar this afternoon?',
      translation: 'やあ！今日の午後の国際交流セミナーに行く予定？',
      userOptions: [
        'Yes, I registered for it yesterday. Are you going too?',
        'No, I have to finish my calculus assignment first.',
        'What seminar? Could you tell me more about it?',
      ],
      hint: '前向きに参加意志を伝え、相手にも聞き返すフレーズが自然です。',
    ),
    const SpeakingTurn(
      speaker: 'Alex (留学生パートナー)',
      text: 'Awesome! We are discussing comparative education systems in Japan and Europe. What topic are you most interested in?',
      translation: 'いいね！日本とヨーロッパの教育制度比較を議論するんだ。どのテーマに一番関心がある？',
      userOptions: [
        'I am particularly interested in university entrance exam methods.',
        'I would like to discuss language learning programs in high schools.',
        'How technology and AI are integrated into daily classrooms.',
      ],
      hint: '自分が大学で探究したい問題意識を具体的に伝えてみましょう。',
    ),
    const SpeakingTurn(
      speaker: 'Alex (留学生パートナー)',
      text: 'That sounds fascinating. Let us prepare some key questions together over coffee before the session starts!',
      translation: 'すごく興味深いね。セッションが始まる前にコーヒーでも飲みながら質問を一緒に準備しよう！',
      userOptions: [
        'Sounds great! Let us meet at the campus cafe in thirty minutes.',
        'Thank you! I will bring my research notes with me.',
      ],
      hint: '相手の提案を快諾し、具体的な集合場所や時間を提示すると会話が弾みます。',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _audioTimer?.cancel();
    super.dispose();
  }

  void _togglePlayback() {
    if (_isPlaying) {
      _audioTimer?.cancel();
      setState(() => _isPlaying = false);
    } else {
      setState(() {
        _isPlaying = true;
        if (_playProgress >= 1.0) _playProgress = 0.0;
      });

      _audioTimer = Timer.periodic(Duration(milliseconds: (100 / _playbackSpeed).round()), (t) {
        if (_playProgress < 1.0) {
          setState(() {
            _playProgress += 0.02;
          });
        } else {
          t.cancel();
          setState(() {
            _isPlaying = false;
            _playProgress = 1.0;
          });
        }
      });
    }
  }

  void _handleOptionSelect(int index) {
    if (_hasAnswered) return;
    final currentQ = _listeningQuestions[_currentListeningIdx];
    final isCorrect = index == currentQ.correctIndex;

    setState(() {
      _selectedOption = index;
      _hasAnswered = true;
    });

    StorageService().recordAttempt(isCorrect, isCorrect ? 35 : 10, bonusCoins: isCorrect ? 10 : 2, subjectId: 'english');

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: isCorrect ? const Color(0xFF34D399) : const Color(0xFFEF4444)),
            const SizedBox(width: 8),
            Text(isCorrect ? '正解！ +35 XP & +10G' : '不正解。解説を確認しましょう'),
          ],
        ),
        duration: const Duration(milliseconds: 1400),
        backgroundColor: isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.headphones, color: Color(0xFF38BDF8), size: 20),
            SizedBox(width: 8),
            Text('英会話・リスニング実戦演習', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: const Color(0xFF38BDF8),
          labelColor: const Color(0xFF38BDF8),
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: '入試リスニング特訓'),
            Tab(text: '実践スピーキング対話'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _buildListeningTab(),
          _buildSpeakingTab(),
        ],
      ),
    );
  }

  Widget _buildListeningTab() {
    final q = _listeningQuestions[_currentListeningIdx];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Audio Player Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        q.title,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    // Speed selector
                    DropdownButton<double>(
                      value: _playbackSpeed,
                      dropdownColor: const Color(0xFF131B2E),
                      style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold),
                      underline: const SizedBox(),
                      items: [0.8, 1.0, 1.2, 1.5].map((s) => DropdownMenuItem(value: s, child: Text('${s}x'))).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _playbackSpeed = val);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(q.situation, style: const TextStyle(fontSize: 11, color: Colors.white60)),
                const SizedBox(height: 14),

                // Audio Slider
                LinearProgressIndicator(
                  value: _playProgress,
                  minHeight: 6,
                  backgroundColor: Colors.white12,
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF38BDF8)),
                ),
                const SizedBox(height: 12),

                // Playback controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.replay_10, color: Colors.white70),
                      onPressed: () => setState(() => _playProgress = (_playProgress - 0.2).clamp(0.0, 1.0)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _togglePlayback,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(14),
                        backgroundColor: const Color(0xFF38BDF8),
                        foregroundColor: Colors.black,
                      ),
                      child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 28),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.forward_10, color: Colors.white70),
                      onPressed: () => setState(() => _playProgress = (_playProgress + 0.2).clamp(0.0, 1.0)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Script disclosure button
          OutlinedButton.icon(
            onPressed: () => setState(() => _showScript = !_showScript),
            icon: Icon(_showScript ? Icons.visibility_off : Icons.visibility, size: 16),
            label: Text(_showScript ? 'スクリプトを隠す' : '英文スクリプト＆日本語訳を表示 (シャドーイング用)'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF38BDF8),
              side: const BorderSide(color: Color(0xFF38BDF8)),
            ),
          ),

          if (_showScript) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF131B2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('【English Script】', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(q.audioScript, style: const TextStyle(color: Colors.white, fontSize: 11.5, height: 1.4)),
                  const SizedBox(height: 10),
                  const Text('【日本語訳】', style: TextStyle(color: Color(0xFF34D399), fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(q.japaneseTranslation, style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.4)),
                ],
              ),
            ),
          ],

          const SizedBox(height: 18),

          // Question Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Q. ${q.question}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 14),
                ...List.generate(q.options.length, (idx) {
                  final isSelected = _selectedOption == idx;
                  final isCorrect = idx == q.correctIndex;
                  Color btnColor = const Color(0xFF0F172A);
                  BorderSide border = const BorderSide(color: Colors.white12);

                  if (_hasAnswered) {
                    if (isCorrect) {
                      btnColor = const Color(0xFF10B981).withValues(alpha: 0.2);
                      border = const BorderSide(color: Color(0xFF10B981), width: 1.5);
                    } else if (isSelected) {
                      btnColor = const Color(0xFFEF4444).withValues(alpha: 0.2);
                      border = const BorderSide(color: Color(0xFFEF4444), width: 1.5);
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () => _handleOptionSelect(idx),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: btnColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.fromBorderSide(border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white10,
                              ),
                              child: Center(
                                child: Text('${idx + 1}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                q.options[idx],
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                            if (_hasAnswered && isCorrect)
                              const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 18),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                if (_hasAnswered) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('【解説】', style: TextStyle(color: Color(0xFFFBBF24), fontSize: 11, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(q.explanation, style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.4)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentListeningIdx = (_currentListeningIdx + 1) % _listeningQuestions.length;
                        _selectedOption = null;
                        _hasAnswered = false;
                        _playProgress = 0.0;
                        _isPlaying = false;
                        _showScript = false;
                        _audioTimer?.cancel();
                      });
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38BDF8), foregroundColor: Colors.black),
                    child: const Text('次の問題に進む'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeakingTab() {
    final step = _speakingScenario[_speakingStep.clamp(0, _speakingScenario.length - 1)];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Partner message
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline, color: Color(0xFF38BDF8), size: 18),
                    const SizedBox(width: 8),
                    Text(step.speaker, style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  step.text,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, height: 1.4),
                ),
                const SizedBox(height: 6),
                Text(
                  step.translation,
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          const Text('あなたへの返答候補 (声に出して発話しましょう):', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          ...step.userOptions.map((opt) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _conversationLog.add('You: $opt');
                    if (_speakingStep < _speakingScenario.length - 1) {
                      _speakingStep++;
                    } else {
                      _speakingStep = 0;
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF131B2E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: Colors.white12)),
                  alignment: Alignment.centerLeft,
                ),
                child: Text(opt, style: const TextStyle(fontSize: 12, height: 1.3)),
              ),
            );
          }),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline, color: Color(0xFFFBBF24), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '発話のヒント: ${step.hint}',
                    style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
