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

(define-module (ros-noetic rqt)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system catkin)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (ros-noetic bootstrap)
  #:use-module (ros-noetic ros)
  #:use-module (ros-noetic ros-base)
  #:use-module (ros-noetic ros-comm)
  #:use-module (ros-noetic ros-core)
  #:use-module (ros-noetic nodelet-core)
  #:use-module (ros-noetic qt-gui-core)
  #:use-module (ros-noetic ros-visualization))

;;; Commentary:
;;;
;;;
;;; Packages related to rqt, the ROS qt framework
;;;
;;; Code:


(define-public ros-noetic-rqt-gui
  (let ((commit "c532cc7fe06318f0277caedc4be866dada63160f")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-gui")
      (version (git-version "0.5.5" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt")
               (commit commit)))
         (sha256
          (base32 "0iwspznn0dmjhf0lbv7snjj17gadrmmzsbvp21sjpmjfimznifl9"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-qt-gui ros-noetic-rospy
                               python-rospkg ros-noetic-python-qt-binding))
      (arguments
       (list
        #:package-dir "rqt_gui"))
      (home-page "https://wiki.ros.org/rqt_gui")
      (synopsis "Main() to start an instance of ROS qt interface")
      (description "Main() to start an instance of ROS qt interface.")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-gui-cpp
  (let ((commit "c532cc7fe06318f0277caedc4be866dada63160f")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-gui-cpp")
      (version (git-version "0.5.5" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt")
               (commit commit)))
         (sha256
          (base32 "0iwspznn0dmjhf0lbv7snjj17gadrmmzsbvp21sjpmjfimznifl9"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-qt-gui ros-noetic-qt-gui-cpp catkin
                               ros-noetic-roscpp ros-noetic-nodelet))
      (arguments
       (list
        #:package-dir "rqt_gui_cpp"))
      (home-page "https://wiki.ros.org/rqt_gui_cpp")
      (synopsis "Enables GUI plugins to use the ROS C++ client library")
      (description "Enables GUI plugins to use the ROS C++ client library.")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-py-common
  (let ((commit "c532cc7fe06318f0277caedc4be866dada63160f")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-py-common")
      (version (git-version "0.5.5" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt")
               (commit commit)))
         (sha256
          (base32 "0iwspznn0dmjhf0lbv7snjj17gadrmmzsbvp21sjpmjfimznifl9"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-genmsg ros-noetic-std-msgs))
      (propagated-inputs (list ros-noetic-genpy
                               ros-noetic-python-qt-binding
                               ros-noetic-qt-gui
                               ros-noetic-roslib
                               ros-noetic-rospy
                               ros-noetic-rostopic
                               ros-noetic-actionlib
                               ros-noetic-rosbag))
      (arguments
       (list
        #:package-dir "rqt_py_common"))
      (home-page "https://wiki.ros.org/rqt_py_common")
      (synopsis "Common functionality for rqt plugins written in Python")
      (description
       "Common functionality for rqt plugins written in Python.
Despite no plugin is provided, this package is part of the rqt_common_plugins
repository to keep refactoring generic functionality from these common plugins
into this package as easy as possible.

Functionality included in this package should cover generic ROS concepts and
should not introduce any special dependencies beside ros_base.")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-gui-py
  (let ((commit "c532cc7fe06318f0277caedc4be866dada63160f")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-gui-py")
      (version (git-version "0.5.5" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt")
               (commit commit)))
         (sha256
          (base32 "0iwspznn0dmjhf0lbv7snjj17gadrmmzsbvp21sjpmjfimznifl9"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-qt-gui ros-noetic-rqt-gui
                               ros-noetic-rospy))
      (arguments
       (list
        #:package-dir "rqt_gui_py"))
      (home-page "https://wiki.ros.org/rqt_gui_py")
      (synopsis "Enables GUI plugins to use the ROS Python client library")
      (description "Enables GUI plugins to use the ROS Python client library.")
      (license license:bsd-3))))

(define-public ros-noetic-rqt
  (let ((commit "c532cc7fe06318f0277caedc4be866dada63160f")
        (revision "0"))
    (package
      (name "ros-noetic-rqt")
      (version (git-version "0.5.5" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt")
               (commit commit)))
         (sha256
          (base32 "0iwspznn0dmjhf0lbv7snjj17gadrmmzsbvp21sjpmjfimznifl9"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-rqt-gui ros-noetic-rqt-gui-cpp
                               ros-noetic-rqt-gui-py))
      (arguments
       (list
        #:package-dir "rqt"))
      (home-page "https://wiki.ros.org/rqt")
      (synopsis "Qt-based framework for GUI development with ROS")
      (description
       "Qt-based framework for GUI development with ROS.
It consists of three parts:
rqt - provides a widget for rqt_gui which enables multiple rqt widgets to
dock in a single window.
rqt_common_plugins -
 ROS backend tools that can be used at robot runtime.
rqt_robot_plugins - Tools for interacting with robots during runtime.")
      (license license:bsd-3))))
