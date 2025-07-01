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

(define-module (ros-noetic ros-visualization)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system catkin)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages graphics)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages xml)
  #:use-module (ros-noetic common-msgs)
  #:use-module (ros-noetic geometry2)
  #:use-module (ros-noetic navigation-msgs)
  #:use-module (ros-noetic ros-core)
  #:use-module (ros-noetic ros-comm)
  #:use-module (ros-noetic ros-perception)
  #:use-module (ros-noetic image-common)
  #:use-module (ros-noetic robot)
  #:use-module (ros-noetic ros))

;;; Commentary:
;;;
;;;
;;; Packages related to visualization in ROS.
;;; Includes GUI code, plotting code, and RVIZ
;;;
;;; Code:

(define-public ros-noetic-python-qt-binding
  (let ((commit "2daadd0830740770690c3d07767bb3e75967ffc5")
        (revision "0"))
    (package
      (name "ros-noetic-python-qt-binding")
      (version (git-version "0.4.6" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/python_qt_binding")
               (commit commit)))
         (sha256
          (base32 "0jzfs521v82jfhwsnk421y0fa2k4m8qxhvrq6k7dn48pgalqi7cj"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rosbuild))
      (propagated-inputs (list python-pyside-2 python-pyqt5-sip))
      (home-page "https://wiki.ros.org/python_qt_binding")
      (synopsis "Python bindings for Qt from either pyside or pyqt")
      (description
       "This stack provides Python bindings for Qt.
There are two providers: pyside and pyqt.  PySide is released under
the LGPL.  PyQt is released under the GPL.

Both the bindings and tools to build bindings are included from each
available provider.  For PySide, it is called \"Shiboken\".
For PyQt,this is called \"SIP\".

Also provided is adapter code to make the user's Python code
independent of which binding provider was actually used which makes
it very easy to switch between these.")
      (license license:bsd-3))))


(define-public ros-noetic-interactive-markers
  (let ((commit "51e6b1c83c376affacad897fa9c6f723ea2c6cd5")
        (revision "0"))
    (package
      (name "ros-noetic-interactive-markers")
      (version (git-version "1.12.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/interactive_markers")
               (commit commit)))
         (sha256
          (base32 "1by0m41rq67lflv0md1cvsy0svknawj08bvpm97r2i3qjd73zz73"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest))
      (propagated-inputs (list ros-noetic-rosconsole
                               ros-noetic-roscpp
                               ros-noetic-rospy
                               ros-noetic-std-msgs
                               ros-noetic-tf2-ros
                               ros-noetic-tf2-geometry-msgs
                               ros-noetic-visualization-msgs))
      (home-page "https://wiki.ros.org/interactive_markers")
      (synopsis
       "3D interactive marker communication library for Rviz and similar tools")
      (description
       "3D interactive marker communication library for Rviz and similar tools")
      (license license:bsd-3))))

(define-public ros-noetic-rviz
  (let ((commit "c4964de840d97b1377456a2054662551816b0a54")
        (revision "0"))
    (package
      (name "ros-noetic-rviz")
      (version (git-version "1.14.26" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rviz")
               (commit commit)))
         (sha256
          (base32 "0jzfs521v82jfhwsnk421y0fa2k4m8qxhvrq6k7dn48pgalqi7cj"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-cmake-modules
                           ros-noetic-rosunit
                           ros-noetic-rostest))
      (propagated-inputs (list assimp
                               ros-noetic-geometry-msgs
                               ros-noetic-image-transport
                               ros-noetic-interactive-markers
                               ros-noetic-laser-geometry
                               ogre
                               ros-noetic-map-msgs
                               ros-noetic-message-filters
                               ros-noetic-nav-msgs
                               ros-noetic-pluginlib
                               ros-noetic-python-qt-binding
                               ros-noetic-resource-retriever
                               ros-noetic-rosconsole
                               ros-noetic-roscpp
                               ros-noetic-roslib
                               ros-noetic-rospy
                               ros-noetic-sensor-msgs
                               ros-noetic-std-msgs
                               ros-noetic-std-srvs
                               ros-noetic-tf2-ros
                               ros-noetic-tf2-geometry-msgs
                               tinyxml2
                               ros-noetic-urdf
                               ros-noetic-visualization-msgs
                               yaml-cpp
                               mesa
                               ros-noetic-message-runtime
                               ros-noetic-media-export
                               ros-noetic-qt5base))
      (home-page "https://wiki.ros.org/rviz")
      (synopsis "3D visualization tool for ROS")
      (description "3D Visualization tool for ROS.")
      (license license:bsd-3))))
