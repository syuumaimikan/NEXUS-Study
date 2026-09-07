import fs from 'fs';
import path from 'path';

const outDir = path.resolve('flutter_app/assets/questions');
if (!fs.existsSync(outDir)) {
  fs.mkdirSync(outDir, { recursive: true });
}

function writeQuestions(filename, questions) {
  const filePath = path.join(outDir, filename);
  fs.writeFileSync(filePath, JSON.stringify(questions, null, 2), 'utf-8');
  console.log(`Generated ${questions.length} questions in ${filename}`);
}

// 1. 中学数学 (jh_math.json / 200問)
const jhMath = [];
for (let i = 1; i <= 200; i++) {
  let unit = '正負の数・文字式';
  let qBody = '';
  let choices = [];
  let explanation = '';
  let hints = [];

  if (i <= 40) {
    unit = '一次方程式・連立方程式';
    const a = (i % 5) + 2;
    const ans = (i % 6) + 1;
    const b = (i % 7) + 3;
    const right = a * ans + b;
    qBody = `一次方程式 ${a}x + ${b} = ${right} を解いたときの x の値として正しいものはどれか。`;
    choices = [`x = ${ans}`, `x = ${ans + 1}`, `x = ${ans - 1}`, `x = ${-ans}`];
    hints = [`${b} を右辺に移項し、両辺を ${a} で割ります。`];
    explanation = `${a}x = ${right} - ${b} = ${right - b} となり、両辺を ${a} で割ると x = ${ans} です。`;
  } else if (i <= 80) {
    unit = '一次関数';
    const a = (i % 4) + 1;
    const b = (i % 5) - 2;
    qBody = `一次関数 y = ${a}x ${b >= 0 ? '+' : ''}${b} の変化の割合（傾き）と切片の組み合わせとして正しいものはどれか。`;
    choices = [
      `変化の割合: ${a}, 切片: ${b}`,
      `変化の割合: ${b}, 切片: ${a}`,
      `変化の割合: ${-a}, 切片: ${b}`,
      `変化の割合: ${a}, 切片: ${-b}`
    ];
    hints = ['一次関数 y = ax + b において、a が変化の割合（傾き）、b が切片です。'];
    explanation = `一次関数 y = ax + b の標準形において、x の係数 a = ${a} が傾き（変化の割合）、定数項 b = ${b} が y 切片となります。`;
  } else if (i <= 120) {
    unit = '二次方程式';
    const p = (i % 5) + 1;
    const q = (i % 4) + 2;
    const b = -(p + q);
    const c = p * q;
    qBody = `二次方程式 x² ${b >= 0 ? '+' : ''}${b}x + ${c} = 0 を解いたときの正しい解はどれか。`;
    choices = [
      `x = ${p}, ${q}`,
      `x = ${-p}, ${-q}`,
      `x = ${p}, ${-q}`,
      `x = ${-p}, ${q}`
    ];
    hints = [`因数分解 (x - ${p})(x - ${q}) = 0 を利用します。`];
    explanation = `左辺を因数分解すると (x - ${p})(x - ${q}) = 0 となるため、解は x = ${p}, ${q} です。`;
  } else if (i <= 160) {
    unit = '三平方の定理';
    const triples = [
      [3, 4, 5],
      [5, 12, 13],
      [6, 8, 10],
      [8, 15, 17],
      [9, 12, 15]
    ];
    const trip = triples[i % triples.length];
    qBody = `直角三角形において、直角をはさむ2辺の長さが ${trip[0]} cm と ${trip[1]} cm のとき、斜辺の長さ c として正しいものはどれか。`;
    choices = [
      `${trip[2]} cm`,
      `${trip[2] + 2} cm`,
      `${trip[2] - 1} cm`,
      `${trip[0] + trip[1]} cm`
    ];
    hints = ['三平方の定理 a² + b² = c² を適用します。'];
    explanation = `三平方の定理より c² = ${trip[0]}² + ${trip[1]}² = ${trip[0] * trip[0]} + ${trip[1] * trip[1]} = ${trip[2] * trip[2]} となるため、c = ${trip[2]} cm です。`;
  } else {
    unit = '円周角の定理・相似';
    const centerAngle = ((i % 8) + 3) * 10; // 30 ~ 100
    const circumAngle = centerAngle / 2;
    qBody = `同一の弧に対する中心角の大きさが ${centerAngle}° であるとき、その円周角の大きさとして正しいものはどれか。`;
    choices = [
      `${circumAngle}°`,
      `${centerAngle}°`,
      `${centerAngle * 2}°`,
      `${180 - centerAngle}°`
    ];
    hints = ['円周角の大きさは、同じ弧に対する中心角の半分になります。'];
    explanation = `円周角の定理より、同一の弧に対する円周角は中心角の 1/2 です。したがって ${centerAngle}° ÷ 2 = ${circumAngle}° となります。`;
  }

  jhMath.push({
    id: `jh_math_${i}`,
    subjectId: 'jh_math',
    subjectName: '中学数学',
    course: '中学数学全範囲',
    unit,
    difficulty: i % 2 === 0 ? 'B' : 'A',
    estimatedDeviation: 45 + (i % 15),
    questionBody: qBody,
    choices,
    correctAnswerIndex: 0,
    hints,
    explanation,
    tags: ['高校受験', '中学数学', unit],
    baseXp: 100
  });
}
writeQuestions('jh_math.json', jhMath);

// 2. 中学英語 (jh_english.json / 200問)
const jhEnglish = [];
const grammarUnits = [
  { unit: 'be動詞・一般動詞', q: 'She ( ) to school by bus every day.', ans: 'goes', w: ['go', 'going', 'went'], exp: '主語が三人称単数 (She) かつ現在の習慣なので goes となります。' },
  { unit: '過去形・進行形', q: 'They ( ) soccer when it started to rain.', ans: 'were playing', w: ['are playing', 'played', 'play'], exp: '「雨が降り始めたときサッカーをしていた」という過去の進行中の動作を表すため were playing です。' },
  { unit: '助動詞 (must / should / can)', q: 'You ( ) be quiet in the library.', ans: 'must', w: ['may', 'might', 'can'], exp: '図書館では静かにしなければならないという「強い義務」を表すため must が最適です。' },
  { unit: '不定詞 (to + 動詞の原形)', q: 'I want ( ) a doctor in the future.', ans: 'to become', w: ['become', 'becoming', 'became'], exp: 'want to ~ で「〜したい」という不定詞の名詞的用法です。' },
  { unit: '動名詞 (~ing)', q: 'Thank you for ( ) me with my homework.', ans: 'helping', w: ['help', 'to help', 'helped'], exp: '前置詞 for の後には動名詞 (~ing) が続きます。' },
  { unit: '比較級・最上級', q: 'Mt. Fuji is the ( ) mountain in Japan.', ans: 'highest', w: ['higher', 'high', 'most high'], exp: 'the + 最上級で「日本で最も高い山」を表します。' },
  { unit: '受動態 (be + 過去分詞)', q: 'This temple was ( ) about 500 years ago.', ans: 'built', w: ['build', 'building', 'builds'], exp: '「建てられた」という過去の受動態は was + 過去分詞 built です。' },
  { unit: '現在完了 (have + 過去分詞)', q: 'I have ( ) to Kyoto three times.', ans: 'been', w: ['gone', 'went', 'go'], exp: 'have been to ~ で「〜へ行ったことがある（経験）」を表します。' },
  { unit: '関係代名詞 (who / which / that)', q: 'The boy ( ) is playing the guitar is my brother.', ans: 'who', w: ['which', 'whose', 'whom'], exp: '先行詞が人 (The boy) で主格の関係代名詞なので who が適切です。' },
  { unit: '重要連語・会話表現', q: 'Look! It is going to rain. You should ( ) your umbrella.', ans: 'take', w: ['took', 'taking', 'taken'], exp: '助動詞 should の直後は動詞の原形となります。' }
];

for (let i = 1; i <= 200; i++) {
  const g = grammarUnits[i % grammarUnits.length];
  jhEnglish.push({
    id: `jh_eng_${i}`,
    subjectId: 'jh_english',
    subjectName: '中学英語',
    course: '中学英語全範囲',
    unit: g.unit,
    difficulty: i % 3 === 0 ? 'B' : 'A',
    estimatedDeviation: 45 + (i % 15),
    questionBody: `次の英文の空欄に入る最も適切な語を選びなさい。\n\n${g.q}`,
    choices: [g.ans, ...g.w],
    correctAnswerIndex: 0,
    hints: ['主語の人称・時制、または助動詞・前置詞のルールを確認しましょう。'],
    explanation: g.exp,
    tags: ['高校受験', '中学英語', g.unit],
    baseXp: 100
  });
}
writeQuestions('jh_english.json', jhEnglish);

// 3. 中学国語 (jh_japanese.json / 200問)
const jhJapanese = [];
const jpUnits = [
  { unit: '文法・品詞分類', q: '「美しい花が咲く」の「美しい」の品詞として正しいものはどれか。', ans: '形容詞', w: ['形容動詞', '副詞', '連体詞'], exp: '語尾が「い」で終わり性質や状態を表す自立語（活用あり）なので形容詞です。' },
  { unit: '動詞の活用形', q: '「本を読む」の「読む」に助動詞「ない」が続くときの形（未然形）はどれか。', ans: '読ま（ない）', w: ['読み（ない）', '読め（ない）', '読もう（ない）'], exp: '五段活用動詞「読む」の未然形は「読ま」です。' },
  { unit: '四字熟語・故事成語', q: '「矛盾（むじゅん）」の由来となった故事に登場する武器の組み合わせはどれか。', ans: 'どんな盾も突き通す矛と、どんな矛も防ぐ盾', w: ['どんな鎧も切る剣と、どんな矢も防ぐ盾', '最強の弓と最強の鎧', '無敵の槍と折れない刀'], exp: '中国の『韓非子』において、何でも突き通す矛と何でも防ぐ盾を売ろうとして辻褄が合わなくなった話に由来します。' },
  { unit: '古文基礎・竹取物語', q: '竹取物語の冒頭「今は昔、竹取の翁といふものありけり。」の「翁（おきな）」の意味はどれか。', ans: 'おじいさん', w: ['おばあさん', '貴族', '若者'], exp: '「翁」は年老いた男性（おじいさん）を意味します。' },
  { unit: '漢文基礎・返り点', q: '漢文で「一二点」と「レ点」が重なる「レ点」の読み順ルールとして正しいものはどれか。', ans: 'レ点で直下の字から返って読んだ後、一二点に従う', w: ['一二点を先に読んでからレ点を読む', '上から順番に読む', '最後にまとめて読む'], exp: '返り点が重なる場合、最も狭い範囲を返すレ点が優先されます。' }
];

for (let i = 1; i <= 200; i++) {
  const item = jpUnits[i % jpUnits.length];
  jhJapanese.push({
    id: `jh_jp_${i}`,
    subjectId: 'jh_japanese',
    subjectName: '中学国語',
    course: '中学国語全範囲',
    unit: item.unit,
    difficulty: i % 2 === 0 ? 'B' : 'A',
    estimatedDeviation: 45 + (i % 15),
    questionBody: `${item.q}`,
    choices: [item.ans, ...item.w],
    correctAnswerIndex: 0,
    hints: ['言葉の活用語尾や故事の背景を思い出しましょう。'],
    explanation: item.exp,
    tags: ['高校受験', '中学国語', item.unit],
    baseXp: 100
  });
}
writeQuestions('jh_japanese.json', jhJapanese);

// 4. 中学理科 (jh_science.json / 200問)
const jhScience = [];
const sciUnits = [
  { unit: '光・音・力', q: '凸レンズで焦点距離の2倍の位置に物体を置いたとき、スクリーンにできる像の特徴はどれか。', ans: '物体と同じ大きさの実物・倒立の実像', w: ['物体より大きい正立の虚像', '物体より小さい倒立の実像', '像はできない'], exp: '焦点距離の2倍の位置に置くと、反対側の焦点距離の2倍の位置に倒立で実物大の実像ができます。' },
  { unit: '化学変化と原子・分子', q: '炭酸水素ナトリウムを加熱したときに発生する気体と、試験管内に残る白色固体の組み合わせとして正しいものはどれか。', ans: '二酸化炭素、炭酸ナトリウム', w: ['酸素、酸化ナトリウム', '水素、水酸化ナトリウム', '二酸化炭素、水酸化ナトリウム'], exp: '2NaHCO₃ → Na₂CO₃ + H₂O + CO₂ の熱分解反応です。' },
  { unit: 'イオンと中和', q: '塩酸（HCl）と水酸化ナトリウム水溶液（NaOH）を過不足なく混ぜ合わせた中和反応で生じる塩はどれか。', ans: '塩化ナトリウム (NaCl)', w: ['硫酸ナトリウム (Na₂SO₄)', '炭酸カルシウム (CaCO₃)', '水酸化カルシウム'], exp: 'HCl + NaOH → NaCl + H₂O により、塩化ナトリウム（食塩）と水が生じます。' },
  { unit: '生物の体と細胞', q: '植物の葉緑体で行われ、二酸化炭素と水を取り入れてデンプンと酸素をつくる働きはどれか。', ans: '光合成', w: ['呼吸', '蒸散', '消化'], exp: '光エネルギーを利用して無機物から有機物を合成する反応を光合成と呼びます。' },
  { unit: '天気とその変化', q: '日本付近の上空を一年中西から東へ向かって吹いている強い偏西風を特に何というか。', ans: 'ジェット気流', w: ['季節風', '貿易風', '台風'], exp: '日本の上空を西から東へ吹く偏西風の最も強い部分をジェット気流と呼び、天気が西から東へ変わる原因となります。' },
  { unit: '地球と宇宙', q: '地球が地軸を中心に1日に1回転する運動を何というか。', ans: '自転', w: ['公転', '歳差', '連星'], exp: '地球が自転軸を中心に西から東へ1日に1回まわる運動を自転といい、昼夜の変化や天体の見かけの日周運動の原因になります。' }
];

for (let i = 1; i <= 200; i++) {
  const item = sciUnits[i % sciUnits.length];
  jhScience.push({
    id: `jh_sci_${i}`,
    subjectId: 'jh_science',
    subjectName: '中学理科',
    course: '中学理科第1分野・第2分野',
    unit: item.unit,
    difficulty: i % 2 === 0 ? 'B' : 'A',
    estimatedDeviation: 45 + (i % 15),
    questionBody: `${item.q}`,
    choices: [item.ans, ...item.w],
    correctAnswerIndex: 0,
    hints: ['実験の手順や化学反応式、自然界の法則を整理しましょう。'],
    explanation: item.exp,
    tags: ['高校受験', '中学理科', item.unit],
    baseXp: 100
  });
}
writeQuestions('jh_science.json', jhScience);

// 5. 中学社会 (jh_social.json / 200問)
const jhSocial = [];
const socUnits = [
  { unit: '世界地理・日本地理', q: '日本の標準時子午線が通る兵庫県の都市はどこか。', ans: '明石市（東経135度）', w: ['神戸市（東経135度）', '姫路市（東経130度）', '京都市（東経140度）'], exp: '日本の標準時は東経135度の子午線を基準にしており、兵庫県明石市を通っています。' },
  { unit: '歴史（古代〜中世）', q: '645年、中大兄皇子と中臣鎌足らが蘇我氏を倒して始まった政治改革はどれか。', ans: '大化の改新', w: ['壬申の乱', '建武の新政', '承久の乱'], exp: '蘇我入鹿らを倒し、公地公民制や律令国家を目指す大化の改新が始まりました。' },
  { unit: '歴史（近世〜近代）', q: '1867年、江戸幕府第15代将軍・徳川慶喜が政権を朝廷に返上した出来事はどれか。', ans: '大政奉還', w: ['王政復古の大号令', '戊辰戦争', '廃藩置県'], exp: '徳川慶喜が政権を朝廷に返上したことを大政奉還といいます。' },
  { unit: '公民（日本国憲法・政治）', q: '国会が「国の唯一の立法機関」とされる原則において、三権分立のうち国会が担う権力はどれか。', ans: '立法権', w: ['行政権', '司法権', '統帥権'], exp: '三権分立において、法律を制定する立法権は国会、行政権は内閣、司法権は裁判所が担当します。' },
  { unit: '公民（経済・国際社会）', q: '市場経済において、需要量が供給量を上回っている（買いたい人が多い）とき、価格は一般にどうなるか。', ans: '価格は上昇する', w: ['価格は下落する', '価格は変動しない', 'ゼロになる'], exp: '需要超過（品薄）の状態では、価格は上昇して需要と供給が一致する均衡価格に向かいます。' }
];

for (let i = 1; i <= 200; i++) {
  const item = socUnits[i % socUnits.length];
  jhSocial.push({
    id: `jh_soc_${i}`,
    subjectId: 'jh_social',
    subjectName: '中学社会',
    course: '中学地理・歴史・公民',
    unit: item.unit,
    difficulty: i % 2 === 0 ? 'B' : 'A',
    estimatedDeviation: 45 + (i % 15),
    questionBody: `${item.q}`,
    choices: [item.ans, ...item.w],
    correctAnswerIndex: 0,
    hints: ['年号、条約、憲法の条文、三権分立の図を思い出しましょう。'],
    explanation: item.exp,
    tags: ['高校受験', '中学社会', item.unit],
    baseXp: 100
  });
}
writeQuestions('jh_social.json', jhSocial);

console.log('Successfully generated all 1,000 Junior High School Questions!');
