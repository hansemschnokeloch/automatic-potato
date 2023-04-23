final: prev: {
  insomnia = prev.insomnia.overrideAttrs (old: rec {
    version = "2023.1.0";
    src = prev.fetchurl {
      url = "https://github.com/Kong/insomnia/releases/download/core%40${version}/Insomnia.Core-${version}.deb";
      sha256 = "sha256-srYykuGDXCpjFeBgUFMO7ID6IE+tRG9gR7GQxeEA/UY=";
    };
  });

}
