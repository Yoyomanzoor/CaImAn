{
  pkgs ? import <nixpkgs> { },
}:
let
  fhs = pkgs.buildFHSEnv {
    name = "caiman-fhs-env";

    targetPkgs = _: [
      pkgs.micromamba
    ];

    profile = ''
      set -e
      eval "$(micromamba shell hook --shell=posix)"
      export MAMBA_ROOT_PREFIX=${builtins.getEnv "PWD"}/.mamba
      if ! test -d $MAMBA_ROOT_PREFIX/envs/caiman; then
          micromamba create --yes -q -n caiman -c conda-forge
      fi
      micromamba activate caiman
      set +e
    '';

    runScript = "fish";
  };
in
fhs.env
