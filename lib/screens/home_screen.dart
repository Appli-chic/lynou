import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lynou/components/general/floating_action_button.dart';
import 'package:lynou/components/post-feed.dart';
import 'package:lynou/localization/app_translations.dart';
import 'package:lynou/models/post.dart';
import 'package:lynou/providers/theme_provider.dart';
import 'package:lynou/screens/new_post_page.dart';
import 'package:lynou/services/user_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin<HomeScreen>  {
  ThemeProvider _themeProvider;
  UserService _userService;

  bool _isStartedOnce = false;
  List<Post> _postList = List<Post>();

  /// Redirect to the page to create a new post.
  /// If a post is really created then we add it directly to the feed.
  _redirectToNewPostPage() async {
    var post = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPostPage()),
    );

    if (post != null) {
      // Add the post in the feed
      _postList.insert(0, post);
    }
  }

  /// Load posts when the screen run for the first time
  _loadPosts() async {
    if (!_isStartedOnce) {
      setState(() {
        _isStartedOnce = true;
      });

      // Get posts from cache
      List<Post> postsFromCache =
          await _userService.fetchWallPosts(Source.cache);
      setState(() {
        _postList = postsFromCache;
      });

      // Get posts from the server
      _userService.fetchWallPosts(Source.server).then((posts) {
        _postList.clear();
        _postList = posts;

        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _userService = Provider.of<UserService>(context);

    _loadPosts();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppTranslations.of(context).text("home_title"),
        ),
        backgroundColor: _themeProvider.backgroundColor,
        elevation: 0,
        brightness: _themeProvider.setBrightness(),
        centerTitle: true,
      ),
      body: Container(
        color: _themeProvider.backgroundColor,
        child: ListView.separated(
          addAutomaticKeepAlives: true,
          itemCount: _postList.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
              child: PostFeed(post: _postList[index]),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              color: _themeProvider.textColor,
              indent: 16,
              endIndent: 16,
            );
          },
        ),
      ),
      floatingActionButton: LYFloatingActionButton(
        theme: _themeProvider.theme,
        iconData: Icons.add,
        onClick: _redirectToNewPostPage,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
