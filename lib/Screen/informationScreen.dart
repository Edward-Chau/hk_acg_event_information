import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hk_acg_event_information/Screen/favouriteScreen.dart';
import 'package:hk_acg_event_information/Widget/DividerSpece.dart';
import 'package:hk_acg_event_information/Widget/eventCategoryLabel.dart';
import 'package:hk_acg_event_information/model/ETAColor.dart';
import 'package:hk_acg_event_information/model/EventModel.dart';
import 'package:hk_acg_event_information/provider/keep_event_provider.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class Informationscreen extends ConsumerStatefulWidget {
  const Informationscreen({
    super.key,
    required this.event,
  });
  final Event event;

  @override
  ConsumerState<Informationscreen> createState() => _InformationscreenState();
}

var format = DateFormat.yMd();
// var formatTime=DateFormat.ymd

class _InformationscreenState extends ConsumerState<Informationscreen> {
  Widget space = const SizedBox(height: 15);

  @override
  Widget build(BuildContext context) {
    final List<int> keepList = ref.watch(keepEventProviderProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              ref
                  .read(keepEventProviderProvider.notifier)
                  .toggleKeep(widget.event.id);
            },
            icon: Icon(
              Icons.favorite,
              color: keepList.contains(widget.event.id)
                  ? Colors.red
                  : Colors.white,
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
              ' widget.time',
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
                    imageErrorBuilder: (context, error, stackTrace) =>
                        const Center(
                      child: Text('error'),
                    ),
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
                    Text('WIP'
                        // format.format(widget.event.dateStart[0]) ==
                        //         format.format(widget.event.dateStart.last)
                        //     ? format.format(widget.event.dateStart[0])
                        //     : '${format.format(widget.event.dateStart[0])} ~ ${format.format(widget.event.dateEnd.last)}',
                        ),
                    space,
                    const Text('會場', style: TextStyle(color: Colors.grey)),
                    InkWell(
                      onTap: () async {
                        if (!await launchUrl(Uri.parse(
                            'https://www.google.com/maps/search/${widget.event.location}'))) {
                          throw Exception('Could not launch url');
                        } //launch location in map

                        // if (await MapLauncher.isMapAvailable(MapType.google)!=null) {
                        //   await MapLauncher.showMarker(
                        //     mapType: MapType.google,
                        //     coords: Coords(37.759392, -122.5107336),
                        //     title: "title",
                        //     description: "description",
                        //   );
                        // }
                        //   MapsLauncher.launchQuery(widget.event.location);
                      },
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
                    Html(data: widget.event.eventDetail),
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
      required this.eventList,
      required this.pushInformationScreen});
  final String titleMessage;
  final String eventName;
  final Function(Event) keep;
  final List<Event> favoriteEventList;
  final List<Event> eventList;
  final Function() pushInformationScreen;
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
                  return const FavouriteScreen();
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
