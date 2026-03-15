import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/utils.dart';
import 'home_notifier.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.selectedPage});

  final int? selectedPage;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _lastBackPressTime;
  late final HomeScreenNotifier homeScreenNotifier;
  final ValueNotifier<bool> canExit = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    homeScreenNotifier = HomeScreenNotifier(selectedPage: widget.selectedPage);
  }

  void _handleBackPressed(BuildContext context) {
    final now = DateTime.now();
    const exitWarningDuration = Duration(seconds: 3);
    final utils = UtilsWithContext(context);

    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > exitWarningDuration) {
      _lastBackPressTime = now;
      canExit.value = false;
      utils.showSnackBar(message: 'Press back again to exit app');
    } else {
      canExit.value = true;
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      } else {
        SystemNavigator.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: canExit,
      builder: (context, value, child) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              _handleBackPressed(context);
            }
          },
          child: ListenableBuilder(
            listenable: homeScreenNotifier,
            builder: (context, child) {
              var pageData = homeScreenNotifier
                  .getPageData[homeScreenNotifier.getSelectedIndex];
              homeScreenNotifier.updateContext(context);
              return Scaffold(
                // appBar: buildAppBar(context, pageData),
                // endDrawer: const EndDrawerWidget(),
                body: SafeArea(child: Center(child: pageData['page'])),
                bottomNavigationBar: CustomBottomNavBar(
                  selectedIndex: homeScreenNotifier.getSelectedIndex,
                  onTabTapped: (index) => homeScreenNotifier.onTabTapped(index),
                  items: homeScreenNotifier.getPageData,
                ),
                // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                // floatingActionButton: pageData['fabExists'] ? FloatingActionButton(
                //   onPressed: pageData['fabOnPressed'],
                //   child: pageData['fabChild'] ?? const Icon(Icons.add),
                // ) : const SizedBox(),
              );
            },
          ),
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context, Map<String, dynamic> pageData) {
    // final drawerWidget = Builder(
    //   builder: (ctx) => CustomIconButton(
    //     iconData: Icons.person,
    //     voidCallback: () => Scaffold.of(ctx).openEndDrawer(),
    //   ),
    // );
    //
    // final List<Widget> actions = List<Widget>.from(pageData['actions'] ?? []);
    // actions.add(drawerWidget);

    return AppBar(
      title: Text(pageData['title'] ?? ''),
      // actions: actions,
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabTapped;
  final List<Map<String, dynamic>> items;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabTapped,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = selectedIndex == index;

          return Expanded(
            flex: isSelected ? 2 : 1,
            child: GestureDetector(
              onTap: () => onTabTapped(index),
              behavior: HitTestBehavior.opaque,
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 16 : 8,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSelected ? item['activeIcon'] : item['icon'],
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface,
                        size: 24,
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            item['label'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class CustomBottomNavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomBottomNavItem({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFD700) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? Colors.black : Colors.grey[600],
                size: 24,
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class CustomBottomNavBarAlt extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabTapped;
  final List<Map<String, dynamic>> items;

  const CustomBottomNavBarAlt({
    super.key,
    required this.selectedIndex,
    required this.onTabTapped,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          return CustomBottomNavItem(
            icon: item['icon'],
            activeIcon: item['activeIcon'],
            label: item['label'],
            isSelected: selectedIndex == index,
            onTap: () => onTabTapped(index),
          );
        }),
      ),
    );
  }
}
