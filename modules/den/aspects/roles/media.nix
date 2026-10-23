{ den, ... }:
{
  den.aspects.roles.media = {
    includes = with den.aspects; [
      applications.media.mpv
      applications.media.obs-studio
      applications.media.qbittorrent
      applications.media.stremio
      applications.media.yt-dlp
    ];
  };
}
