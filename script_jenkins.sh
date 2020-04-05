#!/bin/bash

# Usage:
# send_to_dev_ci.sh
#    Use without arguments, the script will use the static list at the end of script
#
# send_to_dev_ci.sh my_app my_other_app "the directory/which/contains/my_third_app"
#    Use with arguments, each argument will be considered as an app to send to the CI.

# Get the path of this script
script_dir="$(dirname "$(realpath "$0")")"

# Get potential arguments and store them into an array
if [ $# -ge 1 ]
then
    folders_to_send=("$@")
fi

ssh_user=rodinux
ssh_host=ci-apps-dev.yunohost.org
ssh_port=22
ssh_key=~/.ssh/id_rsa
distant_dir=/data
SSHSOCKET=~/.ssh/ssh-socket-%r-%h-%p

SEND_TO_CI () {
    echo "============================"
    echo ">>> Sending $1"
    rsync -avzhuE -c --progress --delete --exclude=".git" "${1%/}" -e "ssh -i $ssh_key -p $ssh_port -o ControlPath=$SSHSOCKET"  $ssh_user@$ssh_host:"$distant_dir/"
    echo "============="
    echo "Build should show up here once it starts:"
    echo "https://$ssh_host/jenkins/view/$ssh_user/job/$(basename "${1%/}")%20($ssh_user)/lastBuild/console"
}

echo "Opening connection"
ssh $ssh_user@$ssh_host -p $ssh_port -i $ssh_key -f -M -N -o ControlPath=$SSHSOCKET
if [ "$?" -ne 0 ]
then
    # If the user wait too long, the connection will fail.
    # Same player try again
    ssh $ssh_user@$ssh_host -p $ssh_port -i $ssh_key -f -M -N -o ControlPath=$SSHSOCKET
fi

# If the script has arguments, use them
if [ -n "$folders_to_send" ]
then
    # Read each arguments separately
    for folder in "${folders_to_send[@]}"
    do
        SEND_TO_CI "$folder"
    done

# Otherwise, without arguments, use the static list
else
    SEND_TO_CI "$script_dir/garradin_ynh"
    SEND_TO_CI "$script_dir/APP2"
    SEND_TO_CI "$script_dir/APP3"
fi

echo "Closing connection"
ssh $ssh_user@$ssh_host -p $ssh_port -i $ssh_key -S $SSHSOCKET -O exit
