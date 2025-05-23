import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'video_player_screen.dart';

final supabase = Supabase.instance.client;

class UserVideosScreen extends StatefulWidget {
  const UserVideosScreen({Key? key}) : super(key: key);

  @override
  State<UserVideosScreen> createState() => _UserVideosScreenState();
}

class _UserVideosScreenState extends State<UserVideosScreen> {
  late Future<List<FileObject>> _videosFuture;
  final String _bucketName = 'user-videos';

  @override
  void initState() {
    super.initState();
    _videosFuture = _fetchVideosFromBucket();
  }

  Future<List<FileObject>> _fetchVideosFromBucket() async {
    try {
      // List files from the root of the bucket.
      // If your videos are in a subfolder, specify the path: .list(path: 'foldername')
      final List<FileObject> files =
          await supabase.storage.from(_bucketName).list();

      // Filter for actual files (not empty placeholder folders if any)
      // and potentially by file type if needed, though Supabase storage list
      // primarily returns objects that are files.
      // Buckets themselves don't usually contain empty folders unless created with placeholder objects.
      // For this example, we assume all listed items are video files.
      // You might want to filter by metadata or name if needed.
      return files
          .where((file) => file.name != '.emptyFolderPlaceholder')
          .toList();
    } catch (e) {
      print('Error listing files from Supabase bucket: $e');
      throw Exception('Failed to load videos from bucket: $e');
    }
  }

  Future<void> _playVideo(FileObject videoFile) async {
    try {
      // Create a signed URL that expires in 1 hour (3600 seconds)
      // This is generally more secure than using public URLs for user-specific content.
      final String signedUrl = await supabase.storage
          .from(_bucketName)
          .createSignedUrl(
            videoFile.name,
            3600,
          ); // videoFile.name is the path/filename

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(videoUrl: signedUrl),
        ),
      );
    } catch (e) {
      print("Error getting signed URL or playing video: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error playing video: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FileObject>>(
      future: _videosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Error loading videos: ${snapshot.error}",
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _videosFuture =
                            _fetchVideosFromBucket(); // ? Retry fetching
                      });
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No videos found in the bucket."));
        }

        final videos = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final videoFile = videos[index];
            // ? Assuming names are descriptive enough. Last updated could be useful too.
            // ? final lastModified = videoFile.lastModified != null ? DateTime.parse(videoFile.lastModified!) : null;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6.0),
              child: ListTile(
                leading: const Icon(
                  Icons.movie_filter_outlined,
                  size: 36,
                  color: Colors.blueGrey,
                ),
                title: Text(
                  videoFile.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                // subtitle: Text(lastModified != null ? "Uploaded: ${lastModified.toLocal().toString().substring(0, 16)}" : "No date"),
                trailing: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.green,
                  size: 30,
                ),
                onTap: () => _playVideo(videoFile),
              ),
            );
          },
        );
      },
    );
  }
}
