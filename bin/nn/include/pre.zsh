[[ -v h ]] || (echo 'env h is not set'; false)

# prepare host folders
out=$(realpath out)
[[ -d $out ]] && rm -r $out
mkdir -p $out

# docker arguments
args=()

# mount
function mount {
    args+=(--mount type=bind,source=${1:a},destination=$2)
}

# mount an nn relative path to /xp/src/nn
function nn_mount  {
    mount $h/$1 /xp/src/nn/$1
}

# "identity" mount a folder (meaning same path on host and in container)
function id_mount {
    mount ${1:a} ${1:a}
}

# interactive
args+=(--interactive --tty --rm --detach-keys 'ctrl-@,x,x')
#args+=(--env TERM --env SHELL)

# docker in docker
args+=(-v /var/run/docker.sock:/var/run/docker.sock)

# x11 for rendering
args+=(
    --env DISPLAY=${DISPLAY:-:0}
    -v=/tmp/.X11-unix:/tmp/.X11-unix:rw
    --pid=host
)

# aws
args+=(
    --env AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
    --env AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
    --env AWS_DEFAULT_REGION=eu-west-1
)

# s3 cache
if [[ -e $h/s3-cache ]]; then
    echo 'you might still have a project local s3-cache, we use a shared ~/envs/s3-cache now'
    exit 1
fi
mkdir -p ~/envs/s3-cache
mount ~/envs/s3-cache /xp/s3-cache
args+=(
    --env NN_S3_CACHE=/xp/s3-cache
)

# user
args+=(--user $(id --user):$(id --group))

# mounts
if ! mountpoint --quiet /efs; then
    echo '/efs might not yet be mounted' >&2
    exit 1
fi
id_mount /efs
nn_mount .

# out dir
mount $out /xp/src/out
args+=(--workdir=/xp/src/out)

# ipython
# TODO we need to map in config too, because symlinks go there, is that okay?
id_mount ~/config
mount ~/.ipython /home/dkuettel/.ipython

# debuggers
# TODO add to case as option below?
#args+=(--env PYTHONBREAKPOINT='ipdb.set_trace')
args+=(--env PYTHONBREAKPOINT='IPython.embed')
# needs pip3 install web-pdb
#args+=(--env PYTHONBREAKPOINT='web_pdb.set_trace' -p 5555:5555)

# vimfix
id_mount ~/toys/vim-python-tracebacks

# probably not needed anymore
# args+=(--env NN_USER=kuettel)

# for with-tb
args+=(-p 6006:6006)

# TODO for speed mounting in local copy, but dangerous if out-of-date
if [[ -d efs-models ]]; then
    echo '*** NOTE: MOUNTING LOCAL EFS MODELS'
    mount efs-models /efs/hacharya/test_data/models
fi

# TODO splitting up into nn and flow makes cases difficult
# because there are some options that I wont in both
# maybe the best solution in the end is to have just one entry point anyway
