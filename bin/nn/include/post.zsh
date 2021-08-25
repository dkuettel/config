echo
echo '** docker args:'
echo $args
echo
echo '** command:'
echo $cmd
echo

nvidia-docker run $args nn-dev:latest $cmd
