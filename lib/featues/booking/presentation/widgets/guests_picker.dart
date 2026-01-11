import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partywity/core/theme.dart';
import 'package:partywity/featues/booking/presentation/bloc/booking_bloc.dart';

class GuestsPicker extends StatelessWidget {
  final BookingState state;
  const GuestsPicker({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        const SizedBox(height: 40),
        const Text(
          "How Many Guest Do\nYou Have?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            itemCount: 10,
            itemBuilder: (context, index) {
              int count = index + 1;
              
              bool isSelected = state.totalGuests == count;

              return GestureDetector(
                onTap: () => context.read<BookingBloc>().add(UpdateTotalGuests(count)),
                child: _buildGuestCard(count, isSelected),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGuestCard(int count, bool isSelected) {
    return Container(
      width: 110,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: isSelected
            ? const LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : null,
        color: isSelected ? null : Colors.white,
        borderRadius: BorderRadius.circular(60),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(count == 1 ? "Guest" : "Guests",
              style: TextStyle(
                  color: isSelected ? Colors.white70 : Colors.black54)),
          Text(count.toString().padLeft(2, '0'),
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black87)),
        ],
      ),
    );
  }

  
}