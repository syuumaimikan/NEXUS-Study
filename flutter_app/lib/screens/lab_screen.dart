import 'package:flutter/material.dart';
import '../widgets/labs/quadratic_lab_widget.dart';
import '../widgets/labs/trig_circle_lab_widget.dart';
import '../widgets/labs/calculus_tangent_lab_widget.dart';
import '../widgets/labs/projectile_lab_widget.dart';
import '../widgets/labs/doppler_wave_lab_widget.dart';
import '../widgets/labs/lens_optics_lab_widget.dart';
import '../widgets/labs/periodic_table_lab_widget.dart';
import '../widgets/labs/titration_ph_lab_widget.dart';
import '../widgets/labs/le_chatelier_lab_widget.dart';
import '../widgets/labs/crystal_lattice_lab_widget.dart';
import '../widgets/labs/genetics_lab_widget.dart';
import '../widgets/labs/seismic_wave_lab_widget.dart';
import '../widgets/labs/central_dogma_lab_widget.dart';
import '../widgets/labs/history_timeline_lab_widget.dart';
import '../widgets/labs/sort_visualizer_lab_widget.dart';
import '../widgets/labs/dijkstra_lab_widget.dart';
import '../widgets/labs/pendulum_lab_widget.dart';
import '../widgets/labs/ac_circuit_lab_widget.dart';
import '../widgets/labs/galvanic_cell_lab_widget.dart';
import '../widgets/labs/gas_laws_lab_widget.dart';
import '../widgets/labs/normal_distribution_lab_widget.dart';
import '../widgets/labs/plate_tectonics_lab_widget.dart';
import '../widgets/labs/enzyme_kinetics_lab_widget.dart';

class LabScreen extends StatefulWidget {
  final int initialTabIndex;

  const LabScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<LabScreen> createState() => _LabScreenState();
}

class _LabScreenState extends State<LabScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _mathSubTab = 0;      // 0: 2次関数, 1: 単位円, 2: 三次関数接線, 3: 正規分布
  int _physicsSubTab = 0;   // 0: 斜方投射, 1: ドップラー, 2: 凸レンズ, 3: 振り子, 4: 交流RLC
  int _chemSubTab = 0;      // 0: 周期表, 1: 滴定, 2: ルシャトリエ, 3: 結晶格子, 4: ダニエル電池, 5: 気体方程式
  int _bioEarthSubTab = 0;  // 0: メンデル, 1: 地震波, 2: セントラルドグマ, 3: プレート, 4: 酵素
  int _infoSubTab = 0;      // 0: ソート, 1: ダイクストラ

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 6,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, 5),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            Icon(Icons.biotech, color: Color(0xFF38BDF8), size: 22),
            SizedBox(width: 8),
            Text(
              'NEXUS Lab (総合可視化実験室・全22種)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: const Color(0xFF38BDF8),
          indicatorWeight: 3,
          labelColor: const Color(0xFF38BDF8),
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(icon: Icon(Icons.calculate, size: 18), text: '数学グラフ'),
            Tab(icon: Icon(Icons.bolt, size: 18), text: '物理・力学/光学'),
            Tab(icon: Icon(Icons.science, size: 18), text: '化学・周期表/平衡'),
            Tab(icon: Icon(Icons.public, size: 18), text: '生物・地学'),
            Tab(icon: Icon(Icons.history_edu, size: 18), text: '歴史タイムライン'),
            Tab(icon: Icon(Icons.terminal, size: 18), text: '情報・アルゴリズム'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 0: Math
          _buildMathView(),
          // 1: Physics
          _buildPhysicsView(),
          // 2: Chemistry
          _buildChemView(),
          // 3: Biology & Earth Science
          _buildBioEarthView(),
          // 4: History
          const HistoryTimelineLabWidget(),
          // 5: Information Science
          _buildInfoView(),
        ],
      ),
    );
  }

  Widget _buildMathView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: const Color(0xFF0B1120),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _subChip('2次関数 & 判別式', _mathSubTab == 0, () => setState(() => _mathSubTab = 0)),
                const SizedBox(width: 8),
                _subChip('三角比 & 単位円', _mathSubTab == 1, () => setState(() => _mathSubTab = 1)),
                const SizedBox(width: 8),
                _subChip('3次関数 & 微分接線', _mathSubTab == 2, () => setState(() => _mathSubTab = 2)),
                const SizedBox(width: 8),
                _subChip('正規分布 ＆ 偏差値', _mathSubTab == 3, () => setState(() => _mathSubTab = 3)),
              ],
            ),
          ),
        ),
        Expanded(
          child: _mathSubTab == 0
              ? const QuadraticLabWidget()
              : _mathSubTab == 1
                  ? const TrigCircleLabWidget()
                  : _mathSubTab == 2
                      ? const CalculusTangentLabWidget()
                      : const NormalDistributionLabWidget(),
        ),
      ],
    );
  }

  Widget _buildPhysicsView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: const Color(0xFF0B1120),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _subChip('斜方投射 (力学)', _physicsSubTab == 0, () => setState(() => _physicsSubTab = 0)),
                const SizedBox(width: 8),
                _subChip('ドップラー効果 (波動)', _physicsSubTab == 1, () => setState(() => _physicsSubTab = 1)),
                const SizedBox(width: 8),
                _subChip('凸レンズ結像 (幾何光学)', _physicsSubTab == 2, () => setState(() => _physicsSubTab = 2)),
                const SizedBox(width: 8),
                _subChip('単振り子 (エネルギー保存)', _physicsSubTab == 3, () => setState(() => _physicsSubTab = 3)),
                const SizedBox(width: 8),
                _subChip('交流RLC回路 (共振)', _physicsSubTab == 4, () => setState(() => _physicsSubTab = 4)),
              ],
            ),
          ),
        ),
        Expanded(
          child: _physicsSubTab == 0
              ? const ProjectileLabWidget()
              : _physicsSubTab == 1
                  ? const DopplerWaveLabWidget()
                  : _physicsSubTab == 2
                      ? const LensOpticsLabWidget()
                      : _physicsSubTab == 3
                          ? const PendulumLabWidget()
                          : const AcCircuitLabWidget(),
        ),
      ],
    );
  }

  Widget _buildChemView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: const Color(0xFF0B1120),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _subChip('118元素周期表 (完全版)', _chemSubTab == 0, () => setState(() => _chemSubTab = 0)),
                const SizedBox(width: 8),
                _subChip('中和滴定pH曲線', _chemSubTab == 1, () => setState(() => _chemSubTab = 1)),
                const SizedBox(width: 8),
                _subChip('ルシャトリエの原理 (平衡)', _chemSubTab == 2, () => setState(() => _chemSubTab = 2)),
                const SizedBox(width: 8),
                _subChip('結晶格子3D＆充填率', _chemSubTab == 3, () => setState(() => _chemSubTab = 3)),
                const SizedBox(width: 8),
                _subChip('ダニエル電池 (イオン化傾向)', _chemSubTab == 4, () => setState(() => _chemSubTab = 4)),
                const SizedBox(width: 8),
                _subChip('気体の状態方程式 PV=nRT', _chemSubTab == 5, () => setState(() => _chemSubTab = 5)),
              ],
            ),
          ),
        ),
        Expanded(
          child: _chemSubTab == 0
              ? const PeriodicTableLabWidget()
              : _chemSubTab == 1
                  ? const TitrationPhLabWidget()
                  : _chemSubTab == 2
                      ? const LeChatelierLabWidget()
                      : _chemSubTab == 3
                          ? const CrystalLatticeLabWidget()
                          : _chemSubTab == 4
                              ? const GalvanicCellLabWidget()
                              : const GasLawsLabWidget(),
        ),
      ],
    );
  }

  Widget _buildBioEarthView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: const Color(0xFF0B1120),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _subChip('メンデル遺伝 (生物)', _bioEarthSubTab == 0, () => setState(() => _bioEarthSubTab = 0)),
                const SizedBox(width: 8),
                _subChip('地震波伝播・大森公式 (地学)', _bioEarthSubTab == 1, () => setState(() => _bioEarthSubTab = 1)),
                const SizedBox(width: 8),
                _subChip('セントラルドグマ (転写翻訳)', _bioEarthSubTab == 2, () => setState(() => _bioEarthSubTab = 2)),
                const SizedBox(width: 8),
                _subChip('プレート沈み込み・海溝 (地学)', _bioEarthSubTab == 3, () => setState(() => _bioEarthSubTab = 3)),
                const SizedBox(width: 8),
                _subChip('酵素反応速度論 (生物)', _bioEarthSubTab == 4, () => setState(() => _bioEarthSubTab = 4)),
              ],
            ),
          ),
        ),
        Expanded(
          child: _bioEarthSubTab == 0
              ? const GeneticsLabWidget()
              : _bioEarthSubTab == 1
                  ? const SeismicWaveLabWidget()
                  : _bioEarthSubTab == 2
                      ? const CentralDogmaLabWidget()
                      : _bioEarthSubTab == 3
                          ? const PlateTectonicsLabWidget()
                          : const EnzymeKineticsLabWidget(),
        ),
      ],
    );
  }

  Widget _buildInfoView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: const Color(0xFF0B1120),
          child: Row(
            children: [
              Expanded(
                child: _subChip('ソートアルゴリズム可視化', _infoSubTab == 0, () => setState(() => _infoSubTab = 0)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _subChip('ダイクストラ法 (最短経路)', _infoSubTab == 1, () => setState(() => _infoSubTab = 1)),
              ),
            ],
          ),
        ),
        Expanded(
          child: _infoSubTab == 0 ? const SortVisualizerLabWidget() : const DijkstraLabWidget(),
        ),
      ],
    );
  }

  Widget _subChip(String label, bool isSelected, VoidCallback onSelect) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: const Color(0xFF38BDF8),
      backgroundColor: const Color(0xFF1E293B),
      labelStyle: TextStyle(
        fontSize: 11,
        color: isSelected ? Colors.black : Colors.white70,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (_) => onSelect(),
    );
  }
}
