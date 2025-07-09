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

(define-module (ros-noetic tutorials)
  #:use-module (guix build-system catkin)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages qt)
  #:use-module (ros-noetic common-msgs)
  #:use-module (ros-noetic geometry)
  #:use-module (ros-noetic geometry2)
  #:use-module (ros-noetic nodelet-core)
  #:use-module (ros-noetic ros)
  #:use-module (ros-noetic ros-base)
  #:use-module (ros-noetic ros-comm)
  #:use-module (ros-noetic ros-core)
  #:use-module (ros-noetic roscpp-core))

;;; Commentary:
;;
;; Packages for ROS tutorials
;;
;; Code:

(define ros-tutorials-base
  (let ((commit "dbf2dc3c89f26a5cad3b7f26f4838bb1fd618bba")
        (revision "0"))
    (package
      (name "ros-noetic-ros-tutorials-base")
      (version (git-version "0.10.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/ros_tutorials")
               (commit commit)))
         (sha256
          (base32 "0pwigr906xqbp4jwjvc7zjwq0f68jvh5dfzl8bcdq45dnjbl6s3d"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (home-page "https://github.com/ros/ros_tutorials")
      (synopsis "Base package for ros tutorials")
      (description "Not for direct use, inherit instead.")
      (license license:bsd-3))))

(define-public ros-noetic-turtlesim
  (package
    (inherit ros-tutorials-base)
    (name "ros-noetic-turtlesim")
    (native-inputs (list ros-noetic-message-generation))
    (inputs (list ros-noetic-geometry-msgs
                  boost
                  qtbase-5
                  ros-noetic-message-runtime
                  ros-noetic-rosconsole
                  ros-noetic-roscpp
                  ros-noetic-roscpp-serialization
                  ros-noetic-roslib
                  ros-noetic-rostime
                  ros-noetic-std-msgs
                  ros-noetic-std-srvs))
    (arguments
     (list
      #:package-dir "turtlesim"))
    (home-page "https://wiki.ros.org/turtlesim")
    (synopsis "Tool for teaching ROS and ROS packages")
    (description
     "A 2D simulation of a vehicle that looks like a turtle.
It can be send commands with ROS messages, and its environment is controlled with ROS
services and parameters.")))

(define-public ros-noetic-roscpp-tutorials
  (package
    (inherit ros-tutorials-base)
    (name "ros-noetic-roscpp-tutorials")
    (native-inputs (list ros-noetic-message-generation))
    (inputs (list boost
                  ros-noetic-rosconsole
                  ros-noetic-roscpp
                  ros-noetic-roscpp-serialization
                  ros-noetic-rostime
                  ros-noetic-std-msgs))
    (arguments
     (list
      #:package-dir "roscpp_tutorials"))
    (home-page "https://wiki.ros.org/roscpp_tutorials")
    (synopsis "Tutorials that demonstrate C++ features of ROS step by step")
    (description "Tutorials for using ROS with C++, including using messages,
services, and parameters.")))

(define-public ros-noetic-rospy-tutorials
  (package
    (inherit ros-tutorials-base)
    (name "ros-noetic-rospy-tutorials")
    (native-inputs (list ros-noetic-message-generation ros-noetic-rostest
                         ros-noetic-roscpp-tutorials))
    (propagated-inputs (list ros-noetic-message-runtime ros-noetic-rospy
                             ros-noetic-std-msgs))
    (arguments
     (list
      #:package-dir "rospy_tutorials"))
    (home-page "https://wiki.ros.org/rospy_tutorials")
    (synopsis "Tutorials that demonstrate Python features of ROS step by step")
    (description "Tutorials for using ROS with Python, including using messages,
services, and parameters.")))

(define-public ros-noetic-ros-tutorials
  (package
    (inherit ros-tutorials-base)
    (name "ros-noetic-ros-tutorials")
    (propagated-inputs (list ros-noetic-message-runtime ros-noetic-rospy
                             ros-noetic-std-msgs))
    (arguments
     (list
      #:package-dir "ros_tutorials"))
    (home-page "https://wiki.ros.org/roscpp_tutorials")
    (synopsis "Packages to demonstrate features of ROS")
    (description "Packages taht demonstrate features of ROS
and packages that support the demonstration of those features.")))

(define common-tutorials-base
  (let ((commit "b3a86ff8a60efd678f942deab47efcadd52a5336")
        (revision "0"))
    (package
      (name "ros-noetic-common-tutorials-base")
      (version (git-version "0.2.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/common_tutorials")
               (commit commit)))
         (sha256
          (base32 "0bnwadzbzx83dmqzwhbzmh86aph1mfl6jnc88dgbmv53ll988208"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (home-page "https://github.com/ros/common_tutorials")
      (synopsis "Base package for common tutorials")
      (description "Not for direct use, inherit instead.")
      (license license:bsd-3))))

(define-public ros-noetic-actionlib-tutorials
  (package
    (inherit common-tutorials-base)
    (name "ros-noetic-actionlib-tutorials")
    (arguments
     (list
      #:package-dir "actionlib_tutorials"))
    (native-inputs (list ros-noetic-message-generation))
    (inputs (list ros-noetic-roscpp))
    (propagated-inputs (list gcc-toolchain-12
                             ros-noetic-actionlib ros-noetic-std-msgs
                             ros-noetic-actionlib-msgs
                             ros-noetic-message-runtime))
    (home-page "https://wiki.ros.org/actionlib_tutorials")
    (synopsis "Tutorials for using actionlib")
    (description "Tutorials for using actionlib")))

(define-public ros-noetic-turtle-actionlib
  (package
    (inherit common-tutorials-base)
    (name "ros-noetic-turtle-actionlib")
    (arguments
     (list
      #:package-dir "turtle_actionlib"))
    (native-inputs (list ros-noetic-message-generation))
    (inputs (list ros-noetic-actionlib
                  ros-noetic-actionlib-msgs
                  ros-noetic-angles
                  ros-noetic-message-runtime
                  ros-noetic-rosconsole
                  ros-noetic-roscpp
                  ros-noetic-std-msgs
                  ros-noetic-std-srvs
                  ros-noetic-turtlesim
                  ros-noetic-geometry-msgs))
      (home-page "https://github.com/ros/turtle_actionlib")
    (synopsis "Tutorials for using actionlib with turtlesim")
    (description "A tutorial that demonstrates how to write an
action server and client with the turtlesim. The shape_server
provides an action interface for drawing regular polygons with
the turtlesim.")))

(define-public ros-noetic-nodelet-tutorial-math
  (package
    (inherit common-tutorials-base)
    (name "ros-noetic-nodelet-tutorial-math")
    (arguments
     (list
      #:package-dir "nodelet_tutorial_math"))
    (inputs (list ros-noetic-nodelet ros-noetic-pluginlib ros-noetic-roscpp
                  ros-noetic-std-msgs))
    (home-page "https://github.com/ros/nodelet_tutorial_math")
    (synopsis "Package for nodelet tutorial")
    (description "Package for nodelet tutorial.")))

(define-public ros-noetic-pluginlib-tutorials
  (package
    (inherit common-tutorials-base)
    (name "ros-noetic-pluginlib-tutorials")
    (arguments
     (list
      #:package-dir "pluginlib_tutorials"))
    (inputs (list ros-noetic-pluginlib ros-noetic-roscpp))
    (home-page "https://github.com/ros/pluginlib_tutorials")
    (synopsis "Tutorials for pluginlib")
    (description "Tutorials for pluginlib")))

(define-public ros-noetic-common-tutorials
  (package
    (inherit common-tutorials-base)
    (name "ros-noetic-common-tutorials")
    (arguments
     (list
      #:package-dir "common_tutorials"))
    (propagated-inputs (list ros-noetic-actionlib-tutorials
                             ros-noetic-nodelet-tutorial-math
                             ros-noetic-pluginlib-tutorials
                             ros-noetic-turtle-actionlib))
    (home-page "https://github.com/ros/common_tutorials")
    (synopsis "Common tutorials for ROS")
    (description "Common Tutorials for ROS")))

(define geometry-tutorials-base
  (let ((commit "d365875776b154ead3150faae9f47d591c20a9d1")
        (revision "0"))
    (package
      (name "ros-noetic-geometry-tutorials-base")
      (version (git-version "0.2.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/geometry_tutorials")
               (commit commit)))
         (sha256
          (base32 "1bj0kj8rxkqxhjsp9zh4j80hg8k90vqs96bl4ljmkhlg9bc9ipl9"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (home-page "https://github.com/ros/geometry_tutorials")
      (synopsis "Base package for geometry tutorials")
      (description "Not for direct use, inherit instead.")
      (license license:bsd-3))))

(define-public ros-noetic-turtle-tf
  (package
    (inherit geometry-tutorials-base)
    (name "ros-noetic-turtle-tf")
    (arguments
     (list
      #:package-dir "turtle_tf"))
    (inputs (list ros-noetic-roscpp))
    (propagated-inputs (list ros-noetic-geometry-msgs
                             ros-noetic-rospy
                             ros-noetic-std-msgs
                             ros-noetic-std-srvs
                             ros-noetic-tf
                             ros-noetic-turtlesim))
    (home-page "https://wiki.ros.org/turtle_tf")
    (synopsis
     "Demonstrates how to write a tf broadcaster and listener with turtlesim")
    (description
     "The turtle_tf_listener commands turtle2 to follow turtle1 around
ad you drive turtle1 using the keyboard")))


(define-public ros-noetic-turtle-tf2
  (package
    (inherit geometry-tutorials-base)
    (name "ros-noetic-turtle-tf2")
    (arguments
     (list
      #:package-dir "turtle_tf2"))
    (inputs (list ros-noetic-roscpp))
    (propagated-inputs (list ros-noetic-geometry-msgs
                             ros-noetic-rospy
                             ros-noetic-std-msgs
                             ros-noetic-std-srvs
                             ros-noetic-tf2
                             ros-noetic-tf2-ros
                             ros-noetic-tf2-geometry-msgs
                             ros-noetic-turtlesim))
    (home-page "https://github.com/ros/turtle_tf")
    (synopsis
     "Demonstrates how to write a tf2 broadcaster and listener with turtlesim")
    (description
     "The turtle_tf2_listener commands turtle2 to follow turtle1 around
ad you drive turtle1 using the keyboard")))
