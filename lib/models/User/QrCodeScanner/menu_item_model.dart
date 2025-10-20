class MenuItemResponse {
  final bool success;
  final String message;
  final int statusCode;
  final List<MenuItem> data;

  MenuItemResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory MenuItemResponse.fromJson(Map<String, dynamic> json) {
    return MenuItemResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      statusCode: json['status_code'] ?? 0,
      data: (json['data'] as List?)
          ?.map((item) => MenuItem.fromJson(item))
          .toList() ??
          [],
    );
  }
}

class MenuItem {
  final int id;
  final String itemName;
  final String itemDetails;
  final double price;
  final double discountedPrice;
  final String calories;
  final String servingSize;
  final String discount;
  final String image;
  final String availability;
  final MenuCategory category;
  final VenueInfo venueInfo;

  MenuItem({
    required this.id,
    required this.itemName,
    required this.itemDetails,
    required this.price,
    required this.discountedPrice,
    required this.calories,
    required this.servingSize,
    required this.discount,
    required this.image,
    required this.availability,
    required this.category,
    required this.venueInfo,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] ?? 0,
      itemName: json['item_name'] ?? '',
      itemDetails: json['item_details'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      discountedPrice: json['discounted_price']?.toDouble() ?? 0.0,
      calories: json['calories'] ?? '0',
      servingSize: json['serving_size'] ?? '1',
      discount: json['discount'] ?? '0',
      image: json['image'] ?? '',
      availability: json['availability'] ?? 'unavailable',
      category: MenuCategory.fromJson(
          json['hospitality_venue_menu_category'] ?? {}),
      venueInfo: VenueInfo.fromJson(json['hospitality_venue'] ?? {}),
    );
  }

  bool get isAvailable => availability == 'available';
}

class MenuCategory {
  final int id;
  final String name;
  final String slug;

  MenuCategory({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}

class VenueInfo {
  final int id;
  final String venueName;
  final String mobileNumber;
  final String location;

  VenueInfo({
    required this.id,
    required this.venueName,
    required this.mobileNumber,
    required this.location,
  });

  factory VenueInfo.fromJson(Map<String, dynamic> json) {
    return VenueInfo(
      id: json['id'] ?? 0,
      venueName: json['venue_name'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      location: json['location'] ?? '',
    );
  }
}
