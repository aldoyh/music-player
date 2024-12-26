import 'dart:convert';
import 'package:http/http.dart' as http;
import 'podcast_episode.dart'; // Import your data model

class PodcastApiService {
  final String baseUrl;

  PodcastApiService({required this.baseUrl});

  Future<List<PodcastEpisode>> getPodcastEpisodes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/episodes')); // Modify the API endpoint as needed

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => PodcastEpisode.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load episodes. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching episodes: $e');
    }
  }
}
