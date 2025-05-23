(define-module (ros-noetic metapackages)
  #:use-module (guix build-system catkin)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix search-paths)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (gnu packages apr)
  #:use-module (gnu packages base)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages check)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages cpp)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages lisp)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-crypto)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages xml)
  #:use-module (ros-noetic bootstrap)
  #:use-module (ros-noetic common-msgs)
  #:use-module (ros-noetic core)
  #:use-module (ros-noetic ros)
  #:use-module (ros-noetic roscpp-core)
  #:use-module (ros-noetic ros-comm)
  #:use-module (ros-noetic ros-comm-msgs)
  #:use-module (contributed))

;; Commentary:
;;
;; Packages in https://github.com/ros/metapackages
;;
;; Code:

(define-public ros-noetic-ros-core
  (let ((commit "482da3e297f47a2e06f54d54c16de7e3cb7ec0f4")
        (revision "0"))
    (package
      (name "ros-noetic-ros-core")
      (version (git-version "1.5.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/metapackages")
                             (commit commit)))
         (sha256
          (base32 "0asbsc1r566i1ijmd5gbgx6pxsznki6ajryc4al2mnn7vn61rn6l"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs
       (list
        ros-noetic-class-loader
        ros-noetic-cmake-modules
        ros-noetic-common-msgs
        ros-noetic-gencpp
        ros-noetic-geneus
        ros-noetic-genlisp
        ros-noetic-genmsg
        ros-noetic-gennodejs
        ros-noetic-genpy
        ros-noetic-message-generation
        ros-noetic-message-runtime
        ros-noetic-pluginlib
        ros-noetic-ros
        ros-noetic-ros-comm
        ros-noetic-rosbag-migration-rule
        ros-noetic-rosconsole
        ros-noetic-rosconsole-bridge
        ros-noetic-roscpp-core
        ros-noetic-rosgraph-msgs
        ros-noetic-roslisp
        ros-noetic-rospack
        ros-noetic-std-msgs
        ros-noetic-std-srvs))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "ros_core"))))))
      (home-page "http://wiki.ros.org/ros_core")
      (synopsis "Aggregates the packages required to use core ROS concepts")
      (description "A metapackage to aggregate the packages required to
use publish / subscribe, services, launch files, and other core ROS concepts")
      (license license:bsd-3))))
