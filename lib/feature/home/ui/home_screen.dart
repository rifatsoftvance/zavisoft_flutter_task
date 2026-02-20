import 'package:flutter/material.dart';
import 'package:zavisoft_flutter_task/core/api_client.dart';
import 'package:zavisoft_flutter_task/feature/home/data/model/product_model.dart';
import 'package:zavisoft_flutter_task/feature/profile/ui/Profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  final api = ApiClient();
  late TabController _tabController;

  List<ProductModel> all = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetch();
  }

  Future<void> fetch() async {
    final products = await api.fetchProducts();
    setState(() {
      all = products;
      loading = false;
    });
  }

  List<ProductModel> filter(String category) {
    if (category == "all") return all;
    return all.where((e) => e.category == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetch,
        child: NestedScrollView(
          physics: const AlwaysScrollableScrollPhysics(),

          /// HEADER PART (Banner + TabBar)
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              /// Collapsible Banner
              SliverAppBar(
                expandedHeight: 200,
                pinned: false,        // Banner disappears
                floating: false,
                snap: false,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Colors.orange,
                    alignment: Alignment.center,
                    child: const Text(
                      "Daraz Style Banner",
                      style: TextStyle(
                          color: Colors.white, fontSize: 22),
                    ),
                  ),
                ),
              ),

              /// Sticky TabBar
              SliverPersistentHeader(
                pinned: true,   // 🔥 THIS keeps tab bar visible
                delegate: _TabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(text: "All"),
                      Tab(text: "Men"),
                      Tab(text: "Women"),
                    ],
                  ),
                ),
              ),
            ];
          },

          /// BODY PART (Tab Views)
          body: TabBarView(
            controller: _tabController,
            children: [
              ProductList(products: filter("all")),
              ProductList(products: filter("men's clothing")),
              ProductList(products: filter("women's clothing")),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.person),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          );
        },
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  final List<ProductModel> products;

  const ProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      // ❌ DO NOT disable scrolling here
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final p = products[index];
              return ListTile(
                leading: Image.network(p.image, width: 50),
                title: Text(p.title),
                subtitle: Text("\$${p.price}"),
              );
            },
            childCount: products.length,
          ),
        ),
      ],
    );
  }
}

/// TabBar Sticky Delegate
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_) => false;
}