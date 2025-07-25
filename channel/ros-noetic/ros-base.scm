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

(define-module (ros-noetic ros-base)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system catkin)
  #:use-module (gnu packages boost)
  #:use-module (ros-noetic common-msgs)
  #:use-module (ros-noetic ros)
  #:use-module (ros-noetic ros-comm)
  #:use-module (ros-noetic ros-core)
  #:use-module (ros-noetic roscpp-core)
  #:use-module (gnu packages wxwidgets))

;;; Commentary:
;;;
;;;
;;; Packages that are part of ros_base
;;;
;;; Code:

(define-public ros-noetic-actionlib
  (let ((commit "ce5635930d4083090ee1e6c4c3248daa3fb3de62")
        (revision "0"))
    (package
      (name "ros-noetic-actionlib")
      (version (git-version "1.14.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/actionlib")
               (commit commit)))
         (sha256
          (base32 "060kbaa8dpsdqfchk1hj188sghmcfgfmp86zccjbqirr10farrh1"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-actionlib-msgs
                           ros-noetic-message-generation
                           ros-noetic-rosnode
                           ros-noetic-rostest
                           ros-noetic-rosunit
                           ros-noetic-std-msgs))
      (propagated-inputs (list boost ros-noetic-actionlib-msgs
                               ros-noetic-message-runtime ros-noetic-rospy
                               ros-noetic-roscpp))
      (arguments
       (list
        #:package-dir "actionlib"))
      (home-page "https://wiki.ros.org/actionlib")
      (synopsis "Standardized interface for preemptible tasks")
      (description
       "The actionlib stack provides a standardized interface for
interfacing with preemptable tasks.  Examples of this include moving
the base to a target location, performing a laser scan and returning
the resulting point cloud, detecting the handle of a door, etc.")
      (license license:bsd-3))))

(define-public ros-noetic-actionlib-tools
  (let ((commit "ce5635930d4083090ee1e6c4c3248daa3fb3de62")
        (revision "0"))
    (package
      (name "ros-noetic-actionlib-tools")
      (version (git-version "1.14.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/actionlib")
               (commit commit)))
         (sha256
          (base32 "060kbaa8dpsdqfchk1hj188sghmcfgfmp86zccjbqirr10farrh1"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-rospy
                               ros-noetic-rostopic
                               ros-noetic-roslib
                               ros-noetic-actionlib
                               ros-noetic-actionlib-msgs
                               python-wxpython))
      (arguments
       (list
        #:package-dir "actionlib_tools"))
      (home-page "https://wiki.ros.org/actionlib")
      (synopsis "GUI tools for actionlib")
      (description "GUI tools for actionlib.")
      (license license:bsd-3))))


(define-public ros-noetic-dynamic-reconfigure
  (let ((commit "a70f872d7a84cd50202e096771c36e04564876d5")
        (revision "0"))
    (package
      (name "ros-noetic-dynamic-reconfigure")
      (version (git-version "1.7.6" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/dynamic_reconfigure")
               (commit commit)))
         (sha256
          (base32 "06yk4j9z7kxkd0ax2b2d3argr3qfcwz6yyfd6cwky444y5vkpiay"))
         (file-name (git-file-name name version))))
      (native-inputs (list ros-noetic-message-generation ros-noetic-rostest))
      (propagated-inputs (list boost
                               ros-noetic-cpp-common
                               ros-noetic-roscpp
                               ros-noetic-std-msgs
                               ros-noetic-rosservice
                               ros-noetic-roslib
                               ros-noetic-rospy
                               ros-noetic-message-runtime))
      (build-system catkin-build-system)
      (home-page "https://wiki.ros.org/dynamic_reconfigure")
      (synopsis "Update ROS parameters at runtime")
      (description "Tools to update ROS parameters at runtime
without needing to restart a node.")
      (license license:bsd-3))))
