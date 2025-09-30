class Booking {
  final String id;
  final String userId;
  final String artisanId;
  final String artisanName;
  final String service;
  final DateTime bookingDate;
  final DateTime createdAt;
  final BookingStatus status;
  final double amount;
  final String? notes;

  Booking({
    required this.id,
    required this.userId,
    required this.artisanId,
    required this.artisanName,
    required this.service,
    required this.bookingDate,
    required this.createdAt,
    required this.status,
    required this.amount,
    this.notes,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['user_id'],
      artisanId: json['artisan_id'],
      artisanName: json['artisan_name'],
      service: json['service'],
      bookingDate: DateTime.parse(json['booking_date']),
      createdAt: DateTime.parse(json['created_at']),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      amount: json['amount']?.toDouble() ?? 0.0,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'artisan_id': artisanId,
      'artisan_name': artisanName,
      'service': service,
      'booking_date': bookingDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'status': status.toString().split('.').last,
      'amount': amount,
      'notes': notes,
    };
  }
}

enum BookingStatus { pending, confirmed, completed, cancelled }
