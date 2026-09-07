import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/storage_service.dart';

class FlashcardItem {
  final String category;
  final String front;
  final String back;
  final String? note;
  final bool isCustom;
  final int? targetId;
  final int? targetSection;
  final String? targetSectionName;
  final String? targetSubSection;
  final String? partOfSpeech;

  const FlashcardItem({
    required this.category,
    required this.front,
    required this.back,
    this.note,
    this.isCustom = false,
    this.targetId,
    this.targetSection,
    this.targetSectionName,
    this.targetSubSection,
    this.partOfSpeech,
  });

  Map<String, String> toMap() => {
        'category': category,
        'front': front,
        'back': back,
        'note': note ?? '',
      };

  factory FlashcardItem.fromMap(Map<String, String> map) => FlashcardItem(
        category: map['category'] ?? '自作カード',
        front: map['front'] ?? '',
        back: map['back'] ?? '',
        note: map['note'],
        isCustom: true,
      );
}

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isFront = true;
  int _currentIndex = 0;
  String _selectedCategory = 'ターゲット1900';

  // Target 1900 specific filters
  int _targetSection = 0; // 0: All, 1: Sec 1 (1-800), 2: Sec 2 (801-1500), 3: Sec 3 (1501-1900)
  String _targetSubSection = 'すべて';
  bool _isFrequencyOrder = true;

  List<FlashcardItem> _targetCards = [];
  List<FlashcardItem> _customCards = [];
  bool _isLoadingTarget = true;

  static const List<FlashcardItem> _defaultCards = [
    // 古文 (Kobun)
    FlashcardItem(category: '古文', front: 'あはれなり', back: 'しみじみと情趣深い、いとおしい', note: '喜怒哀楽の深い感動を表す最重要語。'),
    FlashcardItem(category: '古文', front: 'をかし', back: '趣がある、すばらしい、滑稽だ', note: '理知的な美や肯定的な興味を表す。'),
    FlashcardItem(category: '古文', front: 'おぼつかなし', back: '気がかりだ、不安だ、はっきりしない', note: '現代語の「おぼつかない」とは異なる。'),
    FlashcardItem(category: '古文', front: 'いたし', back: 'はなはだしい、すばらしい、痛々しい', note: '連用形「いたく」で強調を表す。'),
    FlashcardItem(category: '古文', front: 'ゆゆし', back: '不吉だ、恐ろしい、甚だしい、素晴らしい', note: '神聖・不吉の両面で用いられる。'),
    FlashcardItem(category: '古文', front: 'かなし', back: 'いとおしい、かわいい、悲しい', note: '愛情表現として「愛し」と書くことも多い。'),
    FlashcardItem(category: '古文', front: 'うつくし', back: 'かわいい、愛らしい', note: '現代の「美しい」ではなく幼子の可愛らしさ。'),
    FlashcardItem(category: '古文', front: 'めでたし', back: 'すばらしい、立派だ', note: '愛づ（褒める）＋甚し。'),
    FlashcardItem(category: '古文', front: 'こころにくし', back: '奥ゆかしい、心惹かれる', note: '相手の隠れた良さに惹かれる。'),
    FlashcardItem(category: '古文', front: 'わりなし', back: '道理に合わない、どうしようもない、苦しい', note: '理（わり）無し。'),

    // 漢文 (Kanbun)
    FlashcardItem(category: '漢文', front: '再読文字: 未', back: 'いまだ〜ず（まだ〜ない）', note: '例: 未見（いまだみず）'),
    FlashcardItem(category: '漢文', front: '再読文字: 将・且', back: 'まさに〜せんとす（今にも〜しようとする）', note: '未来・意志を表す。'),
    FlashcardItem(category: '漢文', front: '再読文字: 当・応', back: 'まさに〜すべし（当然〜すべきだ）', note: '当然・義務・推量。'),
    FlashcardItem(category: '漢文', front: '使役句法: 使・令・教', back: '〜をして…（せ）しむ（〜に…させる）', note: '使役の助動詞「しむ」と呼応。'),
    FlashcardItem(category: '漢文', front: '受身句法: 見・被・為', back: '〜る・らる（〜される）', note: '為 A 所 B （AのためにBせらる）'),
    FlashcardItem(category: '漢文', front: '反語句法: 豈・何', back: 'あに〜（せ）んや（どうして〜だろうか、いや〜ない）', note: '末尾に「や」「か」を伴う。'),

    // 数学公式 (Math)
    FlashcardItem(category: '数学', front: '2次方程式の解の公式', back: 'x = (-b ± √(b² - 4ac)) / 2a', note: 'bが偶数(b=2b\')のときは (-b\' ± √(b\'² - ac)) / a'),
    FlashcardItem(category: '数学', front: '点と直線の距離公式', back: 'd = |ax₀ + by₀ + c| / √(a² + b²)', note: '点(x₀, y₀)と直線 ax + by + c = 0 の最短距離。'),
    FlashcardItem(category: '数学', front: '三角関数の相互関係', back: 'sin²θ + cos²θ = 1, tanθ = sinθ/cosθ', note: '1 + tan²θ = 1/cos²θ も必須。'),
    FlashcardItem(category: '数学', front: 'sin の2倍角の公式', back: 'sin 2θ = 2 sinθ cosθ', note: '加法定理 sin(α+β) より導出。'),
    FlashcardItem(category: '数学', front: 'cos の2倍角の公式', back: 'cos 2θ = cos²θ - sin²θ = 2cos²θ - 1', note: '= 1 - 2sin²θ とも変形可能。'),
    FlashcardItem(category: '数学', front: '余弦定理 (Cosine Law)', back: 'a² = b² + c² - 2bc cosA', note: 'cosA = (b² + c² - a²) / 2bc'),
    FlashcardItem(category: '数学', front: '正弦定理 (Sine Law)', back: 'a / sinA = b / sinB = c / sinC = 2R', note: 'R は外接円の半径。'),
    FlashcardItem(category: '数学', front: '等比数列の一般項・和', back: 'an = a・rⁿ⁻¹,  Sn = a(1 - rⁿ) / (1 - r)', note: '初項 a、公比 r (r ≠ 1)。'),
    FlashcardItem(category: '数学', front: '積の微分法', back: '(f・g)\' = f\'・g + f・g\'', note: '商の微分法は (f/g)\' = (f\'g - fg\') / g²'),
    FlashcardItem(category: '数学', front: '1/6公式 (放物線と直線の面積)', back: 'S = (a/6)・(β - α)³', note: '∫_α^β a(x-α)(x-β)dx = -(a/6)(β-α)³'),

    // 物理 (Physics)
    FlashcardItem(category: '物理', front: '運動方程式', back: 'm・a = F', note: '質量 m [kg], 加速度 a [m/s²], 合力 F [N]。'),
    FlashcardItem(category: '物理', front: '等加速度運動: 速度・変位', back: 'v = v₀ + at,  x = v₀t + (1/2)at²', note: 'v² - v₀² = 2ax も連動。'),
    FlashcardItem(category: '物理', front: 'ばね振子の周期 T', back: 'T = 2π √(m / k)', note: '質量 m、ばね定数 k。振幅に周期は無関係。'),
    FlashcardItem(category: '物理', front: '単振り子の周期 T', back: 'T = 2π √(l / g)', note: '糸の長さ l、重力加速度 g。微小振動時。'),
    FlashcardItem(category: '物理', front: 'ドップラー効果公式', back: 'f\' = f ・ (V - vo) / (V - vs)', note: '音速 V、観測者速度 vo、音源速度 vs（音の向きが正）。'),
    FlashcardItem(category: '物理', front: 'クーロンの法則', back: 'F = k ・ |q₁・q₂| / r²', note: '真空中。引力または斥力。'),

    // 化学 (Chemistry)
    FlashcardItem(category: '化学', front: '銀鏡反応 (Silver Mirror)', back: 'アルデヒド(-CHO)がアンモニア性硝酸銀を還元し銀が析出', note: '還元性の検出反応。'),
    FlashcardItem(category: '化学', front: 'フェーリング反応', back: 'アルデヒドがCu²⁺を還元し、赤色のCu₂O（酸化銅(I)）が沈殿', note: '糖類の還元性検出にも多用。'),
    FlashcardItem(category: '化学', front: 'ヨードホルム反応', back: 'CH₃-C(=O)- または CH₃-CH(OH)- 構造の検出', note: '黄色沈殿 CHI₃（特異臭）を生じる。'),
    FlashcardItem(category: '化学', front: '炎色反応の覚え方', back: 'リアカー無きK村、動力借るとするもくれない、馬力', note: 'Li(赤), Na(黄), K(赤紫), Cu(青緑), Ca(橙赤), Sr(深赤), Ba(黄緑)'),
    FlashcardItem(category: '化学', front: 'ハーバー・ボッシュ法', back: 'N₂ + 3H₂ ⇄ 2NH₃ (四酸化三鉄触媒, 高温高圧)', note: 'アンモニアの工業的製法。'),

    // 歴史・社会 (History & Civics)
    FlashcardItem(category: '社会', front: '墾田永年私財法 (743年)', back: '開墾した土地の永久私有を認め、荘園発生の契機となった法令', note: '聖武天皇の時代。三世一身法から転換。'),
    FlashcardItem(category: '社会', front: '承久の乱 (1221年)', back: '後鳥羽上皇が鎌倉幕府打倒を図るも幕府側（北条義時）が勝利', note: '六波羅探題が京都に設置された。'),
    FlashcardItem(category: '社会', front: 'モンテスキュー『法の精神』', back: '権力の濫用を防ぐ「三権分立（立法・行政・司法）」を提唱', note: 'フランス啓蒙思想。近代立憲主義の基礎。'),
    FlashcardItem(category: '社会', front: '日本国憲法三大原則', back: '国民主権、基本的人権の尊重、平和主義', note: '1946年11月3日公布、1947年5月3日施行。'),

    // 中学基本 (Junior High Basics)
    FlashcardItem(category: '中学基本', front: '一次関数の式・傾き', back: 'y = ax + b (a: 変化の割合・傾き, b: 切片)', note: '変化の割合 = (yの増加量) / (xの増加量)'),
    FlashcardItem(category: '中学基本', front: '三平方の定理 (Pythagoras)', back: '直角三角形で a² + b² = c² (c: 斜辺)', note: '3:4:5, 5:12:13, 1:1:√2, 1:2:√3'),
    FlashcardItem(category: '中学基本', front: 'オームの法則', back: '電圧 V = 電流 I × 抵抗 R', note: '電力 P = V × I, 熱量 Q = P × t [J]'),
    FlashcardItem(category: '中学基本', front: '光合成の化学反応式', back: '二酸化炭素 + 水 + 光エネルギー → 有機物 + 酸素', note: '葉緑体で行われる。'),
  ];

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(_flipController);
    _loadTargetWords();
    _loadCustomCards();
  }

  Future<void> _loadTargetWords() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/questions/target1900.json');
      final list = json.decode(jsonStr) as List;
      final parsed = list.map((item) {
        final m = item as Map<String, dynamic>;
        return FlashcardItem(
          category: 'ターゲット1900',
          front: m['word'] as String? ?? '',
          back: m['meaning'] as String? ?? '',
          note: m['example'] as String? ?? '',
          targetId: (m['id'] as num?)?.toInt(),
          targetSection: (m['section'] as num?)?.toInt(),
          targetSectionName: m['sectionName'] as String?,
          targetSubSection: m['subSection'] as String?,
          partOfSpeech: m['partOfSpeech'] as String?,
        );
      }).toList();

      if (mounted) {
        setState(() {
          _targetCards = parsed;
          _isLoadingTarget = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingTarget = false;
        });
      }
    }
  }

  void _loadCustomCards() async {
    final list = await StorageService().loadCustomFlashcards();
    if (mounted) {
      setState(() {
        _customCards = list.map((m) => FlashcardItem.fromMap(m)).toList();
      });
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFront) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  List<FlashcardItem> get _filteredCards {
    if (_selectedCategory == 'ターゲット1900') {
      var list = _targetCards;
      if (_targetSection > 0) {
        list = list.where((c) => c.targetSection == _targetSection).toList();
      }
      if (_targetSubSection != 'すべて') {
        list = list.where((c) => c.targetSubSection == _targetSubSection).toList();
      }
      if (!_isFrequencyOrder) {
        // Shuffled copy
        list = List<FlashcardItem>.from(list)..shuffle(Random(42));
      }
      return list;
    }

    final combined = [..._customCards, ..._defaultCards];
    if (_selectedCategory == 'すべて') return combined;
    if (_selectedCategory == '自作カード') return _customCards;
    return combined.where((c) => c.category == _selectedCategory).toList();
  }

  void _showJumpDialog(int total) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF131B2E),
        title: const Row(
          children: [
            Icon(Icons.directions_run, color: Color(0xFF38BDF8), size: 20),
            SizedBox(width: 8),
            Text('単語番号へジャンプ', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('番号 (1 〜 $total) を入力してください', style: const TextStyle(fontSize: 12, color: Colors.white70)),
            const SizedBox(height: 8),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: '例: 100',
                hintStyle: const TextStyle(color: Colors.white30),
                filled: true,
                fillColor: const Color(0xFF090D16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('キャンセル', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            onPressed: () {
              final val = int.tryParse(ctrl.text.trim());
              if (val != null && val >= 1 && val <= total) {
                setState(() {
                  _currentIndex = val - 1;
                  _isFront = true;
                  _flipController.reset();
                });
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38BDF8), foregroundColor: Colors.black),
            child: const Text('ジャンプ', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showAddCardDialog() {
    final frontCtrl = TextEditingController();
    final backCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    String category = '古文';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF131B2E),
          title: const Row(
            children: [
              Icon(Icons.add_card, color: Color(0xFF38BDF8), size: 20),
              SizedBox(width: 8),
              Text('自作暗記カードを追加', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('科目・カテゴリ', style: TextStyle(fontSize: 11, color: Colors.white70)),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  dropdownColor: const Color(0xFF0F172A),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    filled: true,
                    fillColor: const Color(0xFF090D16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  items: ['古文', '漢文', '数学', '物理', '化学', '社会', '中学基本', '自作']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setDialogState(() => category = val ?? '古文'),
                ),
                const SizedBox(height: 12),
                const Text('表面（問題・単語・公式）', style: TextStyle(fontSize: 11, color: Colors.white70)),
                const SizedBox(height: 4),
                TextField(
                  controller: frontCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: '例: 係り結びの法則',
                    hintStyle: const TextStyle(color: Colors.white30, fontSize: 12),
                    filled: true,
                    fillColor: const Color(0xFF090D16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('裏面（意味・解答）', style: TextStyle(fontSize: 11, color: Colors.white70)),
                const SizedBox(height: 4),
                TextField(
                  controller: backCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: '例: ぞ・なむ・や・か→連体形、こそ→已然形',
                    hintStyle: const TextStyle(color: Colors.white30, fontSize: 12),
                    filled: true,
                    fillColor: const Color(0xFF090D16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('補足・例文（任意）', style: TextStyle(fontSize: 11, color: Colors.white70)),
                const SizedBox(height: 4),
                TextField(
                  controller: noteCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: '例: 強調・疑問反語・逆接',
                    hintStyle: const TextStyle(color: Colors.white30, fontSize: 12),
                    filled: true,
                    fillColor: const Color(0xFF090D16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('キャンセル', style: TextStyle(color: Colors.white60)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (frontCtrl.text.trim().isEmpty || backCtrl.text.trim().isEmpty) return;
                final newCard = FlashcardItem(
                  category: category,
                  front: frontCtrl.text.trim(),
                  back: backCtrl.text.trim(),
                  note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
                  isCustom: true,
                );
                final navigator = Navigator.of(ctx);
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                await StorageService().addCustomFlashcard(newCard.toMap());
                navigator.pop();
                _loadCustomCards();
                scaffoldMessenger.clearSnackBars();
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('自作カードを追加しました！'),
                    duration: Duration(milliseconds: 1200),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF38BDF8),
                foregroundColor: Colors.black,
              ),
              child: const Text('追加する', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingTarget) {
      return const Scaffold(
        backgroundColor: Color(0xFF090D16),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF38BDF8)),
        ),
      );
    }

    final cards = _filteredCards;
    final total = cards.length;
    if (_currentIndex >= total) _currentIndex = 0;
    final currentCard = cards.isNotEmpty ? cards[_currentIndex] : null;

    final categories = ['ターゲット1900', '古文', '漢文', '数学', '物理', '化学', '社会', '中学基本', '自作カード', 'すべて'];

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.style, color: Color(0xFF38BDF8), size: 20),
            const SizedBox(width: 8),
            Text(
              _selectedCategory == 'ターゲット1900' ? 'ターゲット1900 全単語' : '暗記カード',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        actions: [
          if (_selectedCategory == 'ターゲット1900') ...[
            IconButton(
              icon: Icon(
                _isFrequencyOrder ? Icons.format_list_numbered : Icons.shuffle,
                color: const Color(0xFF38BDF8),
                size: 20,
              ),
              tooltip: _isFrequencyOrder ? '出る順で表示中 (タップでシャッフル)' : 'シャッフル表示中 (タップで出る順)',
              onPressed: () {
                setState(() {
                  _isFrequencyOrder = !_isFrequencyOrder;
                  _currentIndex = 0;
                  _isFront = true;
                  _flipController.reset();
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white70, size: 20),
              tooltip: '単語番号ジャンプ',
              onPressed: () => _showJumpDialog(total),
            ),
          ],
          IconButton(
            icon: const Icon(Icons.add_card, color: Color(0xFF38BDF8), size: 20),
            tooltip: '自作カードを追加',
            onPressed: _showAddCardDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Category selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFF0F172A),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        cat == 'ターゲット1900'
                            ? '🎯 ターゲット1900 (${_targetCards.length})'
                            : cat == '自作カード'
                                ? '自作 (${_customCards.length})'
                                : cat,
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF38BDF8),
                      backgroundColor: const Color(0xFF1E293B),
                      labelStyle: TextStyle(
                        fontSize: 11,
                        color: isSelected ? Colors.black : Colors.white70,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (_) {
                        setState(() {
                          _selectedCategory = cat;
                          _currentIndex = 0;
                          _isFront = true;
                          _flipController.reset();
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Section selector for Target 1900
          if (_selectedCategory == 'ターゲット1900') ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: const BoxDecoration(
                color: Color(0xFF131B2E),
                border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildSectionChip(0, '全単語 (1〜1900)'),
                    const SizedBox(width: 6),
                    _buildSectionChip(1, 'Sec 1: 基本単語800 (1〜800)'),
                    const SizedBox(width: 6),
                    _buildSectionChip(2, 'Sec 2: 重要単語700 (801〜1500)'),
                    const SizedBox(width: 6),
                    _buildSectionChip(3, 'Sec 3: 難関単語400 (1501〜1900)'),
                  ],
                ),
              ),
            ),
            if (_targetSection > 0) _buildSubSectionSelector(),
          ],

          // Main Card View
          Expanded(
            child: cards.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.note_alt_outlined, size: 48, color: Colors.white24),
                        const SizedBox(height: 12),
                        const Text('該当する単語カードがありません', style: TextStyle(color: Colors.white54)),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('自作カードを作成する'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF38BDF8),
                            foregroundColor: Colors.black,
                          ),
                          onPressed: _showAddCardDialog,
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Card Header info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
                                  ),
                                  child: Text(
                                    currentCard!.targetId != null
                                        ? 'No. ${currentCard.targetId} (出る順)'
                                        : currentCard.category,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8)),
                                  ),
                                ),
                                if (currentCard.partOfSpeech != null) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF818CF8).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      currentCard.partOfSpeech!,
                                      style: const TextStyle(fontSize: 10, color: Color(0xFFA5B4FC), fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            Text(
                              '${_currentIndex + 1} / $total',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white70),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Animated Flip Card
                        Expanded(
                          child: GestureDetector(
                            onTap: _flipCard,
                            child: AnimatedBuilder(
                              animation: _flipAnimation,
                              builder: (context, child) {
                                final angle = _flipAnimation.value * pi;
                                final isUnder = angle > pi / 2;

                                return Transform(
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.001)
                                    ..rotateY(angle),
                                  alignment: Alignment.center,
                                  child: isUnder
                                      ? Transform(
                                          transform: Matrix4.identity()..rotateY(pi),
                                          alignment: Alignment.center,
                                          child: _buildCardBack(currentCard),
                                        )
                                      : _buildCardFront(currentCard),
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Quick Navigation Slider
                        if (total > 1)
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: const Color(0xFF38BDF8),
                              inactiveTrackColor: const Color(0xFF1E293B),
                              thumbColor: const Color(0xFF38BDF8),
                              trackHeight: 3,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                            ),
                            child: Slider(
                              value: _currentIndex.toDouble(),
                              min: 0,
                              max: (total - 1).toDouble(),
                              onChanged: (val) {
                                setState(() {
                                  _currentIndex = val.round();
                                  _isFront = true;
                                  _flipController.reset();
                                });
                              },
                            ),
                          ),

                        const SizedBox(height: 8),

                        // Action Controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton.filledTonal(
                              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFF1E293B),
                                foregroundColor: Colors.white70,
                                padding: const EdgeInsets.all(14),
                              ),
                              onPressed: () {
                                setState(() {
                                  _currentIndex = (_currentIndex - 1 + total) % total;
                                  _isFront = true;
                                  _flipController.reset();
                                });
                              },
                            ),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.flip, size: 18),
                              label: const Text('裏返す', style: TextStyle(fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF38BDF8),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              onPressed: _flipCard,
                            ),
                            IconButton.filledTonal(
                              icon: const Icon(Icons.check_circle_outline, size: 20, color: Color(0xFF10B981)),
                              tooltip: '覚えた！(+5 コイン)',
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFF064E3B).withValues(alpha: 0.5),
                                foregroundColor: const Color(0xFF34D399),
                                padding: const EdgeInsets.all(14),
                              ),
                              onPressed: () async {
                                await StorageService().recordAttempt(true, 5);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('🎉 覚えた！ +5 コイン獲得！'),
                                      duration: Duration(milliseconds: 900),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Color(0xFF10B981),
                                    ),
                                  );
                                  setState(() {
                                    _currentIndex = (_currentIndex + 1) % total;
                                    _isFront = true;
                                    _flipController.reset();
                                  });
                                }
                              },
                            ),
                            IconButton.filledTonal(
                              icon: const Icon(Icons.arrow_forward_ios, size: 18),
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFF1E293B),
                                foregroundColor: Colors.white70,
                                padding: const EdgeInsets.all(14),
                              ),
                              onPressed: () {
                                setState(() {
                                  _currentIndex = (_currentIndex + 1) % total;
                                  _isFront = true;
                                  _flipController.reset();
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionChip(int section, String label) {
    final isSelected = _targetSection == section;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: const Color(0xFF38BDF8),
      backgroundColor: const Color(0xFF0F172A),
      labelStyle: TextStyle(
        fontSize: 10,
        color: isSelected ? Colors.black : Colors.white70,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (_) {
        setState(() {
          _targetSection = section;
          _targetSubSection = 'すべて';
          _currentIndex = 0;
          _isFront = true;
          _flipController.reset();
        });
      },
    );
  }

  Widget _buildSubSectionSelector() {
    final subSections = ['すべて'];
    if (_targetSection == 1) {
      subSections.addAll(['1-100', '101-200', '201-300', '301-400', '401-500', '501-600', '601-700', '701-800']);
    } else if (_targetSection == 2) {
      subSections.addAll(['801-900', '901-1000', '1001-1100', '1101-1200', '1201-1300', '1301-1400', '1401-1500']);
    } else if (_targetSection == 3) {
      subSections.addAll(['1501-1600', '1601-1700', '1701-1800', '1801-1900']);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: const Color(0xFF0B1120),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: subSections.map((sub) {
            final isSel = _targetSubSection == sub;
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChoiceChip(
                label: Text(sub),
                selected: isSel,
                selectedColor: const Color(0xFF818CF8),
                backgroundColor: const Color(0xFF1E293B),
                labelStyle: TextStyle(
                  fontSize: 9,
                  color: isSel ? Colors.black : Colors.white70,
                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (_) {
                  setState(() {
                    _targetSubSection = sub;
                    _currentIndex = 0;
                    _isFront = true;
                    _flipController.reset();
                  });
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCardFront(FlashcardItem card) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (card.targetSectionName != null) ...[
            Text(
              card.targetSectionName!,
              style: const TextStyle(fontSize: 11, color: Color(0xFF38BDF8), fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
          ],
          const Icon(Icons.touch_app_outlined, color: Colors.white30, size: 24),
          const SizedBox(height: 16),
          Text(
            card.front,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text('タップして日本語訳を表示', style: TextStyle(fontSize: 11, color: Colors.white38)),
        ],
      ),
    );
  }

  Widget _buildCardBack(FlashcardItem card) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF064E3B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, color: Color(0xFF34D399), size: 24),
          const SizedBox(height: 12),
          Text(
            card.front,
            style: const TextStyle(fontSize: 14, color: Colors.white60, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            card.back,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6EE7B7),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          if (card.note != null && card.note!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white10),
              ),
              child: Text(
                '例: ${card.note!}',
                style: const TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
