# NEXUS Study (Flutter Native Edition)

高校生向け総合デジタル学習プラットフォーム **NEXUS Study** の Flutter ネイティブアプリケーションです。

---

## 特徴と設計方針

1. **絵文字ゼロ & Flutter Material Design 3 公式アイコンで統一**
   - 画面内のアバターや科目アイコン、ステータス、ボタン等に絵文字は一切使用せず、Material 3 公式アイコン（`Icons.calculate`, `Icons.bolt`, `Icons.science`, `Icons.draw`, `Icons.school`, `Icons.menu_book` 等）で統一。

2. **問題解答中の手書き計算メモ (`ScratchpadCanvas`)**
   - 演習中や模試中に画面右上からワンタップで低遅延の手書きキャンバスを展開可能。
   - 方眼グリッド、5色パレット、消しゴム (`Icons.auto_fix_high`)、Undo (`Icons.undo`)、全消去 (`Icons.delete_outline`) を完備。

3. **高校全範囲・全14科目×200問（計2,800問）の大容量JSON問題バンク**
   - `flutter_app/assets/questions/` 配下に科目ごとに独立したJSONファイルを配置：
     - 高校数学 (`math.json` / 200問)
     - 物理 (`physics.json` / 200問)
     - 化学 (`chemistry.json` / 200問)
     - 生物 (`biology.json` / 200問)
     - 地学 (`earth_science.json` / 200問)
     - 情報 (`information.json` / 200問)
     - 英語 (`english.json` / 200問)
     - 現代文 (`japanese.json` / 200問)
     - 古文 (`kobun.json` / 200問)
     - 漢文 (`kanbun.json` / 200問)
     - 日本史 (`history_japan.json` / 200問)
     - 世界史 (`history_world.json` / 200問)
     - 地理 (`geography.json` / 200問)
     - 公民 (`civics.json` / 200問)
   - 今後も各JSONファイルに問題を追加・編集するだけで即時反映されます。

4. **初回プロファイル設定ウィザード (`OnboardingScreen`)**
   - 初回起動時にニックネーム、学年、文理専攻、第一志望大学を入力。
   - マイページからいつでも志望校変更や全データ初期化が可能です。

5. **NEXUS Lab (インタラクティブ可視化実験室)**
   - 高校生がつまずきやすい抽象概念をスライダーやタップで直感的に操作できるネイティブシミュレーター群（完全60fps `CustomPainter` 実装）：
     - **数学**: 2次関数・判別式シミュレーター（$y = ax^2 + bx + c$ の頂点・軸・判別式 $D$ のリアルタイム連動）、三角比・単位円シミュレーター（$\sin, \cos, \tan$ と波形のリアルタイム連動）
     - **物理**: 斜方投射・放物運動シミュレーター（初速度 $v_0$、角度 $\theta$、最高点 $H$、水平到達距離 $R$ の物理演算と発射アニメーション）
     - **化学**: 元素周期表エクスプローラー（原子番号 1〜36、ボーアの電子殻モデル、典型・遷移・アルカリ等の色分け）
     - **生物**: メンデル遺伝交配シミュレーター（$RrYy \times RrYy$ の $4 \times 4$ プネット平方マトリクス、9:3:3:1 比率の可視化）
     - **情報**: バブルソート可視化（棒グラフの比較・交換ステップ実行とアニメーション）

6. **問題解説の動的図解ダイアグラム (`VisualDiagramCard`)**
   - 演習問題の解答後、解説欄上部に科目・単元に応じた数理グラフ、単位円、斜面上の力学ベクトル分解図、等加速度運動 $v-t$ グラフ、原子電子殻モデルを自動描画。グリッドやラベルの表示切替に対応。

---

## ディレクトリ構成

```text
c:\Users\yuang\Projects\NEXUS Study\
├── dist-apk/
│   └── NEXUS_Study_Flutter.apk   # 実機インストール用ビルド済APK
├── flutter_app/
│   ├── assets/
│   │   └── questions/            # 全14科目×200問のJSON問題バンク
│   │       ├── math.json
│   │       ├── physics.json
│   │       ├── chemistry.json
│   │       ├── biology.json
│   │       ├── earth_science.json
│   │       ├── information.json
│   │       ├── english.json
│   │       ├── japanese.json
│   │       ├── kobun.json
│   │       ├── kanbun.json
│   │       ├── history_japan.json
│   │       ├── history_world.json
│   │       ├── geography.json
│   │       └── civics.json
│   ├── lib/
│   │   ├── main.dart
│   │   ├── models/
│   │   ├── screens/
│   │   ├── services/
│   │   └── widgets/
│   ├── tool/
│   │   └── build_flutter_questions.js # 問題生成・拡張スクリプト
│   └── pubspec.yaml
└── README.md
```

---

## 開発・実行コマンド

```bash
# プロジェクトディレクトリへ移動
cd flutter_app

# 静的解析（エラー・警告ゼロ）
flutter analyze

# テスト実行
flutter test

# 実機実行（ワイヤレスデバッグ接続中のPixel 8 Pro等）
flutter run

# APKビルド
flutter build apk --debug
```
