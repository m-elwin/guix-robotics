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

;;; Packages that are unnecessary but make navigating and using the shell environment easier
(define shell-quality-of-life
 '("bash"
   "procps"))

;;; These dependencies are required to build and use the ros_core packages
;;; Commands that are enabled in the environment are based on http://wiki.ros.org/noetic/Installation/Source <Accessed May 10, 2025>
;;; mkdir ws_noetic
;;; cd ws_noetic
;;; rosinstall_generator ros_core --rosdistro noetic --deps --tar > noetic-ros-core.rosinstall
;;; mkdir ./src
;;; vcs import --input noetic-ros-core.rosinstall
;;; ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release
;;;
;;; The build will then succeed, the workspace can be sourced as usual, and the core ros packages work
(define ros-core-system-deps
 '("bzip2"
   "boost"
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
   ))

(specifications->manifest
 (append shell-quality-of-life ros-core-system-deps))

