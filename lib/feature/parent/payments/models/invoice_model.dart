import 'package:flutter/material.dart';

enum InvoiceStatus { pending, paid }

class InvoiceModel {
  final String id;
  final String title;        
  final String subTitle;      
  final String studentName;  
  final double amount;
  final DateTime dueDate;
  final InvoiceStatus status;
  final String barcode;       
  final bool isOrangeOverride; 

  const InvoiceModel({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.studentName,
    required this.amount,
    required this.dueDate,
    required this.status,
    required this.barcode,
    this.isOrangeOverride = false,
  });
}