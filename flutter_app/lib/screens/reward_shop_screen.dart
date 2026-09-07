import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/storage_service.dart';

class ShopItem {
  final String id;
  final String title;
  final String description;
  final int cost;
  final IconData icon;
  final Color color;
  final String category; // 'title' | 'frame' | 'item'

  const ShopItem({
    required this.id,
    required this.title,
    required this.description,
    required this.cost,
    required this.icon,
    required this.color,
    required this.category,
  });
}

class RewardShopScreen extends StatefulWidget {
  final UserProfile profile;
  final ValueChanged<UserProfile> onProfileUpdated;

  const RewardShopScreen({
    super.key,
    required this.profile,
    required this.onProfileUpdated,
  });

  @override
  State<RewardShopScreen> createState() => _RewardShopScreenState();
}

class _RewardShopScreenState extends State<RewardShopScreen> {
  late UserProfile _currentProfile;

  static const List<ShopItem> _items = [
    // 称号
    ShopItem(
      id: 'title_calculus',
      title: '微積マスター',
      description: '導関数・積分計算を極めし者の称号',
      cost: 200,
      icon: Icons.show_chart,
      color: Color(0xFF38BDF8),
      category: 'title',
    ),
    ShopItem(
      id: 'title_target1900',
      title: '英単語1900覇者',
      description: 'ターゲット1900を完全踏破した証',
      cost: 300,
      icon: Icons.menu_book,
      color: Color(0xFF34D399),
      category: 'title',
    ),
    ShopItem(
      id: 'title_todai',
      title: '東大理三志望',
      description: '最難関の頂を目指すチャレンジャー',
      cost: 500,
      icon: Icons.school,
      color: Color(0xFFF43F5E),
      category: 'title',
    ),
    ShopItem(
      id: 'title_math_wizard',
      title: '数理の魔術師',
      description: '数学・物理の数式を自由自在に操る者',
      cost: 350,
      icon: Icons.auto_awesome,
      color: Color(0xFF818CF8),
      category: 'title',
    ),
    ShopItem(
      id: 'title_zenkoku',
      title: '全統模試1位',
      description: '全国模試トップランカーの威厳',
      cost: 600,
      icon: Icons.emoji_events,
      color: Color(0xFFFBBF24),
      category: 'title',
    ),
    ShopItem(
      id: 'title_speed',
      title: '神速スプリンター',
      description: '5秒以内の神速即答を繰り返す者',
      cost: 250,
      icon: Icons.bolt,
      color: Color(0xFFF59E0B),
      category: 'title',
    ),

    // アバターフレーム
    ShopItem(
      id: 'frame_galaxy',
      title: 'ギャラクシー・パープル',
      description: '深宇宙の輝きを放つネオンフレーム',
      cost: 250,
      icon: Icons.blur_on,
      color: Color(0xFFA855F7),
      category: 'frame',
    ),
    ShopItem(
      id: 'frame_gold',
      title: '太陽フレア・ゴールド',
      description: '黄金に輝く王者のオーラフレーム',
      cost: 400,
      icon: Icons.wb_sunny,
      color: Color(0xFFFBBF24),
      category: 'frame',
    ),
    ShopItem(
      id: 'frame_emerald',
      title: 'クォンタム・エメラルド',
      description: '量子力学的な翠緑のパルスフレーム',
      cost: 300,
      icon: Icons.all_inclusive,
      color: Color(0xFF10B981),
      category: 'frame',
    ),

    // アイテム
    ShopItem(
      id: 'item_shield',
      title: 'ストリーク保険証',
      description: '学習を忘れた日もストリーク継続を1回保護',
      cost: 120,
      icon: Icons.shield,
      color: Color(0xFF38BDF8),
      category: 'item',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentProfile = widget.profile;
  }

  void _buyOrEquip(ShopItem item) async {
    final messenger = ScaffoldMessenger.of(context);
    if (item.category == 'title') {
      final isUnlocked = _currentProfile.unlockedTitles.contains(item.title);
      if (isUnlocked) {
        // Equip title
        final updated = _currentProfile.copyWith(title: item.title);
        await StorageService().saveProfile(updated);
        setState(() => _currentProfile = updated);
        widget.onProfileUpdated(updated);
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            content: Text('称号「${item.title}」をセットしました！'),
            duration: const Duration(milliseconds: 1200),
            backgroundColor: const Color(0xFF38BDF8),
          ),
        );
        return;
      }

      if (_currentProfile.coins < item.cost) {
        messenger.clearSnackBars();
        messenger.showSnackBar(
          const SnackBar(
            content: Text('コインが不足しています！問題を解いてコインを貯めよう。'),
            duration: Duration(milliseconds: 1200),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
        return;
      }

      // Purchase title
      final updatedList = [..._currentProfile.unlockedTitles, item.title];
      final updated = _currentProfile.copyWith(
        coins: _currentProfile.coins - item.cost,
        unlockedTitles: updatedList,
        title: item.title,
      );
      await StorageService().saveProfile(updated);
      setState(() => _currentProfile = updated);
      widget.onProfileUpdated(updated);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text('🎉 称号「${item.title}」を獲得・装備しました！'),
          duration: const Duration(milliseconds: 1200),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    } else if (item.category == 'frame') {
      final frameKey = item.id.replaceAll('frame_', '');
      final isEquipped = _currentProfile.avatarFrame == frameKey;
      if (isEquipped) return;

      if (_currentProfile.coins < item.cost) {
        messenger.clearSnackBars();
        messenger.showSnackBar(
          const SnackBar(
            content: Text('コインが不足しています！'),
            duration: Duration(milliseconds: 1200),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
        return;
      }

      final updated = _currentProfile.copyWith(
        coins: _currentProfile.coins - item.cost,
        avatarFrame: frameKey,
      );
      await StorageService().saveProfile(updated);
      setState(() => _currentProfile = updated);
      widget.onProfileUpdated(updated);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text('フレーム「${item.title}」を解放・装着しました！'),
          duration: const Duration(milliseconds: 1200),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    } else if (item.category == 'item') {
      if (_currentProfile.coins < item.cost) {
        messenger.clearSnackBars();
        messenger.showSnackBar(
          const SnackBar(
            content: Text('コインが不足しています！'),
            duration: Duration(milliseconds: 1200),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
        return;
      }

      final updated = _currentProfile.copyWith(
        coins: _currentProfile.coins - item.cost,
        streakShields: _currentProfile.streakShields + 1,
      );
      await StorageService().saveProfile(updated);
      setState(() => _currentProfile = updated);
      widget.onProfileUpdated(updated);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('🛡️ ストリーク保険証を購入しました！所持数+1'),
          duration: Duration(milliseconds: 1200),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
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
            Icon(Icons.storefront, color: Color(0xFFFBBF24), size: 22),
            SizedBox(width: 8),
            Text('NEXUS コイン交換所', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          // Coins balance chip
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFBBF24).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFBBF24).withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, size: 15, color: Color(0xFFFBBF24)),
                const SizedBox(width: 4),
                Text(
                  '${_currentProfile.coins} G',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFFBBF24)),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current Equips Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                      border: Border.all(
                        color: _currentProfile.avatarFrame == 'gold'
                            ? const Color(0xFFFBBF24)
                            : _currentProfile.avatarFrame == 'purple'
                                ? const Color(0xFFA855F7)
                                : _currentProfile.avatarFrame == 'emerald'
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFF38BDF8),
                        width: 2.5,
                      ),
                    ),
                    child: const Icon(Icons.school, color: Color(0xFF38BDF8), size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBBF24).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFFBBF24).withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                _currentProfile.title,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFFBBF24)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _currentProfile.username,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          'ストリーク保険証: ${_currentProfile.streakShields}枚所持',
                          style: const TextStyle(fontSize: 11, color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              '限定称号・ステータス',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),

            ..._items.where((it) => it.category == 'title').map(_buildShopItemTile),

            const SizedBox(height: 20),

            const Text(
              'アバター・ネオンフレーム',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),

            ..._items.where((it) => it.category == 'frame').map(_buildShopItemTile),

            const SizedBox(height: 20),

            const Text(
              'やる気サポート・アイテム',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),

            ..._items.where((it) => it.category == 'item').map(_buildShopItemTile),
          ],
        ),
      ),
    );
  }

  Widget _buildShopItemTile(ShopItem item) {
    bool isOwned = false;
    bool isEquipped = false;

    if (item.category == 'title') {
      isOwned = _currentProfile.unlockedTitles.contains(item.title);
      isEquipped = _currentProfile.title == item.title;
    } else if (item.category == 'frame') {
      final frameKey = item.id.replaceAll('frame_', '');
      isEquipped = _currentProfile.avatarFrame == frameKey;
      isOwned = isEquipped;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isEquipped ? item.color : Colors.white10),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(item.icon, color: item.color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      if (isEquipped) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: item.color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '装備中',
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: item.color),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(item.description, style: const TextStyle(fontSize: 11, color: Colors.white54)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: isEquipped ? null : () => _buyOrEquip(item),
              style: ElevatedButton.styleFrom(
                backgroundColor: isOwned ? const Color(0xFF1E293B) : const Color(0xFFFBBF24),
                foregroundColor: isOwned ? Colors.white : Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                isEquipped
                    ? '装備中'
                    : isOwned
                        ? 'セット'
                        : '${item.cost} G',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
