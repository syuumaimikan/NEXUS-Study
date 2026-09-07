const fs = require('fs');
const path = require('path');

const elements = [
  { n: 1, s: "H", name: "水素", cat: "非金属", m: 1.008, shells: [1], c: "0xFF38BDF8", desc: "宇宙で最も豊富な元素。無色・無臭・可燃性気体。" },
  { n: 2, s: "He", name: "ヘリウム", cat: "貴ガス", m: 4.003, shells: [2], c: "0xFFA855F7", desc: "最も不活性な貴ガス。沸点は全物質中最低(-268.9℃)。" },
  { n: 3, s: "Li", name: "リチウム", cat: "アルカリ金属", m: 6.94, shells: [2, 1], c: "0xFFF43F5E", desc: "最も軽い金属。リチウムイオン電池の正極・負極に必須。" },
  { n: 4, s: "Be", name: "ベリリウム", cat: "アルカリ土類", m: 9.012, shells: [2, 2], c: "0xFFF59E0B", desc: "X線透過性が高く、エメラルドの構成成分。" },
  { n: 5, s: "B", name: "ホウ素", cat: "半金属", m: 10.81, shells: [2, 3], c: "0xFF10B981", desc: "耐熱ガラス（パイレックス）や半導体のドーパント。" },
  { n: 6, s: "C", name: "炭素", cat: "非金属", m: 12.011, shells: [2, 4], c: "0xFF38BDF8", desc: "生命の基盤。ダイヤモンド、黒鉛、フラーレン等の同素体を持つ。" },
  { n: 7, s: "N", name: "窒素", cat: "非金属", m: 14.007, shells: [2, 5], c: "0xFF38BDF8", desc: "大気の約78%を占める。三重結合による極めて高い安定性。" },
  { n: 8, s: "O", name: "酸素", cat: "非金属", m: 15.999, shells: [2, 6], c: "0xFF38BDF8", desc: "大気の約21%、地殻の46%を占める。生物呼吸に必須。" },
  { n: 9, s: "F", name: "フッ素", cat: "ハロゲン", m: 18.998, shells: [2, 7], c: "0xFF06B6D4", desc: "全元素中最大の電気陰性度(4.0)。極めて強い酸化力。" },
  { n: 10, s: "Ne", name: "ネオン", cat: "貴ガス", m: 20.18, shells: [2, 8], c: "0xFFA855F7", desc: "放電管で赤橙色に発光（ネオンサイン）。閉殻構造。" },
  { n: 11, s: "Na", name: "ナトリウム", cat: "アルカリ金属", m: 22.99, shells: [2, 8, 1], c: "0xFFF43F5E", desc: "炎色反応は黄色。水と激しく反応し水素を発生。" },
  { n: 12, s: "Mg", name: "マグネシウム", cat: "アルカリ土類", m: 24.305, shells: [2, 8, 2], c: "0xFFF59E0B", desc: "葉緑素（クロロフィル）の中心金属。実用金属中最も軽量級。" },
  { n: 13, s: "Al", name: "アルミニウム", cat: "典型金属", m: 26.982, shells: [2, 8, 3], c: "0xFF64748B", desc: "地殻中金属元素で最多。ボーキサイトから溶融塩電解で精錬。" },
  { n: 14, s: "Si", name: "ケイ素", cat: "半金属", m: 28.085, shells: [2, 8, 4], c: "0xFF10B981", desc: "半導体産業の中心。地殻質量第2位（クラーク数2位）。" },
  { n: 15, s: "P", name: "リン", cat: "非金属", m: 30.974, shells: [2, 8, 5], c: "0xFF38BDF8", desc: "DNAやATPの骨格。黄リン（有毒・自然発火）と赤リンの同素体。" },
  { n: 16, s: "S", name: "硫黄", cat: "非金属", m: 32.06, shells: [2, 8, 6], c: "0xFF38BDF8", desc: "斜方硫黄・単斜硫黄・ゴム状硫黄の同素体。硫酸の原料。" },
  { n: 17, s: "Cl", name: "塩素", cat: "ハロゲン", m: 35.45, shells: [2, 8, 7], c: "0xFF06B6D4", desc: "黄緑色の有毒気体。水道水殺菌や漂白剤、塩酸に使用。" },
  { n: 18, s: "Ar", name: "アルゴン", cat: "貴ガス", m: 39.95, shells: [2, 8, 8], c: "0xFFA855F7", desc: "大気中に約0.93%存在。白熱電球や溶接の保護ガス。" },
  { n: 19, s: "K", name: "カリウム", cat: "アルカリ金属", m: 39.098, shells: [2, 8, 8, 1], c: "0xFFF43F5E", desc: "炎色反応は赤紫。神経伝達や植物三大肥料（N, P, K）の一角。" },
  { n: 20, s: "Ca", name: "カルシウム", cat: "アルカリ土類", m: 40.078, shells: [2, 8, 8, 2], c: "0xFFF59E0B", desc: "炎色反応は橙赤。骨・歯の主成分、セメントの主原料。" },
  { n: 21, s: "Sc", name: "スカンジウム", cat: "遷移金属", m: 44.956, shells: [2, 8, 9, 2], c: "0xFFEAB308", desc: "最初の遷移金属。アルミニウム合金の強化に使用。" },
  { n: 22, s: "Ti", name: "チタン", cat: "遷移金属", m: 47.867, shells: [2, 8, 10, 2], c: "0xFFEAB308", desc: "比強度が高く耐食性に優れる。航空宇宙・人工関節に多用。" },
  { n: 23, s: "V", name: "バナジウム", cat: "遷移金属", m: 50.942, shells: [2, 8, 11, 2], c: "0xFFEAB308", desc: "耐摩耗性鋼の添加剤。酸化数は+2から+5まで多彩な色を示す。" },
  { n: 24, s: "Cr", name: "クロム", cat: "遷移金属", m: 51.996, shells: [2, 8, 13, 1], c: "0xFFEAB308", desc: "ステンレス鋼の主要成分（不動態皮膜を形成）。" },
  { n: 25, s: "Mn", name: "マンガン", cat: "遷移金属", m: 54.938, shells: [2, 8, 13, 2], c: "0xFFEAB308", desc: "乾電池（MnO2）や製鋼用脱酸剤。過マンガン酸カリウムは強酸化剤。" },
  { n: 26, s: "Fe", name: "鉄", cat: "遷移金属", m: 55.845, shells: [2, 8, 14, 2], c: "0xFFEAB308", desc: "人類社会を支える最も重要な金属。ヘモグロビンの中心原子。" },
  { n: 27, s: "Co", name: "コバルト", cat: "遷移金属", m: 58.933, shells: [2, 8, 15, 2], c: "0xFFEAB308", desc: "ビタミンB12の中心金属。強力な磁石材料（サマリウムコバルト）。" },
  { n: 28, s: "Ni", name: "ニッケル", cat: "遷移金属", m: 58.693, shells: [2, 8, 16, 2], c: "0xFFEAB308", desc: "ステンレス鋼・ニッケル水素電池・硬貨の原料。" },
  { n: 29, s: "Cu", name: "銅", cat: "遷移金属", m: 63.546, shells: [2, 8, 18, 1], c: "0xFFEAB308", desc: "炎色反応は青緑。高い電気伝導性と熱伝導性。青銅・黄銅の主成分。" },
  { n: 30, s: "Zn", name: "亜鉛", cat: "典型金属", m: 65.38, shells: [2, 8, 18, 2], c: "0xFF64748B", desc: "トタン（鉄の亜鉛めっき）や乾電池の負極。両性金属。" },
  { n: 31, s: "Ga", name: "ガリウム", cat: "典型金属", m: 69.723, shells: [2, 8, 18, 3], c: "0xFF64748B", desc: "融点が約29.8℃で手のひらで溶ける。青色LED基板（GaN）。" },
  { n: 32, s: "Ge", name: "ゲルマニウム", cat: "半金属", m: 72.63, shells: [2, 8, 18, 4], c: "0xFF10B981", desc: "初期トランジスタ材料。赤外線光学レンズに使用。" },
  { n: 33, s: "As", name: "ヒ素", cat: "半金属", m: 74.922, shells: [2, 8, 18, 5], c: "0xFF10B981", desc: "有毒な半金属。ガリウムヒ素（GaAs）半導体の原料。" },
  { n: 34, s: "Se", name: "セレン", cat: "非金属", m: 78.971, shells: [2, 8, 18, 6], c: "0xFF38BDF8", desc: "光電導性を持ちコピー機感光ドラムやガラス着色に使用。" },
  { n: 35, s: "Br", name: "臭素", cat: "ハロゲン", m: 79.904, shells: [2, 8, 18, 7], c: "0xFF06B6D4", desc: "非金属で唯一の常温液体（赤褐色）。刺激臭。" },
  { n: 36, s: "Kr", name: "クリプトン", cat: "貴ガス", m: 83.798, shells: [2, 8, 18, 8], c: "0xFFA855F7", desc: "空港滑走路の強力フラッシュランプや高性能断熱窓。" },
  { n: 37, s: "Rb", name: "ルビジウム", cat: "アルカリ金属", m: 85.468, shells: [2, 8, 18, 8, 1], c: "0xFFF43F5E", desc: "炎色反応は暗赤色。原子時計や光電子増倍管。" },
  { n: 38, s: "Sr", name: "ストロンチウム", cat: "アルカリ土類", m: 87.62, shells: [2, 8, 18, 8, 2], c: "0xFFF59E0B", desc: "炎色反応は深赤色（花火の鮮やかな赤色）。" },
  { n: 39, s: "Y", name: "イットリウム", cat: "遷移金属", m: 88.906, shells: [2, 8, 18, 9, 2], c: "0xFFEAB308", desc: "高温超伝導体（YBCO）やYAGレーザーの構成要素。" },
  { n: 40, s: "Zr", name: "ジルコニウム", cat: "遷移金属", m: 91.224, shells: [2, 8, 18, 10, 2], c: "0xFFEAB308", desc: "中性子吸収断面積が小さく、原子炉の燃料被覆管に使用。" },
  { n: 41, s: "Nb", name: "ニオブ", cat: "遷移金属", m: 92.906, shells: [2, 8, 18, 12, 1], c: "0xFFEAB308", desc: "超伝導磁石（MRI用NbTi線材）や高張力鋼。" },
  { n: 42, s: "Mo", name: "モリブデン", cat: "遷移金属", m: 95.95, shells: [2, 8, 18, 13, 1], c: "0xFFEAB308", desc: "高融点金属。クロムモリブデン鋼や植物の酵素。" },
  { n: 43, s: "Tc", name: "テクネチウム", cat: "遷移金属", m: 98.0, shells: [2, 8, 18, 13, 2], c: "0xFFEAB308", desc: "人類が最初に人工合成した元素。核医学検査(Tc-99m)。" },
  { n: 44, s: "Ru", name: "ルテニウム", cat: "遷移金属", m: 101.07, shells: [2, 8, 18, 15, 1], c: "0xFFEAB308", desc: "白金族元素。ハードディスク磁気記録層や化学触媒。" },
  { n: 45, s: "Rh", name: "ロジウム", cat: "遷移金属", m: 102.91, shells: [2, 8, 18, 16, 1], c: "0xFFEAB308", desc: "自動車排ガス三元触媒。貴金属の中で極めて高価。" },
  { n: 46, s: "Pd", name: "パラジウム", cat: "遷移金属", m: 106.42, shells: [2, 8, 18, 18], c: "0xFFEAB308", desc: "自身の体積の900倍の水素を吸蔵可能。鈴木・宮浦クロスカップリング触媒。" },
  { n: 47, s: "Ag", name: "銀", cat: "遷移金属", m: 107.87, shells: [2, 8, 18, 18, 1], c: "0xFFEAB308", desc: "全物質中最高の電気伝導度・熱伝導率・可視光反射率。" },
  { n: 48, s: "Cd", name: "カドミウム", cat: "典型金属", m: 112.41, shells: [2, 8, 18, 18, 2], c: "0xFF64748B", desc: "ニカド電池。公害病（イタイイタイ病）の原因物質。" },
  { n: 49, s: "In", name: "インジウム", cat: "典型金属", m: 114.82, shells: [2, 8, 18, 18, 3], c: "0xFF64748B", desc: "ITO（酸化インジウムスズ）としてスマホ透明電極に不可欠。" },
  { n: 50, s: "Sn", name: "スズ", cat: "典型金属", m: 118.71, shells: [2, 8, 18, 18, 4], c: "0xFF64748B", desc: "ブリキ（鉄のスズめっき）やはんだ合金の主成分。" },
  { n: 51, s: "Sb", name: "アンチモン", cat: "半金属", m: 121.76, shells: [2, 8, 18, 18, 5], c: "0xFF10B981", desc: "凝固時に体積が膨張する特性。活字合金や難燃剤。" },
  { n: 52, s: "Te", name: "テルル", cat: "半金属", m: 127.6, shells: [2, 8, 18, 18, 6], c: "0xFF10B981", desc: "相変化記録膜（DVD-RAM）や熱電変換素子。" },
  { n: 53, s: "I", name: "ヨウ素", cat: "ハロゲン", m: 126.9, shells: [2, 8, 18, 18, 7], c: "0xFF06B6D4", desc: "紫黒色の固体で昇華性。デンプン反応や消毒液（うがい薬）。" },
  { n: 54, s: "Xe", name: "キセノン", cat: "貴ガス", m: 131.29, shells: [2, 8, 18, 18, 8], c: "0xFFA855F7", desc: "宇宙探査機のイオンエンジン推進剤（はやぶさ）。" },
  { n: 55, s: "Cs", name: "セシウム", cat: "アルカリ金属", m: 132.91, shells: [2, 8, 18, 18, 8, 1], c: "0xFFF43F5E", desc: "国際単位系（SI）の1秒の定義基準（Cs-133超微細遷移）。" },
  { n: 56, s: "Ba", name: "バリウム", cat: "アルカリ土類", m: 137.33, shells: [2, 8, 18, 18, 8, 2], c: "0xFFF59E0B", desc: "炎色反応は黄緑。硫酸バリウムはX線造影剤。" },
  { n: 57, s: "La", name: "ランタン", cat: "ランタノイド", m: 138.91, shells: [2, 8, 18, 18, 9, 2], c: "0xFFEC4899", desc: "ランタノイドの起点。光学ガラスレンズ添加剤。" },
  { n: 58, s: "Ce", name: "セリウム", cat: "ランタノイド", m: 140.12, shells: [2, 8, 18, 19, 9, 2], c: "0xFFEC4899", desc: "ガラス研磨剤（酸化セリウム）や自動車排ガス浄化触媒。" },
  { n: 59, s: "Pr", name: "プラセオジウム", cat: "ランタノイド", m: 140.91, shells: [2, 8, 18, 21, 8, 2], c: "0xFFEC4899", desc: "ネオジム磁石の副成分や黄色陶磁器顔料。" },
  { n: 60, s: "Nd", name: "ネオジム", cat: "ランタノイド", m: 144.24, shells: [2, 8, 18, 22, 8, 2], c: "0xFFEC4899", desc: "世界最強のネオジム磁石（EVモーターや風力発電機に必須）。" },
  { n: 61, s: "Pm", name: "プロメチウム", cat: "ランタノイド", m: 145.0, shells: [2, 8, 18, 23, 8, 2], c: "0xFFEC4899", desc: "天然にはほぼ存在しない放射性希土類。原子力電池。" },
  { n: 62, s: "Sm", name: "サマリウム", cat: "ランタノイド", m: 150.36, shells: [2, 8, 18, 24, 8, 2], c: "0xFFEC4899", desc: "サマリウムコバルト磁石（耐熱性に優れる）。" },
  { n: 63, s: "Eu", name: "ユウロピウム", cat: "ランタノイド", m: 151.96, shells: [2, 8, 18, 25, 8, 2], c: "0xFFEC4899", desc: "ユーロ紙幣の偽造防止蛍光インクや赤色蛍光体。" },
  { n: 64, s: "Gd", name: "ガドリニウム", cat: "ランタノイド", m: 157.25, shells: [2, 8, 18, 25, 9, 2], c: "0xFFEC4899", desc: "MRI造影剤やスーパーカミオカンデの中性子検出剤。" },
  { n: 65, s: "Tb", name: "テルビウム", cat: "ランタノイド", m: 158.93, shells: [2, 8, 18, 27, 8, 2], c: "0xFFEC4899", desc: "緑色蛍光体や超磁歪材料テルフェノール-D。" },
  { n: 66, s: "Dy", name: "ジスプロシウム", cat: "ランタノイド", m: 162.5, shells: [2, 8, 18, 28, 8, 2], c: "0xFFEC4899", desc: "ネオジム磁石の高温耐熱性向上のための添加元素。" },
  { n: 67, s: "Ho", name: "ホルミウム", cat: "ランタノイド", m: 164.93, shells: [2, 8, 18, 29, 8, 2], c: "0xFFEC4899", desc: "最強の磁気モーメントを持つ。医療用ホルミウムレーザー。" },
  { n: 68, s: "Er", name: "エルビウム", cat: "ランタノイド", m: 167.26, shells: [2, 8, 18, 30, 8, 2], c: "0xFFEC4899", desc: "光ファイバー通信用光増幅器（EDFA）の核心材料。" },
  { n: 69, s: "Tm", name: "ツリウム", cat: "ランタノイド", m: 168.93, shells: [2, 8, 18, 31, 8, 2], c: "0xFFEC4899", desc: "可搬型X線装置や外科手術用レーザー。" },
  { n: 70, s: "Yb", name: "イッテルビウム", cat: "ランタノイド", m: 173.05, shells: [2, 8, 18, 32, 8, 2], c: "0xFFEC4899", desc: "光格子時計の候補原子。高出力Ybファイバーレーザー。" },
  { n: 71, s: "Lu", name: "ルテチウム", cat: "ランタノイド", m: 174.97, shells: [2, 8, 18, 32, 9, 2], c: "0xFFEC4899", desc: "ランタノイド最後の元素。PETスキャナーのシンチレータ。" },
  { n: 72, s: "Hf", name: "ハフニウム", cat: "遷移金属", m: 178.49, shells: [2, 8, 18, 32, 10, 2], c: "0xFFEAB308", desc: "高誘電率ゲート絶縁膜（High-k）や原子炉制御棒。" },
  { n: 73, s: "Ta", name: "タンタル", cat: "遷移金属", m: 180.95, shells: [2, 8, 18, 32, 11, 2], c: "0xFFEAB308", desc: "タンタルコンデンサ（超小型・大容量でスマホに不可欠）。" },
  { n: 74, s: "W", name: "タングステン", cat: "遷移金属", m: 183.84, shells: [2, 8, 18, 32, 12, 2], c: "0xFFEAB308", desc: "全金属中最高融点（3422℃）。超硬工具や白熱電球フィラメント。" },
  { n: 75, s: "Re", name: "レニウム", cat: "遷移金属", m: 186.21, shells: [2, 8, 18, 32, 13, 2], c: "0xFFEAB308", desc: "ジェットエンジン超合金の耐熱添加剤。" },
  { n: 76, s: "Os", name: "オスミウム", cat: "遷移金属", m: 190.23, shells: [2, 8, 18, 32, 14, 2], c: "0xFFEAB308", desc: "全元素中最大の密度（22.59 g/cm3）。万年筆ペン先。" },
  { n: 77, s: "Ir", name: "イリジウム", cat: "遷移金属", m: 192.22, shells: [2, 8, 18, 32, 15, 2], c: "0xFFEAB308", desc: "白金族で最も耐食性が高い。恐竜絶滅時のK-Pg境界層に濃縮。" },
  { n: 78, s: "Pt", name: "白金", cat: "遷移金属", m: 195.08, shells: [2, 8, 18, 32, 17, 1], c: "0xFFEAB308", desc: "燃料電池触媒・排ガス浄化触媒・抗がん剤（シスプラチン）。" },
  { n: 79, s: "Au", name: "金", cat: "遷移金属", m: 196.97, shells: [2, 8, 18, 32, 18, 1], c: "0xFFEAB308", desc: "全金属中最大の展性・延性。王水にのみ溶ける不変の貴金属。" },
  { n: 80, s: "Hg", name: "水銀", cat: "遷移金属", m: 200.59, shells: [2, 8, 18, 32, 18, 2], c: "0xFFEAB308", desc: "常温で液体の唯一の金属。アマルガム合金や蛍光灯。" },
  { n: 81, s: "Tl", name: "タリウム", cat: "典型金属", m: 204.38, shells: [2, 8, 18, 32, 18, 3], c: "0xFF64748B", desc: "強い毒性を持つ。心筋シンチグラフィ検査用放射性同位体。" },
  { n: 82, s: "Pb", name: "鉛", cat: "典型金属", m: 207.2, shells: [2, 8, 18, 32, 18, 4], c: "0xFF64748B", desc: "放射線遮蔽材・鉛蓄電池。ウラン系列崩壊の最終安定同位体。" },
  { n: 83, s: "Bi", name: "ビスマス", cat: "典型金属", m: 208.98, shells: [2, 8, 18, 32, 18, 5], c: "0xFF64748B", desc: "重金属だが毒性が極めて低い。胃腸薬や結晶の虹色酸化膜。" },
  { n: 84, s: "Po", name: "ポロニウム", cat: "半金属", m: 209.0, shells: [2, 8, 18, 32, 18, 6], c: "0xFF10B981", desc: "キュリー夫人が祖国ポーランドにちなんで命名。強いアルファ線源。" },
  { n: 85, s: "At", name: "アスタチン", cat: "ハロゲン", m: 210.0, shells: [2, 8, 18, 32, 18, 7], c: "0xFF06B6D4", desc: "地殻中に極微量しか存在しない超希少放射性ハロゲン。" },
  { n: 86, s: "Rn", name: "ラドン", cat: "貴ガス", m: 222.0, shells: [2, 8, 18, 32, 18, 8], c: "0xFFA855F7", desc: "貴ガス唯一の天然放射性同位体。ラドン温泉。" },
  { n: 87, s: "Fr", name: "フランシウム", cat: "アルカリ金属", m: 223.0, shells: [2, 8, 18, 32, 18, 8, 1], c: "0xFFF43F5E", desc: "地球全体で数10グラムしか存在しない極めて不安定な元素。" },
  { n: 88, s: "Ra", name: "ラジウム", cat: "アルカリ土類", m: 226.0, shells: [2, 8, 18, 32, 18, 8, 2], c: "0xFFF59E0B", desc: "キュリー夫妻が発見した放射性同位体。夜光塗料に利用された。" },
  { n: 89, s: "Ac", name: "アクチニウム", cat: "アクチノイド", m: 227.0, shells: [2, 8, 18, 32, 18, 9, 2], c: "0xFF8B5CF6", desc: "アクチノイドの起点。強い放射能により青白く発光。" },
  { n: 90, s: "Th", name: "トリウム", cat: "アクチノイド", m: 232.04, shells: [2, 8, 18, 32, 18, 10, 2], c: "0xFF8B5CF6", desc: "次世代原子炉（トリウム溶融塩炉）の核燃料候補。" },
  { n: 91, s: "Pa", name: "プロトアクチニウム", cat: "アクチノイド", m: 231.04, shells: [2, 8, 18, 32, 20, 9, 2], c: "0xFF8B5CF6", desc: "ウラン崩壊系列の中間生成物。" },
  { n: 92, s: "U", name: "ウラン", cat: "アクチノイド", m: 238.03, shells: [2, 8, 18, 32, 21, 9, 2], c: "0xFF8B5CF6", desc: "原子力発電の主燃料（U-235）。天然に存在する最重元素。" },
  { n: 93, s: "Np", name: "ネプツニウム", cat: "アクチノイド", m: 237.0, shells: [2, 8, 18, 32, 22, 9, 2], c: "0xFF8B5CF6", desc: "最初の超ウラン元素。海王星（Neptune）にちなむ。" },
  { n: 94, s: "Pu", name: "プルトニウム", cat: "アクチノイド", m: 244.0, shells: [2, 8, 18, 32, 24, 8, 2], c: "0xFF8B5CF6", desc: "原子炉内で生成される核燃料。宇宙探査機RTG電源（Pu-238）。" },
  { n: 95, s: "Am", name: "アメリシウム", cat: "アクチノイド", m: 243.0, shells: [2, 8, 18, 32, 25, 8, 2], c: "0xFF8B5CF6", desc: "家庭用煙感知器のイオン化線源。" },
  { n: 96, s: "Cm", name: "キュリウム", cat: "アクチノイド", m: 247.0, shells: [2, 8, 18, 32, 25, 9, 2], c: "0xFF8B5CF6", desc: "キュリー夫妻にちなむ。火星探査ローバーのα線X線分光器。" },
  { n: 97, s: "Bk", name: "バークリウム", cat: "アクチノイド", m: 247.0, shells: [2, 8, 18, 32, 27, 8, 2], c: "0xFF8B5CF6", desc: "カリフォルニア大学バークレー校にちなむ。" },
  { n: 98, s: "Cf", name: "カリホルニウム", cat: "アクチノイド", m: 251.0, shells: [2, 8, 18, 32, 28, 8, 2], c: "0xFF8B5CF6", desc: "強力な中性子源。原子炉の始動用中性子源。" },
  { n: 99, s: "Es", name: "アインスタイニウム", cat: "アクチノイド", m: 252.0, shells: [2, 8, 18, 32, 29, 8, 2], c: "0xFF8B5CF6", desc: "アインシュタインにちなむ。水爆実験の残骸から発見。" },
  { n: 100, s: "Fm", name: "フェルミウム", cat: "アクチノイド", m: 257.0, shells: [2, 8, 18, 32, 30, 8, 2], c: "0xFF8B5CF6", desc: "物理学者エンリコ・フェルミにちなむ。" },
  { n: 101, s: "Md", name: "メンデレビウム", cat: "アクチノイド", m: 258.0, shells: [2, 8, 18, 32, 31, 8, 2], c: "0xFF8B5CF6", desc: "周期表の考案者メンデレーエフにちなむ。" },
  { n: 102, s: "No", name: "ノーベリウム", cat: "アクチノイド", m: 259.0, shells: [2, 8, 18, 32, 32, 8, 2], c: "0xFF8B5CF6", desc: "アルフレッド・ノーベルにちなむ。" },
  { n: 103, s: "Lr", name: "ローレンシウム", cat: "アクチノイド", m: 266.0, shells: [2, 8, 18, 32, 32, 8, 3], c: "0xFF8B5CF6", desc: "サイクロトロン発明者ローレンスにちなむ。" },
  { n: 104, s: "Rf", name: "ラザホージウム", cat: "遷移金属", m: 267.0, shells: [2, 8, 18, 32, 32, 10, 2], c: "0xFFEAB308", desc: "原子核モデルを提唱したラザフォードにちなむ超重元素。" },
  { n: 105, s: "Db", name: "ドブニウム", cat: "遷移金属", m: 268.0, shells: [2, 8, 18, 32, 32, 11, 2], c: "0xFFEAB308", desc: "ロシアの原子核研究所の地名ドゥブナにちなむ。" },
  { n: 106, s: "Sg", name: "シーボーギウム", cat: "遷移金属", m: 269.0, shells: [2, 8, 18, 32, 32, 12, 2], c: "0xFFEAB308", desc: "グレン・シーボーグにちなむ（存命中に命名された初例）。" },
  { n: 107, s: "Bh", name: "ボーリウム", cat: "遷移金属", m: 270.0, shells: [2, 8, 18, 32, 32, 13, 2], c: "0xFFEAB308", desc: "量子力学の先駆者ニールス・ボーアにちなむ。" },
  { n: 108, s: "Hs", name: "ハッシウム", cat: "遷移金属", m: 269.0, shells: [2, 8, 18, 32, 32, 14, 2], c: "0xFFEAB308", desc: "ドイツのヘッセン州のラテン語名にちなむ。" },
  { n: 109, s: "Mt", name: "マイトネリウム", cat: "遷移金属", m: 278.0, shells: [2, 8, 18, 32, 32, 15, 2], c: "0xFFEAB308", desc: "核分裂の理論的解明に貢献したリーゼ・マイトナーにちなむ。" },
  { n: 110, s: "Ds", name: "ダームスタチウム", cat: "遷移金属", m: 281.0, shells: [2, 8, 18, 32, 32, 16, 2], c: "0xFFEAB308", desc: "発見地ドイツ・ダルムシュタットにちなむ。" },
  { n: 111, s: "Rg", name: "レントゲニウム", cat: "遷移金属", m: 282.0, shells: [2, 8, 18, 32, 32, 17, 2], c: "0xFFEAB308", desc: "X線を発見したヴィルヘルム・レントゲンにちなむ。" },
  { n: 112, s: "Cn", name: "コペルニシウム", cat: "遷移金属", m: 285.0, shells: [2, 8, 18, 32, 32, 18, 2], c: "0xFFEAB308", desc: "地動説を提唱したニコラウス・コペルニクスにちなむ。" },
  { n: 113, s: "Nh", name: "ニホニウム", cat: "典型金属", m: 286.0, shells: [2, 8, 18, 32, 32, 18, 3], c: "0xFF64748B", desc: "日本（理化学研究所森田グループ）がアジアで初めて命名権を獲得した超重元素。" },
  { n: 114, s: "Fl", name: "フレロビウム", cat: "典型金属", m: 289.0, shells: [2, 8, 18, 32, 32, 18, 4], c: "0xFF64748B", desc: "ロシアの核物理学者ゲオルギー・フリョロフにちなむ。" },
  { n: 115, s: "Mc", name: "モスコビウム", cat: "典型金属", m: 290.0, shells: [2, 8, 18, 32, 32, 18, 5], c: "0xFF64748B", desc: "モスクワ州にちなんで命名された第15族超重元素。" },
  { n: 116, s: "Lv", name: "リバモリウム", cat: "典型金属", m: 293.0, shells: [2, 8, 18, 32, 32, 18, 6], c: "0xFF64748B", desc: "アメリカのローレンス・リバモア国立研究所にちなむ。" },
  { n: 117, s: "Ts", name: "テネシン", cat: "ハロゲン", m: 294.0, shells: [2, 8, 18, 32, 32, 18, 7], c: "0xFF06B6D4", desc: "オークリッジ国立研究所があるテネシー州にちなむハロゲン元素。" },
  { n: 118, s: "Og", name: "オガネソン", cat: "貴ガス", m: 294.0, shells: [2, 8, 18, 32, 32, 18, 8], c: "0xFFA855F7", desc: "第18族貴ガスの最後を飾る原子番号118の超重元素。物理学者オガネシアンにちなむ。" }
];

console.log(`Verified ${elements.length} elements (1 to 118).`);

// Generate complete PeriodicTableLabWidget Dart code
const dartCode = `import 'dart:math' as math;
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
${elements.map(e => `    ElementData(
      number: ${e.n},
      symbol: '${e.s}',
      name: '${e.name}',
      category: '${e.cat}',
      mass: ${e.m},
      electronShells: [${e.shells.join(', ')}],
      color: Color(${e.c}),
      description: '${e.desc.replace(/'/g, "\\'")}',
    ),`).join('\n')}
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
                '元素一覧 (\${filteredElements.length} / 118 元素)',
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
                    Text('原子量: \${elem.mass}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                    const SizedBox(height: 2),
                    Text(
                      '電子配置 (K,L,M,N,O,P,Q): \${elem.electronShells.join(", ")}',
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
      text: '+\${elem.number}',
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
`;

fs.writeFileSync(path.join(__dirname, '../lib/widgets/labs/periodic_table_lab_widget.dart'), dartCode, 'utf8');
console.log('Successfully wrote periodic_table_lab_widget.dart with all 118 elements!');
