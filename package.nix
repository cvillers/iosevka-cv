{ pkgs, ... }:
rec {
  iosevka-custom = pkgs.iosevka.override {
    privateBuildPlan = builtins.readFile ./build-plan.toml;
    set = "CV";
  };
  iosevka-cv = (
    iosevka-custom.overrideAttrs (
      final: prev: {
        nativeBuildInputs = prev.nativeBuildInputs ++ [
          #pkgs.go-toml
          #pkgs.ttfautohint-nox
          pkgs.nodejs
          pkgs.nerd-font-patcher
        ];
        postInstall = ''
          mkdir -p $out/share/fonts/truetype/{iosevka-cv,iosevka-cv-nerd}
          mv $out/share/fonts/truetype/*.ttf $out/share/fonts/truetype/iosevka-cv/
          for f in $out/share/fonts/truetype/iosevka-cv/*.ttf; do
            nerd-font-patcher --complete --outputdir $out/share/fonts/truetype/iosevka-cv-nerd/ $f
          done
        '';
      }
    )
  );
}
