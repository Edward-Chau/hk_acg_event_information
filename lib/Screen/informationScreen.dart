import 'package:flutter/material.dart';
import 'package:hk_acg_event_information/Screen/favouriteScreen.dart';
import 'package:hk_acg_event_information/Widget/DividerSpece.dart';
import 'package:hk_acg_event_information/Widget/eventCategoryLabel.dart';
import 'package:hk_acg_event_information/model/ETAColor.dart';
import 'package:hk_acg_event_information/model/EventModel.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';
// import 'package:maps_launcher/maps_launcher.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class Informationscreen extends StatefulWidget {
  const Informationscreen({
    super.key,
    required this.event,
    required this.time,
    required this.keep,
    required this.favoriteEventList,
    required this.eventList,
  });
  final Event event;
  final String time;
  final Function(Event) keep;
  final List<Event> favoriteEventList;
  final List<Event> eventList;

  @override
  State<Informationscreen> createState() => _InformationscreenState();
}

var format = DateFormat.yMd();
// var formatTime=DateFormat.ymd

class _InformationscreenState extends State<Informationscreen> {
  Widget space = const SizedBox(height: 15);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(
                () {
                  //fuction
                  if (widget.favoriteEventList.contains(widget.event)) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return KeepLog(
                          titleMessage: "已移除標記活動",
                          eventName: widget.event.title,
                          favoriteEventList: widget.favoriteEventList,
                          keep: widget.keep,
                          eventList: widget.eventList,
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return KeepLog(
                          titleMessage: "已標記活動",
                          eventName: widget.event.title,
                          favoriteEventList: widget.favoriteEventList,
                          keep: widget.keep,
                          eventList: widget.eventList,
                        );
                      },
                    );
                  }

                  widget.keep(widget.event);
                },
              );
            },
            icon: widget.favoriteEventList.contains(widget.event)
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.favorite,
                    color: Colors.grey,
                  ),
          ),
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.event.title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white, fontSize: 18),
            ),
            Text(
              widget.time,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.w700),
            )
          ],
        ),
        backgroundColor: ETAColors.appbarColors_01,
      ),
      body: Container(
        color: Colors.grey[50],
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: ETAColors.screenBackgroundColor,
                width: double.infinity,
                constraints: const BoxConstraints(maxHeight: 200),
                child: InstaImageViewer(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: widget.event.imageURL,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Eventcategorylabel(event: widget.event),
                        ),
                        Text(
                          widget.event.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    space,
                    const Text('主辦單位', style: TextStyle(color: Colors.grey)),
                    Text(widget.event.organizer),
                    space,
                    const Text('時間', style: TextStyle(color: Colors.grey)),
                    Text(
                      format.format(widget.event.dateStart[0]) ==
                              format.format(widget.event.dateStart.last)
                          ? format.format(widget.event.dateStart[0])
                          : '${format.format(widget.event.dateStart[0])} ~ ${format.format(widget.event.dateEnd.last)}',
                    ),
                    space,
                    const Text('會場', style: TextStyle(color: Colors.grey)),
                    InkWell(
                      onTap: () {
                        MapsLauncher.launchQuery(widget.event.location);

                        // if (await MapLauncher.isMapAvailable(MapType.google)!=null) {
                        //   await MapLauncher.showMarker(
                        //     mapType: MapType.google,
                        //     coords: Coords(37.759392, -122.5107336),
                        //     title: "title",
                        //     description: "description",
                        //   );
                        // }
                        //   MapsLauncher.launchQuery(widget.event.location);
                      }, //launch location in map
                      child: Row(
                        children: [
                          Text(widget.event.location,
                              style: TextStyle(color: Colors.blue[800])),
                          Icon(Icons.location_on, color: Colors.orange[800])
                        ],
                      ),
                    ),
                    space,
                    const Text('入場費用', style: TextStyle(color: Colors.grey)),
                    ...widget.event.amount.map((toElement) {
                      return Text(toElement);
                    }),
                    space,
                    const Text('活動内容', style: TextStyle(color: Colors.grey)),
                    Text(evenCategoryChineseName[widget.event.evenCategory]
                        .toString()),
                    space,
                    const Text('官方網站', style: TextStyle(color: Colors.grey)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () async {
                        if (!await launchUrl(
                            Uri.parse(widget.event.officialURL))) {
                          throw Exception('無法前往網站');
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.globe,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "前往官方網站",
                            style: TextStyle(color: Colors.blue),
                          )
                        ],
                      ),
                    )
                    //time
                    ,
                    space,
                    const Dividerspece(
                      dividerTitle: '活動資訊',
                    ),
                    space,
                    ...widget.event.information.map((toElement) {
                      return Text(toElement);
                    }),
                    const SizedBox(height: 30) //end space
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KeepLog extends StatefulWidget {
  const KeepLog(
      {super.key,
      required this.eventName,
      required this.titleMessage,
      required this.keep,
      required this.favoriteEventList,
      required this.eventList});
  final String titleMessage;
  final String eventName;
  final Function(Event) keep;
  final List<Event> favoriteEventList;
  final List<Event> eventList;

  @override
  State<KeepLog> createState() => _KeepLogState();
}

class _KeepLogState extends State<KeepLog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.titleMessage),
      content: Text(widget.eventName),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return FavouriteScreen(
                    favoriteEvent: widget.favoriteEventList,
                    keep: widget.keep,
                    eventList: widget.eventList,
                  );
                },
              ));
            },
            child: const Text("查看清單")),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("確定")),
      ],
    );
  }
}
