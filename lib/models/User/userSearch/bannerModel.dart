class BannerModel {
  bool? success;
  String? message;
  String? timestamp;
  int? statusCode;
  List<Data>? data;

  BannerModel(
      {this.success, this.message, this.timestamp, this.statusCode, this.data});

  BannerModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    timestamp = json['timestamp'];
    statusCode = json['status_code'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['timestamp'] = this.timestamp;
    data['status_code'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? hospitalityVenue;
  String? venueName;
  String? venueEmail;
  String? bannerTitle;
  String? bannerDescription;
  String? image;
  String? link;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? location;
  bool? isActive;
  bool? isFeatured;
  String? approvalStatus;
  bool? isApproved;
  int? approvedBy;
  String? approvedAt;
  Null? rejectionReason;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.hospitalityVenue,
        this.venueName,
        this.venueEmail,
        this.bannerTitle,
        this.bannerDescription,
        this.image,
        this.link,
        this.startDate,
        this.endDate,
        this.startTime,
        this.endTime,
        this.location,
        this.isActive,
        this.isFeatured,
        this.approvalStatus,
        this.isApproved,
        this.approvedBy,
        this.approvedAt,
        this.rejectionReason,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hospitalityVenue = json['hospitality_venue'];
    venueName = json['venue_name'];
    venueEmail = json['venue_email'];
    bannerTitle = json['banner_title'];
    bannerDescription = json['banner_description'];
    image = json['image'];
    link = json['link'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    location = json['location'];
    isActive = json['is_active'];
    isFeatured = json['is_featured'];
    approvalStatus = json['approval_status'];
    isApproved = json['is_approved'];
    approvedBy = json['approved_by'];
    approvedAt = json['approved_at'];
    rejectionReason = json['rejection_reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hospitality_venue'] = this.hospitalityVenue;
    data['venue_name'] = this.venueName;
    data['venue_email'] = this.venueEmail;
    data['banner_title'] = this.bannerTitle;
    data['banner_description'] = this.bannerDescription;
    data['image'] = this.image;
    data['link'] = this.link;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['location'] = this.location;
    data['is_active'] = this.isActive;
    data['is_featured'] = this.isFeatured;
    data['approval_status'] = this.approvalStatus;
    data['is_approved'] = this.isApproved;
    data['approved_by'] = this.approvedBy;
    data['approved_at'] = this.approvedAt;
    data['rejection_reason'] = this.rejectionReason;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
