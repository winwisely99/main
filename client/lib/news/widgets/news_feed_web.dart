//import 'package:collection/collection.dart' show groupBy;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
//import 'package:responsive_scaffold/responsive_scaffold.dart';

import 'package:com.winwisely99.app/services/services.dart';
import 'package:com.winwisely99.app/vendor_plugins/vendor_plugins.dart';

import '../bloc/bloc.dart';
import '../bloc/data.dart';
import './news_view.dart';

class WebNewsFeed extends StatelessWidget {
  const WebNewsFeed({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ProxyProvider2<NetworkService, UserService, NewsBloc>(
      builder: (
        BuildContext _,
        NetworkService network,
        UserService user,
        NewsBloc __,
      ) =>
          NewsBloc(
        network: network,
        user: user,
      ),
      child: const _NewsFeedBody(),
    );
  }
}

class _NewsFeedBody extends StatelessWidget {
  const _NewsFeedBody({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      child: StreamBuilder<List<News>>(
        stream: Provider.of<NewsBloc>(context).getNews(),
        builder: (BuildContext context, AsyncSnapshot<List<News>> snapshot) {
          return WebLayoutBody(
            drawerSelection: 0,
            title: TitleWidget(
              title: 'News',
              icon: Icons.home,
            ),
            detailBuilder: (
              BuildContext context,
              int index,
              bool flag,
            ) {
              return DetailsScreen(
                body: Material(
                  color: Colors.white,
                  elevation: 8.0,
                  child: NewsView(newsId: snapshot.data[index].id.id),
                ),
              );
            },
            itemCount: snapshot.hasData ? snapshot.data.length : 0,
            itemBuilder: (BuildContext context, int index) {
              return NewsTile(news: snapshot.data[index]);
            },
          );
        },
      ),
    );
  }
}

class NewsTile extends StatelessWidget {
  const NewsTile({Key key, this.news}) : super(key: key);
  final News news;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 8.0),
          ListTile(
            title: Text(news.title),
            subtitle: Column(
              children: <Widget>[
                const SizedBox(height: 8.0),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: news.thumbnailUrl == null
                        ? const Text('')
                        : Image.asset(news.thumbnailUrl),
                    /*                                   Image.network(
                                          news.thumbnailUrl,
                                        ), */
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  news.text,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    DateFormat('MMM dd').format(news.timestamp),
                  ),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
            leading: CircleAvatar(
              backgroundImage: AssetImage(news.createdBy.avatarURL),
/*                           NetworkImage(
                              news.createdBy.avatarURL,
                            ), */
              child: const Text(''),
            ),
          ),
        ],
      ),
    );
  }
}
