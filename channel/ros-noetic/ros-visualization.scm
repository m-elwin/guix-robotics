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
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages xml)
  #:use-module (ros-noetic bootstrap)
  #:use-module (ros-noetic ros)
  #:use-module (ros-noetic ros-core)
  #:use-module (guix build-system catkin))

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
