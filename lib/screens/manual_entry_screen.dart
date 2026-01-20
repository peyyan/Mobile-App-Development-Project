import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutriscan/utils/color_ext.dart';

class ManualEntryResult {
  final String name;
  final int calories;
  final int? protein;
  final int? carbs;
  final int? fat;
  final int? fiber;
  final int? sugar;
  final int? sodium;
  final String? imageUrl;

  const ManualEntryResult({
    required this.name,
    required this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.fiber,
    this.sugar,
    this.sodium,
    this.imageUrl,
  });
}

class ManualEntryScreen extends StatefulWidget {
  const ManualEntryScreen({super.key});

  @override
  State<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends State<ManualEntryScreen> {
  final _controller = TextEditingController();
  bool _isSubmitting = false;
  int _selectedCalories = 0;
  ManualEntryResult? _selectedItem;
  final Map<String, int> _selectedCounts = {};

  final List<ManualEntryResult> _singleItems = const [
    ManualEntryResult(
      name: 'Nasi putih (1 cup)',
      calories: 200,
      protein: 4,
      carbs: 45,
      fat: 1,
      fiber: 1,
      sugar: 0,
      sodium: 5,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Telur goreng',
      calories: 90,
      protein: 6,
      carbs: 0,
      fat: 7,
      fiber: 0,
      sugar: 0,
      sodium: 70,
      imageUrl: 'https://images.unsplash.com/photo-1505253716362-afaea1d3d1af',
    ),
    ManualEntryResult(
      name: 'Ayam goreng (1 pc)',
      calories: 250,
      protein: 20,
      carbs: 8,
      fat: 14,
      fiber: 0,
      sugar: 0,
      sodium: 450,
      imageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19',
    ),
    ManualEntryResult(
      name: 'Ikan bakar (1 pc)',
      calories: 220,
      protein: 28,
      carbs: 2,
      fat: 9,
      fiber: 0,
      sugar: 0,
      sodium: 220,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Sambal (1 tbsp)',
      calories: 40,
      protein: 1,
      carbs: 4,
      fat: 2,
      fiber: 1,
      sugar: 2,
      sodium: 180,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Kangkung belacan',
      calories: 120,
      protein: 4,
      carbs: 10,
      fat: 6,
      fiber: 3,
      sugar: 3,
      sodium: 320,
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
    ),
    ManualEntryResult(
      name: 'Taugeh (stir-fry)',
      calories: 80,
      protein: 5,
      carbs: 6,
      fat: 3,
      fiber: 2,
      sugar: 2,
      sodium: 120,
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
    ),
    ManualEntryResult(
      name: 'Tempeh (2 pcs)',
      calories: 160,
      protein: 12,
      carbs: 10,
      fat: 8,
      fiber: 4,
      sugar: 1,
      sodium: 10,
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
    ),
    ManualEntryResult(
      name: 'Tahu goreng (2 pcs)',
      calories: 140,
      protein: 8,
      carbs: 6,
      fat: 9,
      fiber: 1,
      sugar: 1,
      sodium: 180,
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
    ),
    ManualEntryResult(
      name: 'Satay chicken (5 sticks)',
      calories: 330,
      protein: 28,
      carbs: 12,
      fat: 18,
      fiber: 1,
      sugar: 5,
      sodium: 480,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Roti canai (1 pc)',
      calories: 300,
      protein: 7,
      carbs: 39,
      fat: 12,
      fiber: 1,
      sugar: 2,
      sodium: 300,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Roti telur (1 pc)',
      calories: 360,
      protein: 12,
      carbs: 39,
      fat: 16,
      fiber: 1,
      sugar: 2,
      sodium: 420,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Curry puff (1 pc)',
      calories: 180,
      protein: 3,
      carbs: 18,
      fat: 10,
      fiber: 1,
      sugar: 2,
      sodium: 250,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Kuih (1 pc)',
      calories: 120,
      protein: 2,
      carbs: 20,
      fat: 3,
      fiber: 1,
      sugar: 8,
      sodium: 80,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Teh tarik (1 cup)',
      calories: 160,
      protein: 5,
      carbs: 22,
      fat: 5,
      fiber: 0,
      sugar: 18,
      sodium: 90,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Kopi O (1 cup)',
      calories: 50,
      protein: 1,
      carbs: 10,
      fat: 0,
      fiber: 0,
      sugar: 8,
      sodium: 10,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Milo ais (1 cup)',
      calories: 180,
      protein: 5,
      carbs: 28,
      fat: 5,
      fiber: 1,
      sugar: 22,
      sodium: 120,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Laksa broth (1 bowl)',
      calories: 90,
      protein: 4,
      carbs: 8,
      fat: 4,
      fiber: 1,
      sugar: 2,
      sodium: 420,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Chicken soup (1 bowl)',
      calories: 120,
      protein: 10,
      carbs: 4,
      fat: 5,
      fiber: 0,
      sugar: 1,
      sodium: 480,
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
    ),
    ManualEntryResult(
      name: 'Fruit (1 serving)',
      calories: 80,
      protein: 1,
      carbs: 20,
      fat: 0,
      fiber: 3,
      sugar: 12,
      sodium: 2,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
  ];

  final List<ManualEntryResult> _fullMeals = const [
    ManualEntryResult(
      name: 'Nasi lemak (basic)',
      calories: 500,
      protein: 12,
      carbs: 60,
      fat: 22,
      fiber: 4,
      sugar: 6,
      sodium: 650,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Nasi lemak + fried chicken',
      calories: 750,
      protein: 28,
      carbs: 70,
      fat: 38,
      fiber: 4,
      sugar: 6,
      sodium: 900,
      imageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19',
    ),
    ManualEntryResult(
      name: 'Nasi ayam (Hainanese)',
      calories: 650,
      protein: 28,
      carbs: 75,
      fat: 20,
      fiber: 2,
      sugar: 3,
      sodium: 700,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Nasi kandar (mixed)',
      calories: 850,
      protein: 32,
      carbs: 95,
      fat: 38,
      fiber: 5,
      sugar: 6,
      sodium: 1100,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Nasi goreng kampung',
      calories: 600,
      protein: 18,
      carbs: 70,
      fat: 22,
      fiber: 3,
      sugar: 3,
      sodium: 750,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Nasi goreng pattaya',
      calories: 700,
      protein: 20,
      carbs: 75,
      fat: 30,
      fiber: 3,
      sugar: 5,
      sodium: 780,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Mee goreng mamak',
      calories: 700,
      protein: 20,
      carbs: 85,
      fat: 25,
      fiber: 4,
      sugar: 5,
      sodium: 900,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Char kuey teow',
      calories: 750,
      protein: 22,
      carbs: 80,
      fat: 30,
      fiber: 3,
      sugar: 4,
      sodium: 850,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Mee rebus',
      calories: 600,
      protein: 16,
      carbs: 70,
      fat: 20,
      fiber: 4,
      sugar: 6,
      sodium: 700,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Mee kari',
      calories: 650,
      protein: 18,
      carbs: 70,
      fat: 26,
      fiber: 4,
      sugar: 4,
      sodium: 850,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Laksa Penang',
      calories: 600,
      protein: 20,
      carbs: 65,
      fat: 18,
      fiber: 3,
      sugar: 4,
      sodium: 800,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Curry mee',
      calories: 700,
      protein: 20,
      carbs: 70,
      fat: 30,
      fiber: 4,
      sugar: 4,
      sodium: 900,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Hokkien mee',
      calories: 750,
      protein: 22,
      carbs: 80,
      fat: 30,
      fiber: 3,
      sugar: 4,
      sodium: 850,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Wantan mee',
      calories: 650,
      protein: 22,
      carbs: 70,
      fat: 22,
      fiber: 3,
      sugar: 3,
      sodium: 780,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Roti canai + dhal',
      calories: 420,
      protein: 12,
      carbs: 55,
      fat: 14,
      fiber: 5,
      sugar: 3,
      sodium: 520,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Roti canai + curry chicken',
      calories: 650,
      protein: 22,
      carbs: 55,
      fat: 28,
      fiber: 4,
      sugar: 4,
      sodium: 780,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Mee hoon soup',
      calories: 450,
      protein: 16,
      carbs: 55,
      fat: 12,
      fiber: 2,
      sugar: 3,
      sodium: 650,
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
    ),
    ManualEntryResult(
      name: 'Nasi campur (mixed rice)',
      calories: 700,
      protein: 24,
      carbs: 80,
      fat: 24,
      fiber: 4,
      sugar: 4,
      sodium: 900,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Claypot chicken rice',
      calories: 750,
      protein: 28,
      carbs: 85,
      fat: 25,
      fiber: 2,
      sugar: 3,
      sodium: 850,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Nasi kerabu',
      calories: 550,
      protein: 20,
      carbs: 65,
      fat: 18,
      fiber: 5,
      sugar: 3,
      sodium: 700,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Ayam percik + rice',
      calories: 650,
      protein: 26,
      carbs: 60,
      fat: 28,
      fiber: 2,
      sugar: 5,
      sodium: 800,
      imageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19',
    ),
    ManualEntryResult(
      name: 'Asam pedas + rice',
      calories: 620,
      protein: 24,
      carbs: 60,
      fat: 22,
      fiber: 3,
      sugar: 4,
      sodium: 780,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Murtabak',
      calories: 700,
      protein: 28,
      carbs: 70,
      fat: 30,
      fiber: 3,
      sugar: 3,
      sodium: 900,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Chicken biryani',
      calories: 700,
      protein: 25,
      carbs: 80,
      fat: 25,
      fiber: 3,
      sugar: 3,
      sodium: 750,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Banana leaf rice (veg)',
      calories: 650,
      protein: 14,
      carbs: 90,
      fat: 18,
      fiber: 6,
      sugar: 4,
      sodium: 700,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Thosai + sambar',
      calories: 420,
      protein: 10,
      carbs: 70,
      fat: 10,
      fiber: 4,
      sugar: 3,
      sodium: 500,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Idli (3 pcs) + sambar',
      calories: 350,
      protein: 9,
      carbs: 60,
      fat: 6,
      fiber: 3,
      sugar: 2,
      sodium: 420,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Nasi dagang',
      calories: 650,
      protein: 20,
      carbs: 80,
      fat: 22,
      fiber: 3,
      sugar: 4,
      sodium: 780,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Rendang daging + rice',
      calories: 750,
      protein: 28,
      carbs: 60,
      fat: 35,
      fiber: 3,
      sugar: 4,
      sodium: 850,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
    ManualEntryResult(
      name: 'Soto ayam + rice',
      calories: 620,
      protein: 22,
      carbs: 65,
      fat: 20,
      fiber: 2,
      sugar: 3,
      sodium: 750,
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
    ),
    ManualEntryResult(
      name: 'Fish head curry + rice',
      calories: 780,
      protein: 30,
      carbs: 60,
      fat: 38,
      fiber: 3,
      sugar: 4,
      sodium: 980,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a food description.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    if (_selectedCounts.isNotEmpty) {
      Navigator.of(context).pop(_aggregateSelected());
      return;
    }
    if (_selectedItem != null && _selectedItem!.name == value) {
      Navigator.of(context).pop(_selectedItem);
      return;
    }
    Navigator.of(
      context,
    ).pop(ManualEntryResult(name: value, calories: _selectedCalories));
  }

  void _selectQuickItem(ManualEntryResult item) {
    setState(() {
      _controller.text = item.name;
      _selectedCalories = item.calories;
      _selectedItem = item;
      _selectedCounts.clear();
    });
  }

  void _toggleSingleItem(ManualEntryResult item) {
    setState(() {
      final current = _selectedCounts[item.name] ?? 0;
      _selectedCounts[item.name] = current + 1;
      _selectedItem = null;
      _recalculateSelection();
    });
  }

  void _removeSingleItem(ManualEntryResult item) {
    setState(() {
      final current = _selectedCounts[item.name] ?? 0;
      if (current <= 1) {
        _selectedCounts.remove(item.name);
      } else {
        _selectedCounts[item.name] = current - 1;
      }
      _recalculateSelection();
    });
  }

  void _recalculateSelection() {
    if (_selectedCounts.isEmpty) {
      _selectedCalories = 0;
      _controller.text = '';
      return;
    }

    final names = <String>[];
    int calories = 0;
    for (final item in _singleItems) {
      final count = _selectedCounts[item.name] ?? 0;
      if (count > 0) {
        names.add('${item.name} x$count');
        calories += item.calories * count;
      }
    }
    _controller.text = names.join(', ');
    _selectedCalories = calories;
  }

  ManualEntryResult _aggregateSelected() {
    int calories = 0;
    int protein = 0;
    int carbs = 0;
    int fat = 0;
    int fiber = 0;
    int sugar = 0;
    int sodium = 0;
    final names = <String>[];

    for (final item in _singleItems) {
      final count = _selectedCounts[item.name] ?? 0;
      if (count == 0) continue;
      names.add('${item.name} x$count');
      calories += item.calories * count;
      protein += (item.protein ?? 0) * count;
      carbs += (item.carbs ?? 0) * count;
      fat += (item.fat ?? 0) * count;
      fiber += (item.fiber ?? 0) * count;
      sugar += (item.sugar ?? 0) * count;
      sodium += (item.sodium ?? 0) * count;
    }

    return ManualEntryResult(
      name: names.join(', '),
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      fiber: fiber,
      sugar: sugar,
      sodium: sodium,
      imageUrl: _singleItems.first.imageUrl,
    );
  }

  Future<void> _submitQuickItem(ManualEntryResult item) async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;
    Navigator.of(context).pop(item);
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF13ec5b);
    const backgroundLight = Color(0xFFffffff);
    const textColor = Color(0xFF0d1b12);

    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        backgroundColor: backgroundLight,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.chevron_left, color: textColor),
          style: IconButton.styleFrom(backgroundColor: primaryColor.o(0.1)),
        ),
        title: Text(
          'Manual Entry',
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Describe your meal to log it quickly.',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: textColor.o(0.6),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'FOOD DESCRIPTION',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: textColor.o(0.8),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.o(0.03),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g., Chicken salad with avocado',
                    hintStyle: TextStyle(color: textColor.o(0.3)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'QUICK PICKS (SINGLE ITEMS)',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: textColor.o(0.8),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _singleItems.map((item) {
                  final count = _selectedCounts[item.name] ?? 0;
                  return ActionChip(
                    label: Text(
                      count > 0
                          ? '${item.name} x$count - ${item.calories} kcal'
                          : '${item.name} - ${item.calories} kcal',
                      style: GoogleFonts.manrope(fontSize: 12),
                    ),
                    onPressed: () => _toggleSingleItem(item),
                    onLongPress: count > 0
                        ? () => _removeSingleItem(item)
                        : null,
                    backgroundColor: count > 0
                        ? primaryColor.o(0.15)
                        : Colors.grey[100],
                    side: BorderSide(color: Colors.black.o(0.05)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text(
                'FULL MEALS (MALAYSIAN CUISINE)',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: textColor.o(0.8),
                ),
              ),
              const SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _fullMeals.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = _fullMeals[index];
                  return InkWell(
                    onTap: () => _submitQuickItem(item),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black.o(0.05)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${item.calories} kcal',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: textColor.o(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              if (_selectedCalories > 0)
                Text(
                  'Estimated calories: $_selectedCalories kcal',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: textColor,
                    elevation: 0,
                    shadowColor: primaryColor.o(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(textColor),
                        )
                      : Text(
                          'Submit',
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
