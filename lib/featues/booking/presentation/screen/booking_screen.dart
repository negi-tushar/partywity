import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partywity/core/get_Dependency.dart';
import 'package:partywity/core/theme.dart';
import 'package:partywity/featues/booking/presentation/bloc/booking_bloc.dart';
import 'package:partywity/featues/booking/presentation/widgets/custom_gradient_button.dart';
import 'package:partywity/featues/booking/presentation/widgets/gender_selection_step.dart';
import 'package:partywity/featues/booking/presentation/widgets/guests_picker.dart';
import 'package:partywity/featues/booking/presentation/widgets/header_clipper.dart';
import 'package:partywity/featues/booking/presentation/widgets/package_selection_step.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BookingBloc>()..add(InitializeBooking()),
      child: Scaffold(
        body: BlocConsumer<BookingBloc, BookingState>(
          listener: (context, state) {
            if (_pageController.hasClients) {
              _pageController.animateToPage(
                state.currentStep,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            }
            // Submission feedback
            if (state.status == BookingStatus.loading) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Processing your booking..."),
                  duration: Duration(milliseconds: 800),
                ),
              );
            }

            if (state.status == BookingStatus.success && state is SubmitRegistration ) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Booking Submitted Successfully!"),
                  backgroundColor: Colors.green,
                ),
              );
            }

            if (state.status == BookingStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Submission failed. Please try again."),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withValues(alpha: .06),
                    AppTheme.secondaryColor.withValues(alpha: .05),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Column(
                children: [
                  _buildFixedHeader(context, state),

                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildStep1(context, state),
                        _buildStep2(context),
                        _buildStep3(context),
                      ],
                    ),
                  ),

                  _buildBottomButton(context, state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFixedHeader(BuildContext context, BookingState state) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipPath(
          clipper: HeaderClipper(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.24,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF397CCE), Color(0xFF428FD5)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -10,
          right: 20,
          child: Image.asset('assets/img/bg.png', height: 200),
        ),
        if (state.currentStep != 0)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                onPressed: () =>
                    context.read<BookingBloc>().add(PreviousStep()),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white24,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: Icon(Icons.arrow_back, size: 20, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context, BookingState state) {
    bool canProceed = false;

    if (state.currentStep == 0) {
      canProceed = state.totalGuests != null && state.totalGuests! > 0;
    } else if (state.currentStep == 1) {
      canProceed = state.isStage2Valid;
    } else {
      canProceed = state.isFinalStepValid;
    }

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: GradientButton(
        text: state.currentStep == 2 ? "Submit" : "PROCEED",
        onPressed: canProceed
            ? () => context.read<BookingBloc>().add(NextStep())
            : null,
      ),
    );
  }

  Widget _buildStep1(BuildContext context, BookingState state) {
    return GuestsPicker(state: state);
  }

  Widget _buildStep2(BuildContext context) {
    return GenderSelectionStep();
  }

  Widget _buildStep3(BuildContext context) {
    return PackageSelectionStep();
  }
}
