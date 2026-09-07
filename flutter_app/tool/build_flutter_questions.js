import fs from 'fs';
import path from 'path';

const outDir = path.resolve('flutter_app/assets/questions');
if (!fs.existsSync(outDir)) {
  fs.mkdirSync(outDir, { recursive: true });
}

function writeSubjectQuestions(filename, questions) {
  const filePath = path.join(outDir, filename);
  fs.writeFileSync(filePath, JSON.stringify(questions, null, 2), 'utf-8');
  console.log(`Successfully generated ${questions.length} questions in ${filename}`);
}

// ==========================================
// 1. MATH (200 questions)
// ==========================================
const mathQuestions = [];

// Math 1: Quadratic functions (35 questions)
for (let i = 1; i <= 35; i++) {
  const a = (i % 3) + 1;
  const p = (i % 5) + 1;
  const q = ((i * 3) % 7) - 3;
  // y = a(x - p)^2 + q = a(x^2 - 2px + p^2) + q = a x^2 - 2ap x + (a p^2 + q)
  const b = -2 * a * p;
  const c = a * p * p + q;
  const wrongP = p + 1;
  const wrongQ = q - 2;

  mathQuestions.push({
    id: `math_quad_${i}`,
    subjectId: 'math',
    subjectName: '数学',
    course: '数学I',
    unit: '2次関数',
    difficulty: i % 3 === 0 ? 'B' : 'C',
    estimatedDeviation: 50 + (i % 15),
    questionBody: `2次関数 y = ${a === 1 ? '' : a}x² ${b >= 0 ? '+' : ''}${b}x ${c >= 0 ? '+' : ''}${c} の頂点の座標として正しいものはどれか。`,
    choices: [
      `頂点 (${p}, ${q})`,
      `頂点 (${-p}, ${q})`,
      `頂点 (${p}, ${-q})`,
      `頂点 (${wrongP}, ${wrongQ})`
    ],
    correctAnswerIndex: 0,
    hints: [
      `y = ${a}(x² - ${2 * p}x) + ${c} と変形し、平方完成を行います。`,
      `y = ${a}(x - ${p})² + (${q}) となります。`
    ],
    explanation: `与式を変形すると、y = ${a}(x² - ${2 * p}x) + ${c} = ${a}{(x - ${p})² - ${p * p}} + ${c} = ${a}(x - ${p})² + (${q}) となります。したがって頂点の座標は (${p}, ${q}) です。`,
    tags: ['数学I', '2次関数', '平方完成', '頂点'],
    baseXp: 120
  });
}

// Math 2: Trigonometry & Triangles (35 questions)
for (let i = 1; i <= 35; i++) {
  const angles = [30, 45, 60, 120, 135, 150];
  const angle = angles[i % angles.length];
  const cosValues = { 30: '√3 / 2', 45: '1 / √2', 60: '1 / 2', 120: '-1 / 2', 135: '-1 / √2', 150: '-√3 / 2' };
  const sinValues = { 30: '1 / 2', 45: '1 / √2', 60: '√3 / 2', 120: '√3 / 2', 135: '1 / √2', 150: '1 / 2' };
  const target = i % 2 === 0 ? 'cos' : 'sin';
  const correctVal = target === 'cos' ? cosValues[angle] : sinValues[angle];
  const wrongVal1 = target === 'cos' ? sinValues[angle] : cosValues[angle];

  mathQuestions.push({
    id: `math_trig_${i}`,
    subjectId: 'math',
    subjectName: '数学',
    course: '数学I',
    unit: '三角比',
    difficulty: angle > 90 ? 'B' : 'C',
    estimatedDeviation: 52 + (i % 12),
    questionBody: `三角比 ${target} ${angle}° の値として正しいものはどれか。`,
    choices: [
      `${correctVal}`,
      `${wrongVal1 === correctVal ? '-1' : wrongVal1}`,
      `${target === 'cos' ? '- ' + correctVal : '0'}`,
      '1'
    ],
    correctAnswerIndex: 0,
    hints: [`単位円上の座標 (cos θ, sin θ) を考えて角度 ${angle}° の位置を確認します。`],
    explanation: `単位円上において、動径が x 軸の正の向きとなす角 ${angle}° の点の座標を考えると、cos ${angle}° = ${cosValues[angle]}、sin ${angle}° = ${sinValues[angle]} となります。`,
    tags: ['数学I', '三角比', '単位円'],
    baseXp: 110
  });
}

// Math 3: Permutations, Combinations & Probability (35 questions)
for (let i = 1; i <= 35; i++) {
  const n = (i % 5) + 4; // 4 to 8
  const r = (i % 3) + 2; // 2 to 4
  // Combination nCr
  let num = 1;
  let den = 1;
  for (let k = 0; k < r; k++) {
    num *= (n - k);
    den *= (k + 1);
  }
  const comb = Math.round(num / den);

  mathQuestions.push({
    id: `math_prob_${i}`,
    subjectId: 'math',
    subjectName: '数学',
    course: '数学A',
    unit: '場合の数と確率',
    difficulty: 'B',
    estimatedDeviation: 54 + (i % 10),
    questionBody: `異なる ${n} 人の中から ${r} 人の代表委員を選ぶ選び方の総数は何通りあるか。`,
    choices: [
      `${comb} 通り`,
      `${comb + 5} 通り`,
      `${comb * 2} 通り`,
      `${Math.max(1, comb - 3)} 通り`
    ],
    correctAnswerIndex: 0,
    hints: [`順序を区別しない組合せの数 ₙCᵣ を計算します。`],
    explanation: `異なる ${n} 個から ${r} 個を選ぶ組合せは ₙCᵣ = ${n}! / (${r}! × ${n - r}!) = ${comb} 通りです。`,
    tags: ['数学A', '場合の数', '組合せ', 'Cの計算'],
    baseXp: 120
  });
}

// Math 4: Calculus (Derivatives & Integrals) (35 questions)
for (let i = 1; i <= 35; i++) {
  const p = (i % 4) + 1; // 1 to 4
  const c = ((i * 2) % 5) + 1;
  // f(x) = p x^2 + c x -> f'(x) = 2p x + c
  const derivSlopeAt1 = 2 * p + c;

  mathQuestions.push({
    id: `math_calc_${i}`,
    subjectId: 'math',
    subjectName: '数学',
    course: '数学II',
    unit: '微分と積分',
    difficulty: 'B',
    estimatedDeviation: 56 + (i % 12),
    questionBody: `関数 f(x) = ${p === 1 ? '' : p}x² + ${c}x の x = 1 における微分係数（接線の傾き）f'(1) はいくらか。`,
    choices: [
      `${derivSlopeAt1}`,
      `${derivSlopeAt1 + 2}`,
      `${2 * p}`,
      `${p + c}`
    ],
    correctAnswerIndex: 0,
    hints: [`導関数 f'(x) = 2px + c を求め、x = 1 を代入します。`],
    explanation: `f(x) を微分すると f'(x) = ${2 * p}x + ${c} です。x = 1 を代入すると、f'(1) = ${2 * p}(1) + ${c} = ${derivSlopeAt1} となります。`,
    tags: ['数学II', '微分', '微分係数', '接線の傾き'],
    baseXp: 130
  });
}

// Math 5: Sequences & Recurrence (30 questions)
for (let i = 1; i <= 30; i++) {
  const a1 = (i % 5) + 1;
  const d = (i % 4) + 2;
  // Arithmetic sequence an = a1 + (n - 1)d = d n + (a1 - d)
  const constTerm = a1 - d;
  const a5 = a1 + 4 * d;

  mathQuestions.push({
    id: `math_seq_${i}`,
    subjectId: 'math',
    subjectName: '数学',
    course: '数学B',
    unit: '数列',
    difficulty: 'B',
    estimatedDeviation: 58 + (i % 10),
    questionBody: `初項 a₁ = ${a1}、公差 d = ${d} の等差数列 {a_n} の第 5 項 a₅ の値はいくらか。`,
    choices: [
      `${a5}`,
      `${a5 + d}`,
      `${a5 - d}`,
      `${a1 * 5}`
    ],
    correctAnswerIndex: 0,
    hints: [`等差数列の一般項公式 a_n = a₁ + (n - 1)d を用います。`],
    explanation: `一般項は a_n = ${a1} + (n - 1) × ${d} です。n = 5 のとき、a₅ = ${a1} + 4 × ${d} = ${a5} となります。`,
    tags: ['数学B', '等差数列', '一般項'],
    baseXp: 130
  });
}

// Math 6: Vectors & Math III Calculus (30 questions)
for (let i = 1; i <= 30; i++) {
  const vx = (i % 5) + 1;
  const vy = (i % 4) + 2;
  const lenSq = vx * vx + vy * vy;

  mathQuestions.push({
    id: `math_vec_${i}`,
    subjectId: 'math',
    subjectName: '数学',
    course: '数学C',
    unit: 'ベクトル',
    difficulty: 'B',
    estimatedDeviation: 59 + (i % 12),
    questionBody: `ベクトル a = (${vx}, ${vy}) の大きさ |a| の二乗 |a|² はいくらか。`,
    choices: [
      `${lenSq}`,
      `${lenSq + 4}`,
      `${(vx + vy) * (vx + vy)}`,
      `${vx * vy}`
    ],
    correctAnswerIndex: 0,
    hints: [`ベクトルの大きさの定義 |a|² = x² + y² を計算します。`],
    explanation: `成分表示されたベクトル a = (x, y) の大きさは |a| = √(x² + y²) です。したがって |a|² = ${vx}² + ${vy}² = ${vx * vx} + ${vy * vy} = ${lenSq} となります。`,
    tags: ['数学C', 'ベクトル', 'ベクトルの大きさ'],
    baseXp: 130
  });
}

writeSubjectQuestions('math.json', mathQuestions);

// Helper function to generate template questions with rich educational explanations
function generateDomainQuestions(subjectId, subjectName, units, total = 200) {
  const list = [];
  let count = 0;

  while (count < total) {
    const unitIdx = count % units.length;
    const unit = units[unitIdx];
    const itemNum = Math.floor(count / units.length) + 1;

    const q = unit.generator(itemNum, count + 1);
    list.push({
      id: `${subjectId}_${count + 1}`,
      subjectId,
      subjectName,
      course: unit.course,
      unit: unit.name,
      difficulty: count % 4 === 0 ? 'A' : count % 2 === 0 ? 'B' : 'C',
      estimatedDeviation: 50 + (count % 20),
      questionBody: q.body,
      choices: q.choices,
      correctAnswerIndex: 0,
      hints: q.hints,
      explanation: q.explanation,
      tags: [subjectName, unit.name, ...q.tags],
      baseXp: 110 + (count % 60)
    });
    count++;
  }
  return list;
}

// 2. PHYSICS (200 questions)
const physicsUnits = [
  {
    name: '等加速度直線運動',
    course: '物理基礎',
    generator: (i) => {
      const v0 = (i % 5) * 2 + 2;
      const a = (i % 3) + 1;
      const t = (i % 4) + 2;
      const v = v0 + a * t;
      return {
        body: `初速度 ${v0} m/s で直線上を運動する物体が、一定の加速度 ${a} m/s² で加速した。${t} 秒後の物体の速度 v は何 m/s か。`,
        choices: [`${v} m/s`, `${v + 3} m/s`, `${v - 2} m/s`, `${v0 * t} m/s`],
        hints: ['等加速度直線運動の速度公式 v = v₀ + at を用います。'],
        explanation: `v = v₀ + at より、v = ${v0} + (${a} × ${t}) = ${v} m/s です。`,
        tags: ['等加速度', '速度公式']
      };
    }
  },
  {
    name: '運動方程式と力',
    course: '物理基礎',
    generator: (i) => {
      const m = (i % 5) + 2;
      const a = (i % 4) + 1;
      const F = m * a;
      return {
        body: `質量 ${m} kg の物体に一定の力 F を加えたところ、物体は加速度 ${a} m/s² で加速した。力 F の大きさは何 N か。`,
        choices: [`${F} N`, `${F + 4} N`, `${m + a} N`, `${F * 2} N`],
        hints: ['運動方程式 F = ma を適用します。'],
        explanation: `ニュートンの運動方程式 F = ma より、F = ${m} kg × ${a} m/s² = ${F} N です。`,
        tags: ['運動方程式', 'ニュートンの法則']
      };
    }
  },
  {
    name: '仕事と力学的エネルギー',
    course: '物理基礎',
    generator: (i) => {
      const m = (i % 4) + 1;
      const h = (i % 5) * 5 + 5;
      const g = 9.8;
      const U = Math.round(m * g * h * 10) / 10;
      return {
        body: `質量 ${m} kg の物体を基準面から高さ ${h} m の位置まで持ち上げた。物体がもつ重力による位置エネルギー U は何 J か（g = 9.8 m/s²）。`,
        choices: [`${U} J`, `${Math.round(U * 1.2)} J`, `${Math.round(U * 0.8)} J`, `${m * h} J`],
        hints: ['重力による位置エネルギー公式 U = mgh を用います。'],
        explanation: `U = mgh より、U = ${m} × 9.8 × ${h} = ${U} J です。`,
        tags: ['位置エネルギー', '力学的エネルギー']
      };
    }
  },
  {
    name: '波動と音波',
    course: '物理',
    generator: (i) => {
      const f = 200 + (i % 6) * 50;
      const V = 340;
      const lambda = (V / f).toFixed(2);
      return {
        body: `音速 V = 340 m/s の空気中を伝わる振動数 f = ${f} Hz の音波の波長 λ は約何 m か。`,
        choices: [`${lambda} m`, `${(lambda * 1.5).toFixed(2)} m`, `${(lambda * 0.7).toFixed(2)} m`, `${f / V} m`],
        hints: ['波の基本式 V = fλ を λ について解きます。'],
        explanation: `波の基本式 V = fλ より、λ = V / f = 340 / ${f} ≒ ${lambda} m です。`,
        tags: ['波動', '音速', '波の基本式']
      };
    }
  },
  {
    name: '電磁気・オームの法則',
    course: '物理',
    generator: (i) => {
      const R1 = (i % 4) * 2 + 2;
      const R2 = (i % 3) * 3 + 3;
      const R_series = R1 + R2;
      return {
        body: `抵抗値 ${R1} Ω と ${R2} Ω の2つの抵抗を直列に接続したときの合成抵抗 R はいくらか。`,
        choices: [`${R_series} Ω`, `${(R1 * R2) / (R1 + R2)} Ω`, `${R1 * R2} Ω`, `${Math.abs(R1 - R2)} Ω`],
        hints: ['直列接続の合成抵抗は単純に各抵抗の和 R = R₁ + R₂ となります。'],
        explanation: `直列接続における合成抵抗は R = R₁ + R₂ = ${R1} + ${R2} = ${R_series} Ω です。並列の場合は 1/R = 1/R₁ + 1/R₂ となります。`,
        tags: ['電磁気', '回路', '合成抵抗']
      };
    }
  }
];
writeSubjectQuestions('physics.json', generateDomainQuestions('physics', '物理', physicsUnits, 200));

// 3. CHEMISTRY (200 questions)
const chemistryUnits = [
  {
    name: '物質量とモル濃度',
    course: '化学基礎',
    generator: (i) => {
      const moles = ((i % 5) + 1) * 0.1;
      const liters = (i % 3) + 1;
      const conc = (moles / liters).toFixed(2);
      return {
        body: `溶質 ${moles.toFixed(1)} mol が水に溶けて全体で ${liters}.0 L になっている水溶液のモル濃度は何 mol/L か。`,
        choices: [`${conc} mol/L`, `${(conc * 2).toFixed(2)} mol/L`, `${(conc * 0.5).toFixed(2)} mol/L`, `${(moles * liters).toFixed(2)} mol/L`],
        hints: ['モル濃度 (mol/L) = 溶質の物質量 (mol) / 溶液の体積 (L) です。'],
        explanation: `モル濃度は ${moles.toFixed(1)} mol / ${liters}.0 L = ${conc} mol/L です。`,
        tags: ['モル濃度', '物質量']
      };
    }
  },
  {
    name: '中和反応とpH',
    course: '化学基礎',
    generator: (i) => {
      const exp = (i % 5) + 1; // 1 to 5
      return {
        body: `水素イオン濃度 [H⁺] = 1.0 × 10⁻${exp} mol/L の水溶液の pH はいくらか。`,
        choices: [`${exp}`, `${14 - exp}`, `${exp + 1}`, `${Math.max(1, exp - 1)}`],
        hints: ['pH の定義式 pH = -log₁₀[H⁺] です。'],
        explanation: `pH = -log₁₀(1.0 × 10⁻${exp}) = ${exp} です。`,
        tags: ['酸と塩基', 'pH']
      };
    }
  },
  {
    name: '無機物質と気体発生',
    course: '化学',
    generator: (i) => {
      const gases = [
        { name: '水素 H₂', method: '亜鉛に希硫酸を加える', col: '水上置換' },
        { name: '酸素 O₂', method: '過酸化水素水に二酸化マンガンを加える', col: '水上置換' },
        { name: '二酸化炭素 CO₂', method: '石灰石（炭酸カルシウム）に希塩酸を加える', col: '下方置換' },
        { name: 'アンモニア NH₃', method: '塩化アンモニウムと水酸化カルシウムを加熱', col: '上方置換' }
      ];
      const g = gases[i % gases.length];
      return {
        body: `実験室において「${g.method}」ことで発生する気体はどれか。`,
        choices: [`${g.name}`, '塩素 Cl₂', '硫化水素 H₂S', '一酸化窒素 NO'],
        hints: [`捕集方法は${g.col}が適しています。`],
        explanation: `「${g.method}」反応により、${g.name} が発生します。`,
        tags: ['無機化学', '気体発生']
      };
    }
  },
  {
    name: '有機化合物と官能基',
    course: '化学',
    generator: (i) => {
      const groups = [
        { name: 'ヒドロキシ基 (-OH)', prop: 'ナトリウムと反応して水素を発生する（アルコール）' },
        { name: 'アルデヒド基 (-CHO)', prop: '銀鏡反応やフェーリング液還元性を示す' },
        { name: 'カルボキシ基 (-COOH)', prop: '炭酸水素ナトリウムと反応してCO₂を遊離する酸性基' },
        { name: 'エステル結合 (-COO-)', prop: '油脂や芳香のある果実香成分を構成する結合' }
      ];
      const g = groups[i % groups.length];
      return {
        body: `「${g.prop}」という性質をもつ官能基・結合はどれか。`,
        choices: [`${g.name}`, 'ニトロ基 (-NO₂)', 'エーテル結合 (-O-)', 'スルホ基 (-SO₃H)'],
        hints: ['高校有機化学で極めて重要な示性官能基の基本性質です。'],
        explanation: `${g.name} は「${g.prop}」という顕著な性質を示します。`,
        tags: ['有機化学', '官能基', '検出反応']
      };
    }
  }
];
writeSubjectQuestions('chemistry.json', generateDomainQuestions('chemistry', '化学', chemistryUnits, 200));

// 4. BIOLOGY (200 questions)
const biologyUnits = [
  {
    name: '細胞構造と細胞小器官',
    course: '生物基礎',
    generator: (i) => {
      const organelles = [
        { name: 'ミトコンドリア', role: '好気呼吸を行い、有機物を分解してATPを合成する' },
        { name: '葉緑体', role: 'クロロフィルを含み、光エネルギーを利用して光合成を行う' },
        { name: 'リボソーム', role: 'mRNAの遺伝情報に基づいてタンパク質を合成する' },
        { name: 'ゴルジ体', role: '合成されたタンパク質を修飾・濃縮し細胞外へ分泌する' }
      ];
      const o = organelles[i % organelles.length];
      return {
        body: `真核細胞の小器官のうち、「${o.role}」働きを持つものはどれか。`,
        choices: [`${o.name}`, '小胞体', 'リソソーム', '中心体'],
        hints: ['二重膜構造やエネルギー代謝の関連に着目します。'],
        explanation: `${o.name} は、${o.role}細胞小器官です。`,
        tags: ['細胞構造', 'オルガネラ']
      };
    }
  },
  {
    name: 'DNAとセントラルドグマ',
    course: '生物基礎',
    generator: (i) => {
      const dogmas = [
        { step: '転写', desc: 'DNAの塩基配列情報がmRNAに写し取られる過程' },
        { step: '翻訳', desc: 'mRNAのコドンに基づいてtRNAがアミノ酸を運びタンパク質が合成される過程' },
        { step: '半保存的複製', desc: 'DNAの2本鎖がほどけ、それぞれを鋳型として新しい鎖が合成されるDNA複製方式' }
      ];
      const d = dogmas[i % dogmas.length];
      return {
        body: `遺伝情報の発現において、「${d.desc}」を何と呼ぶか。`,
        choices: [`${d.step}`, '逆転写', 'スプライシング', '変異'],
        hints: ['セントラルドグマの中心的ステップです。'],
        explanation: `「${d.desc}」は「${d.step}」と呼ばれます。`,
        tags: ['セントラルドグマ', '遺伝情報']
      };
    }
  }
];
writeSubjectQuestions('biology.json', generateDomainQuestions('biology', '生物', biologyUnits, 200));

// 5. EARTH SCIENCE (200 questions)
const earthUnits = [
  {
    name: '地球の構造とプレート',
    course: '地学基礎',
    generator: (i) => {
      const items = [
        { term: 'モホ不連続面 (モホ面)', desc: '地殻とマントルの境界' },
        { term: 'グーテンベルク不連続面', desc: 'マントルと外核（深さ約2900km）の境界' },
        { term: 'レーマン不連続面', desc: '液体の外核と固体の内核（深さ約5100km）の境界' }
      ];
      const it = items[i % items.length];
      return {
        body: `地球内部構造において、「${it.desc}」の境界面の名称はどれか。`,
        choices: [`${it.term}`, 'アセノスフェア', 'リソスフェア', 'プレート境界'],
        hints: ['地震波速度が急変する境界です。'],
        explanation: `「${it.desc}」は ${it.term} と命名されています。`,
        tags: ['地球構造', '不連続面']
      };
    }
  }
];
writeSubjectQuestions('earth_science.json', generateDomainQuestions('earth_science', '地学', earthUnits, 200));

// 6. INFORMATION (200 questions)
const infoUnits = [
  {
    name: 'コンピュータと進数表現',
    course: '情報I',
    generator: (i) => {
      const dec = (i % 15) + 1; // 1 to 15
      const bin = dec.toString(2).padStart(4, '0');
      return {
        body: `10進数の ${dec} を4ビットの2進数で表現したものはどれか。`,
        choices: [`${bin}`, `${(dec + 1).toString(2).padStart(4, '0')}`, `${(dec + 2).toString(2).padStart(4, '0')}`, '1111'],
        hints: ['重み 8, 4, 2, 1 の組み合わせで足し合わせます。'],
        explanation: `10進数 ${dec} を2進数に変換すると ${bin} です。`,
        tags: ['情報I', '2進数', '基数変換']
      };
    }
  }
];
writeSubjectQuestions('information.json', generateDomainQuestions('information', '情報', infoUnits, 200));

// 7. ENGLISH (200 questions)
const englishUnits = [
  {
    name: '英文法・語法',
    course: '論理・表現',
    generator: (i) => {
      const idioms = [
        { eng: 'look forward to', val: 'looking', sentence: 'I am looking forward to (   ) you again soon.', meaning: '〜を楽しみに待つ（toは前置詞のため動名詞）' },
        { eng: 'used to', val: 'playing', sentence: 'He is used to (   ) soccer in hot weather.', meaning: 'be used to -ing で「〜することに慣れている」' },
        { eng: 'no use', val: 'crying', sentence: 'It is no use (   ) over spilt milk.', meaning: 'It is no use -ing で「〜しても無駄である」' },
        { eng: 'cannot help', val: 'laughing', sentence: 'I could not help (   ) at his joke.', meaning: 'cannot help -ing で「〜せずにはいられない」' }
      ];
      const item = idioms[i % idioms.length];
      return {
        body: `空所に当てはまる最も適切な形を選びなさい。\n\n"${item.sentence}"`,
        choices: [`${item.val}`, 'see', 'to see', 'have seen'],
        hints: [item.meaning],
        explanation: `${item.meaning}。よって動名詞 -ing 形が正解です。`,
        tags: ['英文法', '動名詞', '前置詞']
      };
    }
  }
];
writeSubjectQuestions('english.json', generateDomainQuestions('english', '英語', englishUnits, 200));

// 8. JAPANESE (現代文) (200 questions)
const japaneseUnits = [
  {
    name: '評論読解と概念語',
    course: '論理国語',
    generator: (i) => {
      const words = [
        { word: '分節化', desc: '言葉によって連続した世界を区切り、意味あるものとして認識すること' },
        { word: '共同幻想', desc: '国家や社会など、多くの人々が共有することで現実的効力を持つ観念' },
        { word: 'アイデンティティ', desc: '自己同一性。自分が他者とは異なる一貫した自分であるという確信' },
        { word: 'パラダイム', desc: 'ある時代に支配的な物の見方・科学的認識の枠組み' }
      ];
      const item = words[i % words.length];
      return {
        body: `現代文の頻出重要語「${item.word}」の定義・説明として最も適切なものはどれか。`,
        choices: [`${item.desc}`, '自己の利益を優先して他者を排除すること', '過去の記憶を無意識下に抑圧すること', '客観的な事実のみを論理的に実証すること'],
        hints: ['近代思想・現代評論において中核となるキーワードです。'],
        explanation: `「${item.word}」とは、${item.desc}を指す評論用語です。`,
        tags: ['現代文', '重要キーワード', '読解']
      };
    }
  }
];
writeSubjectQuestions('japanese.json', generateDomainQuestions('japanese', '現代文', japaneseUnits, 200));

// 9. KOBUN (古文) (200 questions)
const kobunUnits = [
  {
    name: '古典文法・助動詞',
    course: '古典探究',
    generator: (i) => {
      const aux = [
        { word: 'る・らる', conn: 'る:四段・ナ変・ラ変の未然形、らる:その他未然形', mean: '受身・尊敬・自発・可能' },
        { word: 'す・さす', conn: '未然形接続', mean: '使役・尊敬' },
        { word: 'つ・ぬ', conn: '連用形接続', mean: '完了・強意' },
        { word: 'たり・り', conn: 'たり:連用形、り:サ未四已（サ変未然・四段已然）', mean: '存続・完了' }
      ];
      const a = aux[i % aux.length];
      return {
        body: `古文の助動詞「${a.word}」が持つ主な文法機能（意味）の組み合わせとして正しいものはどれか。`,
        choices: [`${a.mean}`, '反実仮想・ためらいの意志', '希望・願望', '打消推量・打消意志'],
        hints: [`接続は ${a.conn} です。`],
        explanation: `助動詞「${a.word}」は ${a.conn} に接続し、「${a.mean}」の意味を表します。`,
        tags: ['古文文法', '助動詞']
      };
    }
  }
];
writeSubjectQuestions('kobun.json', generateDomainQuestions('kobun', '古文', kobunUnits, 200));

// 10. KANBUN (漢文) (200 questions)
const kanbunUnits = [
  {
    name: '漢文句法と訓読',
    course: '古典探究',
    generator: (i) => {
      const rules = [
        { name: '使役句法', words: '「使」「令」「教」「遣」', read: '〜をして…（せ）しむ', meaning: '〜に…させる' },
        { name: '受身句法', words: '「見」「被」「為」「所」', read: '〜（る・らる）', meaning: '〜される' },
        { name: '反語句法', words: '「安」「豈」「何」＋文末「乎・哉」', read: 'なんぞ〜（ん・んや）', meaning: 'どうして〜だろうか（いや〜ない）' },
        { name: '限定句法', words: '「唯」「但」「特」「直」', read: 'ただニ〜のみ', meaning: 'ただ〜だけだ' }
      ];
      const r = rules[i % rules.length];
      return {
        body: `漢文において ${r.words} を用いて「${r.meaning}」という意味を表す重要句法はどれか。`,
        choices: [`${r.name}（読み: ${r.read}）`, '比較句法', '詠嘆句法', '仮定句法'],
        hints: ['大学共通テスト・二次試験で頻出の漢文基本句法です。'],
        explanation: `${r.name} は ${r.words} を用い、返り点で「${r.read}」と読み「${r.meaning}」を表します。`,
        tags: ['漢文句法', r.name]
      };
    }
  }
];
writeSubjectQuestions('kanbun.json', generateDomainQuestions('kanbun', '漢文', kanbunUnits, 200));

// 11. JAPANESE HISTORY (200 questions)
const japanHistoryUnits = [
  {
    name: '日本史探究・古代〜近世',
    course: '日本史探究',
    generator: (i) => {
      const events = [
        { year: '645年', event: '大化の改新（乙巳の変）', person: '中大兄皇子・中臣鎌足', note: '蘇我入鹿を暗殺し律令国家建設へ' },
        { year: '701年', event: '大宝律令の制定', person: '刑部親王・藤原不比等', note: '二官八省・国郡里制を確立' },
        { year: '794年', event: '平安京遷都', person: '桓武天皇', note: '長岡京から平安京へ都を移す' },
        { year: '1185年', event: '壇ノ浦の戦い・平氏滅亡', person: '源頼朝・源義経', note: '守護・地頭の設置公認を経て鎌倉幕府へ' },
        { year: '1603年', event: '徳川家康が征夷大将軍に就任', person: '徳川家康', note: '江戸幕府を開府し260年の泰平へ' }
      ];
      const ev = events[i % events.length];
      return {
        body: `日本史において ${ev.year} に ${ev.person} らによって起きた「${ev.note}」出来事はどれか。`,
        choices: [`${ev.event}`, '承久の乱', '保元・平治の乱', '建武の新政'],
        hints: [`年代は ${ev.year} です。`],
        explanation: `${ev.year}、${ev.person} により「${ev.event}」が起こりました（${ev.note}）。`,
        tags: ['日本史', '年号', '重要人物']
      };
    }
  }
];
writeSubjectQuestions('history_japan.json', generateDomainQuestions('history_japan', '日本史', japanHistoryUnits, 200));

// 12. WORLD HISTORY (200 questions)
const worldHistoryUnits = [
  {
    name: '世界史探究・古代〜近現代',
    course: '世界史探究',
    generator: (i) => {
      const events = [
        { year: '前221年', event: '秦の始皇帝による中国統一', note: '郡県制・度量衡統一・焚書坑儒' },
        { year: '1492年', event: 'コロンブスによる新大陸到達', note: 'スペイン女王イサベルの後援で大航海時代を加速' },
        { year: '1517年', event: 'ルターの「95箇条の論題」・宗教改革', note: '贖宥状（免罪符）販売を批判' },
        { year: '1789年', event: 'フランス革命・バスティーユ牢獄襲撃', note: '人権宣言採択・立憲君主制から共和政へ' },
        { year: '1914年', event: 'サラエボ事件・第一次世界大戦勃発', note: 'オーストリア皇太子夫妻暗殺を契機に開戦' }
      ];
      const ev = events[i % events.length];
      return {
        body: `世界史において「${ev.note}」という歴史的事象を何と呼ぶか。`,
        choices: [`${ev.event}（${ev.year}）`, '産業革命', 'ウェストファリア条約締結', 'ウィーン会議'],
        hints: [`年代は ${ev.year} です。`],
        explanation: `${ev.year} に起こった「${ev.event}」は、${ev.note}ことで歴史に大きな転換点をもたらしました。`,
        tags: ['世界史', '世界史重要事項', '市民革命']
      };
    }
  }
];
writeSubjectQuestions('history_world.json', generateDomainQuestions('history_world', '世界史', worldHistoryUnits, 200));

// 13. GEOGRAPHY (200 questions)
const geographyUnits = [
  {
    name: '地理探究・気候と地形',
    course: '地理探究',
    generator: (i) => {
      const climates = [
        { code: 'Af', name: '熱帯雨林気候', feature: '年中高温多雨でスコールが発生し、セルバやジャングルが広がる' },
        { code: 'Cs', name: '地中海性気候', feature: '夏季乾燥・冬季湿潤で、オリーブやコルクガシを栽培する' },
        { code: 'Cfa', name: '温暖湿潤気候', feature: '四季が明瞭で年間を通して雨が多く、照葉樹林や混合林が分布する（日本本州など）' },
        { code: 'ET', name: 'ツンドラ気候', feature: '最暖月平均気温が0〜10℃で、コケ類や地衣類が生育する' }
      ];
      const c = climates[i % climates.length];
      return {
        body: `ケッペンの気候区分において、「${c.feature}」特徴を持つ気候区分はどれか。`,
        choices: [`${c.name} (${c.code})`, '砂漠気候 (BW)', '西岸海洋性気候 (Cfb)', '亜寒帯湿潤気候 (Df)'],
        hints: [`気候記号は ${c.code} です。`],
        explanation: `ケッペンの気候区分 ${c.code} は「${c.name}」と呼ばれ、${c.feature}という特徴を持ちます。`,
        tags: ['地理', '気候区分', 'ケッペン']
      };
    }
  }
];
writeSubjectQuestions('geography.json', generateDomainQuestions('geography', '地理', geographyUnits, 200));

// 14. CIVICS (200 questions)
const civicsUnits = [
  {
    name: '公共・憲法と政治経済',
    course: '公共',
    generator: (i) => {
      const concepts = [
        { term: '国民主権', desc: '国のあり方を最終的に決定する権力が国民に存するという日本国憲法の基本原理' },
        { term: '平和主義（戦争放棄）', desc: '日本国憲法第9条において戦力不保持・交戦権否認を定めた基本原理' },
        { term: '違憲審査権', desc: '裁判所が法律や行政処分が憲法に適合しているかを判断する権限' },
        { term: '市場の失敗', desc: '公共財の供給不足や外部不経済など、市場の自動調節機能が十分に働かない現象' },
        { term: '金融緩和政策', desc: '中央銀行（日本銀行）が政策金利の引き下げや国債買い入れを行い、通貨供給量を増やす政策' }
      ];
      const c = concepts[i % concepts.length];
      return {
        body: `現代社会・公共における概念のうち、「${c.desc}」を指す用語はどれか。`,
        choices: [`${c.term}`, '法の支配', '夜警国家観', '財政投融資'],
        hints: ['高校の公共・政治経済で最頻出の基本概念です。'],
        explanation: `「${c.desc}」は ${c.term} の説明です。`,
        tags: ['公共', '政治経済', '憲法原理']
      };
    }
  }
];
writeSubjectQuestions('civics.json', generateDomainQuestions('civics', '公民', civicsUnits, 200));

console.log('Finished generating all 14 subjects with 200 questions each (Total 2,800 questions)!');
