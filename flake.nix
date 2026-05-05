{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
      version = self.shortRev or self.dirtyShortRev or "dev";
      date =
        let d = self.lastModifiedDate;
        in "${builtins.substring 0 4 d}-${builtins.substring 4 2 d}-${builtins.substring 6 2 d}T${builtins.substring 8 2 d}:${builtins.substring 10 2 d}:${builtins.substring 12 2 d}Z";
    in
    {
      packages = forAllSystems (pkgs: {
        default = pkgs.buildGoModule {
          pname = "rampart";
          inherit version;
          src = self;
          vendorHash = "sha256-MN3fTPEwnmqN7be1Wfp88jPreLw0VSJ+HFyjwfxhEhI=";
          subPackages = [ "cmd/rampart" ];
          ldflags = [
            "-s"
            "-w"
            "-X github.com/peg/rampart/internal/build.versionFromLDFlags=${version}"
            "-X github.com/peg/rampart/internal/build.Commit=${self.shortRev or "unknown"}"
            "-X github.com/peg/rampart/internal/build.Date=${date}"
          ];
          doCheck = false;
          meta = {
            description = "Open-source firewall for AI agents";
            homepage = "https://github.com/peg/rampart";
            license = pkgs.lib.licenses.asl20;
            mainProgram = "rampart";
          };
        };
      });

      formatter = forAllSystems (pkgs: pkgs.nixpkgs-fmt);
    };
}
