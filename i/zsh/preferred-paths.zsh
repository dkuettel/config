
function _preferred_path {
    local mappings=(
        ~/Dropbox/sprint to ~/sprint
        ~/Dropbox/toys to ~/toys
        ~/Dropbox to ~/dbox
    )

    local mapped=${1:A}
    while (( $#mappings > 0 )); do
        mapped=${mapped/#$mappings[1]/$mappings[3]}
        mappings[1,3]=()
    done

    if [[ $mapped == $1 ]]; then
        return 1
    fi

    echo $mapped
}

if PWD=$(_preferred_path $PWD); then
    cd $PWD
fi
