{ pkgs, ... }:
{
  fonts.fonts = with pkgs; [
    # https://nixos.wiki/wiki/Fonts
    (nerdfonts.override { fonts = [ "FiraCode" "DejaVuSansMono" ]; })
    carlito
    fira
    fira-code
    font-awesome
    libertine
    powerline-fonts
    source-sans-pro
    source-serif-pro
    stix-two
    vistafonts
  ];
}


