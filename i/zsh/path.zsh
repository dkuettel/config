
path=(
    $HOME/config/bin
    $HOME/bin
    $HOME/bin/nodejs/bin
    $HOME/.cargo/bin  # rust toolchain
    $HOME/.local/bin  # pip install puts executables here
    /snap/bin  # should be there from system settings?
    $path
)

# path -> reverse -> keep only first unique -> reverse
# prevents any duplication for paths that are already setup
path=(${(Oa)${(u)${(Oa)path}}})

export path PATH
