{
  description = "Custom build of Iosevka";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  # outputs =
  #   { self, ... }@inputs:
  #   let
  #     inherit (inputs.nixpkgs) lib;

  #     supportedSystems = [
  #       "x86_64-linux"
  #       "aarch64-linux"
  #       "aarch64-darwin"
  #     ];

  #     forEachSupportedSystem =
  #       f:
  #       lib.genAttrs supportedSystems (
  #         system:
  #         f {
  #           inherit system;
  #           pkgs = import inputs.nixpkgs {
  #             inherit system;
  #             config.allowUnfree = true;
  #           };
  #         }
  #       );
  #   in
  #   {
  #     devShells = forEachSupportedSystem (
  #       { pkgs, system }:
  #       {
  #         default = pkgs.mkShellNoCC {
  #           packages = with pkgs; [
  #             self.formatter.${system}
  #           ];
  #         };
  #       }
  #     );

  #     formatter = forEachSupportedSystem ({ pkgs, ... }: pkgs.nixfmt);
  #   };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ] (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          default = (pkgs.callPackage ./package.nix { }).iosevka-cv;
        };

        devShells = {
          default = pkgs.mkShellNoCC {
            packages = [
              self.formatter.${system}
            ];
          };
        };

        formatter = pkgs.nixfmt;
      }
    );
}
