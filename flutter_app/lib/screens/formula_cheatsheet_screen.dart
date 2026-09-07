import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormulaItem {
  final String subject;
  final String title;
  final String formula;
  final String conditions;
  final String usagePoint;
  bool isPinned;

  FormulaItem({
    required this.subject,
    required this.title,
    required this.formula,
    required this.conditions,
    required this.usagePoint,
    this.isPinned = false,
  });
}

class FormulaCheatSheetScreen extends StatefulWidget {
  const FormulaCheatSheetScreen({super.key});

  @override
  State<FormulaCheatSheetScreen> createState() => _FormulaCheatSheetScreenState();
}

class _FormulaCheatSheetScreenState extends State<FormulaCheatSheetScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  final List<FormulaItem> _allFormulas = [
    // 数学
    FormulaItem(
      subject: '数学',
      title: '解の公式 (2次方程式)',
      formula: 'x = (-b ± √(b² - 4ac)) / (2a)\nb = 2b\'のとき: x = (-b\' ± √(b\'² - ac)) / a',
      conditions: 'ax² + bx + c = 0 (a ≠ 0)',
      usagePoint: '判別式 D = b² - 4ac > 0 で異なる2実数解、= 0 で重解、< 0 で異なる2虚数解。',
    ),
    FormulaItem(
      subject: '数学',
      title: '三角関数の加法定理',
      formula: 'sin(α ± β) = sinα cosβ ± cosα sinβ\ncos(α ± β) = cosα cosβ ∓ sinα sinβ\ntan(α ± β) = (tanα ± tanβ) / (1 ∓ tanα tanβ)',
      conditions: 'すべての実数角 α, β',
      usagePoint: '2倍角・半角・3倍角の公式、三角関数の合成 a sinθ + b cosθ = √(a²+b²) sin(θ+α) の母体。',
    ),
    FormulaItem(
      subject: '数学',
      title: '積分の1/6公式 (放物線と直線で囲まれた面積)',
      formula: 'S = ∫[α to β] -a(x - α)(x - β) dx = (|a| / 6)(β - α)³',
      conditions: 'y = ax² + bx + c と直線が x = α, β で交わるとき',
      usagePoint: '定積分の展開・代入計算を大幅に短縮する共通テスト・2次試験最重要テクニック。',
    ),
    FormulaItem(
      subject: '数学',
      title: '相加平均・相乗平均の大小関係',
      formula: '(a + b) / 2 ≥ √(ab)  (等号成立: a = b)',
      conditions: 'a > 0 かつ b > 0',
      usagePoint: '「逆数和 a + 1/a の最小値」など、変数の積が定数になる関数の最大・最小問題で即座に使用。',
    ),
    FormulaItem(
      subject: '数学',
      title: '点と直線の距離の公式',
      formula: 'd = |ax₀ + by₀ + c| / √(a² + b²)',
      conditions: '直線 ax + by + c = 0 と 点 (x₀, y₀)',
      usagePoint: '円と直線の位置関係 (d < r で2点交差、d = r で接する、d > r で離れる) で頻出。',
    ),

    // 物理
    FormulaItem(
      subject: '物理',
      title: '等加速度直線運動の3公式',
      formula: '1) v = v₀ + at\n2) x = v₀t + (1/2)at²\n3) v² - v₀² = 2ax',
      conditions: '加速度 a が一定の直線運動',
      usagePoint: '時間を消去したいときは第3式を利用。鉛直投げ上げ・自由落下でも a = -g を代入して同一適用。',
    ),
    FormulaItem(
      subject: '物理',
      title: 'ニュートンの運動方程式',
      formula: 'ma = F  (合力 F = ΣFᵢ)',
      conditions: '質量 m (kg), 加速度 a (m/s²), 力 F (N)',
      usagePoint: '物体ごとに孤立図を描き、着目する軸方向（斜面平行・垂直等）の力を正負をつけて正しく立式。',
    ),
    FormulaItem(
      subject: '物理',
      title: '力学的エネルギー保存の法則',
      formula: '(1/2)mv₁² + mgh₁ + (1/2)kx₁² = (1/2)mv₂² + mgh₂ + (1/2)kx₂²',
      conditions: '保存力（重力・弾性力・静電気力）のみが仕事をする場合',
      usagePoint: '摩擦や空気抵抗 W_other があるときは E₂ - E₁ = W_other でエネルギー変化を立式。',
    ),
    FormulaItem(
      subject: '物理',
      title: 'ドップラー効果の公式',
      formula: 'f\' = f₀ × (V - v_o) / (V - v_s)',
      conditions: '音速 V, 観測者速度 v_o, 音源速度 v_s (音の伝播方向を正)',
      usagePoint: '音源が近づくとき分母小→高音。風があるときは音速が V ± w に変化。',
    ),
    FormulaItem(
      subject: '物理',
      title: 'スネルの屈折の法則',
      formula: 'n₁ sinθ₁ = n₂ sinθ₂  (n₁₂ = n₂/n₁ = v₁/v₂ = λ₁/λ₂)',
      conditions: '媒質1 (屈折率 n₁) から 媒質2 (n₂) への波の入射',
      usagePoint: '全反射の臨界角 θ_c: sinθ_c = n₂ / n₁ (n₁ > n₂ の密から疎へ進むときのみ発生)。',
    ),

    // 化学
    FormulaItem(
      subject: '化学',
      title: '理想気体の状態方程式',
      formula: 'PV = nRT = (w / M)RT\nP: Pa, V: m³, n: mol, R: 8.31 J/(mol・K)',
      conditions: '気体分子間力と分子自身の体積を無視できる理想気体',
      usagePoint: '分子量 M の決定: M = wRT / (PV) = ρRT / P (密度 ρ = w/V)。実在気体は高温・低圧で理想気体に近づく。',
    ),
    FormulaItem(
      subject: '化学',
      title: '酸・塩基の電離平衡とpH',
      formula: 'pH = -log₁₀[H⁺]\n弱酸 (電離度 α ≪ 1): [H⁺] = cα = √(cKa)\n弱塩基: [OH⁻] = √(cKb)',
      conditions: '希薄水溶液 (25℃, 水のイオン積 Kw = [H⁺][OH⁻] = 1.0 × 10⁻¹⁴)',
      usagePoint: '緩衝液のpH (ヘンダーソン・ハッセルバルフ): pH = pKa + log([A⁻]/[HA])。',
    ),
    FormulaItem(
      subject: '化学',
      title: 'ヘスの法則 (総熱量保存の法則)',
      formula: 'Q (反応熱) = Σ(生成物の生成熱) - Σ(反応物の生成熱)\n= Σ(反応物の結合エネルギー) - Σ(生成物の結合エネルギー)',
      conditions: '化学反応の始状態と終状態が決まっている熱化学方程式',
      usagePoint: '燃焼熱・生成熱・結合エネルギーの符号と代入順序を間違えないようエネルギー図を描いて確認。',
    ),

    // 古文
    FormulaItem(
      subject: '古文',
      title: '助動詞の接続早見公式',
      formula: '・未然形接続: る・らる・す・さす・しむ・む・むず・じ・ず・まし・まほし\n・連用形接続: き・けり・つ・ぬ・たり・けむ・たし\n・終止形接続: らむ・らし・めり・べし・まじ・なり',
      conditions: '直前の用言・助動詞の活用形',
      usagePoint: '「なり」の識別: 終止形接続＝伝聞・推定、体言・連体形接続＝断定・存在。',
    ),
    FormulaItem(
      subject: '古文',
      title: '係り結びの法則',
      formula: '・「ぞ・なむ・や・か」→ 文末が【連体形】\n・「こそ」→ 文末が【已然形】(逆接接続「〜已然形＋ど・ば」に展開)',
      conditions: '係助詞が文中に入ったとき',
      usagePoint: '結びの省略（〜ぞ。で文が終わる場合）は直下の動詞（あり・侍り等）が省略されている。',
    ),

    // 英語
    FormulaItem(
      subject: '英語',
      title: '5文型の構造公式',
      formula: '第1文型: S + V (完全自動詞)\n第2文型: S + V + C (S = C)\n第3文型: S + V + O (S ≠ O)\n第4文型: S + V + O₁ + O₂ (O₁にO₂を)\n第5文型: S + V + O + C (O = C / OがCする)',
      conditions: '英文の基本骨格',
      usagePoint: '第4文型から第3文型への書換: to型 (give, tell, show) ⇄ for型 (buy, make, find)。',
    ),
    FormulaItem(
      subject: '英語',
      title: '仮定法の基本公式',
      formula: '仮定法過去 (現在の事実に反する):\nIf + S + 過去形, S + would/could/might + 原形\n仮定法過去完了 (過去の事実に反する):\nIf + S + had + 過去分詞, S + would/could/might + have + 過去分詞',
      conditions: '現実と異なる反実仮想',
      usagePoint: '倒置によるIfの省略: Had I known, Were I to, Should you need。',
    ),

    // 情報
    FormulaItem(
      subject: '情報',
      title: '2進数・16進数・10進数換算公式',
      formula: '2進数: 各桁の重みが 2³, 2², 2¹, 2⁰ (8, 4, 2, 1)\n16進数: 0〜9, A(10), B(11), C(12), D(13), E(14), F(15)\n2進数4桁 ＝ 16進数1桁 (例: 1010₂ = A₁₆ = 10₁₀)',
      conditions: 'コンピュータの数値表現 (基数変換)',
      usagePoint: '負の数の表現: 2の補数 (ビット反転 + 1)。IPアドレス (IPv4: 32bit, IPv6: 128bit) の計算。',
    ),
    FormulaItem(
      subject: '情報',
      title: '主要アルゴリズムの計算量 O記法',
      formula: '・線形探索: O(N)\n・2分探索: O(log N) (整列済み前提)\n・バブルソート / 挿入ソート: O(N²)\n・クイックソート / マージソート: O(N log N)',
      conditions: 'データ件数 N に対する実行ステップ数の漸近的増加率',
      usagePoint: '共通テスト情報Iで頻出。N = 1000のとき N² は100万回、N log₂N は約1万回で100倍高速。',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  List<FormulaItem> _getFiltered(String subject) {
    return _allFormulas.where((item) {
      final matchSub = subject == 'すべて' || item.subject == subject;
      final q = _searchQuery.toLowerCase();
      final matchQuery = q.isEmpty ||
          item.title.toLowerCase().contains(q) ||
          item.formula.toLowerCase().contains(q) ||
          item.usagePoint.toLowerCase().contains(q);
      return matchSub && matchQuery;
    }).toList();
  }

  void _copyFormula(FormulaItem item) {
    Clipboard.setData(ClipboardData(text: '${item.title}\n${item.formula}\n【ポイント】${item.usagePoint}'));
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.content_copy, color: Color(0xFF38BDF8), size: 16),
            SizedBox(width: 8),
            Text('公式テキストをコピーしました'),
          ],
        ),
        duration: Duration(milliseconds: 1000),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF131B2E),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subjects = ['数学', '物理', '化学', '古文', '英語', '情報'];

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.functions, color: Color(0xFF38BDF8), size: 22),
            SizedBox(width: 8),
            Text('全教科・超速公式集＆定理リファレンス', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        bottom: TabBar(
          controller: _tabCtrl,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: const Color(0xFF38BDF8),
          labelColor: const Color(0xFF38BDF8),
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          tabs: subjects.map((s) => Tab(text: s)).toList(),
        ),
      ),
      body: Column(
        children: [
          // Search box
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF0B1120),
            child: TextField(
              controller: _searchCtrl,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: '公式名・定理・キーワードで検索 (例: 1/6, 加法定理, ドップラー)...',
                hintStyle: const TextStyle(color: Colors.white38, fontSize: 11),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF38BDF8), size: 18),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white60, size: 16),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (v) => setState(() => _searchQuery = v.trim()),
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: subjects.map((sub) {
                final list = _getFiltered(sub);
                // Sort pinned to front
                list.sort((a, b) => (b.isPinned ? 1 : 0).compareTo(a.isPinned ? 1 : 0));

                if (list.isEmpty) {
                  return const Center(
                    child: Text('該当する公式が見つかりませんでした', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (context, idx) {
                    final item = list[idx];
                    return _buildFormulaCard(item);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaCard(FormulaItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isPinned ? const Color(0xFFFBBF24).withValues(alpha: 0.6) : Colors.white10,
          width: item.isPinned ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(item.subject, style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(item.isPinned ? Icons.star : Icons.star_border, color: item.isPinned ? const Color(0xFFFBBF24) : Colors.white38, size: 20),
                  tooltip: item.isPinned ? 'ピン留め解除' : '重要公式クリップ',
                  onPressed: () => setState(() => item.isPinned = !item.isPinned),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.white60, size: 16),
                  tooltip: '公式をコピー',
                  onPressed: () => _copyFormula(item),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white10),

          // Formula Display Block
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.25)),
            ),
            child: Text(
              item.formula,
              style: const TextStyle(
                color: Color(0xFF38BDF8),
                fontSize: 13,
                fontWeight: FontWeight.bold,
                height: 1.45,
                fontFamily: 'monospace',
              ),
            ),
          ),

          // Conditions & Point
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('適用条件: ', style: TextStyle(color: Colors.white54, fontSize: 10.5, fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text(item.conditions, style: const TextStyle(color: Colors.white70, fontSize: 10.5)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('入試活用: ', style: TextStyle(color: Color(0xFFFBBF24), fontSize: 10.5, fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text(item.usagePoint, style: const TextStyle(color: Colors.white70, fontSize: 10.5, height: 1.35)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
