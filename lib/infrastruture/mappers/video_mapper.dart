import 'package:cinema/domain/entities/video.dart';
import 'package:cinema/infrastruture/models/moviedb/moviedb_videos.dart';

class VideoMapper {
  static moviedbVideoToEntity(Result moviedbVideo) => Video(
      id: moviedbVideo.id,
      name: moviedbVideo.name,
      youtubeKey: moviedbVideo.key,
      publishedAt: moviedbVideo.publishedAt);
}
