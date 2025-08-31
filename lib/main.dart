
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const M3KitchenSinkApp());
}

class M3KitchenSinkApp extends StatelessWidget {
  const M3KitchenSinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorSchemeSeed: const Color(0xFF6750A4),
      useMaterial3: true,
      // On Android 12+, Flutter uses the platform sparkle ripple by default under M3.
      splashFactory: InkSparkle.splashFactory,
    );
    return MaterialApp(
      title: 'Material 3 Kitchen Sink',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const RootScaffold(),
    );
  }
}

class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key});

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  int _index = 0;
  final _pages = const [
    ButtonsPage(),
    SelectionPage(),
    TextSearchPage(),
    OverlaysPage(),
    StructurePage(),
    ChipsDemoApp()
  ];

  @override
  Widget build(BuildContext context) {
    final destinations = const [
      NavigationDestination(icon: Icon(Icons.smart_button_outlined), selectedIcon: Icon(Icons.smart_button), label: 'Buttons'),
      NavigationDestination(icon: Icon(Icons.tune_outlined), selectedIcon: Icon(Icons.tune), label: 'Selection'),
      NavigationDestination(icon: Icon(Icons.search_outlined), selectedIcon: Icon(Icons.search), label: 'Text & Search'),
      NavigationDestination(icon: Icon(Icons.layers_outlined), selectedIcon: Icon(Icons.layers), label: 'Overlays'),
      NavigationDestination(icon: Icon(Icons.view_agenda_outlined), selectedIcon: Icon(Icons.view_agenda), label: 'Structure'),
      NavigationDestination(icon: Icon(Icons.padding_outlined), selectedIcon: Icon(Icons.padding_rounded), label: 'Chips'),
    ];

    final rail = NavigationRail(
      selectedIndex: _index,
      onDestinationSelected: (i) => setState(() => _index = i),
      labelType: NavigationRailLabelType.all,
      destinations: destinations.map((d) => NavigationRailDestination(icon: d.icon, selectedIcon: d.selectedIcon, label: Text(d.label))).toList(),
    );

    final body = _pages[_index];

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        if (wide) {
          return Scaffold(
            appBar: AppBar(title: const Text('Material 3 Kitchen Sink')),
            body: Row(
              children: [
                SizedBox(width: 88, child: rail),
                const VerticalDivider(width: 1),
                Expanded(child: body),
              ],
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Material 3 Kitchen Sink')),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            destinations: destinations,
            onDestinationSelected: (i) => setState(() => _index = i),
          ),
          body: body,
        );
      },
    );
  }
}

/// ---------- Buttons (Common, Icon, FAB, Segmented) ----------
class ButtonsPage extends StatefulWidget {
  const ButtonsPage({super.key});

  @override
  State<ButtonsPage> createState() => _ButtonsPageState();
}

class _ButtonsPageState extends State<ButtonsPage> {
  Set<String> segments = {'daily'};

  @override
  Widget build(BuildContext context) {
    return _SectionList(children: [
      _Section(
        title: 'Common buttons',
        subtitle: 'Elevated / Filled / Filled tonal / Outlined / Text',
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.upload), label: const Text('Elevated')),
            FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.check_circle), label: const Text('Filled')),
            FilledButton.tonalIcon(onPressed: () {}, icon: const Icon(Icons.more_horiz), label: const Text('Tonal')),
            OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.share), label: const Text('Outlined')),
            TextButton(onPressed: () {}, child: const Text('Text Button')),
          ],
        ),
      ),
      _Section(
        title: 'Icon buttons (M3 variants)',
        subtitle: 'Standard / Filled / Filled tonal / Outlined',
        child: Wrap(
          spacing: 12,
          children: const [
            IconButton(onPressed: null, icon: Icon(Icons.favorite_border)),
            IconButton.filled(onPressed: null, icon: Icon(Icons.favorite)),
            IconButton.filledTonal(onPressed: null, icon: Icon(Icons.favorite)),
            IconButton.outlined(onPressed: null, icon: Icon(Icons.favorite_border)),
          ],
        ),
      ),
      _Section(
        title: 'Floating Action Buttons',
        subtitle: 'FAB and extended FAB',
        child: Wrap(
          spacing: 16,
          children: [
            FloatingActionButton(
              onPressed: () => _snack(context, 'FAB tapped'),
              tooltip: 'Create',
              child: const Icon(Icons.add),
            ),
            FloatingActionButton.extended(
              onPressed: () => _snack(context, 'Extended FAB tapped'),
              icon: const Icon(Icons.send),
              label: const Text('Send'),
            ),
          ],
        ),
      ),
      _Section(
        title: 'SegmentedButton (single-select)',
        subtitle: 'A compact alternative to tabs/toggles for <=5 options',
        child: SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'daily', label: Text('Daily'), icon: Icon(Icons.calendar_view_day)),
            ButtonSegment(value: 'weekly', label: Text('Weekly'), icon: Icon(Icons.date_range)),
            ButtonSegment(value: 'monthly', label: Text('Monthly'), icon: Icon(Icons.calendar_month)),
          ],
          selected: segments,
          onSelectionChanged: (s) => setState(() => segments = s),
          emptySelectionAllowed: false,
          showSelectedIcon: false,
        ),
      ),
    ]);
  }
}

/// ---------- Selection (Checkbox, Radio, Switch, Slider) ----------
class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  bool newsletter = true;
  bool notifications = false;

  String shipping = 'standard';
  double price = 30;
  RangeValues range = const RangeValues(20, 80);

  @override
  Widget build(BuildContext context) {
    return _SectionList(children: [
      _Section(
        title: 'Checkbox / CheckboxListTile',
        child: Column(
          children: [
            CheckboxListTile(
              title: const Text('Subscribe to newsletter'),
              subtitle: const Text('Get product tips weekly'),
              value: newsletter,
              onChanged: (v) => setState(() => newsletter = v ?? false),
            ),
            Row(
              children: [
                const Text('Enable notifications'),
                const SizedBox(width: 12),
                Checkbox(value: notifications, onChanged: (v) => setState(() => notifications = v ?? false)),
              ],
            ),
          ],
        ),
      ),
      _Section(
        title: 'Radio / RadioListTile (mutually exclusive)',
        child: Column(
          children: [
            RadioListTile<String>(
              title: const Text('Standard shipping'),
              value: 'standard',
              groupValue: shipping,
              onChanged: (v) => setState(() => shipping = v!),
            ),
            RadioListTile<String>(
              title: const Text('Express shipping'),
              value: 'express',
              groupValue: shipping,
              onChanged: (v) => setState(() => shipping = v!),
            ),
          ],
        ),
      ),
      _Section(
        title: 'Switch / SwitchListTile',
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Dark mode'),
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (_) => _snack(context, 'Hook up your theme toggler here'),
            ),
            Row(
              children: [
                const Text('Push notifications'),
                const SizedBox(width: 12),
                Switch(value: notifications, onChanged: (v) => setState(() => notifications = v)),
              ],
            ),
          ],
        ),
      ),
      _Section(
        title: 'Slider / RangeSlider',
        child: Column(
          children: [
            Row(
              children: [
                const Text('Price'),
                Expanded(
                  child: Slider(
                    value: price,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: price.round().toString(),
                    onChanged: (v) => setState(() => price = v),
                  ),
                ),
              ],
            ),
            RangeSlider(
              values: range,
              min: 0,
              max: 100,
              divisions: 20,
              labels: RangeLabels('${range.start.round()}', '${range.end.round()}'),
              onChanged: (v) => setState(() => range = v),
            ),
          ],
        ),
      ),
    ]);
  }
}

/// ---------- Text & Search (TextField, InputDecoration, SearchBar/Anchor) ----------
class TextSearchPage extends StatefulWidget {
  const TextSearchPage({super.key});

  @override
  State<TextSearchPage> createState() => _TextSearchPageState();
}

class _TextSearchPageState extends State<TextSearchPage> {
  final _controller = TextEditingController();
  final _searchController = SearchController();
  final _suggestions = [
    'iPhone 15 Pro',
    'Samsung S24 Ultra',
    'MacBook Air M3',
    'Dell XPS 13',
    'Pixel 9 Pro',
  ];

  @override
  Widget build(BuildContext context) {
    return _SectionList(children: [
      _Section(
        title: 'TextField + InputDecoration',
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'name@example.com',
                prefixIcon: Icon(Icons.email_outlined),
                helperText: 'We never share your email.',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
                suffixIcon: Icon(Icons.visibility_off),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
      ),
      _Section(
        title: 'SearchBar + SearchAnchor',
        child: SearchAnchor.bar(
          barHintText: 'Search products…',
          searchController: _searchController,
          suggestionsBuilder: (context, controller) {
            final q = controller.text.toLowerCase();
            final filtered = _suggestions.where((s) => s.toLowerCase().contains(q)).toList();
            return List<ListTile>.generate(filtered.length, (i) {
              return ListTile(
                leading: const Icon(Icons.search),
                title: Text(filtered[i]),
                onTap: () {
                  controller.closeView(filtered[i]);
                  _snack(context, 'Selected: ${filtered[i]}');
                },
              );
            });
          },
        ),
      ),
    ]);
  }
}

/// ---------- Overlays (Dialogs, SnackBar, BottomSheet, Pickers) ----------
class OverlaysPage extends StatelessWidget {
  const OverlaysPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _SectionList(children: [
      _Section(
        title: 'AlertDialog & Dialog.fullscreen',
        child: Wrap(
          spacing: 12,
          children: [
            FilledButton(
              onPressed: () => showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete item?'),
                  content: const Text('This action cannot be undone.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                    FilledButton.tonal(onPressed: () => Navigator.pop(ctx), child: const Text('Delete')),
                  ],
                ),
              ),
              child: const Text('Show AlertDialog'),
            ),
            OutlinedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (ctx) => Dialog.fullscreen(
                  child: Scaffold(
                    appBar: AppBar(title: const Text('Compose Email')),
                    body: const Padding(
                      padding: EdgeInsets.all(16),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Body',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: null,
                      ),
                    ),
                  ),
                ),
              ),
              child: const Text('Fullscreen dialog'),
            ),
          ],
        ),
      ),
      _Section(
        title: 'SnackBar',
        child: FilledButton.icon(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Saved successfully'),
              action: SnackBarAction(label: 'Undo', onPressed: () {}),
              behavior: SnackBarBehavior.floating,
            ),
          ),
          icon: const Icon(Icons.save),
          label: const Text('Show SnackBar'),
        ),
      ),
      _Section(
        title: 'Bottom sheets (modal & persistent)',
        child: Wrap(
          spacing: 12,
          children: [
            FilledButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                showDragHandle: true,
                builder: (ctx) => const _CartSheet(),
              ),
              child: const Text('Modal sheet'),
            ),
            OutlinedButton(
              onPressed: () => _showPersistentSheet(context),
              child: const Text('Persistent sheet'),
            ),
          ],
        ),
      ),
      _Section(
        title: 'Date & Time pickers',
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.tonal(
              onPressed: () async {
                final now = DateTime.now();
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(now.year - 5),
                  lastDate: DateTime(now.year + 5),
                  initialDate: now,
                );
                if (context.mounted && date != null) {
                  _snack(context, 'Picked: ${date.toIso8601String().split("T").first}');
                }
              },
              child: const Text('showDatePicker'),
            ),
            OutlinedButton(
              onPressed: () async {
                final now = DateTime.now();
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(now.year - 5),
                  lastDate: DateTime(now.year + 5),
                  initialDateRange: DateTimeRange(start: now, end: now.add(const Duration(days: 7))),
                );
                if (context.mounted && range != null) {
                  _snack(context, 'Range: ${range.start.toString().split(" ").first} → ${range.end.toString().split(" ").first}');
                }
              },
              child: const Text('showDateRangePicker'),
            ),
            OutlinedButton(
              onPressed: () async {
                final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                if (context.mounted && t != null) {
                  _snack(context, 'Time: ${t.format(context)}');
                }
              },
              child: const Text('showTimePicker'),
            ),
          ],
        ),
      ),
    ]);
  }

  static void _showPersistentSheet(BuildContext context) {
    showBottomSheet(
      context: context,
      builder: (ctx) => const _CartSheet(persistent: true),
    );
  }
}

class _CartSheet extends StatelessWidget {
  const _CartSheet({this.persistent = false});

  final bool persistent;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.shopping_cart_outlined),
                const SizedBox(width: 8),
                Text(persistent ? 'Persistent sheet' : 'Modal sheet', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                if (!persistent) IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 8),
            const Text('2 items · \$89.98'),
            const SizedBox(height: 12),
            FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.payment), label: const Text('Checkout')),
          ],
        ),
      ),
    );
  }
}

/// ---------- Structure (Cards, Lists, Menus, Progress, Navigation bits) ----------
class StructurePage extends StatefulWidget {
  const StructurePage({super.key});

  @override
  State<StructurePage> createState() => _StructurePageState();
}

class _StructurePageState extends State<StructurePage> {
  String? dropdownValue = 'Yemen';
  bool _showMenuBar = kIsWeb || defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.windows;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawerExample(),
      body: _SectionList(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          _Section(
            title: 'Cards + ListTile + Divider',
            child: Card(
              elevation: 0.5,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: const [
                  ListTile(leading: Icon(Icons.person), title: Text('Alaa'), subtitle: Text('Manager')),
                  Divider(height: 1),
                  ListTile(leading: Icon(Icons.phone), title: Text('+967-7xx-xxx-xxx')),
                ],
              ),
            ),
          ),
          _Section(
            title: 'DropdownMenu (M3)',
            child: DropdownMenu<String>(
              enableSearch: true,
              enableFilter: true,
              enabled: true,
              initialSelection: dropdownValue,
              label: const Text('Country'),
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: 'Yemen', label: 'Yemen'),
                DropdownMenuEntry(value: 'KSA', label: 'Saudi Arabia'),
                DropdownMenuEntry(value: 'UAE', label: 'United Arab Emirates'),
              ],
              onSelected: (v) => setState(() => dropdownValue = v),
            ),
          ),
          _Section(
            title: 'MenuAnchor (context menu)',
            child: Align(
              alignment: Alignment.centerLeft,
              child: MenuAnchor(
                builder: (context, controller, child) {
                  return FilledButton.tonalIcon(
                    onPressed: () => controller.isOpen ? controller.close() : controller.open(),
                    icon: const Icon(Icons.more_vert),
                    label: const Text('Open menu'),
                  );
                },
                menuChildren: [
                  MenuItemButton(leadingIcon: const Icon(Icons.copy), onPressed: () => _snack(context, 'Copied!'), child: const Text('Copy')),
                  MenuItemButton(leadingIcon: const Icon(Icons.share), onPressed: () => _snack(context, 'Shared!'), child: const Text('Share')),
                  const Divider(),
                  SubmenuButton(
                    leadingIcon: const Icon(Icons.settings),
                    menuChildren: [
                      MenuItemButton(onPressed: () {}, child: const Text('Preferences')),
                      MenuItemButton(onPressed: () {}, child: const Text('Shortcuts')),
                    ],
                    child: const Text('Settings'),
                  ),
                ],
              ),
            ),
          ),
          if (_showMenuBar)
            _Section(
              title: 'MenuBar (desktop)',
              child: MenuBar(children: [
                SubmenuButton(menuChildren: [
                  MenuItemButton(onPressed: () {}, child: const Text('New')),
                  MenuItemButton(onPressed: () {}, child: const Text('Open')),
                ], child: const Text('File')),
                SubmenuButton(menuChildren: [
                  MenuItemButton(onPressed: () {}, child: const Text('Undo')),
                  MenuItemButton(onPressed: () {}, child: const Text('Redo')),
                ], child: const Text('Edit')),
              ]),
            ),
          _Section(
            title: 'Progress indicators',
            child: Row(
              children: const [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Expanded(child: LinearProgressIndicator(value: 0.6)),
              ],
            ),
          ),
          _Section(
            title: 'Tabs (primary & secondary)',
            child: SizedBox(
              height: 180,
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: const [
                    TabBar(tabs: [Tab(text: 'Home'), Tab(text: 'Work'), Tab(text: 'School')]),
                    SizedBox(height: 8),
                    TabBar.secondary(tabs: [Tab(icon: Icon(Icons.grid_view)), Tab(icon: Icon(Icons.list)), Tab(icon: Icon(Icons.table_rows))]),
                  ],
                ),
              ),
            ),
          ),
          _Section(
            title: 'Navigation Drawer (M3)',
            child: const Text('Open the Drawer from the app bar on mobile or the leading menu icon on desktop.'),
          ),
          _Section(
            title: 'AppBar variants (SliverAppBar.medium / large)',
            child: FilledButton.tonal(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SliverAppBarsDemo())),
              child: const Text('View scrolling app bars'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _snack(context, 'FAB on Structure page'),
        label: const Text('Action'),
        icon: const Icon(Icons.flash_on),
      ),
      bottomNavigationBar: const _BottomAppBarDemo(),
    );
  }
}

class NavigationDrawerExample extends StatelessWidget {
  const NavigationDrawerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text('Quick links', style: Theme.of(context).textTheme.titleSmall),
        ),
        const NavigationDrawerDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text('Home')),
        const NavigationDrawerDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: Text('Settings')),
      ],
    );
  }
}

class _BottomAppBarDemo extends StatelessWidget {
  const _BottomAppBarDemo();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.home_outlined)),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
    );
  }
}

class SliverAppBarsDemo extends StatelessWidget {
  const SliverAppBarsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: const Text('Medium app bar'),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
            ],
          ),
          SliverList.list(children: List.generate(16, (i) => ListTile(leading: const Icon(Icons.label_outline), title: Text('Item $i')))),
          SliverAppBar.large(
            title: const Text('Large app bar'),
            pinned: true,
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_outline)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
            ],
          ),
          SliverList.list(children: List.generate(24, (i) => ListTile(leading: const Icon(Icons.label), title: Text('More $i')))),
        ],
      ),
    );
  }
}

/// ---------- Helpers ----------
class _SectionList extends StatelessWidget {
  const _SectionList({required this.children, this.padding});

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.separated(
        padding: padding ?? const EdgeInsets.all(16),
        itemBuilder: (context, i) => children[i],
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemCount: children.length,
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, this.subtitle, required this.child});

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
            ],
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

void _snack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
class ChipsDemoApp extends StatelessWidget {
  const ChipsDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chips Demo (M3)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6750A4),
      ),
      home: const ChipsScreen(),
    );
  }
}

class ChipsScreen extends StatefulWidget {
  const ChipsScreen({super.key});

  @override
  State<ChipsScreen> createState() => _ChipsScreenState();
}

class _ChipsScreenState extends State<ChipsScreen> {
  // --- FilterChip (multi-select) state
  final List<String> _allFilters = ['Phones', 'Laptops', 'Clothes', 'Accessories'];
  final Set<String> _selectedFilters = {'Phones'};

  // --- ChoiceChip (single-select) state
  final List<String> _choices = ['All', 'Popular', 'New'];
  String _selectedChoice = 'All';

  // --- InputChip (tokens) state
  final List<String> _people = ['Alaa', 'Noura', 'Omar'];
  final Set<String> _selectedPeople = {'Alaa'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chips Examples')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(
            context,
            title: 'ActionChip',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.refresh, size: 18),
                  label: const Text('Refresh'),
                  onPressed: () => _snack(context, 'ActionChip: Refresh'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.download, size: 18),
                  label: const Text('Download'),
                  onPressed: () => _snack(context, 'ActionChip: Download'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _section(
            context,
            title: 'FilterChip (multi-select)',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final tag in _allFilters)
                  FilterChip(
                    label: Text(tag),
                    selected: _selectedFilters.contains(tag),
                    onSelected: (isSel) => setState(() {
                      if (isSel) {
                        _selectedFilters.add(tag);
                      } else {
                        _selectedFilters.remove(tag);
                      }
                    }),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _section(
            context,
            title: 'ChoiceChip (single-select)',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in _choices)
                  ChoiceChip(
                    label: Text(c),
                    selected: _selectedChoice == c,
                    onSelected: (_) => setState(() => _selectedChoice = c),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _section(
            context,
            title: 'InputChip (tokens)',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final p in _people)
                  _selectedPeople.contains(p)
                      ? InputChip(
                    avatar: const CircleAvatar(child: Icon(Icons.person, size: 16)),
                    label: Text(p),
                    selected: true,
                    onSelected: (_) {},
                    onDeleted: () => setState(() => _selectedPeople.remove(p)),
                  )
                      : InputChip(
                    avatar: const CircleAvatar(child: Icon(Icons.person_outline, size: 16)),
                    label: Text(p),
                    selected: false,
                    onSelected: (_) => setState(() => _selectedPeople.add(p)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _section(BuildContext context, {required String title, required Widget child}) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}