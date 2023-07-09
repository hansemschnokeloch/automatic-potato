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

  # phpfpm pools with php version from nix-phps
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
            memory_limit = 1G
          '';
        };
        settings = {
          "listen.owner" = config.services.caddy.user;
          "pm" = "dynamic";
          "pm.max_children" = 5;
          "pm.start_servers" = 2;
          "pm.min_spare_servers" = 1;
          "pm.max_spare_servers" = 5;
        };
        phpOptions = ''
          display_errors = on
          error_reporting = E_ALL
        '';
      };
    };
  phpfpmPools = builtins.listToAttrs (builtins.map mkPhpFpm [ "php73" "php74" "php81" "php82" ]);

  # see https://github.com/NixOS/nixpkgs/issues/14671

  caddy = with pkgs; stdenv.mkDerivation rec {
    __noChroot = true;
    pname = "caddy";
    version = "2.6.4";
    dontUnpack = true;

    nativeBuildInputs = [ git go xcaddy ];

    plugins = [
      "github.com/dunglas/vulcain@v0.4.3"
      "github.com/dunglas/vulcain/caddy@5db72aacb40c39da83111004e7f045c18662659c"
    ];

    configurePhase = ''
      export GOCACHE=$TMPDIR/go-cache
      export GOPATH="$TMPDIR/go"
    '';

    buildPhase =
      let
        pluginArgs = lib.concatMapStringsSep " " (plugin: "--with ${plugin}") plugins;
      in
      ''
        runHook preBuild
        ${xcaddy}/bin/xcaddy build "v${version}" ${pluginArgs}
        runHook postBuild
      '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      mv caddy $out/bin
      runHook postInstall
    '';
  };

  # caddy virtual hosts
  mkDot = list: (builtins.concatStringsSep "." list);
  mkVhost = { phpXX, root, sub, env }: rec {
    name = (mkDot [ sub phpXX "localhost" ]);
    value = {
      extraConfig =
        ''
          root * /var/www${root}
          file_server browse
          php_fastcgi unix/${config.services.phpfpm.pools.${phpXX}.socket} { ${env} }
          rewrite /rest/* /rest/index.php?{query}
        '';
    };
  };
  caddyLocalRootCert = builtins.readFile ./../_local/caddy.root.cert.pem;
  localDevConfig = builtins.fromJSON (builtins.readFile ./../_local/devconfig.json);
  caddyVhosts = builtins.listToAttrs (builtins.map mkVhost localDevConfig.hosts) // {
    "documentation.localhost" = {
      extraConfig =
        ''
          root * /var/www/RES/
          file_server browse
        '';
    };
  };
  # hosts.json example
  # {
  #   "hosts":
  #   [
  #       { "sub": "project1", "phpXX": "php73", "root": "/project1/public", "env": "" },
  #       { "sub": "project2", "phpXX": "php81", "root": "/project2/www", "env": "env CI_ENV development" }
  #   ],
  #   "databases": [ "db1", "db2"]
  # }

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
    ensureDatabases = localDevConfig.databases;
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
    # package = caddy;
    enable = true;
    virtualHosts = caddyVhosts;
  };
  # caddy localhost root certificate
  # get the certificate at http://localhost:2019/pki/ca/local
  security.pki.certificates = [ caddyLocalRootCert ];

}
