class Music {
  String artistName;
  String trackCensoredName;
  String collectionArtistName;

  Music(this.artistName, this.trackCensoredName, this.collectionArtistName);

  Music.fromJson(Map<String, dynamic> json) {
    artistName = json['artistName'];
    trackCensoredName = json['trackCensoredName'];
    collectionArtistName = json['collectionArtistName'];
  }
}