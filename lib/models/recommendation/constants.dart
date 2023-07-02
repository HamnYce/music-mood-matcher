const String databaseName = 'recommendation_db';
const String recommendationTableName = 'recommendation_table';
const String columnId = 'spotifyID';
const String columnThumbnailURL = 'thumbnail_url';
const String columnRecommendationURL = 'recommendation_url';
const String columnTitle = 'title';
const String columnCategory = 'category';
const String columnLiked = 'liked';
const String createRecommendationTableRawSQL = '''
  CREATE TABLE IF NOT EXISTS $recommendationTableName (
  $columnId TEXT PRIMARY KEY, 
  $columnThumbnailURL TEXT NOT NULL,
  $columnRecommendationURL TEXT NOT NULL,
  $columnTitle TEXT NOT NULL,
  $columnCategory TEXT NOT NULL,
  $columnLiked INTEGER NOT NULL
  );
''';
const List<String> categoryTypes = ['track', 'artist', 'album', 'playlist'];

const String searchTableName = 'searched_table';
const String createSearchTableRawSQL = '''
  CREATE TABLE IF NOT EXISTS $searchTableName (
    $columnId TEXT PRIMARY KEY
  );
''';
