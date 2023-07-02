const String databaseName = 'recommendation_db';
const String tableName = 'recommendation_table';
const String columnId = '_id';
const String columnThumbnailURL = 'thumbnail_url';
const String columnRecommendationURL = 'recommendation_url';
const String columnTitle = 'title';
const String columnCategory = 'category';
const String columnLiked = 'liked';
const String createTableRawSQL = '''
  CREATE TABLE IF NOT EXISTS $tableName (
  $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
  $columnThumbnailURL TEXT NOT NULL,
  $columnRecommendationURL TEXT NOT NULL,
  $columnTitle TEXT NOT NULL,
  $columnCategory TEXT NOT NULL,
  $columnLiked INTEGER NOT NULL
  );
''';
const List<String> categoryTypes = ['track', 'artist', 'album', 'playlist'];
