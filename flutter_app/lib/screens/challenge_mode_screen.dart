import 'dart:async';
import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ChallengeQuestion {
  final String title;
  final String question;
  final List<String> choices;
  final int correctIndex;
  final String explanation;

  const ChallengeQuestion({
    required this.title,
    required this.question,
    required this.choices,
    required this.correctIndex,
    required this.explanation,
  });
}

class ChallengePreset {
  final String id;
  final String title;
  final String subtitle;
  final String badge;
  final IconData icon;
  final Color color;
  final List<ChallengeQuestion> questions;

  const ChallengePreset({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.icon,
    required this.color,
    required this.questions,
  });
}

class ChallengeModeScreen extends StatefulWidget {
  final String? initialPresetId;

  const ChallengeModeScreen({super.key, this.initialPresetId});

  @override
  State<ChallengeModeScreen> createState() => _ChallengeModeScreenState();
}

class _ChallengeModeScreenState extends State<ChallengeModeScreen> {
  ChallengePreset? _activePreset;
  int _currentIndex = 0;
  int _score = 0;
  int _combo = 0;
  int _maxCombo = 0;
  int _timeLeft = 60;
  Timer? _timer;
  bool _isGameOver = false;
  int? _selectedChoice;
  bool _showingFeedback = false;
  int _coinsEarned = 0;

  static final List<ChallengePreset> presets = [
    // 1. 高校数学: 微積しまくるモード (Calculus Rush)
    ChallengePreset(
      id: 'calculus_rush',
      title: '微積千本ノック (Calculus Rush)',
      subtitle: '微分・積分・接線・極値をとにかく解きまくる！',
      badge: '高校数学・極限特訓',
      icon: Icons.show_chart,
      color: const Color(0xFF38BDF8),
      questions: [
        ChallengeQuestion(
          title: '微分法: 多項式の導関数',
          question: 'f(x) = 3x⁴ - 5x² + 2x - 7 の導関数 f\'(x) は？',
          choices: ['12x³ - 10x + 2', '12x³ - 5x + 2', '4x³ - 10x', '12x⁴ - 10x² + 2'],
          correctIndex: 0,
          explanation: '(xⁿ)\' = n xⁿ⁻¹ より、(3x⁴)\' = 12x³, (-5x²)\' = -10x, (2x)\' = 2, (-7)\' = 0 です。',
        ),
        ChallengeQuestion(
          title: '積分法: 不定積分',
          question: '∫ (6x² - 4x + 3) dx は？ (Cは積分定数)',
          choices: ['2x³ - 2x² + 3x + C', '3x³ - 2x² + 3x + C', '2x³ - 4x² + 3x + C', '6x³ - 2x² + C'],
          correctIndex: 0,
          explanation: '∫ xⁿ dx = 1/(n+1) xⁿ⁺¹ より、6/3 x³ - 4/2 x² + 3x + C = 2x³ - 2x² + 3x + C です。',
        ),
        ChallengeQuestion(
          title: '接線の傾き',
          question: '曲線 y = x³ - 3x 上の点 (2, 2) における接線の傾き m は？',
          choices: ['9', '6', '3', '12'],
          correctIndex: 0,
          explanation: 'y\' = 3x² - 3。x = 2 を代入すると、m = 3(4) - 3 = 12 - 3 = 9 です。',
        ),
        ChallengeQuestion(
          title: '関数の極値',
          question: 'f(x) = x³ - 3x² の極小値は？',
          choices: ['-4 (x=2)', '0 (x=0)', '-2 (x=1)', '4 (x=-2)'],
          correctIndex: 0,
          explanation: 'f\'(x) = 3x² - 6x = 3x(x - 2) = 0 より x = 0, 2。増減表より x = 2 で極小値 f(2) = 8 - 12 = -4 です。',
        ),
        ChallengeQuestion(
          title: '1/6公式 (放物線と直線)',
          question: '放物線 y = x² と直線 y = 4 で囲まれた部分の面積 S は？',
          choices: ['32/3', '16/3', '8', '64/3'],
          correctIndex: 0,
          explanation: '交点 x = ±2。1/6公式 S = |a|/6 (β - α)³ = 1/6 (2 - (-2))³ = 64/6 = 32/3 です。',
        ),
        ChallengeQuestion(
          title: '定積分: 基本計算',
          question: '∫₀³ (2x - 1) dx の値は？',
          choices: ['6', '9', '3', '12'],
          correctIndex: 0,
          explanation: '[x² - x]₀³ = (9 - 3) - 0 = 6 です。',
        ),
        ChallengeQuestion(
          title: '合成関数の微分',
          question: 'y = (2x + 1)⁵ の導関数 y\' は？',
          choices: ['10(2x + 1)⁴', '5(2x + 1)⁴', '2(2x + 1)⁴', '10(2x + 1)⁵'],
          correctIndex: 0,
          explanation: 'チェーンルール: 5(2x + 1)⁴ × (2x + 1)\' = 5(2x + 1)⁴ × 2 = 10(2x + 1)⁴ です。',
        ),
        ChallengeQuestion(
          title: '積の微分法',
          question: 'f(x) = x・eˣ の導関数 f\'(x) は？',
          choices: ['(x + 1)eˣ', 'x・eˣ', 'eˣ', '(x - 1)eˣ'],
          correctIndex: 0,
          explanation: '(uv)\' = u\'v + uv\' より、(x)\'eˣ + x(eˣ)\' = 1・eˣ + x・eˣ = (x + 1)eˣ です。',
        ),
        ChallengeQuestion(
          title: '三角関数の微分',
          question: 'y = sin(3x) の導関数 y\' は？',
          choices: ['3 cos(3x)', '-3 cos(3x)', 'cos(3x)', '3 sin(3x)'],
          correctIndex: 0,
          explanation: '(sin u)\' = (cos u)・u\' より、cos(3x)・(3x)\' = 3 cos(3x) です。',
        ),
        ChallengeQuestion(
          title: '定積分: 三角関数',
          question: '∫₀^(π/2) cos(x) dx の値は？',
          choices: ['1', '0', 'π/2', '-1'],
          correctIndex: 0,
          explanation: '[sin x]₀^(π/2) = sin(π/2) - sin(0) = 1 - 0 = 1 です。',
        ),
        ChallengeQuestion(
          title: '変曲点',
          question: 'y = x³ - 3x² + 4 の変曲点の x 座標は？',
          choices: ['x = 1', 'x = 0', 'x = 2', 'x = 3'],
          correctIndex: 0,
          explanation: 'y\' = 3x² - 6x, y\'\' = 6x - 6 = 0 より x = 1 で上に凸から下に凸に変わります。',
        ),
        ChallengeQuestion(
          title: '1/12公式 (3次関数と接線)',
          question: '3次関数と接線が囲む面積を求める公式の係数は？',
          choices: ['|a|/12 (β - α)⁴', '|a|/6 (β - α)³', '|a|/30 (β - α)⁵', '|a|/3 (β - α)³'],
          correctIndex: 0,
          explanation: '3次関数と接線で囲まれる面積は S = |a|/12 (β - α)⁴ で瞬時に求まります。',
        ),
      ],
    ),

    // 2. 超速・因数分解タイムアタック (Factorization Sprint)
    ChallengePreset(
      id: 'factorization_sprint',
      title: '超速・因数分解タイムアタック',
      subtitle: 'たすき掛け・複2次式・3次方程式を0.1秒で看破せよ！',
      badge: '高校数学・計算瞬殺',
      icon: Icons.flash_on,
      color: const Color(0xFFF59E0B),
      questions: [
        ChallengeQuestion(
          title: '因数分解: たすき掛け',
          question: '2x² + 5x + 3 を因数分解せよ。',
          choices: ['(2x + 3)(x + 1)', '(2x + 1)(x + 3)', '(2x - 3)(x - 1)', '(x + 3)(x + 2)'],
          correctIndex: 0,
          explanation: '2×1=2, 3×1=3, 2×1 + 3×1 = 5 より (2x + 3)(x + 1) です。',
        ),
        ChallengeQuestion(
          title: '因数分解: 平方の差',
          question: '4x² - 9y² を因数分解せよ。',
          choices: ['(2x - 3y)(2x + 3y)', '(2x - 9y)(2x + y)', '(4x - 3y)(x + 3y)', '(2x - 3y)²'],
          correctIndex: 0,
          explanation: 'a² - b² = (a - b)(a + b) より (2x - 3y)(2x + 3y) です。',
        ),
        ChallengeQuestion(
          title: '因数分解: 3次式の展開公式逆',
          question: 'x³ - 8 を因数分解せよ。',
          choices: ['(x - 2)(x² + 2x + 4)', '(x - 2)(x² - 2x + 4)', '(x + 2)(x² - 2x + 4)', '(x - 2)³'],
          correctIndex: 0,
          explanation: 'a³ - b³ = (a - b)(a² + ab + b²) より (x - 2)(x² + 2x + 4) です。',
        ),
        ChallengeQuestion(
          title: '因数分解: 複2次式',
          question: 'x⁴ - 13x² + 36 を因数分解せよ。',
          choices: ['(x - 2)(x + 2)(x - 3)(x + 3)', '(x² - 4)(x² - 6)', '(x - 6)(x + 6)(x - 1)(x + 1)', '(x² - 9)²'],
          correctIndex: 0,
          explanation: 'X = x² とおくと X² - 13X + 36 = (X - 4)(X - 9) = (x² - 4)(x² - 9) = (x-2)(x+2)(x-3)(x+3) です。',
        ),
        ChallengeQuestion(
          title: '因数分解: 平方完成利用',
          question: 'x⁴ + 4 を因数分解せよ。',
          choices: ['(x² + 2x + 2)(x² - 2x + 2)', '(x² + 2)²', '(x² - 2)²', '(x + 2)²(x - 2)²'],
          correctIndex: 0,
          explanation: 'x⁴ + 4 = (x² + 2)² - (2x)² = (x² + 2x + 2)(x² - 2x + 2) です。',
        ),
      ],
    ),

    // 3. 無機化学 気体＆沈殿瞬殺モード (Precipitate & Gas Flash)
    ChallengePreset(
      id: 'chemistry_flash',
      title: '無機化学 気体＆沈殿瞬殺モード',
      subtitle: 'イオン反応・沈殿色・気体発生の瞬殺判定！',
      badge: '化学・無機特訓',
      icon: Icons.science,
      color: const Color(0xFFEC4899),
      questions: [
        ChallengeQuestion(
          title: '金属イオンの沈殿色',
          question: 'Cu²⁺ 水溶液に少量の NaOH 水溶液を加えたときの沈殿の色は？',
          choices: ['青白色沈殿 (Cu(OH)₂)', '白色沈殿', '褐色沈殿', '黒色沈殿'],
          correctIndex: 0,
          explanation: 'Cu²⁺ + 2OH⁻ → Cu(OH)₂↓（青白色沈殿）。さらに過剰のアンモニア水で深青色溶液（テトラアンミン銅(II)錯イオン）となります。',
        ),
        ChallengeQuestion(
          title: 'ハロゲン化銀の沈殿色',
          question: 'Ag⁺ 水溶液に Cl⁻ を加えたときの沈殿の色は？',
          choices: ['白色沈殿 (AgCl)', '淡黄色沈殿 (AgBr)', '黄色沈殿 (AgI)', '黒色沈殿 (Ag₂S)'],
          correctIndex: 0,
          explanation: 'AgClは白色、AgBrは淡黄色、AgIは黄色沈殿です。AgClはアンモニア水に溶けます。',
        ),
        ChallengeQuestion(
          title: '鉄イオンの呈色反応',
          question: 'Fe³⁺ 水溶液に KSCN（チオシアン酸カリウム）水溶液を加えると何色になる？',
          choices: ['血赤色溶液', '濃青色沈殿', '褐色沈殿', '淡緑色溶液'],
          correctIndex: 0,
          explanation: 'Fe³⁺ に SCN⁻ を加えると血赤色の錯イオンを生じます（極めて鋭敏な検出反応）。',
        ),
        ChallengeQuestion(
          title: '硫化物の沈殿色',
          question: '酸性溶液中で H₂S を通じたとき、黒色沈殿を生じるイオンは？',
          choices: ['Cu²⁺ (CuS: 黒色)', 'Zn²⁺ (ZnS: 白色)', 'Fe²⁺ (FeS: 中・塩基性のみ)', 'Al³⁺ (沈殿せず)'],
          correctIndex: 0,
          explanation: 'イオン化傾向の小さい Cu²⁺, Pb²⁺, Ag⁺ などは酸性でも H₂S で沈殿します。ZnSは白色、FeSは中・塩基性でのみ沈殿します。',
        ),
        ChallengeQuestion(
          title: '気体の捕集法',
          question: 'アンモニア (NH₃) の捕集法として適切なものは？',
          choices: ['上方置換法', '水上置換法', '下方置換法', '昇華法'],
          correctIndex: 0,
          explanation: 'NH₃ は空気より軽く（分子量17 < 空気平均28.8）、極めて水に溶けやすいため上方置換法で捕集します。',
        ),
      ],
    ),

    // 4. 古文助動詞識別スラッシュ (Classical Japanese Auxiliary Slash)
    ChallengePreset(
      id: 'kobun_slash',
      title: '古文助動詞識別スラッシュ',
      subtitle: '「る・らる」「む」「なり」の意味・活用形を瞬殺看破！',
      badge: '国語・古文瞬殺',
      icon: Icons.history_edu,
      color: const Color(0xFFA855F7),
      questions: [
        ChallengeQuestion(
          title: '「る・らる」の識別',
          question: '主語が自発動詞（思ふ・泣く・偲ぶなど）を伴う場合の「る・らる」の意味は？',
          choices: ['自発（自然と〜される）', '受身（〜される）', '可能（〜できる）', '尊敬（お〜になる）'],
          correctIndex: 0,
          explanation: '心情動詞（思ふ、忍ぶ、思ひ出づ）に付く「る・らる」は原則として「自発」です。',
        ),
        ChallengeQuestion(
          title: '助動詞「む」の意味',
          question: '一人称主語で「〜む」とある場合、最も典型的な意味は？',
          choices: ['意志（〜しよう、〜するつもりだ）', '推量（〜だろう）', '勧誘（〜しよう）', '適当（〜がよい）'],
          correctIndex: 0,
          explanation: '「む」は主語によって判定：1人称＝意志、2人称＝勧誘・適当、3人称＝推量となります。',
        ),
        ChallengeQuestion(
          title: '「なり」の識別',
          question: '終止形（ラ変型なら連体形）に接続する「なり」の意味は？',
          choices: ['伝聞・推定（〜と聞く、〜のようだ）', '断定（〜である）', '存在（〜にある）', '比喩（〜のようだ）'],
          correctIndex: 0,
          explanation: '体言・連体形接続＝断定・存在。終止形（ラ変型連体形）接続＝伝聞・推定（音・声の推定）です。',
        ),
        ChallengeQuestion(
          title: '係り結びの法則',
          question: '「こそ」の係り結びで文末に来る活用形は？',
          choices: ['已然形', '連体形', '終止形', '命令形'],
          correctIndex: 0,
          explanation: 'ぞ・なむ・や・か → 連体形。こそ → 已然形（強意・逆接）です。',
        ),
      ],
    ),

    // 5. 情報I 2進数・論理回路瞬殺アタック (Informatics I Bit Sprint)
    ChallengePreset(
      id: 'informatics_sprint',
      title: '情報I 2進数・論理回路瞬殺アタック',
      subtitle: '10進↔2進/16進変換・AND/OR/XORゲートを秒速処理！',
      badge: '情報I・基数論理特訓',
      icon: Icons.terminal,
      color: const Color(0xFF06B6D4),
      questions: [
        ChallengeQuestion(
          title: '基数変換: 2進数から10進数',
          question: '2進数 1101₍₂₎ を10進数に変換すると？',
          choices: ['13', '11', '15', '9'],
          correctIndex: 0,
          explanation: '1×8 + 1×4 + 0×2 + 1×1 = 8 + 4 + 1 = 13 です。',
        ),
        ChallengeQuestion(
          title: '基数変換: 10進数から16進数',
          question: '10進数 255 を16進数で表すと？',
          choices: ['FF', 'FE', '100', 'EF'],
          correctIndex: 0,
          explanation: '255 = 15×16 + 15 = FF₍₁₆₎ です。8ビットで表せる最大値です。',
        ),
        ChallengeQuestion(
          title: '論理演算: XOR (排他的論理和)',
          question: '入力 A = 1, B = 1 のとき、A XOR B の出力は？',
          choices: ['0', '1', '不定', '11'],
          correctIndex: 0,
          explanation: 'XORは「両者が異なるときに1、一致するときに0」を出力するため、1 XOR 1 = 0 です。',
        ),
        ChallengeQuestion(
          title: 'データ量計算: 画像のサイズ',
          question: '横1000 × 縦1000ピクセル、RGB各8ビット（24ビットフルカラー）非圧縮画像の容量は？',
          choices: ['約 3 MB (3,000,000 Byte)', '約 1 MB', '約 24 MB', '約 300 KB'],
          correctIndex: 0,
          explanation: '1000 × 1000 × 3 Byte = 3,000,000 Byte ≈ 3 MB です。',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialPresetId != null) {
      final found = presets.firstWhere(
        (p) => p.id == widget.initialPresetId,
        orElse: () => presets.first,
      );
      _startChallenge(found);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startChallenge(ChallengePreset preset) {
    _timer?.cancel();
    setState(() {
      _activePreset = preset;
      _currentIndex = 0;
      _score = 0;
      _combo = 0;
      _maxCombo = 0;
      _timeLeft = 60;
      _isGameOver = false;
      _selectedChoice = null;
      _showingFeedback = false;
      _coinsEarned = 0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_timeLeft <= 1) {
        timer.cancel();
        _endChallenge();
      } else {
        setState(() {
          _timeLeft--;
        });
      }
    });
  }

  void _endChallenge() async {
    _timer?.cancel();
    final bonusCoins = (_score / 50).round() + (_maxCombo * 5);
    await StorageService().recordAttempt(true, _score * 2, bonusCoins: bonusCoins);
    if (mounted) {
      setState(() {
        _isGameOver = true;
        _coinsEarned = bonusCoins;
      });
    }
  }

  void _handleChoice(int choiceIndex) {
    if (_showingFeedback || _isGameOver || _activePreset == null) return;

    final q = _activePreset!.questions[_currentIndex % _activePreset!.questions.length];
    final isCorrect = choiceIndex == q.correctIndex;

    setState(() {
      _selectedChoice = choiceIndex;
      _showingFeedback = true;
      if (isCorrect) {
        _combo++;
        if (_combo > _maxCombo) _maxCombo = _combo;
        final comboMultiplier = 1 + (_combo * 0.2);
        _score += (100 * comboMultiplier).round();
      } else {
        _combo = 0;
      }
    });

    Future.delayed(const Duration(milliseconds: 650), () {
      if (!mounted) return;
      if (_isGameOver) return;
      setState(() {
        _showingFeedback = false;
        _selectedChoice = null;
        _currentIndex++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_activePreset == null) {
      return _buildPresetLobby();
    }
    if (_isGameOver) {
      return _buildGameOverScreen();
    }
    return _buildActiveGameScreen();
  }

  Widget _buildPresetLobby() {
    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.bolt, color: Color(0xFFFBBF24), size: 22),
            SizedBox(width: 8),
            Text('特訓チャレンジモード', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF818CF8).withValues(alpha: 0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.speed, color: Color(0xFF38BDF8), size: 24),
                      SizedBox(width: 8),
                      Text(
                        '制限時間60秒の瞬殺スプリント',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '高校微積分・因数分解・無機化学・古文助動詞などを反射速度で解答！連勝コンボで大量XP＆コインを獲得しよう。',
                    style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'チャレンジを選択',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),

            ...presets.map((preset) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => _startChallenge(preset),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF131B2E),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: preset.color.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: preset.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(preset.icon, color: preset.color, size: 26),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: preset.color.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        preset.badge,
                                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: preset.color),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  preset.title,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  preset.subtitle,
                                  style: const TextStyle(fontSize: 11, color: Colors.white60),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.play_circle_fill, color: Color(0xFF38BDF8), size: 28),
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveGameScreen() {
    final preset = _activePreset!;
    final q = preset.questions[_currentIndex % preset.questions.length];

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: Text(preset.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white70),
          onPressed: () {
            _timer?.cancel();
            setState(() => _activePreset = null);
          },
        ),
        actions: [
          // Timer badge
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _timeLeft <= 10 ? const Color(0xFFEF4444).withValues(alpha: 0.25) : const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _timeLeft <= 10 ? const Color(0xFFEF4444) : Colors.white24),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.timer,
                  size: 15,
                  color: _timeLeft <= 10 ? const Color(0xFFEF4444) : const Color(0xFF38BDF8),
                ),
                const SizedBox(width: 4),
                Text(
                  '$_timeLeft s',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _timeLeft <= 10 ? const Color(0xFFEF4444) : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Score & Combo Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('SCORE', style: TextStyle(fontSize: 10, color: Colors.white54, fontWeight: FontWeight.bold)),
                      Text(
                        '$_score',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8)),
                      ),
                    ],
                  ),
                  if (_combo > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFEF4444)]),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Text(
                        '🔥 $_combo COMBO!',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  Text(
                    '問 ${_currentIndex + 1}',
                    style: const TextStyle(fontSize: 13, color: Colors.white60),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Question Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131B2E),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: preset.color.withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: preset.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          q.title,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: preset.color),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        q.question,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                      if (_showingFeedback) ...[
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedChoice == q.correctIndex ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                            ),
                          ),
                          child: Text(
                            q.explanation,
                            style: const TextStyle(fontSize: 11, color: Colors.white70, height: 1.4),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 4 Choice Buttons
              ...List.generate(q.choices.length, (idx) {
                final isSelected = _selectedChoice == idx;
                final isCorrect = idx == q.correctIndex;

                Color btnBg = const Color(0xFF1E293B);
                Color borderCol = Colors.transparent;

                if (_showingFeedback) {
                  if (isCorrect) {
                    btnBg = const Color(0xFF064E3B);
                    borderCol = const Color(0xFF10B981);
                  } else if (isSelected) {
                    btnBg = const Color(0xFF4C0519);
                    borderCol = const Color(0xFFEF4444);
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => _handleChoice(idx),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: btnBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderCol),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '${idx + 1}',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white70),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              q.choices[idx],
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          if (_showingFeedback && isCorrect)
                            const Icon(Icons.check_circle, color: Color(0xFF34D399), size: 18),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFBBF24).withValues(alpha: 0.15),
                  border: Border.all(color: const Color(0xFFFBBF24), width: 2),
                ),
                child: const Icon(Icons.emoji_events, color: Color(0xFFFBBF24), size: 44),
              ),
              const SizedBox(height: 20),
              const Text(
                'TIME UP! 特訓完了',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                '${_activePreset?.title}',
                style: const TextStyle(fontSize: 14, color: Color(0xFF38BDF8), fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF131B2E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('最終スコア:', style: TextStyle(color: Colors.white70)),
                        Text('$_score 点', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                    const Divider(color: Colors.white10, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('最大コンボ:', style: TextStyle(color: Colors.white70)),
                        Text('$_maxCombo 連勝', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B))),
                      ],
                    ),
                    const Divider(color: Colors.white10, height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('獲得コイン＆XP:', style: TextStyle(color: Colors.white70)),
                        Text('+${_score * 2} XP / +$_coinsEarned G', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF34D399))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _activePreset = null),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        side: const BorderSide(color: Colors.white24),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('メニューに戻る'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _startChallenge(_activePreset!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF38BDF8),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('もう一度挑戦', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
