import 'dart:math' as math;
import 'package:flutter/material.dart';

class ElementData {
  final int number;
  final String symbol;
  final String name;
  final String category;
  final double mass;
  final List<int> electronShells;
  final Color color;
  final String description;

  const ElementData({
    required this.number,
    required this.symbol,
    required this.name,
    required this.category,
    required this.mass,
    required this.electronShells,
    required this.color,
    required this.description,
  });
}

class PeriodicTableLabWidget extends StatefulWidget {
  const PeriodicTableLabWidget({super.key});

  @override
  State<PeriodicTableLabWidget> createState() => _PeriodicTableLabWidgetState();
}

class _PeriodicTableLabWidgetState extends State<PeriodicTableLabWidget> {
  String _selectedCategory = 'すべて';
  String _searchQuery = '';
  ElementData? _selectedElement;

  static const List<ElementData> _elements = [
    ElementData(
      number: 1,
      symbol: 'H',
      name: '水素',
      category: '非金属',
      mass: 1.008,
      electronShells: [1],
      color: Color(0xFF38BDF8),
      description: '宇宙で最も豊富な元素。無色・無臭・可燃性気体。',
    ),
    ElementData(
      number: 2,
      symbol: 'He',
      name: 'ヘリウム',
      category: '貴ガス',
      mass: 4.003,
      electronShells: [2],
      color: Color(0xFFA855F7),
      description: '最も不活性な貴ガス。沸点は全物質中最低(-268.9℃)。',
    ),
    ElementData(
      number: 3,
      symbol: 'Li',
      name: 'リチウム',
      category: 'アルカリ金属',
      mass: 6.94,
      electronShells: [2, 1],
      color: Color(0xFFF43F5E),
      description: '最も軽い金属。リチウムイオン電池の正極・負極に必須。',
    ),
    ElementData(
      number: 4,
      symbol: 'Be',
      name: 'ベリリウム',
      category: 'アルカリ土類',
      mass: 9.012,
      electronShells: [2, 2],
      color: Color(0xFFF59E0B),
      description: 'X線透過性が高く、エメラルドの構成成分。',
    ),
    ElementData(
      number: 5,
      symbol: 'B',
      name: 'ホウ素',
      category: '半金属',
      mass: 10.81,
      electronShells: [2, 3],
      color: Color(0xFF10B981),
      description: '耐熱ガラス（パイレックス）や半導体のドーパント。',
    ),
    ElementData(
      number: 6,
      symbol: 'C',
      name: '炭素',
      category: '非金属',
      mass: 12.011,
      electronShells: [2, 4],
      color: Color(0xFF38BDF8),
      description: '生命の基盤。ダイヤモンド、黒鉛、フラーレン等の同素体を持つ。',
    ),
    ElementData(
      number: 7,
      symbol: 'N',
      name: '窒素',
      category: '非金属',
      mass: 14.007,
      electronShells: [2, 5],
      color: Color(0xFF38BDF8),
      description: '大気の約78%を占める。三重結合による極めて高い安定性。',
    ),
    ElementData(
      number: 8,
      symbol: 'O',
      name: '酸素',
      category: '非金属',
      mass: 15.999,
      electronShells: [2, 6],
      color: Color(0xFF38BDF8),
      description: '大気の約21%、地殻の46%を占める。生物呼吸に必須。',
    ),
    ElementData(
      number: 9,
      symbol: 'F',
      name: 'フッ素',
      category: 'ハロゲン',
      mass: 18.998,
      electronShells: [2, 7],
      color: Color(0xFF06B6D4),
      description: '全元素中最大の電気陰性度(4.0)。極めて強い酸化力。',
    ),
    ElementData(
      number: 10,
      symbol: 'Ne',
      name: 'ネオン',
      category: '貴ガス',
      mass: 20.18,
      electronShells: [2, 8],
      color: Color(0xFFA855F7),
      description: '放電管で赤橙色に発光（ネオンサイン）。閉殻構造。',
    ),
    ElementData(
      number: 11,
      symbol: 'Na',
      name: 'ナトリウム',
      category: 'アルカリ金属',
      mass: 22.99,
      electronShells: [2, 8, 1],
      color: Color(0xFFF43F5E),
      description: '炎色反応は黄色。水と激しく反応し水素を発生。',
    ),
    ElementData(
      number: 12,
      symbol: 'Mg',
      name: 'マグネシウム',
      category: 'アルカリ土類',
      mass: 24.305,
      electronShells: [2, 8, 2],
      color: Color(0xFFF59E0B),
      description: '葉緑素（クロロフィル）の中心金属。実用金属中最も軽量級。',
    ),
    ElementData(
      number: 13,
      symbol: 'Al',
      name: 'アルミニウム',
      category: '典型金属',
      mass: 26.982,
      electronShells: [2, 8, 3],
      color: Color(0xFF64748B),
      description: '地殻中金属元素で最多。ボーキサイトから溶融塩電解で精錬。',
    ),
    ElementData(
      number: 14,
      symbol: 'Si',
      name: 'ケイ素',
      category: '半金属',
      mass: 28.085,
      electronShells: [2, 8, 4],
      color: Color(0xFF10B981),
      description: '半導体産業の中心。地殻質量第2位（クラーク数2位）。',
    ),
    ElementData(
      number: 15,
      symbol: 'P',
      name: 'リン',
      category: '非金属',
      mass: 30.974,
      electronShells: [2, 8, 5],
      color: Color(0xFF38BDF8),
      description: 'DNAやATPの骨格。黄リン（有毒・自然発火）と赤リンの同素体。',
    ),
    ElementData(
      number: 16,
      symbol: 'S',
      name: '硫黄',
      category: '非金属',
      mass: 32.06,
      electronShells: [2, 8, 6],
      color: Color(0xFF38BDF8),
      description: '斜方硫黄・単斜硫黄・ゴム状硫黄の同素体。硫酸の原料。',
    ),
    ElementData(
      number: 17,
      symbol: 'Cl',
      name: '塩素',
      category: 'ハロゲン',
      mass: 35.45,
      electronShells: [2, 8, 7],
      color: Color(0xFF06B6D4),
      description: '黄緑色の有毒気体。水道水殺菌や漂白剤、塩酸に使用。',
    ),
    ElementData(
      number: 18,
      symbol: 'Ar',
      name: 'アルゴン',
      category: '貴ガス',
      mass: 39.95,
      electronShells: [2, 8, 8],
      color: Color(0xFFA855F7),
      description: '大気中に約0.93%存在。白熱電球や溶接の保護ガス。',
    ),
    ElementData(
      number: 19,
      symbol: 'K',
      name: 'カリウム',
      category: 'アルカリ金属',
      mass: 39.098,
      electronShells: [2, 8, 8, 1],
      color: Color(0xFFF43F5E),
      description: '炎色反応は赤紫。神経伝達や植物三大肥料（N, P, K）の一角。',
    ),
    ElementData(
      number: 20,
      symbol: 'Ca',
      name: 'カルシウム',
      category: 'アルカリ土類',
      mass: 40.078,
      electronShells: [2, 8, 8, 2],
      color: Color(0xFFF59E0B),
      description: '炎色反応は橙赤。骨・歯の主成分、セメントの主原料。',
    ),
    ElementData(
      number: 21,
      symbol: 'Sc',
      name: 'スカンジウム',
      category: '遷移金属',
      mass: 44.956,
      electronShells: [2, 8, 9, 2],
      color: Color(0xFFEAB308),
      description: '最初の遷移金属。アルミニウム合金の強化に使用。',
    ),
    ElementData(
      number: 22,
      symbol: 'Ti',
      name: 'チタン',
      category: '遷移金属',
      mass: 47.867,
      electronShells: [2, 8, 10, 2],
      color: Color(0xFFEAB308),
      description: '比強度が高く耐食性に優れる。航空宇宙・人工関節に多用。',
    ),
    ElementData(
      number: 23,
      symbol: 'V',
      name: 'バナジウム',
      category: '遷移金属',
      mass: 50.942,
      electronShells: [2, 8, 11, 2],
      color: Color(0xFFEAB308),
      description: '耐摩耗性鋼の添加剤。酸化数は+2から+5まで多彩な色を示す。',
    ),
    ElementData(
      number: 24,
      symbol: 'Cr',
      name: 'クロム',
      category: '遷移金属',
      mass: 51.996,
      electronShells: [2, 8, 13, 1],
      color: Color(0xFFEAB308),
      description: 'ステンレス鋼の主要成分（不動態皮膜を形成）。',
    ),
    ElementData(
      number: 25,
      symbol: 'Mn',
      name: 'マンガン',
      category: '遷移金属',
      mass: 54.938,
      electronShells: [2, 8, 13, 2],
      color: Color(0xFFEAB308),
      description: '乾電池（MnO2）や製鋼用脱酸剤。過マンガン酸カリウムは強酸化剤。',
    ),
    ElementData(
      number: 26,
      symbol: 'Fe',
      name: '鉄',
      category: '遷移金属',
      mass: 55.845,
      electronShells: [2, 8, 14, 2],
      color: Color(0xFFEAB308),
      description: '人類社会を支える最も重要な金属。ヘモグロビンの中心原子。',
    ),
    ElementData(
      number: 27,
      symbol: 'Co',
      name: 'コバルト',
      category: '遷移金属',
      mass: 58.933,
      electronShells: [2, 8, 15, 2],
      color: Color(0xFFEAB308),
      description: 'ビタミンB12の中心金属。強力な磁石材料（サマリウムコバルト）。',
    ),
    ElementData(
      number: 28,
      symbol: 'Ni',
      name: 'ニッケル',
      category: '遷移金属',
      mass: 58.693,
      electronShells: [2, 8, 16, 2],
      color: Color(0xFFEAB308),
      description: 'ステンレス鋼・ニッケル水素電池・硬貨の原料。',
    ),
    ElementData(
      number: 29,
      symbol: 'Cu',
      name: '銅',
      category: '遷移金属',
      mass: 63.546,
      electronShells: [2, 8, 18, 1],
      color: Color(0xFFEAB308),
      description: '炎色反応は青緑。高い電気伝導性と熱伝導性。青銅・黄銅の主成分。',
    ),
    ElementData(
      number: 30,
      symbol: 'Zn',
      name: '亜鉛',
      category: '典型金属',
      mass: 65.38,
      electronShells: [2, 8, 18, 2],
      color: Color(0xFF64748B),
      description: 'トタン（鉄の亜鉛めっき）や乾電池の負極。両性金属。',
    ),
    ElementData(
      number: 31,
      symbol: 'Ga',
      name: 'ガリウム',
      category: '典型金属',
      mass: 69.723,
      electronShells: [2, 8, 18, 3],
      color: Color(0xFF64748B),
      description: '融点が約29.8℃で手のひらで溶ける。青色LED基板（GaN）。',
    ),
    ElementData(
      number: 32,
      symbol: 'Ge',
      name: 'ゲルマニウム',
      category: '半金属',
      mass: 72.63,
      electronShells: [2, 8, 18, 4],
      color: Color(0xFF10B981),
      description: '初期トランジスタ材料。赤外線光学レンズに使用。',
    ),
    ElementData(
      number: 33,
      symbol: 'As',
      name: 'ヒ素',
      category: '半金属',
      mass: 74.922,
      electronShells: [2, 8, 18, 5],
      color: Color(0xFF10B981),
      description: '有毒な半金属。ガリウムヒ素（GaAs）半導体の原料。',
    ),
    ElementData(
      number: 34,
      symbol: 'Se',
      name: 'セレン',
      category: '非金属',
      mass: 78.971,
      electronShells: [2, 8, 18, 6],
      color: Color(0xFF38BDF8),
      description: '光電導性を持ちコピー機感光ドラムやガラス着色に使用。',
    ),
    ElementData(
      number: 35,
      symbol: 'Br',
      name: '臭素',
      category: 'ハロゲン',
      mass: 79.904,
      electronShells: [2, 8, 18, 7],
      color: Color(0xFF06B6D4),
      description: '非金属で唯一の常温液体（赤褐色）。刺激臭。',
    ),
    ElementData(
      number: 36,
      symbol: 'Kr',
      name: 'クリプトン',
      category: '貴ガス',
      mass: 83.798,
      electronShells: [2, 8, 18, 8],
      color: Color(0xFFA855F7),
      description: '空港滑走路の強力フラッシュランプや高性能断熱窓。',
    ),
    ElementData(
      number: 37,
      symbol: 'Rb',
      name: 'ルビジウム',
      category: 'アルカリ金属',
      mass: 85.468,
      electronShells: [2, 8, 18, 8, 1],
      color: Color(0xFFF43F5E),
      description: '炎色反応は暗赤色。原子時計や光電子増倍管。',
    ),
    ElementData(
      number: 38,
      symbol: 'Sr',
      name: 'ストロンチウム',
      category: 'アルカリ土類',
      mass: 87.62,
      electronShells: [2, 8, 18, 8, 2],
      color: Color(0xFFF59E0B),
      description: '炎色反応は深赤色（花火の鮮やかな赤色）。',
    ),
    ElementData(
      number: 39,
      symbol: 'Y',
      name: 'イットリウム',
      category: '遷移金属',
      mass: 88.906,
      electronShells: [2, 8, 18, 9, 2],
      color: Color(0xFFEAB308),
      description: '高温超伝導体（YBCO）やYAGレーザーの構成要素。',
    ),
    ElementData(
      number: 40,
      symbol: 'Zr',
      name: 'ジルコニウム',
      category: '遷移金属',
      mass: 91.224,
      electronShells: [2, 8, 18, 10, 2],
      color: Color(0xFFEAB308),
      description: '中性子吸収断面積が小さく、原子炉の燃料被覆管に使用。',
    ),
    ElementData(
      number: 41,
      symbol: 'Nb',
      name: 'ニオブ',
      category: '遷移金属',
      mass: 92.906,
      electronShells: [2, 8, 18, 12, 1],
      color: Color(0xFFEAB308),
      description: '超伝導磁石（MRI用NbTi線材）や高張力鋼。',
    ),
    ElementData(
      number: 42,
      symbol: 'Mo',
      name: 'モリブデン',
      category: '遷移金属',
      mass: 95.95,
      electronShells: [2, 8, 18, 13, 1],
      color: Color(0xFFEAB308),
      description: '高融点金属。クロムモリブデン鋼や植物の酵素。',
    ),
    ElementData(
      number: 43,
      symbol: 'Tc',
      name: 'テクネチウム',
      category: '遷移金属',
      mass: 98,
      electronShells: [2, 8, 18, 13, 2],
      color: Color(0xFFEAB308),
      description: '人類が最初に人工合成した元素。核医学検査(Tc-99m)。',
    ),
    ElementData(
      number: 44,
      symbol: 'Ru',
      name: 'ルテニウム',
      category: '遷移金属',
      mass: 101.07,
      electronShells: [2, 8, 18, 15, 1],
      color: Color(0xFFEAB308),
      description: '白金族元素。ハードディスク磁気記録層や化学触媒。',
    ),
    ElementData(
      number: 45,
      symbol: 'Rh',
      name: 'ロジウム',
      category: '遷移金属',
      mass: 102.91,
      electronShells: [2, 8, 18, 16, 1],
      color: Color(0xFFEAB308),
      description: '自動車排ガス三元触媒。貴金属の中で極めて高価。',
    ),
    ElementData(
      number: 46,
      symbol: 'Pd',
      name: 'パラジウム',
      category: '遷移金属',
      mass: 106.42,
      electronShells: [2, 8, 18, 18],
      color: Color(0xFFEAB308),
      description: '自身の体積の900倍の水素を吸蔵可能。鈴木・宮浦クロスカップリング触媒。',
    ),
    ElementData(
      number: 47,
      symbol: 'Ag',
      name: '銀',
      category: '遷移金属',
      mass: 107.87,
      electronShells: [2, 8, 18, 18, 1],
      color: Color(0xFFEAB308),
      description: '全物質中最高の電気伝導度・熱伝導率・可視光反射率。',
    ),
    ElementData(
      number: 48,
      symbol: 'Cd',
      name: 'カドミウム',
      category: '典型金属',
      mass: 112.41,
      electronShells: [2, 8, 18, 18, 2],
      color: Color(0xFF64748B),
      description: 'ニカド電池。公害病（イタイイタイ病）の原因物質。',
    ),
    ElementData(
      number: 49,
      symbol: 'In',
      name: 'インジウム',
      category: '典型金属',
      mass: 114.82,
      electronShells: [2, 8, 18, 18, 3],
      color: Color(0xFF64748B),
      description: 'ITO（酸化インジウムスズ）としてスマホ透明電極に不可欠。',
    ),
    ElementData(
      number: 50,
      symbol: 'Sn',
      name: 'スズ',
      category: '典型金属',
      mass: 118.71,
      electronShells: [2, 8, 18, 18, 4],
      color: Color(0xFF64748B),
      description: 'ブリキ（鉄のスズめっき）やはんだ合金の主成分。',
    ),
    ElementData(
      number: 51,
      symbol: 'Sb',
      name: 'アンチモン',
      category: '半金属',
      mass: 121.76,
      electronShells: [2, 8, 18, 18, 5],
      color: Color(0xFF10B981),
      description: '凝固時に体積が膨張する特性。活字合金や難燃剤。',
    ),
    ElementData(
      number: 52,
      symbol: 'Te',
      name: 'テルル',
      category: '半金属',
      mass: 127.6,
      electronShells: [2, 8, 18, 18, 6],
      color: Color(0xFF10B981),
      description: '相変化記録膜（DVD-RAM）や熱電変換素子。',
    ),
    ElementData(
      number: 53,
      symbol: 'I',
      name: 'ヨウ素',
      category: 'ハロゲン',
      mass: 126.9,
      electronShells: [2, 8, 18, 18, 7],
      color: Color(0xFF06B6D4),
      description: '紫黒色の固体で昇華性。デンプン反応や消毒液（うがい薬）。',
    ),
    ElementData(
      number: 54,
      symbol: 'Xe',
      name: 'キセノン',
      category: '貴ガス',
      mass: 131.29,
      electronShells: [2, 8, 18, 18, 8],
      color: Color(0xFFA855F7),
      description: '宇宙探査機のイオンエンジン推進剤（はやぶさ）。',
    ),
    ElementData(
      number: 55,
      symbol: 'Cs',
      name: 'セシウム',
      category: 'アルカリ金属',
      mass: 132.91,
      electronShells: [2, 8, 18, 18, 8, 1],
      color: Color(0xFFF43F5E),
      description: '国際単位系（SI）の1秒の定義基準（Cs-133超微細遷移）。',
    ),
    ElementData(
      number: 56,
      symbol: 'Ba',
      name: 'バリウム',
      category: 'アルカリ土類',
      mass: 137.33,
      electronShells: [2, 8, 18, 18, 8, 2],
      color: Color(0xFFF59E0B),
      description: '炎色反応は黄緑。硫酸バリウムはX線造影剤。',
    ),
    ElementData(
      number: 57,
      symbol: 'La',
      name: 'ランタン',
      category: 'ランタノイド',
      mass: 138.91,
      electronShells: [2, 8, 18, 18, 9, 2],
      color: Color(0xFFEC4899),
      description: 'ランタノイドの起点。光学ガラスレンズ添加剤。',
    ),
    ElementData(
      number: 58,
      symbol: 'Ce',
      name: 'セリウム',
      category: 'ランタノイド',
      mass: 140.12,
      electronShells: [2, 8, 18, 19, 9, 2],
      color: Color(0xFFEC4899),
      description: 'ガラス研磨剤（酸化セリウム）や自動車排ガス浄化触媒。',
    ),
    ElementData(
      number: 59,
      symbol: 'Pr',
      name: 'プラセオジウム',
      category: 'ランタノイド',
      mass: 140.91,
      electronShells: [2, 8, 18, 21, 8, 2],
      color: Color(0xFFEC4899),
      description: 'ネオジム磁石の副成分や黄色陶磁器顔料。',
    ),
    ElementData(
      number: 60,
      symbol: 'Nd',
      name: 'ネオジム',
      category: 'ランタノイド',
      mass: 144.24,
      electronShells: [2, 8, 18, 22, 8, 2],
      color: Color(0xFFEC4899),
      description: '世界最強のネオジム磁石（EVモーターや風力発電機に必須）。',
    ),
    ElementData(
      number: 61,
      symbol: 'Pm',
      name: 'プロメチウム',
      category: 'ランタノイド',
      mass: 145,
      electronShells: [2, 8, 18, 23, 8, 2],
      color: Color(0xFFEC4899),
      description: '天然にはほぼ存在しない放射性希土類。原子力電池。',
    ),
    ElementData(
      number: 62,
      symbol: 'Sm',
      name: 'サマリウム',
      category: 'ランタノイド',
      mass: 150.36,
      electronShells: [2, 8, 18, 24, 8, 2],
      color: Color(0xFFEC4899),
      description: 'サマリウムコバルト磁石（耐熱性に優れる）。',
    ),
    ElementData(
      number: 63,
      symbol: 'Eu',
      name: 'ユウロピウム',
      category: 'ランタノイド',
      mass: 151.96,
      electronShells: [2, 8, 18, 25, 8, 2],
      color: Color(0xFFEC4899),
      description: 'ユーロ紙幣の偽造防止蛍光インクや赤色蛍光体。',
    ),
    ElementData(
      number: 64,
      symbol: 'Gd',
      name: 'ガドリニウム',
      category: 'ランタノイド',
      mass: 157.25,
      electronShells: [2, 8, 18, 25, 9, 2],
      color: Color(0xFFEC4899),
      description: 'MRI造影剤やスーパーカミオカンデの中性子検出剤。',
    ),
    ElementData(
      number: 65,
      symbol: 'Tb',
      name: 'テルビウム',
      category: 'ランタノイド',
      mass: 158.93,
      electronShells: [2, 8, 18, 27, 8, 2],
      color: Color(0xFFEC4899),
      description: '緑色蛍光体や超磁歪材料テルフェノール-D。',
    ),
    ElementData(
      number: 66,
      symbol: 'Dy',
      name: 'ジスプロシウム',
      category: 'ランタノイド',
      mass: 162.5,
      electronShells: [2, 8, 18, 28, 8, 2],
      color: Color(0xFFEC4899),
      description: 'ネオジム磁石の高温耐熱性向上のための添加元素。',
    ),
    ElementData(
      number: 67,
      symbol: 'Ho',
      name: 'ホルミウム',
      category: 'ランタノイド',
      mass: 164.93,
      electronShells: [2, 8, 18, 29, 8, 2],
      color: Color(0xFFEC4899),
      description: '最強の磁気モーメントを持つ。医療用ホルミウムレーザー。',
    ),
    ElementData(
      number: 68,
      symbol: 'Er',
      name: 'エルビウム',
      category: 'ランタノイド',
      mass: 167.26,
      electronShells: [2, 8, 18, 30, 8, 2],
      color: Color(0xFFEC4899),
      description: '光ファイバー通信用光増幅器（EDFA）の核心材料。',
    ),
    ElementData(
      number: 69,
      symbol: 'Tm',
      name: 'ツリウム',
      category: 'ランタノイド',
      mass: 168.93,
      electronShells: [2, 8, 18, 31, 8, 2],
      color: Color(0xFFEC4899),
      description: '可搬型X線装置や外科手術用レーザー。',
    ),
    ElementData(
      number: 70,
      symbol: 'Yb',
      name: 'イッテルビウム',
      category: 'ランタノイド',
      mass: 173.05,
      electronShells: [2, 8, 18, 32, 8, 2],
      color: Color(0xFFEC4899),
      description: '光格子時計の候補原子。高出力Ybファイバーレーザー。',
    ),
    ElementData(
      number: 71,
      symbol: 'Lu',
      name: 'ルテチウム',
      category: 'ランタノイド',
      mass: 174.97,
      electronShells: [2, 8, 18, 32, 9, 2],
      color: Color(0xFFEC4899),
      description: 'ランタノイド最後の元素。PETスキャナーのシンチレータ。',
    ),
    ElementData(
      number: 72,
      symbol: 'Hf',
      name: 'ハフニウム',
      category: '遷移金属',
      mass: 178.49,
      electronShells: [2, 8, 18, 32, 10, 2],
      color: Color(0xFFEAB308),
      description: '高誘電率ゲート絶縁膜（High-k）や原子炉制御棒。',
    ),
    ElementData(
      number: 73,
      symbol: 'Ta',
      name: 'タンタル',
      category: '遷移金属',
      mass: 180.95,
      electronShells: [2, 8, 18, 32, 11, 2],
      color: Color(0xFFEAB308),
      description: 'タンタルコンデンサ（超小型・大容量でスマホに不可欠）。',
    ),
    ElementData(
      number: 74,
      symbol: 'W',
      name: 'タングステン',
      category: '遷移金属',
      mass: 183.84,
      electronShells: [2, 8, 18, 32, 12, 2],
      color: Color(0xFFEAB308),
      description: '全金属中最高融点（3422℃）。超硬工具や白熱電球フィラメント。',
    ),
    ElementData(
      number: 75,
      symbol: 'Re',
      name: 'レニウム',
      category: '遷移金属',
      mass: 186.21,
      electronShells: [2, 8, 18, 32, 13, 2],
      color: Color(0xFFEAB308),
      description: 'ジェットエンジン超合金の耐熱添加剤。',
    ),
    ElementData(
      number: 76,
      symbol: 'Os',
      name: 'オスミウム',
      category: '遷移金属',
      mass: 190.23,
      electronShells: [2, 8, 18, 32, 14, 2],
      color: Color(0xFFEAB308),
      description: '全元素中最大の密度（22.59 g/cm3）。万年筆ペン先。',
    ),
    ElementData(
      number: 77,
      symbol: 'Ir',
      name: 'イリジウム',
      category: '遷移金属',
      mass: 192.22,
      electronShells: [2, 8, 18, 32, 15, 2],
      color: Color(0xFFEAB308),
      description: '白金族で最も耐食性が高い。恐竜絶滅時のK-Pg境界層に濃縮。',
    ),
    ElementData(
      number: 78,
      symbol: 'Pt',
      name: '白金',
      category: '遷移金属',
      mass: 195.08,
      electronShells: [2, 8, 18, 32, 17, 1],
      color: Color(0xFFEAB308),
      description: '燃料電池触媒・排ガス浄化触媒・抗がん剤（シスプラチン）。',
    ),
    ElementData(
      number: 79,
      symbol: 'Au',
      name: '金',
      category: '遷移金属',
      mass: 196.97,
      electronShells: [2, 8, 18, 32, 18, 1],
      color: Color(0xFFEAB308),
      description: '全金属中最大の展性・延性。王水にのみ溶ける不変の貴金属。',
    ),
    ElementData(
      number: 80,
      symbol: 'Hg',
      name: '水銀',
      category: '遷移金属',
      mass: 200.59,
      electronShells: [2, 8, 18, 32, 18, 2],
      color: Color(0xFFEAB308),
      description: '常温で液体の唯一の金属。アマルガム合金や蛍光灯。',
    ),
    ElementData(
      number: 81,
      symbol: 'Tl',
      name: 'タリウム',
      category: '典型金属',
      mass: 204.38,
      electronShells: [2, 8, 18, 32, 18, 3],
      color: Color(0xFF64748B),
      description: '強い毒性を持つ。心筋シンチグラフィ検査用放射性同位体。',
    ),
    ElementData(
      number: 82,
      symbol: 'Pb',
      name: '鉛',
      category: '典型金属',
      mass: 207.2,
      electronShells: [2, 8, 18, 32, 18, 4],
      color: Color(0xFF64748B),
      description: '放射線遮蔽材・鉛蓄電池。ウラン系列崩壊の最終安定同位体。',
    ),
    ElementData(
      number: 83,
      symbol: 'Bi',
      name: 'ビスマス',
      category: '典型金属',
      mass: 208.98,
      electronShells: [2, 8, 18, 32, 18, 5],
      color: Color(0xFF64748B),
      description: '重金属だが毒性が極めて低い。胃腸薬や結晶の虹色酸化膜。',
    ),
    ElementData(
      number: 84,
      symbol: 'Po',
      name: 'ポロニウム',
      category: '半金属',
      mass: 209,
      electronShells: [2, 8, 18, 32, 18, 6],
      color: Color(0xFF10B981),
      description: 'キュリー夫人が祖国ポーランドにちなんで命名。強いアルファ線源。',
    ),
    ElementData(
      number: 85,
      symbol: 'At',
      name: 'アスタチン',
      category: 'ハロゲン',
      mass: 210,
      electronShells: [2, 8, 18, 32, 18, 7],
      color: Color(0xFF06B6D4),
      description: '地殻中に極微量しか存在しない超希少放射性ハロゲン。',
    ),
    ElementData(
      number: 86,
      symbol: 'Rn',
      name: 'ラドン',
      category: '貴ガス',
      mass: 222,
      electronShells: [2, 8, 18, 32, 18, 8],
      color: Color(0xFFA855F7),
      description: '貴ガス唯一の天然放射性同位体。ラドン温泉。',
    ),
    ElementData(
      number: 87,
      symbol: 'Fr',
      name: 'フランシウム',
      category: 'アルカリ金属',
      mass: 223,
      electronShells: [2, 8, 18, 32, 18, 8, 1],
      color: Color(0xFFF43F5E),
      description: '地球全体で数10グラムしか存在しない極めて不安定な元素。',
    ),
    ElementData(
      number: 88,
      symbol: 'Ra',
      name: 'ラジウム',
      category: 'アルカリ土類',
      mass: 226,
      electronShells: [2, 8, 18, 32, 18, 8, 2],
      color: Color(0xFFF59E0B),
      description: 'キュリー夫妻が発見した放射性同位体。夜光塗料に利用された。',
    ),
    ElementData(
      number: 89,
      symbol: 'Ac',
      name: 'アクチニウム',
      category: 'アクチノイド',
      mass: 227,
      electronShells: [2, 8, 18, 32, 18, 9, 2],
      color: Color(0xFF8B5CF6),
      description: 'アクチノイドの起点。強い放射能により青白く発光。',
    ),
    ElementData(
      number: 90,
      symbol: 'Th',
      name: 'トリウム',
      category: 'アクチノイド',
      mass: 232.04,
      electronShells: [2, 8, 18, 32, 18, 10, 2],
      color: Color(0xFF8B5CF6),
      description: '次世代原子炉（トリウム溶融塩炉）の核燃料候補。',
    ),
    ElementData(
      number: 91,
      symbol: 'Pa',
      name: 'プロトアクチニウム',
      category: 'アクチノイド',
      mass: 231.04,
      electronShells: [2, 8, 18, 32, 20, 9, 2],
      color: Color(0xFF8B5CF6),
      description: 'ウラン崩壊系列の中間生成物。',
    ),
    ElementData(
      number: 92,
      symbol: 'U',
      name: 'ウラン',
      category: 'アクチノイド',
      mass: 238.03,
      electronShells: [2, 8, 18, 32, 21, 9, 2],
      color: Color(0xFF8B5CF6),
      description: '原子力発電の主燃料（U-235）。天然に存在する最重元素。',
    ),
    ElementData(
      number: 93,
      symbol: 'Np',
      name: 'ネプツニウム',
      category: 'アクチノイド',
      mass: 237,
      electronShells: [2, 8, 18, 32, 22, 9, 2],
      color: Color(0xFF8B5CF6),
      description: '最初の超ウラン元素。海王星（Neptune）にちなむ。',
    ),
    ElementData(
      number: 94,
      symbol: 'Pu',
      name: 'プルトニウム',
      category: 'アクチノイド',
      mass: 244,
      electronShells: [2, 8, 18, 32, 24, 8, 2],
      color: Color(0xFF8B5CF6),
      description: '原子炉内で生成される核燃料。宇宙探査機RTG電源（Pu-238）。',
    ),
    ElementData(
      number: 95,
      symbol: 'Am',
      name: 'アメリシウム',
      category: 'アクチノイド',
      mass: 243,
      electronShells: [2, 8, 18, 32, 25, 8, 2],
      color: Color(0xFF8B5CF6),
      description: '家庭用煙感知器のイオン化線源。',
    ),
    ElementData(
      number: 96,
      symbol: 'Cm',
      name: 'キュリウム',
      category: 'アクチノイド',
      mass: 247,
      electronShells: [2, 8, 18, 32, 25, 9, 2],
      color: Color(0xFF8B5CF6),
      description: 'キュリー夫妻にちなむ。火星探査ローバーのα線X線分光器。',
    ),
    ElementData(
      number: 97,
      symbol: 'Bk',
      name: 'バークリウム',
      category: 'アクチノイド',
      mass: 247,
      electronShells: [2, 8, 18, 32, 27, 8, 2],
      color: Color(0xFF8B5CF6),
      description: 'カリフォルニア大学バークレー校にちなむ。',
    ),
    ElementData(
      number: 98,
      symbol: 'Cf',
      name: 'カリホルニウム',
      category: 'アクチノイド',
      mass: 251,
      electronShells: [2, 8, 18, 32, 28, 8, 2],
      color: Color(0xFF8B5CF6),
      description: '強力な中性子源。原子炉の始動用中性子源。',
    ),
    ElementData(
      number: 99,
      symbol: 'Es',
      name: 'アインスタイニウム',
      category: 'アクチノイド',
      mass: 252,
      electronShells: [2, 8, 18, 32, 29, 8, 2],
      color: Color(0xFF8B5CF6),
      description: 'アインシュタインにちなむ。水爆実験の残骸から発見。',
    ),
    ElementData(
      number: 100,
      symbol: 'Fm',
      name: 'フェルミウム',
      category: 'アクチノイド',
      mass: 257,
      electronShells: [2, 8, 18, 32, 30, 8, 2],
      color: Color(0xFF8B5CF6),
      description: '物理学者エンリコ・フェルミにちなむ。',
    ),
    ElementData(
      number: 101,
      symbol: 'Md',
      name: 'メンデレビウム',
      category: 'アクチノイド',
      mass: 258,
      electronShells: [2, 8, 18, 32, 31, 8, 2],
      color: Color(0xFF8B5CF6),
      description: '周期表の考案者メンデレーエフにちなむ。',
    ),
    ElementData(
      number: 102,
      symbol: 'No',
      name: 'ノーベリウム',
      category: 'アクチノイド',
      mass: 259,
      electronShells: [2, 8, 18, 32, 32, 8, 2],
      color: Color(0xFF8B5CF6),
      description: 'アルフレッド・ノーベルにちなむ。',
    ),
    ElementData(
      number: 103,
      symbol: 'Lr',
      name: 'ローレンシウム',
      category: 'アクチノイド',
      mass: 266,
      electronShells: [2, 8, 18, 32, 32, 8, 3],
      color: Color(0xFF8B5CF6),
      description: 'サイクロトロン発明者ローレンスにちなむ。',
    ),
    ElementData(
      number: 104,
      symbol: 'Rf',
      name: 'ラザホージウム',
      category: '遷移金属',
      mass: 267,
      electronShells: [2, 8, 18, 32, 32, 10, 2],
      color: Color(0xFFEAB308),
      description: '原子核モデルを提唱したラザフォードにちなむ超重元素。',
    ),
    ElementData(
      number: 105,
      symbol: 'Db',
      name: 'ドブニウム',
      category: '遷移金属',
      mass: 268,
      electronShells: [2, 8, 18, 32, 32, 11, 2],
      color: Color(0xFFEAB308),
      description: 'ロシアの原子核研究所の地名ドゥブナにちなむ。',
    ),
    ElementData(
      number: 106,
      symbol: 'Sg',
      name: 'シーボーギウム',
      category: '遷移金属',
      mass: 269,
      electronShells: [2, 8, 18, 32, 32, 12, 2],
      color: Color(0xFFEAB308),
      description: 'グレン・シーボーグにちなむ（存命中に命名された初例）。',
    ),
    ElementData(
      number: 107,
      symbol: 'Bh',
      name: 'ボーリウム',
      category: '遷移金属',
      mass: 270,
      electronShells: [2, 8, 18, 32, 32, 13, 2],
      color: Color(0xFFEAB308),
      description: '量子力学の先駆者ニールス・ボーアにちなむ。',
    ),
    ElementData(
      number: 108,
      symbol: 'Hs',
      name: 'ハッシウム',
      category: '遷移金属',
      mass: 269,
      electronShells: [2, 8, 18, 32, 32, 14, 2],
      color: Color(0xFFEAB308),
      description: 'ドイツのヘッセン州のラテン語名にちなむ。',
    ),
    ElementData(
      number: 109,
      symbol: 'Mt',
      name: 'マイトネリウム',
      category: '遷移金属',
      mass: 278,
      electronShells: [2, 8, 18, 32, 32, 15, 2],
      color: Color(0xFFEAB308),
      description: '核分裂の理論的解明に貢献したリーゼ・マイトナーにちなむ。',
    ),
    ElementData(
      number: 110,
      symbol: 'Ds',
      name: 'ダームスタチウム',
      category: '遷移金属',
      mass: 281,
      electronShells: [2, 8, 18, 32, 32, 16, 2],
      color: Color(0xFFEAB308),
      description: '発見地ドイツ・ダルムシュタットにちなむ。',
    ),
    ElementData(
      number: 111,
      symbol: 'Rg',
      name: 'レントゲニウム',
      category: '遷移金属',
      mass: 282,
      electronShells: [2, 8, 18, 32, 32, 17, 2],
      color: Color(0xFFEAB308),
      description: 'X線を発見したヴィルヘルム・レントゲンにちなむ。',
    ),
    ElementData(
      number: 112,
      symbol: 'Cn',
      name: 'コペルニシウム',
      category: '遷移金属',
      mass: 285,
      electronShells: [2, 8, 18, 32, 32, 18, 2],
      color: Color(0xFFEAB308),
      description: '地動説を提唱したニコラウス・コペルニクスにちなむ。',
    ),
    ElementData(
      number: 113,
      symbol: 'Nh',
      name: 'ニホニウム',
      category: '典型金属',
      mass: 286,
      electronShells: [2, 8, 18, 32, 32, 18, 3],
      color: Color(0xFF64748B),
      description: '日本（理化学研究所森田グループ）がアジアで初めて命名権を獲得した超重元素。',
    ),
    ElementData(
      number: 114,
      symbol: 'Fl',
      name: 'フレロビウム',
      category: '典型金属',
      mass: 289,
      electronShells: [2, 8, 18, 32, 32, 18, 4],
      color: Color(0xFF64748B),
      description: 'ロシアの核物理学者ゲオルギー・フリョロフにちなむ。',
    ),
    ElementData(
      number: 115,
      symbol: 'Mc',
      name: 'モスコビウム',
      category: '典型金属',
      mass: 290,
      electronShells: [2, 8, 18, 32, 32, 18, 5],
      color: Color(0xFF64748B),
      description: 'モスクワ州にちなんで命名された第15族超重元素。',
    ),
    ElementData(
      number: 116,
      symbol: 'Lv',
      name: 'リバモリウム',
      category: '典型金属',
      mass: 293,
      electronShells: [2, 8, 18, 32, 32, 18, 6],
      color: Color(0xFF64748B),
      description: 'アメリカのローレンス・リバモア国立研究所にちなむ。',
    ),
    ElementData(
      number: 117,
      symbol: 'Ts',
      name: 'テネシン',
      category: 'ハロゲン',
      mass: 294,
      electronShells: [2, 8, 18, 32, 32, 18, 7],
      color: Color(0xFF06B6D4),
      description: 'オークリッジ国立研究所があるテネシー州にちなむハロゲン元素。',
    ),
    ElementData(
      number: 118,
      symbol: 'Og',
      name: 'オガネソン',
      category: '貴ガス',
      mass: 294,
      electronShells: [2, 8, 18, 32, 32, 18, 8],
      color: Color(0xFFA855F7),
      description: '第18族貴ガスの最後を飾る原子番号118の超重元素。物理学者オガネシアンにちなむ。',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedElement = _elements[5]; // Carbon default
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['すべて', '非金属', 'アルカリ金属', 'アルカリ土類', '遷移金属', 'ハロゲン', '貴ガス', '典型金属', '半金属', 'ランタノイド', 'アクチノイド'];

    final filteredElements = _elements.where((e) {
      final matchesCat = _selectedCategory == 'すべて' || e.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          e.name.contains(_searchQuery) ||
          e.symbol.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.number.toString() == _searchQuery;
      return matchesCat && matchesSearch;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search & Filter
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              children: [
                TextField(
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: '元素名・記号・原子番号 (1〜118) で検索...',
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
                      _searchQuery = val.trim();
                    });
                  },
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((cat) {
                      final isSelected = (_selectedCategory == cat);
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: const Color(0xFF38BDF8).withValues(alpha: 0.3),
                          labelStyle: TextStyle(
                            color: isSelected ? const Color(0xFF38BDF8) : Colors.white60,
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (val) {
                            if (val) setState(() => _selectedCategory = cat);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Selected Element Detailed Card with Bohr Orbit
          if (_selectedElement != null) _buildDetailCard(_selectedElement!),

          const SizedBox(height: 16),

          // Elements Grid (1 to 118)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '元素一覧 (${filteredElements.length} / 118 元素)',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Text(
                'タップで詳細＆電子軌道表示',
                style: TextStyle(fontSize: 11, color: Colors.white38),
              ),
            ],
          ),
          const SizedBox(height: 10),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 0.85,
            ),
            itemCount: filteredElements.length,
            itemBuilder: (context, idx) {
              final elem = filteredElements[idx];
              final isSelected = _selectedElement?.number == elem.number;

              return InkWell(
                onTap: () {
                  setState(() => _selectedElement = elem);
                },
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected ? elem.color.withValues(alpha: 0.3) : const Color(0xFF131B2E),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? elem.color : elem.color.withValues(alpha: 0.2),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        elem.number.toString(),
                        style: TextStyle(fontSize: 8, color: elem.color.withValues(alpha: 0.8), fontWeight: FontWeight.bold),
                      ),
                      Text(
                        elem.symbol,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: elem.color,
                        ),
                      ),
                      Text(
                        elem.name,
                        style: const TextStyle(fontSize: 8, color: Colors.white70),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(ElementData elem) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: elem.color.withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: elem.color.withValues(alpha: 0.1),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Element symbol box
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: elem.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: elem.color, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      elem.number.toString(),
                      style: TextStyle(fontSize: 11, color: elem.color, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      elem.symbol,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: elem.color),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          elem.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: elem.color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: elem.color.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            elem.category,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: elem.color),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('原子量: ${elem.mass}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                    const SizedBox(height: 2),
                    Text(
                      '電子配置 (K,L,M,N,O,P,Q): ${elem.electronShells.join(", ")}',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF38BDF8)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              elem.description,
              style: const TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
            ),
          ),
          const SizedBox(height: 16),
          // Bohr Model Orbit Visualizer
          Center(
            child: Column(
              children: [
                const Text('ボーア模型（電子配置ビジュアライザー）', style: TextStyle(fontSize: 11, color: Colors.white54)),
                const SizedBox(height: 8),
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CustomPaint(
                    painter: _BohrModelPainter(elem: elem),
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

class _BohrModelPainter extends CustomPainter {
  final ElementData elem;

  _BohrModelPainter({required this.elem});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw Nucleus
    final nucleusPaint = Paint()..color = elem.color;
    canvas.drawCircle(center, 12, nucleusPaint);

    final textSpan = TextSpan(
      text: '+${elem.number}',
      style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold),
    );
    final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));

    // Draw Electron Shells
    final maxRadius = size.width / 2 - 8;
    final shellsCount = elem.electronShells.length;
    final radiusStep = maxRadius / (shellsCount + 1);

    for (int i = 0; i < shellsCount; i++) {
      final r = radiusStep * (i + 1);
      final orbitPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawCircle(center, r, orbitPaint);

      final electronsInShell = elem.electronShells[i];
      for (int e = 0; e < electronsInShell; e++) {
        final angle = (2 * math.pi / electronsInShell) * e;
        final ex = center.dx + r * math.cos(angle);
        final ey = center.dy + r * math.sin(angle);

        final electronPaint = Paint()..color = const Color(0xFF38BDF8);
        canvas.drawCircle(Offset(ex, ey), 3.5, electronPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BohrModelPainter oldDelegate) => oldDelegate.elem.number != elem.number;
}
