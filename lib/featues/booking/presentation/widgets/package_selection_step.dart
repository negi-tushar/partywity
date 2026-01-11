import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partywity/core/theme.dart';
import 'package:partywity/featues/booking/domain/entities/entities.dart';
import 'package:partywity/featues/booking/presentation/bloc/booking_bloc.dart';

class PackageSelectionStep extends StatefulWidget {
  const PackageSelectionStep({super.key});

  @override
  State<PackageSelectionStep> createState() => _PackageSelectionStepState();
}

class _PackageSelectionStepState extends State<PackageSelectionStep> {
  final TextEditingController _citySearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(FetchCities());
  }

  @override
  void dispose() {
    _citySearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Select Package Type",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _buildTransparentToggle(context, state),
              const SizedBox(height: 25),

              _buildPackageDropdown(context, state),

              _buildInlineMultiSelectDropdown(
                label: "City",
                icon: Icons.domain,
                selectedItems: state.selectedCities,
                isOpen: state.isCityDropdownOpen,
                items: state.cities,
                searchController: _citySearchController,
                onToggle: () =>
                    context.read<BookingBloc>().add(ToggleCityDropdown()),
                onChanged: (item) =>
                    context.read<BookingBloc>().add(ToggleCitySelection(item)),
              ),

              _buildAreaParentChildDropdown(context, state),

              const SizedBox(height: 120),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAreaParentChildDropdown(
    BuildContext context,
    BookingState state,
  ) {
    Map<String, List<AreaEntity>> groupedAreas = {};
    for (var area in state.areas) {
      groupedAreas.putIfAbsent(area.cityName, () => []).add(area);
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (state.selectedCities.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please select a city first"),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else {
              context.read<BookingBloc>().add(ToggleAreaDropdown());
            }
          },
          child: Container(
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: Colors.black54,
                  size: 20,
                ),
                const SizedBox(width: 15),
                Text(
                  state.selectedAreas.isEmpty
                      ? "Select Area"
                      : "${state.selectedAreas.length} Areas selected",
                  style: TextStyle(
                    color: state.selectedAreas.isEmpty
                        ? Colors.grey
                        : Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Icon(
                  state.isAreaDropdownOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.arrow_drop_down_circle,
                  color: AppTheme.primaryColor,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
        if (state.isAreaDropdownOpen)
          Container(
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                if (state.selectedAreas.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () => context.read<BookingBloc>().add(
                            const ResetAreas(),
                          ),
                          child: const Text(
                            "Reset",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ...groupedAreas.entries.map((entry) {
                  String cityName = entry.key;
                  List<AreaEntity> cityAreas = entry.value;

                  bool isAnyAreaInCitySelected = cityAreas.any(
                    (a) => state.selectedAreas.any((sa) => sa.id == a.id),
                  );
                  bool areAllAreasInCitySelected = cityAreas.every(
                    (a) => state.selectedAreas.any((sa) => sa.id == a.id),
                  );

                  return Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                      unselectedWidgetColor: Colors.grey.shade400,
                    ),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      iconColor: AppTheme.primaryColor,

                      leading: Checkbox(
                        value: areAllAreasInCitySelected
                            ? true
                            : (isAnyAreaInCitySelected ? null : false),
                        tristate: true,
                        activeColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onChanged: (_) {
                          context.read<BookingBloc>().add(
                            ToggleCityGroupAreas(cityAreas),
                          );
                        },
                      ),
                      title: Text(
                        cityName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      children: [
                        const Divider(height: 1, indent: 50),
                        ...cityAreas.map((area) {
                          bool isSelected = state.selectedAreas.any(
                            (sa) => sa.id == area.id,
                          );
                          return CheckboxListTile(
                            contentPadding: const EdgeInsets.only(left: 30),
                            title: Text(
                              area.name,
                              style: const TextStyle(fontSize: 13),
                            ),
                            value: isSelected,
                            activeColor: AppTheme.secondaryColor,
                            controlAffinity: ListTileControlAffinity.leading,
                            dense: true,
                            onChanged: (_) => context.read<BookingBloc>().add(
                              ToggleAreaSelection(area),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 10),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildInlineMultiSelectDropdown({
    required String label,
    required IconData icon,
    required List<dynamic> selectedItems,
    required bool isOpen,
    required List<dynamic> items,
    required TextEditingController searchController,
    required VoidCallback onToggle,
    required Function(dynamic) onChanged,
  }) {
    final filteredItems = items
        .where(
          (item) => item.name.toLowerCase().contains(
            searchController.text.toLowerCase(),
          ),
        )
        .toList();

    return Column(
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Container(
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.black54, size: 20),
                const SizedBox(width: 15),
                Text(
                  selectedItems.isEmpty
                      ? "Select $label"
                      : "${selectedItems.length} $label selected",
                  style: TextStyle(
                    color: selectedItems.isEmpty ? Colors.grey : Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Icon(
                  isOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.arrow_drop_down_circle,
                  color: AppTheme.primaryColor,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
        if (isOpen)
          Container(
            margin: const EdgeInsets.only(top: 5),
            constraints: const BoxConstraints(maxHeight: 250),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: (val) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: "Search $label...",
                      prefixIcon: const Icon(Icons.search, size: 18),
                      isDense: true,
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: filteredItems.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: Colors.grey.shade100,
                      indent: 15,
                      endIndent: 15,
                    ),
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final isSelected = selectedItems.any(
                        (element) => element.id == item.id,
                      );
                      return CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: AppTheme.primaryColor,
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        title: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        value: isSelected,
                        onChanged: (val) => onChanged(item),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPackageDropdown(BuildContext context, BookingState state) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => context.read<BookingBloc>().add(TogglePackageDropdown()),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.liquor_outlined,
                  color: Colors.black54,
                  size: 22,
                ),
                const SizedBox(width: 15),
                Text(
                  state.selectedPackages.isEmpty
                      ? "Select Package Name"
                      : "${state.selectedPackages.length} selected",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Icon(
                  state.isPackageDropdownOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.arrow_drop_down_circle,
                  color: AppTheme.primaryColor,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
        if (state.isPackageDropdownOpen)
          Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 350),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _buildPackageStatusContent(context, state),
          ),
      ],
    );
  }

  Widget _buildPackageStatusContent(BuildContext context, BookingState state) {
    if (state.packageStatus == PackageStatus.loading) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final List<String> flatItems = state.apiPackages.keys.toList();

    if (flatItems.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text("No packages available."),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      itemCount: flatItems.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, color: Colors.grey.shade100),
      itemBuilder: (context, index) {
        final String packageName = flatItems[index];
        final bool isSelected = state.selectedPackages.contains(packageName);

        return CheckboxListTile(
          value: isSelected,
          activeColor: AppTheme.primaryColor,
          checkColor: Colors.white,
          dense: true,

          controlAffinity: ListTileControlAffinity.leading,
          title: Text(
            packageName,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
          onChanged: (bool? value) {
            context.read<BookingBloc>().add(
              TogglePackageSelection(packageName),
            );
          },
        );
      },
    );
  }

  Widget _buildTransparentToggle(BuildContext context, BookingState state) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: Row(
        spacing: 10,
        children: [
          _buildToggleChip(
            context,
            "Alcoholic",
            state.packageType == "Alcoholic",
          ),
          _buildToggleChip(
            context,
            "Non-Alcoholic",
            state.packageType == "Non-Alcoholic",
          ),
        ],
      ),
    );
  }

  Widget _buildToggleChip(BuildContext context, String label, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<BookingBloc>().add(UpdatePackageType(label));
          context.read<BookingBloc>().add(FetchPackages(label));
          context.read<BookingBloc>().add(const ResetPackages());
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  )
                : LinearGradient(
                    colors: [AppTheme.primaryColor.withValues(alpha:.1), AppTheme.primaryColor.withValues(alpha: .1)],
                  ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
