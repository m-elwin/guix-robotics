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
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages check)
  #:use-module (gnu packages cpp)
  #:use-module (gnu packages engineering)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages xml)
  #:use-module (ros-noetic bootstrap)
  #:use-module (ros-noetic common-msgs)
  #:use-module (ros-noetic geometry2)
  #:use-module (ros-noetic ros)
  #:use-module (ros-noetic ros-comm)
  #:use-module (ros-noetic ros-core)
  #:use-module (ros-noetic roscpp-core)
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
                               ros-noetic-urdf orocos-kinematics-dynamics))
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

(define-public ros-noetic-robot-state-publisher
  (let ((commit "85ed2140a0966f492a038d47f222f593047760c3")
        (revision "0"))
    (package
      (name "ros-noetic-robot-state-publisher")
      (version (git-version "1.15.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/robot_state_publisher")
               (commit commit)))
         (sha256
          (base32 "0vqyyblawdf0qw4r6ccq5fsi2hm19ik6bvyy8s86qbq5q1pc0ycr"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest ros-noetic-rosbag))
      (inputs (list ros-noetic-tf2-kdl ros-noetic-kdl-parser
                    ros-noetic-rostime))
      (propagated-inputs (list ros-noetic-roscpp ros-noetic-sensor-msgs
                               ros-noetic-tf2-ros orocos-kinematics-dynamics))
      (home-page "https://wiki.ros.org/robot_state_publisher")
      (synopsis "Publish the state of a robot to tf2")
      (description
       "Allows you to publish the state of a robot to
tf2.  Once the state gets published, it is available to all
components in the system that also use tf2.  The package takes the
joint angles of the robot as input and publishes the 3D poses
of the robot links, using a kinematic tree model of the robot.
The package can both be used as a library and as a ROS node.
This package has been well tested and the code is stable.
No major changes are planned in the near future.")
      (license license:bsd-3))))

(define-public ros-noetic-roslint
  (let ((commit "d6bb658e53cac6a911c9fef149d759553133dc8f")
        (revision "0"))
    (package
      (name "ros-noetic-roslint")
      (version (git-version "1.14.20" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/roslint")
               (commit commit)))
         (sha256
          (base32 "1g9hgw3772cr5sa0lg9fxy2slbjf8i9m7f75316nlm89bzz95yij"))
         (file-name (git-file-name name version))
         (modules '((guix build utils)))
         ;; cannot access /dev/stderr in build container, use
         ;; an alternative shell method of redirecting to stderr
         (snippet '(substitute* "scripts/test_wrapper"
                     (("tee /dev/stderr")
                      "tee >(cat >&2)")))))
      (build-system catkin-build-system)
      (propagated-inputs (list python-pylint cpplint))
      (home-page "https://wiki.ros.org/roslint")
      (synopsis "CMake lint commands for ROS packages")
      (description "The lint command performs static checking of Python
or C++ source code for errors and standards compliance.")
      (license license:bsd-3))))

(define-public ros-noetic-xacro
  (let ((commit "d3265d04a991b4ad8b645022f06326b6fa7b9df3")
        (revision "0"))
    (package
      (name "ros-noetic-xacro")
      (version (git-version "1.14.20" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/xacro")
               (commit commit)))
         (sha256
          (base32 "0jfzadf46qi88ms3h5d7xwvravnraajbrn8qyfl690crjz7f245x"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest ros-noetic-roslint))
      (propagated-inputs (list ros-noetic-roslaunch))
      (arguments
       (list
        #:phases
        #~(modify-phases %standard-phases
            (add-after 'unpack 'patch-tests
              (lambda _
                ;; specify the full path to xacro so Popen can find it
                (substitute* "test/test_xacro.py"
                  (("call\\(\\['xacro'")
                   (string-append "call(['"
                                  (getcwd) "/../build/devel/bin/xacro'"))))))))
      (home-page "https://wiki.ros.org/xacro")
      (synopsis "XML macro language")
      (description
       "XML macro language. With xacro, you can construct shorter
and more readable XML files by using macros that expand to larger
XML expressions.  Useful for creating URDFs.")
      (license license:bsd-3))))
