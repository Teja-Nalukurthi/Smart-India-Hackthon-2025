import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/models/booking.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final List<Booking> _mockBookings = [
    Booking(
      id: '1',
      userId: 'user_123',
      artisanId: 'artisan_1',
      artisanName: 'Rajesh Kumar',
      service: 'Traditional Pottery Workshop',
      bookingDate: DateTime.now().add(const Duration(days: 3)),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      status: BookingStatus.confirmed,
      amount: 2500.0,
      notes: '2-hour pottery session',
    ),
    Booking(
      id: '2',
      userId: 'user_123',
      artisanId: 'artisan_2',
      artisanName: 'Meera Devi',
      service: 'Handloom Weaving Demo',
      bookingDate: DateTime.now().subtract(const Duration(days: 5)),
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      status: BookingStatus.completed,
      amount: 1800.0,
    ),
    Booking(
      id: '3',
      userId: 'user_123',
      artisanId: 'artisan_3',
      artisanName: 'Arjun Singh',
      service: 'Metalwork Experience',
      bookingDate: DateTime.now().add(const Duration(days: 10)),
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: BookingStatus.pending,
      amount: 3200.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'My Bookings',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textLight),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _mockBookings.length,
        itemBuilder: (context, index) {
          final booking = _mockBookings[index];
          return _buildBookingCard(booking);
        },
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    Color statusColor;
    String statusText;

    switch (booking.status) {
      case BookingStatus.pending:
        statusColor = Colors.orange;
        statusText = 'Pending';
        break;
      case BookingStatus.confirmed:
        statusColor = Colors.blue;
        statusText = 'Confirmed';
        break;
      case BookingStatus.completed:
        statusColor = Colors.green;
        statusText = 'Completed';
        break;
      case BookingStatus.cancelled:
        statusColor = Colors.red;
        statusText = 'Cancelled';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  booking.service,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha((255 * 0.1).round()),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor, width: 1),
                ),
                child: Text(
                  statusText,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Icon(Icons.person_outline, size: 16, color: AppColors.textSubtle),
              const SizedBox(width: 8),
              Text(
                booking.artisanName,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSubtle,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: AppColors.textSubtle,
              ),
              const SizedBox(width: 8),
              Text(
                '${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSubtle,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Icon(Icons.currency_rupee, size: 16, color: AppColors.textSubtle),
              const SizedBox(width: 8),
              Text(
                '₹${booking.amount.toStringAsFixed(0)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          if (booking.notes != null) ...[
            const SizedBox(height: 8),
            Text(
              booking.notes!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSubtle,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
