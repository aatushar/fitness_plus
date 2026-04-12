import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YouTubePlaylistPage extends StatefulWidget {
  const YouTubePlaylistPage({Key? key}) : super(key: key);

  @override
  State<YouTubePlaylistPage> createState() => _YouTubePlaylistPageState();
}

class _YouTubePlaylistPageState extends State<YouTubePlaylistPage> {
  late YoutubePlayerController _controller;
  int _currentPlayingIndex = 0;
  bool _isPlayerReady = false;

  // Playlist Data
  final List<Map<String, String>> _playlist = [
    {
      'title': 'Test Video - Always Works',
      'category': 'Test',
      'url': 'https://www.youtube.com/watch?v=KLuTLF3x9sA',
      'videoId': 'KLuTLF3x9sA',
      'thumbnail': 'https://img.youtube.com/vi/KLuTLF3x9sA/hqdefault.jpg',
      'duration': '0:11',
    },
    {
      'title': 'Motivational Speech for GYM',
      'category': 'Motivation',
      'url': 'https://www.youtube.com/watch?v=FE-ua3eJ2lo',
      'videoId': 'FE-ua3eJ2lo',
      'thumbnail': 'https://img.youtube.com/vi/FE-ua3eJ2lo/hqdefault.jpg',
      'duration': '10:23',
    },
    {
      'title': 'Powerful Workout Motivation',
      'category': 'Motivation',
      'url': 'https://www.youtube.com/watch?v=xiaOc4l9yL8',
      'videoId': 'xiaOc4l9yL8',
      'thumbnail': 'https://img.youtube.com/vi/xiaOc4l9yL8/hqdefault.jpg',
      'duration': '8:45',
    },
    {
      'title': 'Quran Recitation - Peaceful',
      'category': 'Quran',
      'url': 'https://www.youtube.com/watch?v=t-_SbDuqxQc',
      'videoId': 't-_SbDuqxQc',
      'thumbnail': 'https://img.youtube.com/vi/t-_SbDuqxQc/hqdefault.jpg',
      'duration': '15:30',
    },
  ];

  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: true,
        loop: false,
        enableCaption: false,
        strictRelatedVideos: false,
        enableJavaScript: true,
        playsInline: false,
      ),
    ); // Load first video

    // Listen for player state changes
    _controller.addListener(() {
      if (_controller.value.playerState == PlayerState.playing) {
        // Video is playing
      }
    });
  }

  void _playVideo(int index) {
    try {
      setState(() {
        _currentPlayingIndex = index;
      });

      final videoId = _playlist[index]['videoId']!;

      // Load and play the video
      _controller.loadVideoById(videoId: videoId);

      // Play the video after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_controller.value.playerState != PlayerState.playing) {
          _controller.playVideo();
        }
      });

    } catch (e) {
      print('Error playing video: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to play video'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<Map<String, String>> _getFilteredPlaylist() {
    if (_selectedCategory == 'All') {
      return _playlist;
    }
    return _playlist
        .where((video) => video['category'] == _selectedCategory)
        .toList();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPlaylist = _getFilteredPlaylist();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Workout Playlist',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE94560), Color(0xFFFF6B9D)],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(Icons.video_library, color: Colors.white, size: 16),
                const SizedBox(width: 5),
                Text(
                  '${_playlist.length} Videos',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Video Player
          Container(
            color: Colors.black,
            height: 250,
            child: YoutubePlayer(
              controller: _controller,
              aspectRatio: 16 / 9,
            ),
          ),

          // Currently Playing Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF16213E), Color(0xFF0F3460)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE94560).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.play_circle_filled,
                        color: Color(0xFFE94560),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Now Playing',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _playlist[_currentPlayingIndex]['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Controls
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => _controller.pauseVideo(),
                  icon: const Icon(Icons.pause, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFE94560),
                  ),
                ),
                const SizedBox(width: 15),
                IconButton(
                  onPressed: () => _controller.playVideo(),
                  icon: const Icon(Icons.play_arrow, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFE94560),
                  ),
                ),
                const SizedBox(width: 15),
                IconButton(
                  onPressed: () {
                    _controller.seekTo(seconds: 0);
                    _controller.pauseVideo();
                  },
                  icon: const Icon(Icons.stop, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFE94560),
                  ),
                ),
              ],
            ),
          ),

          // Categories
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('All'),
                  _buildCategoryChip('Test'),
                  _buildCategoryChip('Motivation'),
                  _buildCategoryChip('Quran'),
                ],
              ),
            ),
          ),

          // Playlist
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: filteredPlaylist.length,
              itemBuilder: (context, index) {
                final video = filteredPlaylist[index];
                final originalIndex = _playlist.indexOf(video);
                final isPlaying = _currentPlayingIndex == originalIndex;

                return GestureDetector(
                  onTap: () => _playVideo(originalIndex),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: isPlaying
                          ? const Color(0xFFE94560).withOpacity(0.1)
                          : const Color(0xFF16213E),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isPlaying
                            ? const Color(0xFFE94560)
                            : Colors.transparent,
                      ),
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 80,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(video['thumbnail']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        video['title']!,
                        style: TextStyle(
                          color: isPlaying
                              ? const Color(0xFFE94560)
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${video['category']!} • ${video['duration']!}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: isPlaying
                            ? const Color(0xFFE94560)
                            : Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = category),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE94560) : const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

extension on YoutubePlayerController {
  void addListener(Null Function() param0) {}
}