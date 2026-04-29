{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: {
        default = pkgs.buildGoModule {
          pname = "rampart";
          version = "0.9.15";
          src = self;
          vendorHash = "sha256-MN3fTPEwnmqN7be1Wfp88jPreLw0VSJ+HFyjwfxhEhI=";
          doCheck = false;
        };
      });
    };
}
