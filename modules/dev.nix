{ pkgs, config, lib, ... }:
let
  # using pkgs2 to avoid recursive loop with fetchFromGitHub
  # see https://stackoverflow.com/questions/73097604/nixos-how-to-import-some-configuration-from-gitlab-infinite-recursion-encounte
  pkgs2 = (import <nixpkgs> { });
  nix-phps = pkgs2.fetchFromGitHub {
    owner = "fossar";
    repo = "nix-phps";
    rev = "ac2bb3d416a10fc66d0148dddc63a19c6c5a907c";
    hash = "sha256-74kQIFf3Cu1aeOsohCiLuA1aXNGYt2U9tTUP0yvm4EA=";
  };
  phps = import nix-phps;
  # virtualHosts
  myHosts = [
    {
      phpVersion = "php81";
      serverName = "wpi.php81.localhost";
      documentRoot = "/var/www/ESW/wpi";
    }
  ];

  # create phpfpm pools with multiple php versions
  mkPhpFpm = phpXX:
    {
      name = phpXX;
      value = {
        user = config.services.caddy.user;
        group = config.services.caddy.group;
        phpPackage = phps.packages.${builtins.currentSystem}.${phpXX}.buildEnv {
          extensions = ({ enabled, all }: enabled ++ (with all; [
            xdebug
          ]));
          extraConfig = ''
          '';
        };

        settings = {
          "listen.owner" = config.services.caddy.user;
          "pm" = "dynamic";
          "pm.max_children" = 75;
          "pm.start_servers" = 10;
          "pm.min_spare_servers" = 5;
          "pm.max_spare_servers" = 20;
          "pm.max_requests" = 500;
        };
        phpOptions = ''
          display_errors = on
          error_reporting = E_ALL

        '';
      };

    };
  phpfpmPools = builtins.listToAttrs (builtins.map mkPhpFpm [ "php73" "php74" "php80" "php81" ]);

  # caddy virtual hosts
  mkDot = list: (builtins.concatStringsSep "." list);
  mkVhost = { phpXX, root, sub }: rec {
    name = (mkDot [ sub phpXX "localhost" ]);
    value = {
      extraConfig =
        ''
          root * /var/www/${root}
          file_server browse
          php_fastcgi unix/${config.services.phpfpm.pools.${phpXX}.socket}
        '';
    };
  };
  caddyVhosts = builtins.listToAttrs (builtins.map mkVhost hosts);
  hosts = [
    { sub = "sarl"; phpXX = "php73"; root = "/SARL/dolibarr/htdocs"; }
    { sub = "merlin"; phpXX = "php73"; root = "/ESW/merlin.e-swin.net/public"; }
    { sub = "uther"; phpXX = "php73"; root = "/ESW/uther.e-swin.net/public"; }
    { sub = "perceval"; phpXX = "php73"; root = "/ESW/perceval.e-swin.net/public"; }
    { sub = "dgd"; phpXX = "php73"; root = "/DGD/dgd.domicilgym.fr/public"; }
  ];

  # databases
  databases = [ "sarl" "merlin" "uther" "perceval" "dgd" ];

  # caddy virtual hosts
  # mkDot = builtins.concatStringsSep ".";
  # mkVhost = { phpXX, root, subdomain }: {
  #   ${mkDot [ subdomain phpXX "localhost" ]} = {
  #     extraConfig =
  #       ''
  #         root * /var/www/${root}
  #         file_server browse
  #         php_fastcgi unix/${config.services.phpfpm.pools.${phpXX}.socket}
  #       '';
  #   };
  # };
  # caddyVhosts = builtins.foldl' (host: vhosts: vhosts // mkVhost host) {} hosts;
  # hosts = [
  #   {
  #     subdomain = "merlin";
  #     phpXX = "php73";
  #     root = "/ESW/merlin.e-swin.net/public";
  #   }
  #   {
  #     subdomain = "uther";
  #     phpXX = "php73";
  #     root = "/ESW/uther.e-swin.net/public";
  #   }
  # ];

in
{
  # mailhog
  services.mailhog = {
    enable = true;
  };

  # databases
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureDatabases = databases;
    initialScript = pkgs.writeText "mysql-init.sql" ''
      CREATE USER 'devuser'@'localhost' IDENTIFIED BY 'devpwd';
      GRANT ALL PRIVILEGES ON *.* TO 'devuser'@'localhost';
      FLUSH PRIVILEGES;
    '';
  };
  services.postgresql = {
    enable = true;
  };

  # phpfpm
  services.phpfpm.pools = phpfpmPools;

  # caddy webserver
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.caddy = {
    enable = true;
    virtualHosts = caddyVhosts;
  };
  # caddy localhost root certificate
  security.pki.certificates = [ (builtins.readFile ./../common/caddy.root.cert.pem) ];

}
