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
  #:use-module (gnu packages graphviz)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages xml)
  #:use-module (ros-noetic bootstrap)
  #:use-module (ros-noetic ros)
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
      (propagated-inputs (list ros-noetic-qt-gui
                               ros-noetic-rospy
                               python-rospkg
                               ros-noetic-python-qt-binding))
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
      (propagated-inputs (list ros-noetic-qt-gui
                               ros-noetic-qt-gui-cpp
                               ros-noetic-roscpp
                               ros-noetic-nodelet))
      (arguments
       (list
        #:package-dir "rqt_gui_cpp"))
      (home-page "https://wiki.ros.org/rqt_gui_cpp")
      (synopsis "Enables GUI plugins to use the ROS C++ client library")
      (description "Enables GUI plugins to use the ROS C++ client library.")
      (license license:bsd-3))))
