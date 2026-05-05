{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { nixpkgs, self, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: {
        default = pkgs.buildGoModule {
          pname = "rampart";
          version = self.shortRev or self.dirtyShortRev or "dev";
          src = ./.;
          vendorHash = "sha256-MN3fTPEwnmqN7be1Wfp88jPreLw0VSJ+HFyjwfxhEhI=";
          subPackages = [ "cmd/rampart" ];
          ldflags =
            let
              pkg = "github.com/peg/rampart/internal/build";
              version = self.shortRev or self.dirtyShortRev or "dev";
            in
            [
              "-s" "-w"
              "-X ${pkg}.Version=${version}"
              "-X ${pkg}.Commit=${self.shortRev or "unknown"}"
              "-X ${pkg}.Date=1970-01-01T00:00:00Z"
            ];
          doCheck = false;
        };
      });
    };
}
