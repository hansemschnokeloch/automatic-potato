{ pkgs, ... }: with pkgs;

let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
    };
  };
  navicat = pkgs.callPackage ./../pkgs/navicat.nix { };
in

{
  environment.systemPackages = [
    # essential
    chromium # web browser
    exa # replacement for ls
    fd # simple alternative to find
    file # determine type of file
    firefox # web browser
    fzf # command line fuzzy finder
    gthumb # image viewer
    jq # command line json processor
    unstable.kitty # terminal
    rar # utility for rar archives
    ripgrep # (rg) recursive regex search utility
    starship # customizable shell prompt
    unzip # zip archive utility - exctractor
    wget # file retriever utility
    zip # zip archive utility - compressor

    # neovim
    neovim-unwrapped # ❤️
    black # python code formatter
    cargo # rust package manager
    stylua # lua code formatter
    sumneko-lua-language-server # LSP for lua
    tree-sitter # parser generator tool
    wl-clipboard # command line copy/paste utility for wayland

    # webdev
    navicat
    postman # API development environment

    # dev
    gcc # GNU compiler collection
    git # version control system
    gnumake # build from MakeFile
    lazygit # terminal UI for git

    # utils
    dig # domain name server
    docker-compose # compose for docker
    kooha # screen recorder
    lm_sensors # read hardware sensors
    neofetch # system info script
    poppler_utils # pdf rendering library
    protonvpn-gui # GUI for proton VPN
    timewarrior # time tracking
    virtualbox # virtualization

    # node
    nodejs
    nodePackages.prettier
    nodePackages.neovim
    nodePackages.intelephense
    nodePackages.tailwindcss

    # py3
    python3
    python3Packages.pynvim # Python Package Required for neovim
    python3Packages.msgpack # Python Package Required for neovim
    python3Packages.flake8 # Python Package

    # latex
    tectonic
    tikzit

    # messaging
    signal-desktop # signal

    # office
    libreoffice-fresh # office suite
    masterpdfeditor # pdf editor
    onlyoffice-bin # office suite

  ];
}
