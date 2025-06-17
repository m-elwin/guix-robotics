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

(define-module (ros-noetic qt-gui-core)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system catkin)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (gnu packages graphviz)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages xml)
  #:use-module (ros-noetic bootstrap)
  #:use-module (ros-noetic ros)
  #:use-module (ros-noetic ros-core)
  #:use-module (ros-noetic ros-visualization)
  #:use-module (ros-noetic system))

;;; Commentary:
;;;
;;;
;;; Packages for the qt-gui-core metapackage
;;; All packages here should be on the same version
;;;
;;; Code:

(define-public ros-noetic-qt-gui
  (let ((commit "02e7378a17006961638f2ab01f58da1595bbd879")
        (revision "0"))
    (package
      (name "ros-noetic-qt-gui")
      (version (git-version "0.4.5" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/qt_gui_core")
               (commit commit)))
         (sha256
          (base32 "07sml01pbyq23xjcq521jlh16q6vrzin097bc76aw9xs1ds50c96"))
         (file-name (git-file-name name version))))
    (build-system catkin-build-system)
    (propagated-inputs (list python-rospkg))
    (arguments (list
                #:package-dir "qt_gui"))
    (home-page "https://wiki.ros.org/qt_gui")
    (synopsis "Infrastructure for integrated GUIs based on Qt")
    (description "Extensible framework with Python and C++ plugins
(implemented in separate packages) which can contribute arbitrary widgets.
Requires PyQt or PySide bindings.")
    (license license:bsd-3))))

(define-public ros-noetic-qt-gui-cpp
  (let ((commit "02e7378a17006961638f2ab01f58da1595bbd879")
        (revision "0"))
    (package
      (name "ros-noetic-qt-gui-cpp")
      (version (git-version "0.4.5" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/qt_gui_core")
               (commit commit)))
         (sha256
          (base32 "07sml01pbyq23xjcq521jlh16q6vrzin097bc76aw9xs1ds50c96"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-cmake-modules))
      (propagated-inputs (list ros-noetic-pluginlib
                               ros-noetic-qt-gui
                               ros-noetic-python-qt-binding
                               qtbase-5
                               tinyxml))
      (arguments (list
                  #:package-dir "qt_gui_cpp"))
      (home-page "https://wiki.ros.org/qt_gui_cpp")
      (synopsis "C++ bindings for qt_gui")
      (description "Creates bindings for every
generator available. At least one specific binding must be available
in order to use C++ plugins.")
      (license license:bsd-3))))

(define-public ros-noetic-qt-gui-py-common
  (let ((commit "02e7378a17006961638f2ab01f58da1595bbd879")
        (revision "0"))
    (package
      (name "ros-noetic-qt-gui-py-common")
      (version (git-version "0.4.5" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/qt_gui_core")
               (commit commit)))
         (sha256
          (base32 "07sml01pbyq23xjcq521jlh16q6vrzin097bc76aw9xs1ds50c96"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list python-rospkg))
      (arguments
       (list
        #:package-dir "qt_gui_py_common"))
      (home-page "https://wiki.ros.org/qt_gui_py_common")
      (synopsis "Common functionality for GUI plugins written in Python")
      (description "Common functionality for GUI plugins written in Python.")
      (license license:bsd-3))))

(define-public ros-noetic-qt-gui-app
  (let ((commit "02e7378a17006961638f2ab01f58da1595bbd879")
        (revision "0"))
    (package
      (name "ros-noetic-qt-gui-app")
      (version (git-version "0.4.5" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/qt_gui_core")
               (commit commit)))
         (sha256
          (base32 "07sml01pbyq23xjcq521jlh16q6vrzin097bc76aw9xs1ds50c96"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-qt-gui))
      (arguments
       (list
        #:package-dir "qt_gui_app"))
      (home-page "https://wiki.ros.org/qt_gui_app")
      (synopsis
       "Provides the main() to start an interface providided by qt_gui")
      (description
       "Provides the main() to start an interface provided by qt_gui.")
      (license license:bsd-3))))

(define-public ros-noetic-qt-dotgraph
  (let ((commit "02e7378a17006961638f2ab01f58da1595bbd879")
        (revision "0"))
    (package
      (name "ros-noetic-qt-dotgraph")
      (version (git-version "0.4.5" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/qt_gui_core")
               (commit commit)))
         (sha256
          (base32 "07sml01pbyq23xjcq521jlh16q6vrzin097bc76aw9xs1ds50c96"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list python-pygraphviz))
      (propagated-inputs (list python-pydot-noetic))
      (arguments
       (list
        #:package-dir "qt_dotgraph"))
      (home-page "https://wiki.ros.org/qt_dotgraph")
      (synopsis "Helpers to work with dot graphs")
      (description "Helpers to work with dot graphs.")
      (license license:bsd-3))))

(define-public ros-noetic-qt-gui-core
  (let ((commit "02e7378a17006961638f2ab01f58da1595bbd879")
        (revision "0"))
    (package
      (name "ros-noetic-qt-gui-core")
      (version (git-version "0.4.5" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/qt_gui_core")
               (commit commit)))
         (sha256
          (base32 "07sml01pbyq23xjcq521jlh16q6vrzin097bc76aw9xs1ds50c96"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-qt-dotgraph ros-noetic-qt-gui
                               ros-noetic-qt-gui-app ros-noetic-qt-gui-cpp
                               ros-noetic-qt-gui-py-common))
      (arguments
       (list
        #:package-dir "qt_gui_core"))
      (home-page "https://wiki.ros.org/qt_gui_core")
      (synopsis "Integration of ROS and Qt")
      (description
       "Integration of ROS package system and ROS-specific plugins for Qt GUIs.")
      (license license:bsd-3))))
