{ pkgs, ... }:

let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
    };
  };
in

{
  fonts.fonts = with pkgs; [
    # https://nixos.wiki/wiki/Fonts
    # (nerdfonts.override { fonts = [ "FiraCode" "DejaVuSansMono" ]; })
    # carlito
    # fira
    # fira-code
    # font-awesome
    # libertine
    # powerline-fonts
    # source-sans-pro
    # source-serif-pro
    # stix-two
    # vistafonts
    (unstable.nerdfonts.override { fonts = [ "FiraCode" "SourceCodePro" ]; })
    fira
    fira-code
    libertine
    source-serif-pro
    stix-two
    vistafonts
  ];
}
