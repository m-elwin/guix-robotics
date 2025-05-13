#!/usr/bin/env bash
# Quickly create an environment in a container that allows building ROS noetic from scratch using catkin
# The purpose of this container is to provide an environment where ROS noetic commands can be run
# as done normally through ROS on Ubuntu. It's a convenient way to try out this guix channel
# without needing to know anything about guix

# TODO: rosdep doesn't work.

# This part of the bash script appears as a comment to guix
# An example of this technique is provided below
# https://www.futurile.net/2023/04/29/guix-shell-virtual-environments-containers/ <Accessed 5/5/2025>
set -ex

curr_dir=$(dirname $(readlink -f "$0"))

# Set environment variables here and preserve them
exec guix shell -L "$curr_dir/channel" -C \
     --container \
     --emulate-fhs \
     --nesting \
     --network \
     --writable-root \
     -m $0 -- bash
!#


(specifications->manifest
 '("bzip2"
   "bash"
   "boost"
   "catkin"
   "cmake@3.25.1"
   "console-bridge"
   "coreutils"
   "findutils"
   "gawk"
   "gcc-toolchain"
   "gpgme"
   "googletest"
   "grep"
   "log4cxx@0.11"
   "lz4"
   "make"
   "nss-certs"
   "openssl"
   "poco"
   "procps"
   "python"
   "python-defusedxml"
   "python-empy"
   "python-gnupg"
   "python-pycryptodomex"
   "python-netifaces"
   "python-nose"
   "python-rosdep"
   "python-rosinstall-generator"
   "sed"
   "tinyxml2"
   "vcstool"
   )
 )

