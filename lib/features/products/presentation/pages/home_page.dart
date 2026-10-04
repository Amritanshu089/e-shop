import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../cart/domain/cart_item.dart';
import '../../../wishlist/bloc/wishlist_bloc.dart';
import '../../../wishlist/bloc/wishlist_event.dart';
import '../../../wishlist/bloc/wishlist_state.dart';
import '../../data/models/product_model.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';
import '../bloc/cart_event.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController =
      TextEditingController();

  int _selectedCategoryIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<ProductBloc>().add(
                  const RefreshProducts(),
                );

            await Future.delayed(
              const Duration(milliseconds: 700),
            );
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeader(),
              ),
              SliverToBoxAdapter(
                child: _buildSearchBar(),
              ),
              SliverToBoxAdapter(
                child: _buildHeroBanner(),
              ),
              SliverToBoxAdapter(
                child: _buildCategories(),
              ),
              SliverToBoxAdapter(
                child: _buildSectionHeader(),
              ),
              _buildProducts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        12,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7C4DFF),
                  Color(0xFF9C6BFF),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.shopping_bag_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Shoply',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Everything you love, in one place',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          _headerButton(
            Icons.favorite_border_rounded,
            () {
              context.go('/wishlist');
            },
          ),
          const SizedBox(width: 8),
          _buildCartHeaderButton(),
        ],
      ),
    );
  }

  Widget _buildCartHeaderButton() {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            _headerButton(
              Icons.shopping_bag_outlined,
              () {
                context.go('/cart');
              },
            ),
            if (state.totalItems > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 19,
                    minHeight: 19,
                  ),
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5C7A),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFF8F7FC),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      state.totalItems > 99
                          ? '99+'
                          : '${state.totalItems}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _headerButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            size: 22,
            color: const Color(0xFF29243D),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        8,
        20,
        20,
      ),
      child: TextFormField(
        controller: _searchController,
        onChanged: (value) {
          context.read<ProductBloc>().add(
                SearchProducts(value),
              );
        },
        decoration: const InputDecoration(
          hintText: 'Search products, brands...',
          prefixIcon: Icon(
            Icons.search_rounded,
          ),
          suffixIcon: Icon(
            Icons.tune_rounded,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6C4CF1),
              Color(0xFF9D72FF),
              Color(0xFFFF7BA5),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -35,
              top: -45,
              child: Container(
                width: 145,
                height: 145,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.10,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'LIMITED OFFER',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Fresh picks.\nBetter prices.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          height: 1.05,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Up to 40% off selected products',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 13),
                      SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategoryIndex = 0;
                            });

                            context
                                .read<ProductBloc>()
                                .add(
                                  const SelectCategory(
                                    null,
                                  ),
                                );
                          },
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.white,
                            foregroundColor:
                                const Color(0xFF6949E8),
                            elevation: 0,
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 16,
                            ),
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                12,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Shop now',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  flex: 4,
                  child: Center(
                    child: Icon(
                      Icons.shopping_bag_rounded,
                      size: 76,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 25,
        bottom: 5,
      ),
      child: BlocBuilder<ProductBloc, ProductState>(
        buildWhen: (previous, current) =>
            previous.categories != current.categories ||
            previous.selectedCategory !=
                current.selectedCategory,
        builder: (context, state) {
          final categories = [
            'All',
            ...state.categories.take(8),
          ];

          return Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Browse categories',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 43,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final selected =
                        _selectedCategoryIndex == index;

                    return Padding(
                      padding:
                          const EdgeInsets.only(right: 9),
                      child: ChoiceChip(
                        label: Text(
                          _formatCategory(
                            categories[index],
                          ),
                        ),
                        selected: selected,
                        showCheckmark: false,
                        onSelected: (_) {
                          setState(() {
                            _selectedCategoryIndex =
                                index;
                          });

                          context
                              .read<ProductBloc>()
                              .add(
                                index == 0
                                    ? const SelectCategory(
                                        null,
                                      )
                                    : SelectCategory(
                                        categories[index],
                                      ),
                              );
                        },
                        selectedColor:
                            const Color(0xFF7C4DFF),
                        backgroundColor: Colors.white,
                        side: BorderSide.none,
                        labelStyle: TextStyle(
                          color: selected
                              ? Colors.white
                              : const Color(0xFF6D687D),
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        24,
        20,
        15,
      ),
      child: Text(
        'Trending products',
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildProducts() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.status == ProductStatus.loading &&
            state.products.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(50),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (state.status == ProductStatus.failure &&
            state.products.isEmpty) {
          return SliverToBoxAdapter(
            child: _buildErrorState(state),
          );
        }

        final products = state.visibleProducts;

        if (products.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(50),
              child: Center(
                child: Text(
                  'No products found',
                ),
              ),
            ),
          );
        }

        return SliverPadding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ProductCard(
                  product: products[index],
                );
              },
              childCount: products.length,
            ),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 16,
              childAspectRatio: 0.63,
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(ProductState state) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 55,
            color: Color(0xFFFF5C7A),
          ),
          const SizedBox(height: 12),
          const Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.errorMessage ??
                'Unable to load products',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              context.read<ProductBloc>().add(
                    const LoadProducts(),
                  );
            },
            child: const Text(
              'Try again',
            ),
          ),
        ],
      ),
    );
  }

  String _formatCategory(String category) {
    if (category == 'All') {
      return category;
    }

    return category
        .split('-')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }
}

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final discountedPrice = product.price -
        (product.price *
            product.discountPercentage /
            100);

    return BlocBuilder<WishlistBloc, WishlistState>(
      buildWhen: (previous, current) =>
          previous.contains(product.id) !=
          current.contains(product.id),
      builder: (context, wishlistState) {
        final isWishlisted =
            wishlistState.contains(product.id);

        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              context.push(
                '/products/${product.id}',
              );
            },
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        color: const Color(0xFFF5F3FA),
                        child: Image.network(
                          product.thumbnail,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons
                                    .image_not_supported_outlined,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                      if (product.discountPercentage > 0)
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFFFF5C7A),
                              borderRadius:
                                  BorderRadius.circular(9),
                            ),
                            child: Text(
                              '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight:
                                    FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        top: 9,
                        right: 9,
                        child: Material(
                          color: Colors.white,
                          shape: const CircleBorder(),
                          child: InkWell(
                            onTap: () {
                              context
                                  .read<WishlistBloc>()
                                  .add(
                                    ToggleWishlist(
                                      product,
                                    ),
                                  );
                            },
                            customBorder:
                                const CircleBorder(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(8),
                              child: Icon(
                                isWishlisted
                                    ? Icons
                                        .favorite_rounded
                                    : Icons
                                        .favorite_border_rounded,
                                size: 17,
                                color: isWishlisted
                                    ? const Color(
                                        0xFFFF5C7A,
                                      )
                                    : const Color(
                                        0xFF29243D,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    12,
                    10,
                    12,
                    12,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.brand.isNotEmpty
                            ? product.brand
                            : product.category,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF8B8798),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.title,
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 15,
                            color: Color(0xFFFFB020),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            product.rating
                                .toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${product.stock} left',
                            style: const TextStyle(
                              fontSize: 9,
                              color:
                                  Color(0xFF4CAF50),
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '\$${discountedPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.w800,
                              ),
                            ),
                          ),
                          if (product
                                  .discountPercentage >
                              0)
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                decoration:
                                    TextDecoration
                                        .lineThrough,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 9),
                      SizedBox(
                        width: double.infinity,
                        height: 34,
                        child: ElevatedButton.icon(
                          onPressed: product.stock <= 0
                              ? null
                              : () {
                                  context
                                      .read<CartBloc>()
                                      .add(
                                        AddToCart(
                                          CartItem(
                                            product:
                                                product,
                                            quantity: 1,
                                          ),
                                        ),
                                      );

                                  ScaffoldMessenger.of(
                                    context,
                                  )
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${product.title} added to cart',
                                        ),
                                        behavior:
                                            SnackBarBehavior
                                                .floating,
                                        duration:
                                            const Duration(
                                          milliseconds:
                                              1200,
                                        ),
                                      ),
                                    );
                                },
                          icon: const Icon(
                            Icons
                                .shopping_bag_outlined,
                            size: 15,
                          ),
                          label: Text(
                            product.stock > 0
                                ? 'Add to cart'
                                : 'Out of stock',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(
                              0xFF7C4DFF,
                            ),
                            foregroundColor:
                                Colors.white,
                            disabledBackgroundColor:
                                Colors.grey.shade300,
                            disabledForegroundColor:
                                Colors.grey.shade600,
                            elevation: 0,
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 8,
                            ),
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                11,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}