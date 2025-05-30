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

(define-module (ros-noetic ros)
  #:use-module (guix build-system catkin)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages xml)
  #:use-module (contributed)
  #:use-module (ros-noetic core)
  #:use-module (ros-noetic roscpp-core)
  #:use-module (ros-noetic bootstrap))

;; Commentary:
;;
;; Packages that are part of the ros repository and a few associated
;; fundamental packages that depend both on these packages and packages in core.
;;
;; Code:

;; ROS_ROOT is an old ROS environment variable that is still used in some cases
(define ros-root-search-path
  (search-path-specification (variable "ROS_ROOT") (files (list "share/ros"))))

(define-public ros-noetic-rosbuild
  (let ((commit "f143ced5be791fd844e697fd5bf6b8d0a1f633e0")
        (revision "0"))
    (package
      (name "ros-noetic-rosbuild")
      (version (git-version "1.15.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/ros")
               (commit commit)))
         (sha256
          (base32 "035w9l1d2z5f5bvry8mgdakg60j67sc27npgn0k4f773588q2p37"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list pkg-config ros-noetic-message-generation))
      (propagated-inputs (list ros-noetic-message-runtime))
      (native-search-paths
       (list ros-root-search-path))
      (arguments
       (list
        #:package-dir "core/rosbuild"))
      (home-page "https://wiki.ros.org/rosbuild")
      (synopsis "Scripts for managing CMake-based build system for ROS")
      (description
       "This is the build-tool that existed before catkin,
it is still needed for roslaunch for some reason.")
      (license license:bsd-3))))

(define-public ros-noetic-roslang
  (let ((commit "f143ced5be791fd844e697fd5bf6b8d0a1f633e0")
        (revision "0"))
    (package
      (name "ros-noetic-roslang")
      (version (git-version "1.15.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/ros")
               (commit commit)))
         (sha256
          (base32 "035w9l1d2z5f5bvry8mgdakg60j67sc27npgn0k4f773588q2p37"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list pkg-config ros-noetic-message-generation))
      (arguments
       (list
        #:package-dir "core/roslang"))
      (home-page "https://wiki.ros.org/roslang")
      (synopsis "Common package that all client libraries depend on")
      (description "Mainly used to find client libraries
(via 'rospack depends-on1 roslang').")
      (license license:bsd-3))))

(define-public ros-noetic-rosmake
  (let ((commit "f143ced5be791fd844e697fd5bf6b8d0a1f633e0")
        (revision "0"))
    (package
      (name "ros-noetic-rosmake")
      (version (git-version "1.15.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/ros")
               (commit commit)))
         (sha256
          (base32 "035w9l1d2z5f5bvry8mgdakg60j67sc27npgn0k4f773588q2p37"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list python-rospkg))
      (arguments
       (list
        #:package-dir "tools/rosmake"
        #:phases
        #~(modify-phases %standard-phases
            ;; go to the directory for the ros package
            (add-after 'unpack 'patch-tests
              (lambda _
                ;; specify the full path to rosmake so Popen can find it
                (substitute* "test/test_rosmake_commandline.py"
                  (("'rosmake',")
                   (string-append "'"
                                  (getcwd) "/../build/devel/bin/rosmake',"))))))))
      (home-page "https://wiki.ros.org/rosmake")
      (synopsis "Legacy ROS build tool")
      (description
       "Outdated tool that can build all ros dependencies in the correct order.")
      (license license:bsd-3))))

(define-public ros-noetic-mk
  (let ((commit "f143ced5be791fd844e697fd5bf6b8d0a1f633e0")
        (revision "0"))
    (package
      (name "ros-noetic-mk")
      (version (git-version "1.15.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/ros")
               (commit commit)))
         (sha256
          (base32 "035w9l1d2z5f5bvry8mgdakg60j67sc27npgn0k4f773588q2p37"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-rosbuild ros-noetic-rosmake))
      (arguments
       (list
        #:package-dir "core/mk"))
      (home-page "https://wiki.ros.org/mk")
      (synopsis "Some .mk include files for building ROS architecture")
      (description
       "Most package authors should use cmake .mk,
which calls CMake for the build of the package.
The other files in this package are intended for use in exotic situations
that mostly arise when importing 3rdparty code.")
      (license license:bsd-3))))

(define-public ros-noetic-roslib
  (let ((commit "f143ced5be791fd844e697fd5bf6b8d0a1f633e0")
        (revision "0"))
    (package
      (name "ros-noetic-roslib")
      (version (git-version "1.15.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/ros")
               (commit commit)))
         (sha256
          (base32 "035w9l1d2z5f5bvry8mgdakg60j67sc27npgn0k4f773588q2p37"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list boost ros-noetic-rosmake))
      (propagated-inputs (list ros-noetic-rospack ros-noetic-ros-environment
                               python-rospkg))
      (arguments
       (list
        #:package-dir "core/roslib"))
      (home-page "https://wiki.ros.org/roslib")
      (synopsis "Base dependencies and support libraries for ROS")
      (description "Contains many of the common data structures and tools that
are shared across ROS client library implementations")
      (license license:bsd-3))))

(define-public ros-noetic-rosbash
  (let ((commit "f143ced5be791fd844e697fd5bf6b8d0a1f633e0")
        (revision "0"))
    (package
      (name "ros-noetic-rosbash")
      (version (git-version "1.15.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/ros")
               (commit commit)))
         (sha256
          (base32 "035w9l1d2z5f5bvry8mgdakg60j67sc27npgn0k4f773588q2p37"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-rospack))
      (arguments
       (list
        #:package-dir "tools/rosbash"))
      (home-page "https://wiki.ros.org/rosbash")
      (synopsis "Assorted shell commands for using ros with bash")
      (description "Assorted shell commands for using ros with bash.")
      (license license:bsd-3))))


(define-public ros-noetic-rosboost-cfg
  (let ((commit "f143ced5be791fd844e697fd5bf6b8d0a1f633e0")
        (revision "0"))
    (package
      (name "ros-noetic-rosboost-cfg")
      (version (git-version "1.15.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/ros")
               (commit commit)))
         (sha256
          (base32 "035w9l1d2z5f5bvry8mgdakg60j67sc27npgn0k4f773588q2p37"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (arguments
       (list
        #:package-dir "tools/rosboost_cfg"))
      (home-page "https://wiki.ros.org/rosboost_cfg")
      (synopsis
       "Used by the rosboost-cfg tool for determining cflgags/iflags of boost")
      (description "Used by the rosboost-cfg tool for
determining cflgags/iflags etc. of boost on your system")
      (license license:bsd-3))))


(define-public ros-noetic-rosclean
  (let ((commit "f143ced5be791fd844e697fd5bf6b8d0a1f633e0")
        (revision "0"))
    (package
      (name "ros-noetic-rosclean")
      (version (git-version "1.15.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/ros")
               (commit commit)))
         (sha256
          (base32 "035w9l1d2z5f5bvry8mgdakg60j67sc27npgn0k4f773588q2p37"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (inputs (list bash-minimal))
      (propagated-inputs (list python-rospkg))
      (arguments
       (list
        #:package-dir "tools/rosclean"
        #:phases
        #~(modify-phases %standard-phases
            (add-after 'wrap 'wrap-script
              (lambda _
                (wrap-program (string-append #$output "/bin/rosclean")
                  `("PATH" ":" prefix
                    ,(list (string-append #$coreutils "/bin")))))))))
      (home-page "https://wiki.ros.org/rosclean")
      (synopsis "Cleanup file system resources (e.g. log files)")
      (description "Cleanup file system resources (e.g. log files).")
      (license license:bsd-3))))

(define-public ros-noetic-roscreate
  (let ((commit "f143ced5be791fd844e697fd5bf6b8d0a1f633e0")
        (revision "0"))
    (package
      (name "ros-noetic-roscreate")
      (version (git-version "1.15.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/ros")
               (commit commit)))
         (sha256
          (base32 "035w9l1d2z5f5bvry8mgdakg60j67sc27npgn0k4f773588q2p37"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-roslib python-rospkg))
      (arguments
       (list
        #:package-dir "tools/roscreate"))
      (home-page "https://wiki.ros.org/roscreate")
      (synopsis "Tool taht assists in creating ROS filesystem resources")
      (description
       "It provides roscreate-pkg, which creates a new package
directory, including the appropriate build and manifest files.")
      (license license:bsd-3))))

(define-public ros-noetic-rosunit
  (let ((commit "f143ced5be791fd844e697fd5bf6b8d0a1f633e0")
        (revision "0"))
    (package
      (name "ros-noetic-rosunit")
      (version (git-version "1.15.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/ros")
               (commit commit)))
         (sha256
          (base32 "035w9l1d2z5f5bvry8mgdakg60j67sc27npgn0k4f773588q2p37"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-roslib))
      (arguments
       (list
        #:package-dir "tools/rosunit"))
      (home-page "https://wiki.ros.org/rosunit")
      (synopsis "Unit-testing package for ROS")
      (description "Lower-level library for rostest that handles
unit tests, whereas rostest handles integration tests.")
      (license license:bsd-3))))

(define-public ros-noetic-ros
  (let ((commit "f143ced5be791fd844e697fd5bf6b8d0a1f633e0")
        (revision "0"))
    (package
      (name "ros-noetic-ros")
      (version (git-version "1.15.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/ros")
               (commit commit)))
         (sha256
          (base32 "035w9l1d2z5f5bvry8mgdakg60j67sc27npgn0k4f773588q2p37"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list catkin
                               ros-noetic-mk
                               ros-noetic-rosbuild
                               ros-noetic-roslang
                               ros-noetic-roslib
                               ros-noetic-rosbash
                               ros-noetic-rosboost-cfg
                               ros-noetic-rosclean
                               ros-noetic-roscreate
                               ros-noetic-rosmake
                               ros-noetic-rosunit))
      (arguments
       (list
        #:package-dir "ros"))
      (home-page "https://wiki.ros.org/ros")
      (synopsis "ROS Packaging System")
      (description "ROS Packaging System")
      (license license:bsd-3))))

(define-public ros-noetic-rosconsole
  (let ((commit "44ad0b1f0eccc7f5abd14144e4fe5f74f85592d6")
        (revision "0"))
    (package
      (name "ros-noetic-rosconsole")
      (version (git-version "1.14.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/rosconsole")
               (commit commit)))
         (sha256
          (base32 "0dgxs7x9f8gbigvnbnkn2j066fzlz38avk28av90214bc0ny27yv"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rosunit))
      (inputs (list ros-noetic-rosbuild))
      (propagated-inputs (list boost log4cxx-noetic ros-noetic-cpp-common
                               ros-noetic-rostime))
      (home-page "https://wiki.ros.org/rosconsole")
      (synopsis "ROS console output library")
      (description "ROS console output library.")
      (license license:bsd-3))))

(define-public ros-noetic-pluginlib
  (let ((commit "8d4bf7e4fab132d6b7d894d446631a9161f2afec")
        (revision "0"))
    (package
      (name "ros-noetic-pluginlib")
      (version (git-version "1.13.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/pluginlib")
               (commit commit)))
         (sha256
          (base32 "133bxdlw4ggsicyzql82hmvfji8lpd60qj2cqrvci3bfc1nr2j7z"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-cmake-modules))
      (propagated-inputs (list boost ros-noetic-class-loader
                               ros-noetic-rosconsole ros-noetic-roslib
                               tinyxml2))
      (arguments
       (list
        #:package-dir "pluginlib"))
      (home-page "https://wiki.ros.org/pluginlib")
      (synopsis
       "Write and dynamically load plugins using the ROS build infrastructure")
      (description "These tools require plugin providers to register
their plugins in the package.xml of their package.")
      (license license:bsd-3))))


(define-public ros-noetic-rosconsole-bridge
  (let ((commit "ba01216e44b3f70cb1166b5b2d292ba594718205")
        (revision "0"))
    (package
      (name "ros-noetic-rosconsole-bridge")
      (version (git-version "0.5.5" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/rosconsole_bridge")
                             (commit commit)))
         (sha256
          (base32 "13pjbfscx6cwr8fkdh8fq4ga1kbmdyf6sjzcyvpbwdycz70y4fgc"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs
       (list ros-noetic-cpp-common
             console-bridge
             ros-noetic-rosconsole))
      (home-page "http://wiki.ros.org/rosconsole_bridge")
      (synopsis "Connects console_bridge-based logging to rosconsole-logging")
      (description "Used in conjunction with consoel_bridge and rosconsole to
connect console_bridge-based logging to rosconsole-logging.")
      (license license:bsd-3))))
