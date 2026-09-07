import 'package:flutter/material.dart';

class HistoryEra {
  final String name;
  final String period;
  final String keyFigure;
  final String summary;
  final List<String> events;
  final String worldEvent;
  final Color color;

  const HistoryEra({
    required this.name,
    required this.period,
    required this.keyFigure,
    required this.summary,
    required this.events,
    required this.worldEvent,
    required this.color,
  });
}

class HistoryTimelineLabWidget extends StatefulWidget {
  const HistoryTimelineLabWidget({super.key});

  @override
  State<HistoryTimelineLabWidget> createState() => _HistoryTimelineLabWidgetState();
}

class _HistoryTimelineLabWidgetState extends State<HistoryTimelineLabWidget> {
  int _selectedEraIndex = 0;
  String _searchFilter = '';

  static const List<HistoryEra> _eras = [
    HistoryEra(
      name: '縄文・弥生時代',
      period: '紀元前1万年 〜 3世紀頃',
      keyFigure: '卑弥呼 (邪馬台国女王)',
      summary: '狩猟採集の縄文土器文化から、水稲農耕と金属器（青銅器・鉄器）が伝来した弥生時代へ。ムラからクニへと統合が進み邪馬台国が魏に使者を送る。',
      events: [
        '前4世紀頃: 九州北部に水稲稲作と金属器が伝来し弥生時代へ',
        '57年: 奴国が後漢の光武帝から「漢委奴国王」の金印を授かる',
        '239年: 邪馬台国の女王卑弥呼が魏に使者を送り「親魏倭王」の金印を授かる',
      ],
      worldEvent: '中国: 漢帝国・三国時代（魏・蜀・呉） / 地中海: ローマ帝国の繁栄とパクス・ロマーナ',
      color: Color(0xFFF59E0B),
    ),
    HistoryEra(
      name: '古墳・飛鳥時代',
      period: '3世紀後半 〜 710年',
      keyFigure: '聖徳太子 / 中大兄皇子 / 中臣鎌足',
      summary: '前方後円墳が全国に広がり大和政権が成立。仏教公伝を経て、聖徳太子の政治改革、大化の改新、白村江の戦い、律令国家の建設へと至る。',
      events: [
        '538年: 百済の聖明王から仏教が公伝する',
        '603/604年: 聖徳太子が冠位十二階・十七条憲法を制定、遣隋使派遣(小野妹子)',
        '645年: 大化の改新（中大兄皇子・中臣鎌足が蘇我入鹿を討ち改新の詔を発布）',
        '663年: 白村江の戦い（唐・新羅連合軍に大敗、防人・水城を配置）',
        '701年: 大宝律令の完成（律令国家の法制基盤が確立）',
      ],
      worldEvent: '中国: 隋による中国統一、唐帝国の建国 / 中東: イスラーム教の創始（ムハンマド）',
      color: Color(0xFF10B981),
    ),
    HistoryEra(
      name: '奈良時代',
      period: '710年 〜 794年',
      keyFigure: '聖武天皇 / 行基 / 鑑真',
      summary: '平城京を中心に律令制の最盛期を迎える。聖武天皇による東大寺大仏建立など仏教による国家鎮護（天平文化）が進む一方、墾田永年私財法により荘園の萌芽が生じる。',
      events: [
        '710年: 元明天皇が平城京（奈良）に遷都',
        '712/720年: 『古事記』『日本書紀』の完成、風土記の編纂',
        '743年: 墾田永年私財法の制定（土地の私有が永久に認められ初期荘園が発達）',
        '752年: 東大寺大仏開眼供養会が行われる',
        '754年: 唐僧鑑真が度重なる遭難を乗り越えて来日、唐招提寺を開く',
      ],
      worldEvent: '欧州: トゥール・ポワティエ間の戦い(732) / 中東: アッバース朝建国(750)',
      color: Color(0xFF38BDF8),
    ),
    HistoryEra(
      name: '平安時代',
      period: '794年 〜 1185年',
      keyFigure: '桓武天皇 / 菅原道真 / 藤原道長 / 平清盛',
      summary: '平安京遷都から約400年。遣唐使廃止により国風文化が花開く（仮名文字、源氏物語）。藤原氏の摂関政治から院政、武士の台頭、平氏政権を経て壇ノ浦の戦いで武家政権へ。',
      events: [
        '794年: 桓武天皇が平安京（京都）に遷都',
        '894年: 菅原道真の建議により遣唐使が廃止される',
        '1016年: 藤原道長が摂政となり摂関政治の頂点を極める（「この世をば…」）',
        '1086年: 白河上皇が院政を開始（北面の武士を配置）',
        '1167年: 平清盛が武士として初めて太政大臣に就任、日宋貿易を推進',
        '1185年: 壇ノ浦の戦いで平氏が滅亡',
      ],
      worldEvent: '中国: 宋（北宋・南宋）の繁栄 / 欧州: 十字軍の遠征開始(1096)',
      color: Color(0xFFA855F7),
    ),
    HistoryEra(
      name: '鎌倉時代',
      period: '1185年 〜 1333年',
      keyFigure: '源頼朝 / 北条政子 / 北条時宗',
      summary: '源頼朝による日本初の武家政権。守護・地頭の設置、執権政治（北条氏）、御成敗式目、鎌倉新仏教の普及。2度にわたる元寇を退けるも御恩と奉公の崩壊により滅亡。',
      events: [
        '1185年: 源頼朝が諸国に守護・地頭を設置（武家支配の実権確立）',
        '1192年: 源頼朝が征夷大将軍に任命され鎌倉幕府を開く',
        '1221年: 承久の乱（後鳥羽上皇を隠岐に配流、六波羅探題を設置）',
        '1232年: 北条泰時が武家最初の成文法『御成敗式目』を制定',
        '1274/1281年: 元寇（文永の役・弘安の役）でフビライの元軍を撃退',
        '1297年: 永仁の徳政令（御家人の困窮を救済しようとするも失敗）',
        '1333年: 足利尊氏・新田義貞らの蜂起により鎌倉幕府が滅亡',
      ],
      worldEvent: 'アジア: モンゴル帝国（チンギス・ハン）の世界征服と大帝国成立',
      color: Color(0xFFEC4899),
    ),
    HistoryEra(
      name: '室町・戦国時代',
      period: '1336年 〜 1573年',
      keyFigure: '足利尊氏 / 足利義満 / 雪舟 / 織田信長',
      summary: '建武の新政崩壊後、南北朝の動乱を経て足利義満が南北朝合一・勘合貿易を成立。北山・東山文化が栄えるが、応仁の乱を機に下剋上の戦国乱世へと突入する。',
      events: [
        '1338年: 足利尊氏が征夷大将軍となり室町幕府を開く',
        '1392年: 第3代将軍足利義満が南北朝を合一、明と勘合貿易を開始（金閣）',
        '1467年: 応仁の乱が勃発（11年間の戦火により京都が荒廃、戦国時代の幕開け）',
        '1492年: コロンブスのアメリカ大陸到達（世界史大航海時代）',
        '1543年: 種子島に鉄砲が伝来する',
        '1549年: フランシスコ・ザビエルが鹿児島に来日、キリスト教を布教',
        '1560年: 桶狭間の戦いで織田信長が今川義元を急襲して破る',
      ],
      worldEvent: '欧州: ルネサンスと宗教改革（ルター）、大航海時代の開幕',
      color: Color(0xFFEF4444),
    ),
    HistoryEra(
      name: '安土桃山時代',
      period: '1573年 〜 1603年',
      keyFigure: '織田信長 / 豊臣秀吉 / 千利休',
      summary: '織田信長の天下布武（楽市楽座・長篠の戦い）から、本能寺の変を経て豊臣秀吉が全国を統一。太閤検地と刀狩により兵農分離を断行し桃山文化が花開く。',
      events: [
        '1573年: 織田信長が足利義昭を追放し室町幕府が滅亡',
        '1575年: 長篠の戦い（武田勝頼の騎馬隊を火縄銃三段撃ちで撃破）',
        '1582年: 本能寺の変（明智光秀が謀反、信長自害）、山崎の戦い',
        '1588年: 豊臣秀吉が刀狩令を発布、太閤検地により石高制を確立（兵農分離）',
        '1590年: 小田原征伐で後北条氏を降伏させ秀吉が天下統一を果たす',
        '1600年: 関ヶ原の戦い（徳川家康率いる東軍が石田三成の西軍に勝利）',
      ],
      worldEvent: 'アジア: 明朝の衰退 / 欧州: イギリス東インド会社設立(1600)',
      color: Color(0xFFEAB308),
    ),
    HistoryEra(
      name: '江戸時代',
      period: '1603年 〜 1867年',
      keyFigure: '徳川家康 / 徳川吉宗 / 田沼意次 / 坂本龍馬',
      summary: '徳川家康が開府し約260年の泰平の世。武家諸法度・参勤交代・鎖国体制を築く。元禄文化・化政文化が花開き、幕末の黒船来航から大政奉還へと至る。',
      events: [
        '1603年: 徳川家康が征夷大将軍となり江戸幕府を開く',
        '1635/1639年: 武家諸法度改定(参勤交代義務化)、ポルトガル船来航禁止(鎖国完成)',
        '1716年: 第8代将軍徳川吉宗が享保の改革を推進（公事方御定書・目安箱）',
        '1787/1841年: 寛政の改革(松平定信)・天保の改革(水野忠邦)',
        '1853年: ペリー率いるアメリカ黒船が浦賀に来航（開国への転換点）',
        '1858年: 日米修好通商条約の調印（不平等条約、安政の大獄）',
        '1866年: 薩長同盟（坂本龍馬・中岡慎太郎の仲介により西郷隆盛と木戸孝允が締結）',
        '1867年: 第15代将軍徳川慶喜が大政奉還を行い政権を朝廷に返上',
      ],
      worldEvent: '英: 産業革命 / 仏: フランス革命(1789) / 米: 南北戦争(1861-1865)',
      color: Color(0xFF06B6D4),
    ),
    HistoryEra(
      name: '近代（明治・大正）',
      period: '1868年 〜 1926年',
      keyFigure: '西郷隆盛 / 大久保利通 / 伊藤博文 / 吉野作造',
      summary: '明治維新により近代国家へ大転換。富国強兵・殖産興業、自由民権運動、大日本帝国憲法の制定。日清・日露戦争を経て国際連盟常任理事国となる。',
      events: [
        '1868年: 五箇条の御誓文、明治改元、戊辰戦争',
        '1871/1873年: 廃藩置県、学制・徴兵令・地租改正',
        '1877年: 西南戦争（士族反乱の終焉）',
        '1889年: 大日本帝国憲法が発布される（東アジア初の近代立憲憲法）',
        '1894/1904年: 日清戦争・日露戦争（条約改正と国際的地位向上）',
        '1914年: 第一次世界大戦勃発（日本の参戦と大戦景気）',
        '1923年: 関東大震災の発生',
        '1925年: 普通選挙法（満25歳以上男子）と治安維持法の制定',
      ],
      worldEvent: '欧州: 第一次世界大戦(1914-1918) / ロシア: ロシア革命(1917)',
      color: Color(0xFF6366F1),
    ),
    HistoryEra(
      name: '現代（昭和・平成・令和）',
      period: '1926年 〜 現在',
      keyFigure: '吉田茂 / 白洲次郎',
      summary: '世界恐慌から軍部の台頭、太平洋戦争の敗戦。日本国憲法の公布、サンフランシスコ平和条約による主権回復、高度経済成長を経て現代へ。',
      events: [
        '1929年: ニューヨーク世界恐慌が勃発',
        '1931/1937年: 満州事変、日中戦争の勃発',
        '1941年: 太平洋戦争開戦（真珠湾攻撃）',
        '1945年: ポツダム宣言受諾、無条件降伏（第二次世界大戦終結）',
        '1946/1947年: 日本国憲法公布（国民主権・平和主義・基本的人権の尊重）',
        '1951年: サンフランシスコ平和条約・日米安全保障条約調印',
        '1964年: 東京オリンピック開催、東海道新幹線開業（高度経済成長期）',
        '1972年: 日中国交正常化、沖縄返還',
        '1991年: バブル経済崩壊、冷戦終結',
      ],
      worldEvent: '第二次世界大戦 / 米ソ冷戦 / ベルリンの壁崩壊(1989) / グローバル化・AI革命',
      color: Color(0xFF14B8A6),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredEras = _eras.where((e) {
      if (_searchFilter.isEmpty) return true;
      final q = _searchFilter.toLowerCase();
      return e.name.toLowerCase().contains(q) ||
          e.summary.toLowerCase().contains(q) ||
          e.keyFigure.toLowerCase().contains(q) ||
          e.events.any((ev) => ev.toLowerCase().contains(q));
    }).toList();

    final selectedEra = _eras[_selectedEraIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header description
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.history_edu, color: Color(0xFF38BDF8), size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '日本史 × 世界史 同期タイムライン',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '時代をタップして重要事件・中心人物・世界史との対比を即座に確認できます',
                        style: TextStyle(fontSize: 11, color: Colors.white60),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Search Field
          TextField(
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: '歴史事件・人物・年号を検索 (例: 壇ノ浦, 聖徳太子, 1853)...',
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF38BDF8), size: 18),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
            onChanged: (val) {
              setState(() {
                _searchFilter = val.trim();
              });
            },
          ),

          const SizedBox(height: 14),

          // Era Selector Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(filteredEras.length, (idx) {
                final era = filteredEras[idx];
                final isSelected = _eras[_selectedEraIndex].name == era.name;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(era.name),
                    selected: isSelected,
                    selectedColor: era.color.withValues(alpha: 0.3),
                    labelStyle: TextStyle(
                      color: isSelected ? era.color : Colors.white60,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          _selectedEraIndex = _eras.indexWhere((e) => e.name == era.name);
                        });
                      }
                    },
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 16),

          // Detail Card of Selected Era
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: selectedEra.color.withValues(alpha: 0.4), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: selectedEra.color.withValues(alpha: 0.1),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedEra.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: selectedEra.color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: selectedEra.color.withValues(alpha: 0.5)),
                      ),
                      child: Text(
                        selectedEra.period,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: selectedEra.color),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Color(0xFF38BDF8)),
                    const SizedBox(width: 6),
                    Text(
                      'キーパーソン: ${selectedEra.keyFigure}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF38BDF8)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  selectedEra.summary,
                  style: const TextStyle(fontSize: 12, color: Colors.white70, height: 1.5),
                ),
                const SizedBox(height: 16),

                // Critical Events list
                const Text(
                  '重要歴史事項・年号 (大学・高校入試頻出)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                ...selectedEra.events.map((event) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: selectedEra.color),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            event,
                            style: const TextStyle(fontSize: 12, color: Colors.white, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 14),

                // World History Parallel
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.public, color: Color(0xFFF59E0B), size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '同時代の世界史動向',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              selectedEra.worldEvent,
                              style: const TextStyle(fontSize: 11, color: Colors.white70, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
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
