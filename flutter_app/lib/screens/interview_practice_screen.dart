import 'dart:async';
import 'package:flutter/material.dart';

class InterviewQuestion {
  final String id;
  final String category;
  final String question;
  final String point;
  final String modelAnswer;
  final String advice;

  const InterviewQuestion({
    required this.id,
    required this.category,
    required this.question,
    required this.point,
    required this.modelAnswer,
    required this.advice,
  });
}

class InterviewPracticeScreen extends StatefulWidget {
  const InterviewPracticeScreen({super.key});

  @override
  State<InterviewPracticeScreen> createState() => _InterviewPracticeScreenState();
}

class _InterviewPracticeScreenState extends State<InterviewPracticeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  String _selectedCategory = '大学 総合型・推薦選抜';

  // Interactive practice state
  bool _isPracticing = false;
  int _currentQuestionIndex = 0;
  int _remainingSeconds = 60;
  Timer? _timer;
  final TextEditingController _answerCtrl = TextEditingController();
  bool _showFeedback = false;

  final List<InterviewQuestion> _questions = [
    // 総合型・推薦
    const InterviewQuestion(
      id: 'q1',
      category: '大学 総合型・推薦選抜',
      question: '本学のこの学部・学科を志望した理由を1分程度で述べてください。',
      point: '他大学ではなく「なぜこの大学・この教授の研究室なのか」の独自性と、将来のビジョンとの一貫性を評価します。',
      modelAnswer: '私は将来、次世代の再生可能エネルギー蓄電技術の研究開発に携わりたいと考えています。貴学の〇〇教授が取り組まれている固体電解質リチウムイオン電池の材料研究は世界をリードしており、学問領域を横断した実験設備と産学連携のプログラムが充実している点に強く惹かれ、志望いたしました。',
      advice: 'パンフレットの言葉の丸暗記はNG。自分の過去の経験（探究学習や部活動など）を起点に「だからここを選んだ」と語りましょう。',
    ),
    const InterviewQuestion(
      id: 'q2',
      category: '大学 総合型・推薦選抜',
      question: '高校生活の中で、自ら主体的に課題を見つけて解決に取り組んだ経験を教えてください。',
      point: '指示待ちではなく自走力があるか、周囲と協調しながら課題解決（探究）を完遂した経験があるかを見ています。',
      modelAnswer: '高校2年時の探究活動において、地域のプラスチック廃棄物分別率が低いことに着目しました。現地調査や住民へのアンケートを実施し、ゴミ袋のデザイン改善と視覚的な分別チャートを作成・提案した結果、回収率の向上に寄与することができました。',
      advice: '「何を達成したか」の成果以上に、「途中で生じた壁」と「それをどう工夫して乗り越えたか」の思考プロセスを伝えましょう。',
    ),
    const InterviewQuestion(
      id: 'q3',
      category: '大学 総合型・推薦選抜',
      question: '大学入学後、学業以外で挑戦してみたいことや課外活動はありますか？',
      point: '知的好奇心の幅広さと、大学コミュニティに積極的に参加する主体性・活力を確認します。',
      modelAnswer: '専攻の勉学に加えて、国際交流プログラムや留学生との共同生活寮での活動に挑戦したいです。異なる文化的背景を持つ学生との対話を通じて、グローバルな視野と協調性を鍛えたいと考えています。',
      advice: 'サークル名や留学の希望を具体的に挙げ、それが自分の将来の成長にどう結びつくかまで結びつけて語ると好印象です。',
    ),
    // 一般入試・医学部
    const InterviewQuestion(
      id: 'q4',
      category: '大学 一般・医学部面接',
      question: '医師（または医療従事者・専門職）を目指す覚悟と、大切にしたい倫理観について述べてください。',
      point: '過酷な医療現場に耐えうる使命感と、患者ファーストの共感力・誠実な倫理観を試します。',
      modelAnswer: '医療技術の進歩は目覚ましいですが、常に病ではなく「人」を診る医師でありたいと考えています。祖父の闘病に寄り添ってくださった主治医のように、患者や家族の不安に寄り添い、説明責任とインフォームド・コンセントを徹底できる誠実な医師を目指します。',
      advice: '憧れだけでなく、患者の命を預かる重責を真摯に受け止めている姿勢を落ち着いた声と言葉で表現しましょう。',
    ),
    const InterviewQuestion(
      id: 'q5',
      category: '大学 一般・医学部面接',
      question: '最近関心を持った医療・科学分野の時事ニュースは何ですか？',
      point: '日頃から社会や学術の動向にアンテナを張っているか、自分の意見を論理的に構築できるかを評価します。',
      modelAnswer: '生成AIを用いた新薬候補物質の探索や画像診断支援の臨床応用に関するニュースです。開発期間の短縮が期待される一方で、最終的な診断責任の所在やバイアスへの配慮など、医療倫理とAIガバナンスの重要性を痛感しました。',
      advice: '事実の概要説明で終わらせず、「それに対して自分はどう考えるか」「将来どう関わるか」まで述べるのが鉄則です。',
    ),
    // 高校受験
    const InterviewQuestion(
      id: 'q6',
      category: '高校入試面接',
      question: '本校に入学したら、特に頑張りたい教科や部活動は何ですか？',
      point: '高校生活の具体的なイメージを持っているか、前向きな意欲があるかを確認します。',
      modelAnswer: '中学校で培った基礎を活かし、特に数学の発展的な問題演習に力を注ぎたいです。また、理科部に入部して地域の自然環境調査や科学オリンピックへの参加に挑戦し、文武両道を目指します。',
      advice: '中学時代の実績を踏まえつつ、高校での新しい目標を明るくハキハキと答えましょう。',
    ),
    const InterviewQuestion(
      id: 'q7',
      category: '高校入試面接',
      question: 'あなたの長所と短所について、具体的なエピソードを交えて教えてください。',
      point: '客観的な自己分析ができているか、短所を改善しようと努力している姿勢があるかを見ます。',
      modelAnswer: '長所は一度決めたことを最後までやり抜く粘り強さです。短所は何事も慎重になりすぎて決断に時間がかかることですが、事前に締め切りを意識して行動することで改善を図っています。',
      advice: '短所だけで終わらず、「どのように改善するよう工夫しているか」をセットで話すことで誠実さをアピールできます。',
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
    _timer?.cancel();
    _answerCtrl.dispose();
    super.dispose();
  }

  void _startPractice(int qIndex) {
    _timer?.cancel();
    setState(() {
      _currentQuestionIndex = qIndex;
      _isPracticing = true;
      _remainingSeconds = 60;
      _showFeedback = false;
      _answerCtrl.clear();
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        t.cancel();
        setState(() => _showFeedback = true);
      }
    });
  }

  void _finishAnswer() {
    _timer?.cancel();
    setState(() {
      _showFeedback = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.record_voice_over, color: Color(0xFF38BDF8), size: 20),
            SizedBox(width: 8),
            Text('面接対策＆対話シミュレータ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
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
            Tab(text: '予想質問集＆攻略法'),
            Tab(text: '対話模擬面接実戦'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _buildQuestionBankTab(),
          _buildInteractivePracticeTab(),
        ],
      ),
    );
  }

  Widget _buildQuestionBankTab() {
    final filtered = _questions.where((q) => q.category == _selectedCategory).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Category Selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['大学 総合型・推薦選抜', '大学 一般・医学部面接', '高校入試面接'].map((cat) {
                final isSel = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSel,
                    selectedColor: const Color(0xFF38BDF8),
                    backgroundColor: const Color(0xFF131B2E),
                    labelStyle: TextStyle(
                      fontSize: 11,
                      color: isSel ? Colors.black : Colors.white70,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Manner tip card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFF38BDF8), size: 16),
                    SizedBox(width: 6),
                    Text('面接基本マナーの鉄則', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  '・入室時: ドアを3回ノック →「失礼いたします」と一礼 → 椅子の横で名前を名乗り「お座りください」と言われてから着席\n・視線: 面接官の眉間や目元を穏やかに見つめ、語尾は「〜です」「〜ます」と言い切る\n・回答の長さ: 1問あたり45秒〜1分程度が最も聞き取りやすく印象的です',
                  style: TextStyle(fontSize: 10.5, color: Colors.white70, height: 1.45),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          ...filtered.asMap().entries.map((entry) {
            final idx = entry.key;
            final q = entry.value;
            return _buildQuestionCard(idx, q);
          }),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(int index, InterviewQuestion q) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            'Q${index + 1}. ${q.question}',
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '評価の眼目: ${q.point}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 10),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Divider(color: Colors.white10),
                  const Text('【模範回答例】', style: TextStyle(color: Color(0xFF34D399), fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(q.modelAnswer, style: const TextStyle(color: Colors.white, fontSize: 11, height: 1.4)),
                  ),
                  const SizedBox(height: 10),
                  const Text('【面接官のアドバイス】', style: TextStyle(color: Color(0xFFFBBF24), fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(q.advice, style: const TextStyle(color: Colors.white70, fontSize: 10.5, height: 1.4)),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      _tabCtrl.animateTo(1);
                      _startPractice(_questions.indexOf(q));
                    },
                    icon: const Icon(Icons.mic, size: 14),
                    label: const Text('この質問で模擬面接を開始'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF38BDF8),
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractivePracticeTab() {
    final currentQ = _questions[_currentQuestionIndex.clamp(0, _questions.length - 1)];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Interviewer Character Box
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF38BDF8), width: 2),
                  ),
                  child: const Icon(Icons.person, color: Color(0xFF38BDF8), size: 32),
                ),
                const SizedBox(height: 8),
                const Text('主任面接官', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131B2E),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Text(
                    '「${currentQ.question}」',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, height: 1.4),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Countdown Timer Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.timer, color: Color(0xFFFBBF24), size: 18),
                    const SizedBox(width: 8),
                    const Text('回答制限時間:', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
                Text(
                  '$_remainingSeconds 秒',
                  style: TextStyle(
                    color: _remainingSeconds <= 10 ? const Color(0xFFF43F5E) : const Color(0xFFFBBF24),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Answer input / memo area
          TextField(
            controller: _answerCtrl,
            maxLines: 4,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            decoration: InputDecoration(
              hintText: '回答の要点やメモを箇条書きで記録できます（口頭練習しながら入力可能）',
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 11),
              filled: true,
              fillColor: const Color(0xFF131B2E),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
          ),

          const SizedBox(height: 14),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isPracticing && !_showFeedback ? _finishAnswer : () => _startPractice(_currentQuestionIndex),
                  icon: Icon(_isPracticing && !_showFeedback ? Icons.stop : Icons.play_arrow, size: 16),
                  label: Text(_isPracticing && !_showFeedback ? '回答完了・評価確認' : '面接シミュレーション開始'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38BDF8),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Color(0xFF38BDF8)),
                tooltip: '次の質問へ',
                onPressed: () {
                  final next = (_currentQuestionIndex + 1) % _questions.length;
                  _startPractice(next);
                },
              ),
            ],
          ),

          // Feedback Section
          if (_showFeedback) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF131B2E),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF34D399).withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Color(0xFF34D399), size: 18),
                      SizedBox(width: 8),
                      Text('面接官からのフィードバック＆模範回答', style: TextStyle(color: Color(0xFF34D399), fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('【模範回答】', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(currentQ.modelAnswer, style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.4)),
                  const SizedBox(height: 10),
                  const Text('【プロ講師の改善アドバイス】', style: TextStyle(color: Color(0xFFFBBF24), fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(currentQ.advice, style: const TextStyle(color: Colors.white70, fontSize: 10.5, height: 1.4)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
