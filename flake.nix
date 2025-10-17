{
  description = "Talos homelab development environment";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";

  outputs =
    inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      # Helper function to generate outputs for each system
      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import inputs.nixpkgs {
              inherit system;
            };
          }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              kubectl
              talosctl
              # Add more tools here if needed
            ];

            shellHook = ''
              clear
              echo "🌟 Talos Homelab Development Environment 🌟"
              echo ""

              # ASCII Talos robot
              echo "     [::] "
              echo "    /    \\"
              echo "   | O  O |"
              echo "   |  --  |"
              echo "    \\____/"
              echo ""

              # Set local Talos and Kubernetes config paths
              export TALOSCONFIG="$PWD/talos-config/talosconfig.yaml"
              export KUBECONFIG="$PWD/kube-config.yaml"

              # Check configs
              if [ -f "$TALOSCONFIG" ]; then
                echo "Talos config loaded from $TALOSCONFIG"
              else
                echo "⚠️  Talos config file not found at $TALOSCONFIG"
              fi

              if [ -f "$KUBECONFIG" ]; then
                echo "Kubernetes config loaded from $KUBECONFIG"
              else
                echo "⚠️  Kubernetes config file not found at $KUBECONFIG"
              fi

              echo ""
              echo "💻 Happy hacking in your Talos Kubernetes homelab!"
            '';
          };
        }
      );
    };
}
