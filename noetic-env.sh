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

# Set environment variables here and preserve them

exec guix shell -L channel -C \
     --container \
     --network \
     -m $0

!#


(specifications->manifest
 '("nss-certs"
   "coreutils"
   "python-rosinstall-generator"
   "catkin"
   "python"
   "python-empy"
   "python-rosdep"
   "cmake@3.25.1"
   "gcc-toolchain"
   "make"
   )
 )

