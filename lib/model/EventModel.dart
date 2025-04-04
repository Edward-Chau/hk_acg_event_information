import 'package:flutter/material.dart';
import 'package:hk_acg_event_information/model/enumCategory.dart';

var evenCategoryChineseName = {
  EvenCategory.acg: "動漫展",
  EvenCategory.comicMarket: "同人展",
  EvenCategory.only: "only場",
  EvenCategory.electronicMusic: "動漫電音節"
};

var evenCategoryColor = {
  EvenCategory.acg: Colors.orange[300],
  EvenCategory.comicMarket: Colors.blue[700],
  EvenCategory.only: Colors.green[300],
  EvenCategory.electronicMusic: Colors.purple[300]
};

class Event {
  const Event(
      {required this.id,
      required this.imageURL,
      required this.title,
      // required this.dateStart,
      // required this.dateEnd,
      required this.date,
      required this.ticket,
      required this.amount,
      required this.evenCategory,
      required this.organizer,
      required this.officialURL,
      required this.location,
      required this.eventDetail});

  final int id;
  final String imageURL;
  final String title;
  final List<DateTime> date;
  final double ticket;
  final List<String> amount;
  final EvenCategory evenCategory;
  final String organizer;
  final String officialURL;
  final String location;
  final String eventDetail;
}


// final List<> eventDate;


// class EventDate