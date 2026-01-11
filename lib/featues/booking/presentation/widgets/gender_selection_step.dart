import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:partywity/constants/constant.dart';
import 'package:partywity/core/theme.dart';
import 'package:partywity/featues/booking/presentation/bloc/booking_bloc.dart';

class GenderSelectionStep extends StatelessWidget {
  const GenderSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        final int totalGoal = state.totalGuests ?? 0;
        final int remaining = state.remainingGuests;
        final List<String> activeSlots = state.selectedPeriod == "Lunch"
            ? lunchSlots
            : dinnerSlots;
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildSummaryCard(totalGoal, remaining,context),
              const SizedBox(height: 30),
              const Text(
                "Select Male and Female Guest",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: _buildSelectorCard(
                      label: "Male Guest",
                      count: state.maleGuests ?? 0,
                      onTap: () => _showPicker(
                        context,
                        "Male",
                        (val) => UpdateMaleGuests(val),
                        state.maleGuests ?? 0,
                        remaining,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSelectorCard(
                      label: "Female Guest",
                      count: state.femaleGuests ?? 0,
                      onTap: () => _showPicker(
                        context,
                        "Female",
                        (val) => UpdateFemaleGuests(val),
                        state.femaleGuests ?? 0,
                        remaining,
                      ),
                    ),
                  ),
                ],
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.read<BookingBloc>().add(
                    ToggleKidsSection(state.hasKids),
                  ),
                  child: Text(
                    "We have kids in the party.",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: state.hasKids
                          ? Colors.purple
                          : AppTheme.secondaryColor,
                    ),
                  ),
                ),
              ),

              if (state.hasKids) ...[
                const Text(
                  "Select Children",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                _buildSelectorCard(
                  label: "Children Count",
                  count: state.childrenCount ?? 0,
                  isKids: true,
                  onTap: () => _showPicker(
                    context,
                    "Children",
                    (val) => UpdateChildrenCount(val),
                    state.childrenCount ?? 0,
                    remaining,
                  ),
                ),
              ],

              
              const SizedBox(height: 30),
              const Text(
                "Select Date",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              _buildDateRow(context, state),

              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Selected Date  •  ${DateFormat('dd MMM yy').format(state.selectedDate ?? DateTime.now())}",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),

              const SizedBox(height: 30),
              const Text(
                "Select time of day",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              Row(
                children: [
                  _buildPeriodChip(
                    context,
                    "Lunch",
                    state.selectedPeriod == "Lunch",
                  ),
                  const SizedBox(width: 10),
                  _buildPeriodChip(
                    context,
                    "Dinner",
                    state.selectedPeriod == "Dinner",
                  ),
                ],
              ),

              const SizedBox(height: 20),
              _buildTimeGrid(context, state, activeSlots),
              const SizedBox(height: 20),

              const Text(
                "Select Pricing Type",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildPricingSelectionRow(context, state),
              const SizedBox(height: 20),

              const SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }

  

  Widget _buildPricingSelectionRow(BuildContext context, BookingState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: _buildPricingChip(
              context,
              "Per Person Pricing",
              state.selectedPricingType == "Per Person",
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildPricingChip(
              context,
              "Table Menu (Ala Carte)",
              state.selectedPricingType == "Ala Carte",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingChip(
    BuildContext context,
    String label,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        final type = label.contains("Per Person") ? "Per Person" : "Ala Carte";
        context.read<BookingBloc>().add(UpdatePricingType(type));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          
          gradient: isSelected
              ? LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: isSelected ? null : Colors.white70,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.secondaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeGrid(
    BuildContext context,
    BookingState state,
    List<String> activeSlots,
  ) {
    
    double screenWidth = MediaQuery.of(context).size.width;
    
    int crossAxisCount = screenWidth < 400 ? 3 : 4;

    return GridView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(), 
      itemCount: activeSlots.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.5, 
      ),
      itemBuilder: (context, index) {
        final time = activeSlots[index];
        bool isSelected = state.selectedTime == time;

        return GestureDetector(
          onTap: () =>
              context.read<BookingBloc>().add(UpdateSelectedTime(time)),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isSelected ? Colors.transparent : Colors.grey.shade200,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppTheme.secondaryColor.withValues(alpha: 0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              time,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 13, 
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateRow(BuildContext context, BookingState state) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          DateTime date = DateTime.now().add(Duration(days: index));
          
          bool isSelected =
              state.selectedDate != null &&
              state.selectedDate!.day == date.day &&
              state.selectedDate!.month == date.month &&
              state.selectedDate!.year == date.year;

          String dayLabel = index == 0
              ? "Today"
              : (index == 1 ? "Tomorrow" : DateFormat('EEEE').format(date));

          return GestureDetector(
            onTap: () =>
                context.read<BookingBloc>().add(UpdateSelectedDate(date)),
            child: Container(
              width: 105,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          AppTheme.primaryColor,
                          AppTheme.secondaryColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.shade100,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.secondaryColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayLabel,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('dd MMM').format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPeriodChip(BuildContext context, String label, bool isSelected) {
    return GestureDetector(
      onTap: () => context.read<BookingBloc>().add(UpdateTimePeriod(label)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        decoration: BoxDecoration(
          
          gradient: isSelected
              ? LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white60,
          borderRadius: BorderRadius.circular(25),
          
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.secondaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(int total, int remaining,BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            total.toString().padLeft(2, '0'),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Guest",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                remaining == 0 ? "Total Selected" : "$remaining Remaining",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          InkWell(
            onTap: () =>  context.read<BookingBloc>().add(PreviousStep()),
            child: const Icon(Icons.edit_note_outlined, color: Colors.black, size: 28)),
        ],
      ),
    );
  }

  Widget _buildSelectorCard({
    required String label,
    required int count,
    required VoidCallback onTap,
    bool isKids = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isKids
                ? Colors.purple.withValues(alpha: 0.3)
                : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Text(
              count.toString().padLeft(2, '0'),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.arrow_drop_down_circle,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showPicker(
    BuildContext context,
    String title,
    Function(int) eventKey,
    int currentVal,
    int remaining,
  ) {
    final bloc = context.read<BookingBloc>();
    final int maxAvailable = currentVal + remaining;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                maxAvailable == 0
                    ? "All Guests Assigned"
                    : "Select $title Count",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              maxAvailable == 0
                  ? const Text("No more guests available to add.")
                  : SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: maxAvailable + 1,
                        itemBuilder: (context, index) {
                          bool isSelected = index == currentVal;
                          return GestureDetector(
                            onTap: () {
                              bloc.add(eventKey(index));
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 60,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                
                                gradient: isSelected
                                    ? LinearGradient(
                                        colors: [
                                          AppTheme.primaryColor,
                                          AppTheme.secondaryColor,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                color: isSelected ? null : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Center(
                                child: Text(
                                  "$index",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
