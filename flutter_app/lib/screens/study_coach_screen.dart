import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class StudyCoachScreen extends StatefulWidget {
  final UserProfile profile;

  const StudyCoachScreen({super.key, required this.profile});

  @override
  State<StudyCoachScreen> createState() => _StudyCoachScreenState();
}

class _StudyCoachScreenState extends State<StudyCoachScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text': 'こんにちは！NEXUS 学習コーチです。第一志望校や教科別の勉強法、共通テストの時間配分、模試の復習など、受験に関する悩みや疑問は何でも相談してください。',
      'time': '10:00',
    },
  ];

  final List<String> _quickPrompts = [
    '共通テスト数学の時間配分のコツは？',
    '英語長文の速読力を上げるには？',
    '模試の判定が悪かった時の復習法は？',
    '直前期のモチベーション維持法は？',
    '過去問演習は何年分やるべき？',
    '暗記した公式が本番で出てこない時の対処法は？',
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final time = TimeOfDay.now().format(context);
    setState(() {
      _messages.add({'isUser': true, 'text': text, 'time': time});
    });
    _textController.clear();

    _scrollToBottom();

    // AI Coach response generation
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      final reply = _generateCoachAdvice(text);
      setState(() {
        _messages.add({'isUser': false, 'text': reply, 'time': TimeOfDay.now().format(context)});
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _generateCoachAdvice(String prompt) {
    final target = widget.profile.targetUniversity.isEmpty ? '志望校' : widget.profile.targetUniversity;

    if (prompt.contains('数学') || prompt.contains('時間配分')) {
      return '【数学の時間配分と解法の鉄則】\n'
          '1. まず全問を1分眺め、各大問の難易度と誘導の長さを把握します。\n'
          '2. 完答を狙わず「解ける小問から確実に満点を取りにいく」姿勢が最重要です。\n'
          '3. 1つの小問で3分以上手が止まったら、躊躇なく次の大問へスキップする勇気を持ちましょう。\n'
          '4. 微積分や数列の定型問題は「NEXUSの公式集」と「瞬殺チャレンジ」で計算速度を極限まで高めておくと、余った時間を後半の考察問題に回せます。';
    } else if (prompt.contains('英語') || prompt.contains('速読')) {
      return '【英語長文の速読力向上メソッド】\n'
          '1. スラッシュリーディング: 文構造（S+V+O+C）の区切りごとに意味を塊（チャンク）で捉え、日本語に返り読みせず左から右へ理解します。\n'
          '2. シャドーイング: 「NEXUS リスニングモード」の音声を1.2倍速で流しながら、スクリプトを見ずに声を出して追唱してください。英語の語順処理脳が驚異的に鍛えられます。\n'
          '3. ターゲット1900の単語は「0.5秒以内に日本語訳が浮かぶ」瞬発力レベルまで仕上げることが、長文読解の基盤になります。';
    } else if (prompt.contains('模試') || prompt.contains('判定')) {
      return '【模試判定の捉え方と黄金の復習法】\n'
          '1. 模試の判定（E判定やD判定）は「現時点の弱点の宝庫」にすぎず、合否の確定ではありません。\n'
          '2. 最も重要なのは「失点原因の3分類」です：\n'
          '   ① 知らなかった知識 ➔ 暗記カード・公式集に即登録\n'
          '   ② 方針は立ったが計算ミス・時間切れ ➔ 演習量でスピード強化\n'
          '   ③ 問題文の読み違い ➔ 設問の条件に下線を引く習慣づけ\n'
          '3. 間違えた問題は「NEXUS 弱点復習帳」に記録し、忘却曲線に沿って1日後・3日後に解き直せば確実に偏差値が跳ね上がります！';
    } else if (prompt.contains('過去問')) {
      return '【$target の過去問演習計画】\n'
          '1. 過去問は「最低5〜10年分」を目標にします。\n'
          '2. 1周目は時間を厳密に測って本番形式で解き、出題傾向と時間不足の度合いを痛感することが大切です。\n'
          '3. 2周目は「時間無制限で満点が取れるまで論理を組み立て直す」ディープな復習を行いましょう。\n'
          '4. 共通テストと個別2次試験の比率（${widget.profile.targetUniversity}の配点）を常に意識し、傾斜配点が高い科目に学習時間を傾斜配分してください。';
    } else if (prompt.contains('モチベーション') || prompt.contains('直前')) {
      return '【直前期のメンタル管理と睡眠の黄金律】\n'
          '1. 不安になるのは「本気で合格したい証拠」です。不安を感じたらペンを持って手を動かしましょう。\n'
          '2. 睡眠時間は最低でも6.5〜7時間を確保してください。記憶は睡眠中に脳の海馬で定着します。\n'
          '3. 「ポモドーロ集中タイマー」で25分だけ集中するサイクルを刻むと、だらだらした勉強を防ぎ、達成感を積み上げられます。\n'
          '目標偏差値 ${widget.profile.targetDeviation.toStringAsFixed(1)} 達成に向けて、一歩ずつ着実に進みましょう！応援しています。';
    }

    return '【$target 合格へのコーチングアドバイス】\n'
        'ご質問の「$prompt」について、効果的なアプローチをお答えします。\n'
        '毎日の学習計画を「NEXUS 学習カレンダー」で可視化し、朝と夜のリマインダーに合わせて習慣化することが最短の近道です。焦らず、本日の重要課題を1つずつクリアしていきましょう！';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.psychology, color: Color(0xFF38BDF8), size: 24),
            SizedBox(width: 8),
            Text('AI 学習コーチ ＆ 受験メンター', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Quick Topic Chips
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            color: const Color(0xFF0F172A).withValues(alpha: 0.5),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _quickPrompts.map((p) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(p),
                      backgroundColor: const Color(0xFF131B2E),
                      labelStyle: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11),
                      side: BorderSide(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
                      onPressed: () => _sendMessage(p),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                final isUser = m['isUser'] as bool;
                final text = m['text'] as String;
                final time = m['time'] as String;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!isUser) ...[
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF38BDF8)),
                          ),
                          child: const Icon(Icons.school, color: Color(0xFF38BDF8), size: 18),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isUser ? const Color(0xFF0284C7) : const Color(0xFF131B2E),
                            borderRadius: BorderRadius.circular(18).copyWith(
                              bottomRight: isUser ? Radius.zero : const Radius.circular(18),
                              bottomLeft: !isUser ? Radius.zero : const Radius.circular(18),
                            ),
                            border: Border.all(color: isUser ? Colors.transparent : Colors.white10),
                          ),
                          child: Column(
                            crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(
                                text,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  height: 1.45,
                                  fontWeight: isUser ? FontWeight.w500 : FontWeight.normal,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(time, style: const TextStyle(color: Colors.white38, fontSize: 9.5)),
                            ],
                          ),
                        ),
                      ),
                      if (isUser) const SizedBox(width: 10),
                    ],
                  ),
                );
              },
            ),
          ),

          // Text Input Bar
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF0F172A),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: '勉強法・悩み・質問を入力...',
                        hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
                        filled: true,
                        fillColor: const Color(0xFF131B2E),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () => _sendMessage(_textController.text),
                    icon: const Icon(Icons.send, size: 18),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFF38BDF8),
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
