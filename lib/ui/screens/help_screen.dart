import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQCategory {
  final String title;
  final String icon;
  final List<FAQ> faqs;

  const FAQCategory({
    required this.title,
    required this.icon,
    required this.faqs,
  });
}

class FAQ {
  final String question;
  final String answer;

  const FAQ({
    required this.question,
    required this.answer,
  });
}

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final _searchController = TextEditingController();
  int? _expandedTileIndex;

  final List<FAQCategory> _categories = [
    const FAQCategory(
      title: 'Заказы',
      icon: '🛍️',
      faqs: [
        FAQ(
          question: 'Как отследить статус заказа?',
          answer: 'Вы можете отследить статус вашего заказа в разделе '
              '"История заказов" в вашем профиле. Там вы найдете информацию '
              'о текущем статусе и местоположении вашего заказа.',
        ),
        FAQ(
          question: 'Как отменить заказ?',
          answer: 'Чтобы отменить заказ, перейдите в раздел "История заказов", '
              'найдите нужный заказ и нажмите кнопку "Отменить". Обратите '
              'внимание, что отменить заказ можно только до того, как он будет '
              'принят в обработку.',
        ),
      ],
    ),
    const FAQCategory(
      title: 'Оплата',
      icon: '💳',
      faqs: [
        FAQ(
          question: 'Какие способы оплаты доступны?',
          answer: 'Мы принимаем различные способы оплаты:\n'
              '• Банковские карты (Visa, Mastercard)\n'
              '• Apple Pay и Google Pay\n'
              '• Наличные при доставке',
        ),
        FAQ(
          question: 'Как добавить новую карту?',
          answer: 'Чтобы добавить новую карту, перейдите в раздел '
              '"Способы оплаты" в вашем профиле и нажмите "Добавить карту". '
              'Введите данные карты, и она будет сохранена для будущих покупок.',
        ),
      ],
    ),
    const FAQCategory(
      title: 'Доставка',
      icon: '🚚',
      faqs: [
        FAQ(
          question: 'Сколько времени занимает доставка?',
          answer: 'Стандартное время доставки составляет 30-45 минут с момента '
              'подтверждения заказа. Точное время зависит от вашего '
              'местоположения и загруженности службы доставки.',
        ),
        FAQ(
          question: 'В какие районы осуществляется доставка?',
          answer: 'Мы доставляем заказы во все районы города. При оформлении '
              'заказа вы можете указать свой адрес, и система автоматически '
              'проверит возможность доставки.',
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildHeader(context),
          SliverToBoxAdapter(
            child: _buildSearch()
                .animate()
                .fadeIn(duration: 500.ms)
                .slideY(begin: -0.2, end: 0),
          ),
          SliverToBoxAdapter(
            child: _buildContactSupport(context)
                .animate()
                .fadeIn(delay: 200.ms)
                .slideY(begin: 0.2, end: 0),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Частые вопросы',
                style: GoogleFonts.sourceCodePro(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ).animate().fadeIn(delay: 400.ms),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 600),
                    child: SlideAnimation(
                      verticalOffset: 50,
                      child: FadeInAnimation(
                        child: _buildCategoryCard(
                          context,
                          _categories[index],
                          index,
                        ),
                      ),
                    ),
                  );
                },
                childCount: _categories.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 150,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Помощь',
          style: GoogleFonts.sourceCodePro(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.2),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Поиск по вопросам',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildContactSupport(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.support_agent,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Нужна помощь?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Свяжитесь с нами в чате',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Open chat support
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).colorScheme.primary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
            ),
            child: const Text(
              'Чат',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    FAQCategory category,
    int categoryIndex,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: categoryIndex == _expandedTileIndex,
          onExpansionChanged: (expanded) {
            setState(() {
              _expandedTileIndex = expanded ? categoryIndex : null;
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          leading: Text(
            category.icon,
            style: const TextStyle(fontSize: 24),
          ),
          title: Text(
            category.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          children: category.faqs.map((faq) => _buildFAQItem(faq)).toList(),
        ),
      ),
    );
  }

  Widget _buildFAQItem(FAQ faq) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            faq.question,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                faq.answer,
                style: TextStyle(
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
