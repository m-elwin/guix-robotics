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

(define-module (ros-noetic robot)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system catkin)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages check)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages xml)
  #:use-module (ros-noetic bootstrap)
  #:use-module (ros-noetic common-msgs)
  #:use-module (ros-noetic ros)
  #:use-module (ros-noetic ros-comm)
  #:use-module (ros-noetic ros-core)
  #:use-module (ros-noetic ros-visualization)
  #:use-module (ros-noetic system))

;;; Commentary:
;;;
;;;
;;; Packages that are part of the robot metapacakge
;;; or their dependencies (including joint-state-publisher
;;; and urdf related packages.
;;;
;;; Code:

(define-public ros-noetic-control-msgs
  (let ((commit "c7b118501c24278467153822dd70e8c53baad3d5")
        (revision "0"))
    (package
      (name "ros-noetic-control-msgs")
      (version (git-version "1.5.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-controls/control_msgs")
               (commit commit)))
         (sha256
          (base32 "133fmjxhk0w3w2pyhh4ymgi80h9hcn708lw10qfxqlghjxzs2rid"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation))
      (propagated-inputs (list ros-noetic-message-runtime
                               ros-noetic-actionlib-msgs
                               ros-noetic-geometry-msgs
                               ros-noetic-trajectory-msgs))
      (arguments (list
        #:package-dir "control_msgs"))
      (home-page "http://wiki.ros.org/control_msgs")
      (synopsis "Messages and actions useful for controlling robots")
      (description "Base messages and actions useful for controlling
robots.  It provides representations for controller setpoints and joint
and cartesian trajectories.")
      (license license:bsd-3))))

(define-public ros-noetic-filters
  (let ((commit "126188027067f6822c39003dcc2aa86002d27f9f")
        (revision "0"))
    (package
      (name "ros-noetic-filters")
      (version (git-version "1.9.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/filters")
               (commit commit)))
         (sha256
          (base32 "1468prq2hq6xnn463h91zbw26y8sqab1vigzzskzd1kmipafxhah"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest))
      (propagated-inputs (list ros-noetic-roslib ros-noetic-rosconsole
                               ros-noetic-roscpp ros-noetic-pluginlib boost))
      (home-page "http://wiki.ros.org/filters")
      (synopsis "Standardized interface for processing data in sequence")
      (description
       "This library provides a standardized interface for
processing data as a sequence of filters.  This package contains a base
class upon which to build specific implementations as well as an interface
which dynamically loads filters based on runtime parameters.")
      (license license:bsd-3))))

(define-public ros-noetic-joint-state-publisher
  (let ((commit "ccb4446b9092e7f6d7956d7058d17745df7f8475")
        (revision "0"))
    (package
      (name "ros-noetic-joint-state-publisher")
      (version (git-version "1.15.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/joint_state_publisher")
               (commit commit)))
         (sha256
          (base32 "0i1ilshhxk5mvmzl9f4nrvf2cirxy52j1snv10d80ypgq91lh91m"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest))
      (propagated-inputs (list ros-noetic-rospy ros-noetic-sensor-msgs))
      (arguments
       (list
        #:package-dir "joint_state_publisher"))
      (home-page "https://wiki.ros.org/joint_state_publisher")
      (synopsis
       "Set and publish joint state values for a given URDF")
      (description
       "A tool for setting and publishing joint state values for a URDF")
      (license license:bsd-3))))

(define-public ros-noetic-joint-state-publisher-gui
  (let ((commit "ccb4446b9092e7f6d7956d7058d17745df7f8475")
        (revision "0"))
    (package
      (name "ros-noetic-joint-state-publisher-gui")
      (version (git-version "1.15.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/joint_state_publisher")
               (commit commit)))
         (sha256
          (base32 "0i1ilshhxk5mvmzl9f4nrvf2cirxy52j1snv10d80ypgq91lh91m"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest))
      (propagated-inputs (list ros-noetic-rospy
                               ros-noetic-joint-state-publisher
                               ros-noetic-python-qt-binding))
      (arguments
       (list
        #:package-dir "joint_state_publisher_gui"))
      (home-page "https://wiki.ros.org/joint_state_publisher_gui")
      (synopsis
       "GUI tool for setting and publishing joint state values for a given URDF")
      (description
       "GUI tool for setting and publishing joint state values for a URDF")
      (license license:bsd-3))))

(define-public ros-noetic-urdf-parser-plugin
  (let ((commit "b3fa398ae267b577b33f5d8bd04694fd3a068d98")
        (revision "0"))
    (package
      (name "ros-noetic-urdf-parser-plugin")
      (version (git-version "1.13.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/urdf")
               (commit commit)))
         (sha256
          (base32 "0kwmg01h82qxg0l4sz31llihi94iaivgzmgpgs7rypli26931smj"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (arguments
       (list
        #:package-dir "urdf_parser_plugin"))
      (propagated-inputs (list urdfdom urdfdom-headers))
      (home-page "https://wiki.ros.org/urdf_parser_plugin")
      (synopsis "C++ base class for URDF parsers")
      (description "A C++ base class for URDF parsers.")
      (license license:bsd-3))))

(define-public ros-noetic-urdf
  (let ((commit "b3fa398ae267b577b33f5d8bd04694fd3a068d98")
        (revision "0"))
    (package
      (name "ros-noetic-urdf")
      (version (git-version "1.13.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/urdf")
               (commit commit)))
         (sha256
          (base32 "0kwmg01h82qxg0l4sz31llihi94iaivgzmgpgs7rypli26931smj"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (arguments
       (list
        #:package-dir "urdf"))
      (native-inputs (list ros-noetic-cmake-modules
                           ros-noetic-urdf-parser-plugin ros-noetic-rostest))
      (propagated-inputs (list urdfdom
                               urdfdom-headers
                               ros-noetic-rosconsole-bridge
                               ros-noetic-roscpp
                               ros-noetic-pluginlib
                               tinyxml
                               tinyxml2))
      (home-page "https://wiki.ros.org/urdf")
      (synopsis "C++ URDF parser")
      (description
       "This package contains a C++ parser for the Unified Robot Description
Format (URDF), which is an XML format for representing a robot model.
The code API of the parser has been through our review process and will remain
backwards compatible in future releases.")
      (license license:bsd-3))))

(define-public ros-noetic-urdfdom-py
  (let ((commit "3bcb9051e3bc6ebb8bff0bf8dd2c2281522b05d9")
        (revision "0"))
    (package
      (name "ros-noetic-urdfdom-py")
      (version (git-version "0.4.6" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/urdf_parser_py")
               (commit commit)))
         (sha256
          (base32 "19gr7im61c8nc0as4n5ipdqrvp49rf7kyz6ny87yi3iai2418kwa"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list python-mock))
      (propagated-inputs (list ros-noetic-rospy python-pyyaml))
      (home-page "https://wiki.ros.org/urdfdom_py")
      (synopsis "Python URDF parser")
      (description "Python URDF Parser")
      (license license:bsd-3))))

(define-public ros-noetic-kdl-parser
  (let ((commit "74d4ee3bc6938de8ae40a700997baef06114ea1b")
        (revision "0"))
    (package
      (name "ros-noetic-kdl-parser")
      (version (git-version "1.14.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/kdl_parser")
               (commit commit)))
         (sha256
          (base32 "04wmbgkfig541xn2pvni9s0dy5fz5xff8c2zc7sw1yrvinca06pz"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-cmake-modules ros-noetic-roscpp
                           ros-noetic-rostest))
      (inputs (list ros-noetic-rosconsole))
      (propagated-inputs (list urdfdom-headers tinyxml tinyxml2
                               ros-noetic-urdf orocos-kdl))
      (arguments
       (list
        #:package-dir "kdl_parser"))
      (home-page "https://wiki.ros.org/kdl_parser")
      (synopsis "Construct a KDL tree from a URDF")
      (description
       "The Kinematics and Dynamics Library (KDL) defines a tree structure
to represent the kinematic and dynamic parameters of a robot
mechanism.  kdl_parser provides tools to construct a KDL
tree from an XML robot representation in URDF.")
      (license license:bsd-3))))
