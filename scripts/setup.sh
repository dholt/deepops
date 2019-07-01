#!/usr/bin/env bash

. /etc/os-release

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "${SCRIPT_DIR}/.." || echo "Could not cd to repository root"

# Pinned Ansible version
ANSIBLE_OK="2.7"
ANSIBLE_VERSION="2.7.11"

# Install Software
case "$ID" in
    rhel*|centos*)
    # Enable EPEL (required for Pip)
    sudo yum -y install epel-release

	# Install pip and ensure Jinja2 is updated
	if ! which pip >/dev/null 2>&1; then
	    echo "Installing pip..."
	    sudo yum -y install python-pip >/dev/null
	fi
	pip --version
        echo "Upgrading jinja2"
        sudo pip install --upgrade Jinja2

        # Check Ansible version and install with pip
        if ! which ansible >/dev/null 2>&1; then
	    sudo pip install ansible=="${ANSIBLE_VERSION}"
	else
	    current_version=$(ansible --version | head -n1 | awk '{print $2}')
	    if ! echo "${current_version}" | grep "${ANSIBLE_OK}" >/dev/null 2>&1; then
	        echo "Unsupported version of Ansible: ${current_version}"
		echo "Version must match ${ANSIBLE_OK}.x"
		exit 1
	    fi
	fi

        # Install python-netaddr
        python -c 'import netaddr' >/dev/null 2>&1
        if [ $? -ne 0 ] ; then
            echo "Installing Python dependencies..."
            sudo yum -y install python36 python-netaddr >/dev/null
	    sudo ln -s /usr/bin/python36 /usr/bin/python3
        fi

        # Install git
        type git >/dev/null 2>&1
        if [ $? -ne 0 ] ; then
            echo "Installing git..."
            sudo yum -y install git >/dev/null
        fi
        git --version

        # Install IPMItool
        type ipmitool >/dev/null 2>&1
        if [ $? -ne 0 ] ; then
            echo "Installing IPMITool..."
            sudo yum -y install ipmitool >/dev/null
        fi
        ipmitool -V


	# Install wget
	if ! which wget >/dev/null 2>&1; then
	    echo "Installing wget..."
            sudo yum -y install wget >/dev/null
        fi
        wget --version
        ;;
    ubuntu*)
        # Update apt cache
        echo "Updating apt cache..."
        sudo apt-get update >/dev/null

        # Install repo tool
        type apt-add-repository >/dev/null 2>&1
        if [ $? -ne 0 ] ; then
            sudo apt-get -y install software-properties-common >/dev/null
        fi

	# Install pip
	if ! which pip >/dev/null 2>&1; then
	    echo "Installing pip..."
	    sudo apt-get -y install python-pip >/dev/null
	fi
	pip --version

        # Check Ansible version and install with pip
        if ! which ansible >/dev/null 2>&1; then
	    sudo pip install ansible=="${ANSIBLE_VERSION}"
	else
	    current_version=$(ansible --version | head -n1 | awk '{print $2}')
	    if ! echo "${current_version}" | grep "${ANSIBLE_OK}" >/dev/null 2>&1; then
	        echo "Unsupported version of Ansible: ${current_version}"
		echo "Version must match ${ANSIBLE_OK}.x"
		exit 1
	    fi
	fi

        # Install python-netaddr
        python -c 'import netaddr' >/dev/null 2>&1
        if [ $? -ne 0 ] ; then
            echo "Installing Python dependencies..."
            sudo apt-get -y install python-netaddr python3-netaddr >/dev/null
        fi

        # Install git
        type git >/dev/null 2>&1
        if [ $? -ne 0 ] ; then
            echo "Installing git..."
            sudo apt -y install git >/dev/null
        fi
        git --version

        # Install IPMItool
        type ipmitool >/dev/null 2>&1
        if [ $? -ne 0 ] ; then
            echo "Installing IPMITool..."
            sudo apt -y install ipmitool >/dev/null
        fi
        ipmitool -V

	# Install wget
	if ! which wget >/dev/null 2>&1; then
	    echo "Installing wget..."
            sudo apt -y install wget >/dev/null
        fi
        wget --version
        ;;
    *)
        echo "Unsupported Operating System $ID_LIKE"
        echo "Please install Ansible, Git, and python-netaddr manually"
        ;;
esac

# Install Ansible Galaxy roles
ansible-galaxy --version >/dev/null 2>&1
if [ $? -eq 0 ] ; then
    ansible-galaxy install -r requirements.yml
else
    echo "ERROR: Unable to install Ansible Galaxy roles"
fi

# Update submodules
git status >/dev/null 2>&1
if [ $? -eq 0 ] ; then
    git submodule update --init
else
    echo "ERROR: Unable to update Git submodules"
fi

# Copy default configuration
CONFIG_DIR=${CONFIG_DIR:-./config}
if [ ! -d "${CONFIG_DIR}" ] ; then
    cp -rfp ./config.example "${CONFIG_DIR}"
    echo "Copied default configuration to ${CONFIG_DIR}"
else
    echo "Configuration directory '${CONFIG_DIR}' exists, not overwriting"
fi
