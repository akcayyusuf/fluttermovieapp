import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:tmdb_dart/tmdb_dart.dart';

class Homenew extends StatefulWidget {
  @override
  HomenewState createState() => HomenewState();
}

class HomenewState extends State<Homenew> with TickerProviderStateMixin {
  Color bg = Color.fromRGBO(38, 48, 54, 1);
  Color card = Color.fromRGBO(14, 25, 32, 1);
  Color appbar = Color.fromRGBO(11, 28, 39, 1);
  Color main = Color.fromRGBO(190, 195, 215, 1);
  Color butt = Color.fromRGBO(48, 95, 214, 1);
  Color icon = Color.fromRGBO(244, 165, 33, 1);

  final pagectrl = PageController(initialPage: 0);
  int _selectedIndex = 0;
  final controller = TextEditingController();
  bool issearching = false;

  Future mytmdb(String arguments) async {
    // assert(arguments.length == 1);
    TmdbService service = TmdbService("11d50f5b518377fbd8bca8303b79be01");

    // auto configure api based on default configuration
    // OR custom configure api using setter 'configuration'
    await service.initConfiguration();

    var pagedResult = await service.movie.search("harry");

    for (var movie in pagedResult.results) {
      print("${movie.title} - ${movie.voteAverage}");
    }

    var pagedTvResult = await service.tv.getAiringToday();

    for (var tv in pagedTvResult.results) {
      print("${tv.name} - ${tv.voteAverage}");
    }

    var popular = await service.movie.getPopular();

    for (var movie in popular.results) {
      print("${movie.title} - ${movie.voteAverage} - ${movie.voteAverage}");
    }

    var discover = await service.movie.discover(
      settings: MovieDiscoverSettings(
        primaryReleaseDateGTE: Date(day: 15, month: 9, year: 2010),
        primaryReleaseDateLTE: Date(day: 22, month: 10, year: 2015),
        voteAverageGTE: 5.5,
        withPeople: [108916, 7467],
        sortBy: SortBy.popularity.desc,
        quality: QualitySettings(
          backdropQuality: AssetQuality.High,
          logoQuality: AssetQuality.High,
          posterQuality: AssetQuality.High,
          profileQuality: AssetQuality.High,
          stillQuality: AssetQuality.High,
        ),
      ),
    );

    for (var movie in discover.results) {
      print("${movie.title} - ${movie.voteAverage} - ${movie.releaseDate}");
    }

    var movie = await service.movie.getDetails(671,
        appendSettings: AppendSettings(
          includeRecommendations: true,
          includeSimilarContent: true,
        ));

    print("${movie.recommendations[0].title}");
    print("${movie.similar[0].title}");

    var tv = await service.tv.getDetails(1399,
        appendSettings: AppendSettings(
          includeRecommendations: true,
          includeSimilarContent: true,
        ));
    print("${tv.originalName} - ${tv.seasons.length}");
    print("${tv.similar[0].originalName} - ${tv.similar[0].firstAirDate}");

    print("Countries: ${(await service.getAllCountries()).length}");
    print("MovieGenres: ${(await service.getAllTvGenres()).length}");
  }

// generate many requests
// number of requests is over the allowed threshold
// but thanks to integrated resilience, all the requests are completed successfully
  Future resilienceExample(TmdbService service) async {
    var futures = Iterable.generate(100)
        .map((x) => service.movie.search(x.toString()))
        .toList();
    await Future.wait(futures);
  }

  @override
  Widget build(BuildContext context) {
    mytmdb("11d50f5b518377fbd8bca8303b79be01");
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: bg,

        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              elevation: 0,
              iconTheme: IconThemeData(color: icon),
              backgroundColor: appbar,
              title: issearching
                  ? TextFormField(
                      autofocus: true,
                      onFieldSubmitted: (value) {
                        String ara = controller.text;

                        return value;
                      },
                      validator: (search) {
                        return search;
                      },
                      controller: controller,
                      style: TextStyle(color: icon, fontSize: 16),
                      decoration: InputDecoration(
                          hintText: "Hoşgeldin Başkan",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          border: InputBorder.none),
                    )
                  : Text("Buraya logo koyacam", style: TextStyle(color: icon)),
              centerTitle: true,
              actions: [
                IconButton(
                    icon: Icon(
                      issearching ? Icons.cancel : Icons.search,
                      color: icon,
                    ),
                    onPressed: () {
                      setState(() {
                        issearching = !issearching;
                      });
                    })
              ],
            ),
            SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: appbar,
                child: TabBar(
                  indicatorPadding: EdgeInsets.only(bottom: 20),
                  labelStyle: TextStyle(
                      //up to your taste
                      fontSize: 20),
                  indicatorSize: TabBarIndicatorSize.label, //makes it better
                  labelColor: icon, //Google's sweet blue
                  unselectedLabelColor: Colors.grey[500], //niceish grey
                  isScrollable: true, //up to your taste
                  indicator: MD2Indicator(
                      //it begins here

                      indicatorHeight: 3,
                      indicatorColor: icon,
                      indicatorSize: MD2IndicatorSize
                          .full //3 different modes tiny-normal-full
                      ),
                  tabs: <Widget>[
                    Tab(
                      text: "Filmler",
                    ),
                    Tab(
                      text: "TV Şovları",
                    ),
                    Tab(
                      text: "Netflix",
                    ),
                    Tab(
                      text: "Prime",
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Popüler",
                    style: TextStyle(
                        color: icon, fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.grey[400],
                    ),
                    onTap: () {},
                  )
                ],
              ),
            ),
            ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(width: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: card,
                          height: 180,
                          width: 110,
                          child: Column(
                            children: [
                              SizedBox(height: 5),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  "https://www.karanliksinema.com/wp-content/uploads/2019/10/joker-2019-afis.jpg",
                                  fit: BoxFit.cover,
                                  height: 135,
                                  width: 100,
                                ),
                              ),
                              SizedBox(height: 5),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Flexible(
                                        child: Text(
                                          "Joker",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.blueGrey[400],
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      child: Icon(
                                        Icons.more_vert,
                                        color: main,
                                        size: 20,
                                      ),
                                      onTap: () {},
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                );
              },
            )
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //     children: [
            //       SizedBox(width: 16),
            //       ClipRRect(
            //         borderRadius: BorderRadius.circular(10),
            //         child: Container(
            //           color: card,
            //           height: 180,
            //           width: 110,
            //           child: Column(
            //             children: [
            //               SizedBox(height: 5),
            //               ClipRRect(
            //                 borderRadius: BorderRadius.circular(10),
            //                 child: Image.network(
            //                   "https://www.karanliksinema.com/wp-content/uploads/2019/10/joker-2019-afis.jpg",
            //                   fit: BoxFit.cover,
            //                   height: 135,
            //                   width: 100,
            //                 ),
            //               ),
            //               SizedBox(height: 5),
            //               Padding(
            //                 padding: const EdgeInsets.symmetric(horizontal: 5),
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Container(
            //                       child: Flexible(
            //                         child: Text(
            //                           "Joker",
            //                           maxLines: 2,
            //                           overflow: TextOverflow.ellipsis,
            //                           style: TextStyle(
            //                               color: Colors.blueGrey[400],
            //                               fontSize: 12),
            //                         ),
            //                       ),
            //                     ),
            //                     GestureDetector(
            //                       child: Icon(
            //                         Icons.more_vert,
            //                         color: main,
            //                         size: 20,
            //                       ),
            //                       onTap: () {},
            //                     )
            //                   ],
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       ),
            //       SizedBox(width: 5),
            //     ],
            //   ),
            // ),
          ],
        ),
        // PageView(
        //   controller: pagectrl,
        //   children: [
        //     Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       mainAxisSize: MainAxisSize.max,
        //       children: [
        // Flexible(
        //   flex: 3,
        //   child: Container(
        //     width: MediaQuery.of(context).size.width,
        //     color: appbar,
        //     child: TabBar(
        //       indicatorPadding: EdgeInsets.only(bottom: 20),
        //       labelStyle: TextStyle(
        //           //up to your taste
        //           fontSize: 20),
        //       indicatorSize:
        //           TabBarIndicatorSize.label, //makes it better
        //       labelColor: icon, //Google's sweet blue
        //       unselectedLabelColor: Colors.grey[500], //niceish grey
        //       isScrollable: true, //up to your taste
        //       indicator: MD2Indicator(
        //           //it begins here

        //           indicatorHeight: 3,
        //           indicatorColor: icon,
        //           indicatorSize: MD2IndicatorSize
        //               .full //3 different modes tiny-normal-full
        //           ),
        //       tabs: <Widget>[
        //         Tab(
        //           text: "Filmler",
        //         ),
        //         Tab(
        //           text: "TV Şovları",
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        //       ],
        //     ),
        //   ],
        // ),
        drawer: Drawer(
          child: Container(
            color: bg,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text(
                    'Buraya ne olacağı belli değil',
                    style: TextStyle(fontSize: 30, color: appbar),
                  ),
                  decoration: BoxDecoration(color: icon),
                ),
                ListTile(
                  leading: Icon(
                    Icons.check,
                    color: main,
                  ),
                  title: Text(
                    'İzlediklerin',
                    style: TextStyle(color: main),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(
                    Icons.alarm,
                    color: main,
                  ),
                  title: Text(
                    'İstek listen',
                    style: TextStyle(color: main),
                  ),
                  onTap: () {},
                ),
                ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: main,
                    ),
                    title: Text(
                      "Yusuf Akçay",
                      style: TextStyle(color: main),
                    ))
              ],
            ),
          ),
        ),
        bottomNavigationBar: FancyBottomNavigation(
          activeIconColor: appbar,
          inactiveIconColor: main,
          circleColor: icon,
          barBackgroundColor: appbar,
          textColor: icon,
          initialSelection: 0,
          tabs: [
            TabData(iconData: Icons.home, title: "Anasayfa"),
            TabData(iconData: Icons.bookmark, title: "Listelerin"),
            TabData(iconData: Icons.person, title: "Profil")
          ],
          onTabChangedListener: (position) {
            setState(() {});
          },
        ),
      ),
    );
  }
}
