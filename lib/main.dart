// Suggested code may be subject to a license. Learn more: ~LicenseLog:51891765.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1722035553.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3407616349.

import 'package:flutter/material.dart';
import 'podcast_api_service.dart';
import 'podcast_episode.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Podcast Player',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: PodcastListScreen(),
    );
  }
}

class PodcastListScreen extends StatefulWidget {
  const PodcastListScreen({super.key});

  @override
  _PodcastListScreenState createState() => _PodcastListScreenState();
}

class _PodcastListScreenState extends State<PodcastListScreen> {
  late PodcastApiService _apiService;
  List<PodcastEpisode> _episodes = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  PodcastEpisode? _currentlyPlaying;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _apiService = PodcastApiService(baseUrl: 'YOUR_API_BASE_URL'); // Replace with your actual base URL
    _fetchEpisodes();
    _audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      setState(() {
        _isPlaying = s == PlayerState.playing;
      });
    });
    _audioPlayer.onPlayerComplete.listen((event) {
        _currentlyPlaying = null;
    });
  }

  Future<void> _fetchEpisodes() async {
    try {
      final episodes = await _apiService.getPodcastEpisodes();
      setState(() {
        _episodes = episodes;
      });
    } catch (e) {
      print('Error fetching episodes: $e');
      // Handle error (show a snackbar, etc.)
    }
  }

  void _playPause(PodcastEpisode episode) async {
    if (_currentlyPlaying == episode && _isPlaying) {
      await _audioPlayer.pause();
    } else if (_currentlyPlaying == episode && !_isPlaying) {
      await _audioPlayer.resume();
    } else {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(episode.audioUrl));
      setState(() {
        _currentlyPlaying = episode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Podcast Episodes'),
      ),
      body: ListView.builder(
        itemCount: _episodes.length,
        itemBuilder: (context, index) {
          final episode = _episodes[index];
          return ListTile(
            leading: Image.network(episode.imageUrl), // Display the image
            title: Text(episode.title),
            subtitle: Text(episode.description),
            trailing: IconButton(
              icon: Icon(_currentlyPlaying == episode && _isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () => _playPause(episode),
            ),
          );
        },
      ),
    );
  }
}
