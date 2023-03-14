{ pkgs, ... }: with pkgs;

{
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
    # rawtherapee # raw image processing

    # video
    handbrake # video transcoder
    vlc # VLC video player

    # visio
    skypeforlinux # skype 
    zoom-us # zoom

  ];
}
