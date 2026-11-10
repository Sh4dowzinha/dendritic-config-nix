# modules/den/lib/_default-applications.nix
{ den, lib }:
let
  catalog = {
    browser = {
      brave-origin = {
        aspect = den.aspects.applications.browsers.brave-origin;
        desktopId = "brave-origin.desktop";
      };
      librewolf = {
        aspect = den.aspects.applications.browsers.librewolf;
        desktopId = "librewolf.desktop";
      };
    };
    #file-manager = {
    #  dolphin = {
    #    aspect = null;
    #    desktopId = "org.kde.dolphin.desktop";
    #  };
    #};
    #terminal = {
    #  konsole = {
    #    aspect = null;
    #    desktopId = "org.kde.konsole.desktop";
    #  };
    #  kitty = {
    #    aspect = den.aspects.applications.terminal.kitty;
    #    desktopId = "kitty.desktop";
    #  };
    #};
    #pdf = {
    #  okular = {
    #    aspect = null;
    #    desktopId = "org.kde.okular.desktop";
    #  };
    #};
    #image-viewer = {
    #  gwenview = {
    #    aspect = null;
    #    desktopId = "org.kde.gwenview.desktop";
    #  };
    #};
    #audio-player = {
    #  elisa = {
    #    aspect = null;
    #    desktopId = "org.kde.elisa.desktop";
    #  };
    #};
  };

  # Automatically creates a typed mkOption for every category key in catalog
  options = lib.genAttrs (builtins.attrNames catalog) (
    category:
    lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Default ${category} shorthand name or desktop file ID.";
    }
  );

  mimeTypes = {
    browser = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/x-extension-xhtml"
      "application/x-extension-xht"
      "application/x-extension-html"
      "application/x-extension-htm"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/about"
      "x-scheme-handler/unknown"
    ];

    #file-manager = [
    #  "inode/directory"
    #];

    #pdf = [
    #  "application/pdf"
    #  "application/x-pdf"
    #  "application/x-bzpdf"
    #  "application/x-gzpdf"
    #];

    #image-viewer = [
    #  "image/bmp"
    #  "image/gif"
    #  "image/jpeg"
    #  "image/jpg"
    #  "image/png"
    #  "image/svg+xml"
    #  "image/tiff"
    #  "image/webp"
    #  "image/avif"
    #  "image/heif"
    #  "image/jxl"
    #];

    #audio-player = [
    #  "audio/aac"
    #  "audio/flac"
    #  "audio/mp4"
    #  "audio/mpeg"
    #  "audio/ogg"
    #  "audio/wav"
    #  "audio/webm"
    #  "audio/x-m4a"
    #  "audio/x-matroska"
    #  "audio/x-mp3"
    #  "audio/x-vorbis+ogg"
    #  "audio/x-wav"
    #];
  };

  # Resolution precedence:
  # User Global Settings // Host Machine Fallbacks
  resolveEffectiveDefaults =
    {
      host ? null,
      user,
    }:
    let
      filterNonNull = lib.filterAttrs (_: v: v != null);

      hostFallbackDefaults =
        if host != null then host.settings.desktop.default-applications or { } else { };

      userGlobalDefaults = user.settings.desktop.default-applications or { };

      # Reserved for future per-user host overrides:
      # hostUserOverrides =
      #   if host != null && host.settings ? users && host.settings.users ? ${userName} then
      #     host.settings.users.${userName}.desktop.default-applications or { }
      #   else
      #     { };
    in
    (filterNonNull hostFallbackDefaults) // (filterNonNull userGlobalDefaults);

  resolveDesktopId =
    category: val:
    if val == null then
      null
    else if catalog ? ${category} && catalog.${category} ? ${val} then
      catalog.${category}.${val}.desktopId
    else
      val;

  getAspectsToInclude =
    effectiveDefaults:
    lib.filter (a: a != null) (
      lib.mapAttrsToList (
        category: val:
        if val != null && catalog ? ${category} && catalog.${category} ? ${val} then
          catalog.${category}.${val}.aspect
        else
          null
      ) effectiveDefaults
    );
in
{
  inherit
    catalog
    options
    mimeTypes
    resolveEffectiveDefaults
    resolveDesktopId
    getAspectsToInclude
    ;
}
