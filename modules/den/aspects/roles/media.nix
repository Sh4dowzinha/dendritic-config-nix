{ den, ... }:
{
  den.aspects.roles.media = {
    includes = with den.aspects; [
      applications.media.mpv
      applications.media.qbittorrent
      applications.media.yt-dlp
    ];
  };
}
