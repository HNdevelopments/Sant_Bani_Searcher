import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../widgets/disclaimer_dialog.dart';
import 'bani_detail_screen.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/bani_card.dart';
import '../models/bani.dart';
import '../services/data_service.dart';
import '../services/search_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Bani> allBanis = [];
  List<Bani> filteredBanis = [];

  bool loading = true;

  final TextEditingController searchController = TextEditingController();

  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  int? highlightedBaniId;

  @override
  void initState() {
    super.initState();
    loadData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      DisclaimerDialog.show(context);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    final data = await DataService.loadAllBanis();

    setState(() {
      allBanis = data;
      filteredBanis = data;
      loading = false;
    });
  }

  void search(String query) {
    setState(() {
      filteredBanis = SearchService.search(
        query,
        allBanis,
      );
    });
  }

  Future<void> _openDetail(Bani bani) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final returnedId = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => BaniDetailScreen(bani: bani),
      ),
    );
    FocusManager.instance.primaryFocus?.unfocus();

    if (returnedId == null || !mounted) return;

    searchController.clear();
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      filteredBanis = List<Bani>.from(allBanis);
    });

    await Future.delayed(const Duration(milliseconds: 100));

    final index = filteredBanis.indexWhere((e) => e.id == returnedId);

    if (index == -1) return;

    _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOutExpo,
    );

    setState(() {
      highlightedBaniId = returnedId;
    });

    await Future.delayed(const Duration(seconds: 10));

    if (!mounted) return;

    setState(() {
      highlightedBaniId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFAF7F2),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: SearchBarWidget(
                controller: searchController,
                onChanged: search,
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Scrollbar(
                child: ScrollablePositionedList.builder(
                  itemScrollController: _itemScrollController,
                  itemPositionsListener: _itemPositionsListener,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    0,
                    18,
                    24,
                  ),
                  itemCount: filteredBanis.length,
                  itemBuilder: (context, index) {
                    final bani = filteredBanis[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: BaniCard(
                        bani: bani,
                        highlighted: bani.id == highlightedBaniId,
                        onTap: () => _openDetail(bani), 
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}