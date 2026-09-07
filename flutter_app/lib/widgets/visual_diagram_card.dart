import 'dart:math' as math;
import 'package:flutter/material.dart';

enum DiagramType {
  quadratic,
  trigCircle,
  physicsIncline,
  physicsVtGraph,
  chemistryBohr,
  historyTrivia,
  classicalJapanese,
  classicalChinese,
  englishGrammar,
  geographyDiagram,
  civicsMechanism,
  biologyModel,
  earthScienceModel,
  informaticsLogic,
  japaneseLogic,
  generalConcept,
}

class VisualDiagramCard extends StatefulWidget {
  final String subjectId;
  final String questionText;
  final String explanation;

  const VisualDiagramCard({
    super.key,
    required this.subjectId,
    required this.questionText,
    required this.explanation,
  });

  @override
  State<VisualDiagramCard> createState() => _VisualDiagramCardState();
}

class _VisualDiagramCardState extends State<VisualDiagramCard> {
  bool _showLabels = true;
  bool _showGrid = true;

  DiagramType _detectType() {
    final sId = widget.subjectId.toLowerCase();
    final text = '${widget.questionText} ${widget.explanation}'.toLowerCase();

    // Mathematics
    if (sId == 'math' || sId == 'jh_math') {
      if (text.contains('sin') || text.contains('cos') || text.contains('tan') || text.contains('三角') || text.contains('単位円')) {
        return DiagramType.trigCircle;
      }
      return DiagramType.quadratic;
    }

    // Physics
    if (sId == 'physics') {
      if (text.contains('v-t') || text.contains('速度') || text.contains('加速度') || text.contains('等加速度')) {
        return DiagramType.physicsVtGraph;
      }
      return DiagramType.physicsIncline;
    }

    // Chemistry
    if (sId == 'chemistry') {
      return DiagramType.chemistryBohr;
    }

    // History (World & Japanese)
    if (sId.contains('history') || sId == 'world_history' || sId == 'japanese_history' || (sId == 'jh_social' && (text.contains('幕府') || text.contains('時代') || text.contains('戦争') || text.contains('条約')))) {
      return DiagramType.historyTrivia;
    }

    // Classical Japanese (古文)
    if (sId.contains('kobun') || sId.contains('classical_japanese') || text.contains('助動詞') || text.contains('係り結び') || text.contains('古文')) {
      return DiagramType.classicalJapanese;
    }

    // Classical Chinese (漢文)
    if (sId.contains('kanbun') || sId.contains('classical_chinese') || text.contains('返り点') || text.contains('再読文字') || text.contains('書き下し') || text.contains('漢文')) {
      return DiagramType.classicalChinese;
    }

    // English
    if (sId.contains('english') || sId == 'jh_english' || text.contains('文法') || text.contains('関係詞') || text.contains('仮定法')) {
      return DiagramType.englishGrammar;
    }

    // Geography
    if (sId.contains('geography') || (sId == 'jh_social' && (text.contains('気候') || text.contains('雨温図') || text.contains('地形') || text.contains('山脈')))) {
      return DiagramType.geographyDiagram;
    }

    // Civics / Politics & Economy / Ethics
    if (sId.contains('civics') || sId.contains('politics') || sId.contains('ethics') || sId == 'jh_social') {
      return DiagramType.civicsMechanism;
    }

    // Biology
    if (sId.contains('biology') || (sId == 'jh_science' && (text.contains('細胞') || text.contains('光合成') || text.contains('遺伝') || text.contains('dna')))) {
      return DiagramType.biologyModel;
    }

    // Earth Science
    if (sId.contains('earth') || (sId == 'jh_science' && (text.contains('地層') || text.contains('地震') || text.contains('火山') || text.contains('天体')))) {
      return DiagramType.earthScienceModel;
    }

    // Information
    if (sId.contains('info') || sId.contains('informatics')) {
      return DiagramType.informaticsLogic;
    }

    // Modern Japanese
    if (sId.contains('japanese') || sId == 'jh_japanese') {
      return DiagramType.japaneseLogic;
    }

    return DiagramType.generalConcept;
  }

  @override
  Widget build(BuildContext context) {
    final type = _detectType();

    String title;
    IconData icon;
    Color accentColor;

    switch (type) {
      case DiagramType.quadratic:
        title = '数式・放物線グラフ可視化';
        icon = Icons.show_chart;
        accentColor = const Color(0xFF38BDF8);
        break;
      case DiagramType.trigCircle:
        title = '三角比・単位円モデル可視化';
        icon = Icons.radio_button_checked;
        accentColor = const Color(0xFF38BDF8);
        break;
      case DiagramType.physicsIncline:
        title = '力学・斜面ベクトル分解図';
        icon = Icons.trending_down;
        accentColor = const Color(0xFF34D399);
        break;
      case DiagramType.physicsVtGraph:
        title = '等加速度直線運動 v-t グラフ';
        icon = Icons.timeline;
        accentColor = const Color(0xFF34D399);
        break;
      case DiagramType.chemistryBohr:
        title = '原子構造・電子殻モデル';
        icon = Icons.blur_circular;
        accentColor = const Color(0xFFFBBF24);
        break;
      case DiagramType.historyTrivia:
        title = '歴史深掘りコラム＆入試トリビア';
        icon = Icons.menu_book;
        accentColor = const Color(0xFFF43F5E);
        break;
      case DiagramType.classicalJapanese:
        title = '古文文法・助動詞接続ダイアグラム＆読解コラム';
        icon = Icons.auto_stories;
        accentColor = const Color(0xFFA855F7);
        break;
      case DiagramType.classicalChinese:
        title = '漢文訓読ダイアグラム＆重要句形コラム';
        icon = Icons.translate;
        accentColor = const Color(0xFFEC4899);
        break;
      case DiagramType.englishGrammar:
        title = '英文法・構文構造分析 (S+V+O+C) ＆ 語法コラム';
        icon = Icons.account_tree;
        accentColor = const Color(0xFF06B6D4);
        break;
      case DiagramType.geographyDiagram:
        title = '地理・気候雨温図＆地形ダイアグラム';
        icon = Icons.public;
        accentColor = const Color(0xFF10B981);
        break;
      case DiagramType.civicsMechanism:
        title = '社会システム・制度対比コラム＆メカニズム図解';
        icon = Icons.account_balance;
        accentColor = const Color(0xFF8B5CF6);
        break;
      case DiagramType.biologyModel:
        title = '生物構造モデル＆細胞・代謝ダイアグラム';
        icon = Icons.biotech;
        accentColor = const Color(0xFF10B981);
        break;
      case DiagramType.earthScienceModel:
        title = '地層・プレートテクトニクス＆天体ダイアグラム';
        icon = Icons.landscape;
        accentColor = const Color(0xFFF59E0B);
        break;
      case DiagramType.informaticsLogic:
        title = '情報科学・データ構造＆論理回路図解';
        icon = Icons.memory;
        accentColor = const Color(0xFF38BDF8);
        break;
      case DiagramType.japaneseLogic:
        title = '現代文・論理展開マップ＆重要語彙コラム';
        icon = Icons.psychology;
        accentColor = const Color(0xFF818CF8);
        break;
      case DiagramType.generalConcept:
        title = '論理構造・概念ダイアグラム';
        icon = Icons.hub;
        accentColor = const Color(0xFF38BDF8);
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(icon, color: accentColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Toggle Grid (applicable for canvas)
                if (_isCanvasType(type)) ...[
                  IconButton(
                    icon: Icon(
                      _showGrid ? Icons.grid_on : Icons.grid_off,
                      size: 18,
                      color: _showGrid ? accentColor : Colors.white38,
                    ),
                    tooltip: 'グリッド切替',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => setState(() => _showGrid = !_showGrid),
                  ),
                  IconButton(
                    icon: Icon(
                      _showLabels ? Icons.label : Icons.label_off,
                      size: 18,
                      color: _showLabels ? accentColor : Colors.white38,
                    ),
                    tooltip: 'ラベル切替',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => setState(() => _showLabels = !_showLabels),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFF1E293B)),

          // Body Content: Customized by Subject Type
          _buildBodyContent(type, accentColor),

          // Caption explanation
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: Text(
              _getCaption(type),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isCanvasType(DiagramType type) {
    return type == DiagramType.quadratic ||
        type == DiagramType.trigCircle ||
        type == DiagramType.physicsIncline ||
        type == DiagramType.physicsVtGraph ||
        type == DiagramType.chemistryBohr ||
        type == DiagramType.geographyDiagram ||
        type == DiagramType.biologyModel;
  }

  Widget _buildBodyContent(DiagramType type, Color accentColor) {
    switch (type) {
      case DiagramType.historyTrivia:
        return _buildHistoryTriviaColumn();
      case DiagramType.classicalJapanese:
        return _buildClassicalJapaneseColumn();
      case DiagramType.classicalChinese:
        return _buildClassicalChineseColumn();
      case DiagramType.englishGrammar:
        return _buildEnglishGrammarColumn();
      case DiagramType.civicsMechanism:
        return _buildCivicsMechanismColumn();
      case DiagramType.earthScienceModel:
        return _buildEarthScienceColumn();
      case DiagramType.informaticsLogic:
        return _buildInformaticsLogicColumn();
      case DiagramType.japaneseLogic:
        return _buildJapaneseLogicColumn();
      default:
        // Canvas rendering
        return Container(
          height: 180,
          padding: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomPaint(
              painter: _DiagramPainter(
                type: type,
                showGrid: _showGrid,
                showLabels: _showLabels,
              ),
              size: Size.infinite,
            ),
          ),
        );
    }
  }

  // 1. History Trivia Column Widget
  Widget _buildHistoryTriviaColumn() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF43F5E).withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Color(0xFFF43F5E), size: 16),
                    SizedBox(width: 6),
                    Text(
                      '入試頻出トリビア・歴史の因果関係',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFF43F5E)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildStepChip('時代背景', '権力集中の揺らぎ', const Color(0xFF38BDF8)),
                    const Icon(Icons.arrow_forward, size: 14, color: Colors.white38),
                    _buildStepChip('契機・事件', '改革・条約締結', const Color(0xFFFBBF24)),
                    const Icon(Icons.arrow_forward, size: 14, color: Colors.white38),
                    _buildStepChip('歴史的意義', '新秩序への移行', const Color(0xFF34D399)),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  '【同時代東西比較の視点】\n日本史の重要事件が起きた時期、世界史ではどのような変革が進んでいたか（例: 鉄砲伝来＝宗教改革期、明治維新＝普仏戦争・アメリカ南北戦争期）をリンクして捉えると論述問題で圧倒的な得点源になります。',
                  style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. Classical Japanese Grammar Column
  Widget _buildClassicalJapaneseColumn() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFA855F7).withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.menu_book, color: Color(0xFFA855F7), size: 16),
                    SizedBox(width: 6),
                    Text('助動詞の接続・識別マスターチャート', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFA855F7))),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _buildGrammarChip('未然形接続', 'る・らる・す・さす・む・ず', const Color(0xFF38BDF8)),
                    _buildGrammarChip('連用形接続', 'き・けり・つ・ぬ・たり・たし', const Color(0xFF34D399)),
                    _buildGrammarChip('終止形接続', 'らむ・らし・めり・べし・まじ', const Color(0xFFFBBF24)),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  '【係り結びの法則】\n「ぞ・なむ・や・か」→ 連体形で結ぶ（強意・疑問・反語）\n「こそ」→ 已然形で結ぶ（強意・逆接余情）\n主語の切り替わりは接続助詞「を・に・が」や敬語の敬意の方向（本動詞・補助動詞）で瞬時に判定します。',
                  style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. Classical Chinese Kunten Column
  Widget _buildClassicalChineseColumn() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEC4899).withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.translate, color: Color(0xFFEC4899), size: 16),
                SizedBox(width: 6),
                Text('漢文訓読・返り点＆重要再読文字', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFEC4899))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildKuntenBox('レ点', '直下から直上へ一字戻る'),
                const SizedBox(width: 8),
                _buildKuntenBox('一・二点', '二点から一点へ戻る'),
                const SizedBox(width: 8),
                _buildKuntenBox('上・中・下点', '一二点を挟む場合に適用'),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              '【頻出再読文字の読みと意味】\n・「未」(いまダーず: まだ〜ない)\n・「将/且」(まさニ〜(と)す: 今にも〜しようとする)\n・「当/応」(まさニ〜べシ: 当然〜すべきだ / きっと〜だろう)\n・「宜」(よろシク〜べシ: 〜するのがよい)',
              style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }

  // 4. English Grammar SVOC Column
  Widget _buildEnglishGrammarColumn() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF06B6D4).withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.account_tree, color: Color(0xFF06B6D4), size: 16),
                SizedBox(width: 6),
                Text('英語構文 5文型 (S+V+O+C) 構造分析', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF06B6D4))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildSvocTag('S (主語)', const Color(0xFF38BDF8)),
                const SizedBox(width: 6),
                _buildSvocTag('V (動詞)', const Color(0xFFF43F5E)),
                const SizedBox(width: 6),
                _buildSvocTag('O (目的語)', const Color(0xFF10B981)),
                const SizedBox(width: 6),
                _buildSvocTag('C (補語)', const Color(0xFFFBBF24)),
                const SizedBox(width: 6),
                _buildSvocTag('M (修飾語)', Colors.white38),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              '【構文把握の極意】\n第4文型 SVO1O2 (O1にO2を与える) ⇄ 第3文型 SVO to/for O\n第5文型 SVOC では常に「O = C」または「OがCする主語述語関係」が成立します。関係詞節や分詞構文が挿入されても、文の幹となる骨格S+Vを瞬時に見抜くのが速読の鍵です。',
              style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  // 5. Civics System Column
  Widget _buildCivicsMechanismColumn() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.account_balance, color: Color(0xFF8B5CF6), size: 16),
                SizedBox(width: 6),
                Text('社会システム・三権分立と抑制・均衡', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildPowerBranch('国会 (立法)', '内閣総理大臣指名 / 違憲立法審査'),
                const SizedBox(width: 8),
                _buildPowerBranch('内閣 (行政)', '衆議院解散 / 違憲審査'),
                const SizedBox(width: 8),
                _buildPowerBranch('裁判所 (司法)', '内閣不信任決議 / 裁判官弾劾'),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              '【市場経済メカニズム】\n需要曲線(右下がり)と供給曲線(右上がり)の交点で「均衡価格」が決定。超過需要時は価格上昇、超過供給時は価格下落の自動調整機構(アダム・スミスの「見えざる手」)が働きます。',
              style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  // 6. Earth Science Column
  Widget _buildEarthScienceColumn() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.landscape, color: Color(0xFFF59E0B), size: 16),
                SizedBox(width: 6),
                Text('地層累乗の法則・断層＆プレート運動', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B))),
              ],
            ),
            SizedBox(height: 8),
            Text(
              '・正断層: 引張力により上盤がずり下がる\n・逆断層: 圧縮力により上盤がずり上がる (プレート境界で多発)\n・不整合面: 堆積→隆起→侵食→沈降→再堆積の劇的インターバル\n・示準化石: 生息期間が短く広範囲（フズリナ・三葉虫・アンモナイト）\n・示相化石: 生息環境が限定的（サンゴ＝暖かく浅い海、シジミ＝汽水）',
              style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }

  // 7. Informatics Logic Column
  Widget _buildInformaticsLogicColumn() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.memory, color: Color(0xFF38BDF8), size: 16),
                SizedBox(width: 6),
                Text('基本論理ゲート真理値表 ＆ 基数変換', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8))),
              ],
            ),
            SizedBox(height: 8),
            Text(
              '・AND: 両方1のときのみ1\n・OR: どちらか一方でも1なら1\n・XOR (排他的論理和): 入力が異なるとき1、同じとき0\n・NOT: 0⇄1の反転\n【基数変換】2進数の4ビットは16進数1桁に直結 (例: 1101₂ = 13 = D₁₆)。ビットマスク演算やパリティチェックによる誤り訂正の基礎です。',
              style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }

  // 8. Modern Japanese Logic Column
  Widget _buildJapaneseLogicColumn() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF818CF8).withValues(alpha: 0.3)),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: Color(0xFF818CF8), size: 16),
                SizedBox(width: 6),
                Text('現代文・評論文の論理展開ツリー', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF818CF8))),
              ],
            ),
            SizedBox(height: 8),
            Text(
              '・対比構造: 「近代 (西欧/合理性/普遍)」⇄「前近代 (日本/身体性/固有性)」\n・逆接の合図: 「しかし」「だが」の直後に筆者の主張核心が来る\n・具体例と抽象命題: 具体例（エピソード・比喩）は直前の抽象的主張を理解するための補助線。設問の正解根拠は必ず抽象部から拾うのが鉄則です。',
              style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepChip(String step, String desc, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            Text(step, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color)),
            Text(desc, style: const TextStyle(fontSize: 8, color: Colors.white70), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _buildGrammarChip(String title, String content, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color)),
          Text(content, style: const TextStyle(fontSize: 8.5, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildKuntenBox(String title, String rule) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFEC4899))),
            const SizedBox(height: 2),
            Text(rule, style: const TextStyle(fontSize: 8, color: Colors.white60)),
          ],
        ),
      ),
    );
  }

  Widget _buildSvocTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color)),
    );
  }

  Widget _buildPowerBranch(String branch, String powers) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(branch, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6))),
            const SizedBox(height: 2),
            Text(powers, style: const TextStyle(fontSize: 8, color: Colors.white60)),
          ],
        ),
      ),
    );
  }

  String _getCaption(DiagramType type) {
    switch (type) {
      case DiagramType.quadratic:
        return '【図解】関数 y = ax² + bx + c の頂点 (p, q) および x 軸との交点（解）の配置関係です。軸を基準に対称性を持ちます。';
      case DiagramType.trigCircle:
        return '【図解】単位円 (半径1) において、点 P の x 座標が cosθ、y 座標が sinθ、直線の傾きが tanθ に対応します。';
      case DiagramType.physicsIncline:
        return '【図解】斜面上の物体に働く重力 mg は、斜面平行成分 mg sinθ と斜面垂直成分 mg cosθ に直交分解されます。垂直抗力 N と釣り合います。';
      case DiagramType.physicsVtGraph:
        return '【図解】v-t グラフの傾きは加速度 a を表し、グラフと t 軸で囲まれた台形の面積が移動距離 x に等しくなります。';
      case DiagramType.chemistryBohr:
        return '【図解】ボーアの原子模型。中心の原子核周囲を、内側から K 殻 (最大2個)、L 殻 (最大8個)、M 殻が取り囲む電子配置モデルです。';
      case DiagramType.geographyDiagram:
        return '【図解】ケッペンの気候区分・雨温図の推移モデルおよび河川作用（上流・中流・下流）による扇状地・三日月湖・三角州の地形模式です。';
      case DiagramType.biologyModel:
        return '【図解】真核生物の細胞構造（核・ミトコンドリア・小胞体・リボソーム）および二重らせん構造（相補的塩基対 A-T, G-C）の模式図です。';
      case DiagramType.historyTrivia:
        return '【歴史コラム】暗記にとどまらず、政治・経済・国際情勢の「因果の連鎖」として把握することで、論述記述や難問に強い学力が定着します。';
      case DiagramType.classicalJapanese:
        return '【古文コラム】文末の活用形と助動詞接続の合致を確認し、敬語の主客関係と合わせて正確な読解力を身につけましょう。';
      case DiagramType.classicalChinese:
        return '【漢文コラム】再読文字・返り点を機械的に追うだけでなく、基本文型（S+V+O）を意識して書き下し文を復元することが満点への近道です。';
      case DiagramType.englishGrammar:
        return '【英語コラム】英文読解では、どんな長文も5つの文型のいずれかに帰着します。骨格を見出し、修飾句をカッコで括る習慣を身につけましょう。';
      case DiagramType.civicsMechanism:
        return '【公民コラム】三権分立によるチェック・アンド・バランスや市場の価格決定など、制度の目的と力学を体系的に整理しましょう。';
      case DiagramType.earthScienceModel:
        return '【地学コラム】プレート境界での地殻変動や、地層の重なり・不整合の順序を空間的・時間的に捉えることが重要です。';
      case DiagramType.informaticsLogic:
        return '【情報コラム】論理回路・二進数演算は現代デジタル社会の基盤です。真理値表とブール代数を結びつけて瞬殺できるようにしましょう。';
      case DiagramType.japaneseLogic:
        return '【現代文コラム】評論文は筆者の独自の主張と、それを補強する論理・具体例・対比のネットワークです。感情ではなく構造で読み解きます。';
      case DiagramType.generalConcept:
        return '【概念図】前提条件から論理的な推論を経て導かれる結論の構造関係を示しています。';
    }
  }
}

class _DiagramPainter extends CustomPainter {
  final DiagramType type;
  final bool showGrid;
  final bool showLabels;

  _DiagramPainter({
    required this.type,
    required this.showGrid,
    required this.showLabels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFF0B1120);
    canvas.drawRect(Offset.zero & size, bgPaint);

    if (showGrid) {
      _drawGrid(canvas, size);
    }

    switch (type) {
      case DiagramType.quadratic:
        _drawQuadratic(canvas, size);
        break;
      case DiagramType.trigCircle:
        _drawTrigCircle(canvas, size);
        break;
      case DiagramType.physicsIncline:
        _drawIncline(canvas, size);
        break;
      case DiagramType.physicsVtGraph:
        _drawVtGraph(canvas, size);
        break;
      case DiagramType.chemistryBohr:
        _drawBohr(canvas, size);
        break;
      case DiagramType.geographyDiagram:
        _drawGeographyChart(canvas, size);
        break;
      case DiagramType.biologyModel:
        _drawCellModel(canvas, size);
        break;
      default:
        _drawGeneralConcept(canvas, size);
        break;
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1.0;

    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _drawQuadratic(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = Colors.white30
      ..strokeWidth = 1.5;

    final cx = size.width / 2;
    final cy = size.height * 0.7;

    canvas.drawLine(Offset(20, cy), Offset(size.width - 20, cy), axisPaint);
    canvas.drawLine(Offset(cx, 15), Offset(cx, size.height - 15), axisPaint);

    final curvePaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    bool first = true;
    for (double x = -100; x <= 100; x += 2) {
      final px = cx + x;
      final py = cy - (0.012 * x * x - 35);
      if (first) {
        path.moveTo(px, py);
        first = false;
      } else {
        path.lineTo(px, py);
      }
    }
    canvas.drawPath(path, curvePaint);

    final vPaint = Paint()..color = const Color(0xFFFBBF24);
    final vx = cx;
    final vy = cy + 35;
    canvas.drawCircle(Offset(vx, vy), 4, vPaint);

    if (showLabels) {
      _drawText(canvas, 'O', Offset(cx - 12, cy + 2), Colors.white38);
      _drawText(canvas, 'x', Offset(size.width - 15, cy + 2), Colors.white60);
      _drawText(canvas, 'y', Offset(cx + 6, 12), Colors.white60);
      _drawText(canvas, '頂点 (p, q)', Offset(vx + 6, vy - 6), const Color(0xFFFBBF24));
      _drawText(canvas, 'y = a(x - p)² + q', Offset(cx - 50, 25), const Color(0xFF38BDF8));
    }
  }

  void _drawTrigCircle(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(cx, cy) * 0.75;

    final axisPaint = Paint()..color = Colors.white24..strokeWidth = 1.0;
    canvas.drawLine(Offset(cx - r - 20, cy), Offset(cx + r + 20, cy), axisPaint);
    canvas.drawLine(Offset(cx, cy - r - 20), Offset(cx, cy + r + 20), axisPaint);

    final circlePaint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.4)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(cx, cy), r, circlePaint);

    const angle = math.pi / 4;
    final px = cx + r * math.cos(angle);
    final py = cy - r * math.sin(angle);

    final radiusPaint = Paint()..color = const Color(0xFFFBBF24)..strokeWidth = 2.0;
    canvas.drawLine(Offset(cx, cy), Offset(px, py), radiusPaint);

    final pPaint = Paint()..color = const Color(0xFFFBBF24);
    canvas.drawCircle(Offset(px, py), 4, pPaint);

    final compPaint = Paint()..color = const Color(0xFF34D399)..strokeWidth = 1.5;
    canvas.drawLine(Offset(cx, py), Offset(px, py), compPaint);
    canvas.drawLine(Offset(px, cy), Offset(px, py), compPaint);

    if (showLabels) {
      _drawText(canvas, 'P(cosθ, sinθ)', Offset(px + 4, py - 14), const Color(0xFFFBBF24));
      _drawText(canvas, '1', Offset(cx + r + 4, cy + 2), Colors.white38);
      _drawText(canvas, 'θ', Offset(cx + 14, cy - 14), const Color(0xFFFBBF24));
    }
  }

  void _drawIncline(Canvas canvas, Size size) {
    final p1 = Offset(30, size.height - 30);
    final p2 = Offset(size.width - 30, size.height - 30);
    final p3 = Offset(size.width - 30, 40);

    final slopePaint = Paint()..color = Colors.white30..strokeWidth = 2.0;
    canvas.drawLine(p1, p2, slopePaint);
    canvas.drawLine(p2, p3, slopePaint);
    canvas.drawLine(p1, p3, Paint()..color = const Color(0xFF38BDF8)..strokeWidth = 2.5);

    final bx = (p1.dx + p3.dx) / 2;
    final by = (p1.dy + p3.dy) / 2;

    final boxPaint = Paint()..color = const Color(0xFFFBBF24);
    canvas.drawRect(Rect.fromCenter(center: Offset(bx, by - 12), width: 26, height: 20), boxPaint);

    final mgPaint = Paint()..color = const Color(0xFFF43F5E)..strokeWidth = 2.0;
    canvas.drawLine(Offset(bx, by - 12), Offset(bx, by + 40), mgPaint);

    if (showLabels) {
      _drawText(canvas, 'mg (重力)', Offset(bx + 4, by + 30), const Color(0xFFF43F5E));
      _drawText(canvas, 'θ', Offset(p1.dx + 25, p1.dy - 16), const Color(0xFF38BDF8));
    }
  }

  void _drawVtGraph(Canvas canvas, Size size) {
    final cx = 40.0;
    final cy = size.height - 35.0;

    final axisPaint = Paint()..color = Colors.white38..strokeWidth = 1.5;
    canvas.drawLine(Offset(cx, cy), Offset(size.width - 25, cy), axisPaint);
    canvas.drawLine(Offset(cx, cy), Offset(cx, 25), axisPaint);

    final v0Y = cy - 30;
    final v1X = size.width - 60;
    final v1Y = cy - 90;

    final areaPath = Path()
      ..moveTo(cx, cy)
      ..lineTo(cx, v0Y)
      ..lineTo(v1X, v1Y)
      ..lineTo(v1X, cy)
      ..close();

    canvas.drawPath(
      areaPath,
      Paint()..color = const Color(0xFF38BDF8).withValues(alpha: 0.15),
    );

    final linePaint = Paint()..color = const Color(0xFF34D399)..strokeWidth = 2.5;
    canvas.drawLine(Offset(cx, v0Y), Offset(v1X, v1Y), linePaint);

    if (showLabels) {
      _drawText(canvas, 'v₀', Offset(cx - 24, v0Y - 6), Colors.white70);
      _drawText(canvas, 'v', Offset(cx - 18, 20), const Color(0xFF34D399));
      _drawText(canvas, 't', Offset(size.width - 20, cy + 4), Colors.white70);
      _drawText(canvas, '面積 = 移動距離 x', Offset(cx + 40, cy - 40), const Color(0xFF38BDF8));
      _drawText(canvas, '傾き = 加速度 a', Offset(cx + 50, v0Y - 40), const Color(0xFF34D399));
    }
  }

  void _drawBohr(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final nucPaint = Paint()..color = const Color(0xFFF43F5E);
    canvas.drawCircle(Offset(cx, cy), 10, nucPaint);

    final shellPaint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final rK = 35.0;
    final rL = 65.0;
    canvas.drawCircle(Offset(cx, cy), rK, shellPaint);
    canvas.drawCircle(Offset(cx, cy), rL, shellPaint);

    final ePaint = Paint()..color = const Color(0xFF38BDF8);
    canvas.drawCircle(Offset(cx + rK, cy), 3.5, ePaint);
    canvas.drawCircle(Offset(cx - rK, cy), 3.5, ePaint);

    for (int i = 0; i < 4; i++) {
      final a = i * math.pi / 2;
      canvas.drawCircle(Offset(cx + rL * math.cos(a), cy + rL * math.sin(a)), 3.5, ePaint);
    }

    if (showLabels) {
      _drawText(canvas, '核 (+)', Offset(cx - 9, cy - 5), Colors.white);
      _drawText(canvas, 'K殻 (2e⁻)', Offset(cx + rK - 6, cy - 14), const Color(0xFF38BDF8));
      _drawText(canvas, 'L殻 (8e⁻)', Offset(cx + rL - 6, cy - 14), const Color(0xFF38BDF8));
    }
  }

  void _drawGeographyChart(Canvas canvas, Size size) {
    final cx = 35.0;
    final cy = size.height - 30.0;
    final w = size.width - 70.0;

    final axisPaint = Paint()..color = Colors.white24..strokeWidth = 1.0;
    canvas.drawLine(Offset(cx, cy), Offset(cx + w, cy), axisPaint);

    // Draw rainfall bars
    final barW = w / 12 - 3;
    final barPaint = Paint()..color = const Color(0xFF0284C7).withValues(alpha: 0.6);
    final rains = [50, 60, 90, 130, 160, 220, 180, 190, 210, 140, 80, 55];
    for (int i = 0; i < 12; i++) {
      final bx = cx + i * (barW + 3);
      final bh = (rains[i] / 240) * (size.height - 60);
      canvas.drawRect(Rect.fromLTWH(bx, cy - bh, barW, bh), barPaint);
    }

    // Draw temperature line
    final tempPaint = Paint()..color = const Color(0xFFF43F5E)..strokeWidth = 2.0;
    final temps = [4, 5, 9, 15, 20, 24, 28, 29, 25, 19, 13, 7];
    for (int i = 0; i < 11; i++) {
      final x1 = cx + i * (barW + 3) + barW / 2;
      final y1 = cy - 20 - (temps[i] / 35) * 60;
      final x2 = cx + (i + 1) * (barW + 3) + barW / 2;
      final y2 = cy - 20 - (temps[i + 1] / 35) * 60;
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), tempPaint);
      canvas.drawCircle(Offset(x1, y1), 2.5, tempPaint);
    }

    if (showLabels) {
      _drawText(canvas, '降水量 (mm)', Offset(cx, 10), const Color(0xFF0284C7));
      _drawText(canvas, '気温 (°C)', Offset(size.width - 65, 10), const Color(0xFFF43F5E));
      _drawText(canvas, '1月 〜 12月 (温帯・温暖湿潤気候 Cfaモデル)', Offset(cx + 20, cy + 8), Colors.white60);
    }
  }

  void _drawCellModel(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Cell membrane
    final cellPaint = Paint()
      ..color = const Color(0xFF10B981).withValues(alpha: 0.3)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: 180, height: 110), cellPaint);

    // Nucleus
    final nucPaint = Paint()..color = const Color(0xFFA855F7).withValues(alpha: 0.7);
    canvas.drawCircle(Offset(cx - 25, cy), 22, nucPaint);

    // Mitochondria
    final mitoPaint = Paint()..color = const Color(0xFFF59E0B);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 40, cy - 20), width: 24, height: 12), mitoPaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 30, cy + 25), width: 24, height: 12), mitoPaint);

    if (showLabels) {
      _drawText(canvas, '核 (DNA格納)', Offset(cx - 45, cy - 6), Colors.white);
      _drawText(canvas, 'ミトコンドリア (ATP合成)', Offset(cx + 25, cy - 36), const Color(0xFFF59E0B));
      _drawText(canvas, '細胞膜 (物質透過・恒常性)', Offset(cx - 50, cy + 42), const Color(0xFF10B981));
    }
  }

  void _drawGeneralConcept(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final boxPaint = Paint()..color = const Color(0xFF1E293B);
    final borderPaint = Paint()..color = const Color(0xFF38BDF8)..strokeWidth = 1.5..style = PaintingStyle.stroke;

    final r1 = Rect.fromCenter(center: Offset(cx - 70, cy), width: 75, height: 35);
    final r2 = Rect.fromCenter(center: Offset(cx + 70, cy), width: 75, height: 35);

    canvas.drawRRect(RRect.fromRectAndRadius(r1, const Radius.circular(8)), boxPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(r1, const Radius.circular(8)), borderPaint);

    canvas.drawRRect(RRect.fromRectAndRadius(r2, const Radius.circular(8)), boxPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(r2, const Radius.circular(8)), borderPaint);

    final arrowPaint = Paint()..color = const Color(0xFFFBBF24)..strokeWidth = 2.0;
    canvas.drawLine(Offset(cx - 30, cy), Offset(cx + 30, cy), arrowPaint);
    canvas.drawLine(Offset(cx + 22, cy - 5), Offset(cx + 30, cy), arrowPaint);
    canvas.drawLine(Offset(cx + 22, cy + 5), Offset(cx + 30, cy), arrowPaint);

    if (showLabels) {
      _drawText(canvas, '前提条件', Offset(cx - 95, cy - 6), Colors.white);
      _drawText(canvas, '論理的帰結', Offset(cx + 45, cy - 6), Colors.white);
      _drawText(canvas, '推論・法則', Offset(cx - 24, cy - 18), const Color(0xFFFBBF24));
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _DiagramPainter oldDelegate) =>
      oldDelegate.type != type ||
      oldDelegate.showGrid != showGrid ||
      oldDelegate.showLabels != showLabels;
}
