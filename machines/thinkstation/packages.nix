{ pkgs, ... }: with pkgs;

{
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.guest.enable = true;
  environment.systemPackages = [
    # games
    # leela-zero # go player
    # katago # go player

    # image
    gimp # the gimp
    inkscape # vector graphics editor

    # music
    easytag # music tag editor
    freac # free audio converter
    lollypop # music player
    picard # music brainz picard music tagger

    # personnal
    homebank # personnal finance

    # photo
    # rawtherapee # image processing
    darktable # image processing

    # video
    handbrake # video transcoder
    vlc # VLC video player

    # visio
    # skypeforlinux # skype 
    zoom-us # zoom

  ];
}
