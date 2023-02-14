import 'package:flutter/material.dart';

import '../models/video_info.dart';
import '../widgets/video_player_screen.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final VideoInfo video =
        ModalRoute.of(context)!.settings.arguments as VideoInfo;

    return Scaffold(
        // appBar: AppBar(),
        body: CustomScrollView(
      slivers: [
        _CustomAppBar(key: key, video: video),
        SliverList(
          delegate: SliverChildListDelegate([
            _PosterAndTitle(key: key, video: video),
            _OverViewPlayer(key: key, video: video),
            const SizedBox(height: 20),
            VideoPlayerScreen(video: video)
          ]),
        )
      ],
    ));
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar({super.key, required this.video});

  final VideoInfo video;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.black87,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
          color: Colors.black45,
          child: Text(
            video.title,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'),
          // image: AssetImage('assets/no-image.jpg'),
          image: NetworkImage(video.image ?? ""),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  const _PosterAndTitle({super.key, required this.video});

  final VideoInfo video;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        Hero(
          tag: video.heroId!,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(video.image ?? ""),
              fit: BoxFit.cover,
              width: 130,
              height: 190,
            ),
          ),
        ),
        const SizedBox(width: 20),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: size.width - 190),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(video.title,
                  style: textTheme.headlineSmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2),
              Text(_printDuration(Duration(seconds: video.duration ?? 0)),
                  style: textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2),
              Row(
                children: [
                  // Icon( Icons.star_outline, size: 15, color: Colors.grey),
                  // SizedBox(width: 5),
                  Text(video.tags ?? "", style: textTheme.bodySmall)
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'video', arguments: video);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black54,
                  ),
                  child: const Text('Play video'),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}

class _OverViewPlayer extends StatelessWidget {
  const _OverViewPlayer({super.key, required this.video});

  final VideoInfo video;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        video.description ?? "Video Description",
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
