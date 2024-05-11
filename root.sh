##!/bin/sh

current_dir="$(cd "$(dirname "$0")" && pwd)"
. $current_dir/env.sh

# Ensure the script is running as root
if [ "$(id -u)" -ne 0 ]; then
	echo "This script must be run as root."
	exit 1
fi

# Create user if not exists
if ! id -u user >/dev/null 2>&1; then
	echo "Creating user $usr..."
	useradd -G sudo -m $usr -s /bin/zsh
else
	echo "User '$usr' already exists"
fi

if [ $? -ne 0 ]; then
	echo "User creation failed. Cannot proceed with user tasks."
	exit 1
fi

echo "Running user-specific tasks as $usr..."

# Run the user tasks script as the new user
chown $usr:$usr $current_dir/user.sh $current_dir/env.sh
su - $usr -c "sudo -u $usr sh '$configure_user_script'"
if [ $? -ne 0 ]; then
	echo "Tasks execution as $usr failed."
	exit 1
fi

echo "Bootstrap process completed successfully."
