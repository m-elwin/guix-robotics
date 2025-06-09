;;; Guix-Robotics --- GNU Guix Channel
;;; Copyright © 2025 Matthew Elwin <elwin@northwestern.edu>
;;; This file is part of Guix-Robotics.
;;;
;;; Guix-Robotics is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; Guix-Robotics is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with Guix-Robotics.  If not, see <http://www.gnu.org/licenses/>.

(define-module (ros-noetic metapackages)
  #:use-module (guix build-system catkin)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (ros-noetic bond-core)
  #:use-module (ros-noetic common-msgs)
  #:use-module (ros-noetic nodelet-core)
  #:use-module (ros-noetic ros)
  #:use-module (ros-noetic ros-base)
  #:use-module (ros-noetic ros-core)
  #:use-module (ros-noetic ros-comm)
  #:use-module (ros-noetic roscpp-core))

;;; Commentary:
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
         (uri (git-reference
               (url "https://github.com/ros/metapackages")
               (commit commit)))
         (sha256
          (base32 "0asbsc1r566i1ijmd5gbgx6pxsznki6ajryc4al2mnn7vn61rn6l"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-class-loader
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
      (arguments
       (list
        #:package-dir "ros_core"))
      (home-page "http://wiki.ros.org/ros_core")
      (synopsis "Aggregates the packages required to use core ROS concepts")
      (description
       "A metapackage to aggregate the packages required to
use publish / subscribe, services, launch files, and other core ROS concepts")
      (license license:bsd-3))))

(define-public ros-noetic-ros-base
  (let ((commit "482da3e297f47a2e06f54d54c16de7e3cb7ec0f4")
        (revision "0"))
    (package
      (name "ros-noetic-ros-base")
      (version (git-version "1.5.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/metapackages")
               (commit commit)))
         (sha256
          (base32 "0asbsc1r566i1ijmd5gbgx6pxsznki6ajryc4al2mnn7vn61rn6l"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-ros-core ros-noetic-actionlib
                               ros-noetic-bond-core
                               ros-noetic-dynamic-reconfigure
                               ros-noetic-nodelet-core))
      (arguments
       (list
        #:package-dir "ros_base"))
      (home-page "http://wiki.ros.org/ros_base")
      (synopsis
       "Metapackage that extends ros_core and includes basic non-robot tools")
      (description
       "Metapackage that extends ros_core and includes other basic non-robot tools like
actionlib, dynamic reconfigure, nodelets, and pluginlib.")
      (license license:bsd-3))))

(define-public ros-noetic-robot
  (let ((commit "482da3e297f47a2e06f54d54c16de7e3cb7ec0f4")
        (revision "0"))
    (package
      (name "ros-noetic-robot")
      (version (git-version "1.5.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/metapackages")
               (commit commit)))
         (sha256
          (base32 "0asbsc1r566i1ijmd5gbgx6pxsznki6ajryc4al2mnn7vn61rn6l"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-ros-base
                               ros-noetic-control-msgs
                               ros-noetic-diagnostics
                               ros-noetic-executive-smach
                               ros-noetic-filters
                               ros-noetic-geometry
;                               ros-noetic-joint-state-publisher
;                              ros-noetic-kdl-parser
;                              ros-noetic-robot-state-publisher
;                              ros-noetic-urdf
;                              ros-noetic-urdf-parser-plugin
                                        ;                              ros-noetic-xacro
                               ))
      (arguments
       (list
        #:package-dir "robot"))
      (home-page "https://github.com/ros/metapackages")
      (synopsis
       "Metapackage that extends ros_base with ROS libraries for robot hardware")
      (description
       "Metapackage that extends ros_base with ROS libraries for robot hardware
It may not contain any GUI dependencies.")
      (license license:bsd-3))))
