import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final String senderEmail;
  final String senderId;
  final String message;
  final Timestamp time;

  ChatModel({
    required this.id,
    required this.senderEmail,
    required this.senderId,
    required this.message,
    required this.time,
  });

  // Convert a ChatModel instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderEmail': senderEmail,
      'senderId': senderId,
      'message': message,
      'time': time,
    };
  }

  // Create a ChatModel instance from a JSON map
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      senderEmail: json['senderEmail'],
      senderId: json['senderId'],
      message: json['message'],
      time: json['time'],
    );
  }
}