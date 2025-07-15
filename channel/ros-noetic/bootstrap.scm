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

(define-module (ros-noetic bootstrap)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system pyproject)
  #:use-module (guix build-system python)
  #:use-module (guix git-download)
  #:use-module (guix search-paths)
  #:use-module (guix gexp)
  #:use-module (gnu packages)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages certs)
  #:use-module (gnu packages check)
  #:use-module (gnu packages time)
  #:use-module (gnu packages xml))

;; Commentary:
;;
;; "Bootstrap" dependencies needed to build ROS noetic from source
;; See https://wiki.ros.org/noetic/Installation/Source#Installing_bootstrap_dependencies <Accessed 5/23/2025>
;; These are system dependencies but maintained by ROS developers, and do need catkin.
;;
;; Code:

(define-public console-bridge
  (let ((commit "0828d846f2d4940b4e2b5075c6c724991d0cd308")
        (revision "0"))
    (package
      (name "console-bridge")
      (version (git-version "1.0.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/console_bridge")
               (commit commit)))
         (sha256
          (base32 "18rjjzkg1ml2p4aa41kvfgamkxc88g0iv3fd94vxr8917mqshw9k"))
         (file-name (git-file-name name version))))
      (build-system cmake-build-system)
      (arguments
       (list
        #:configure-flags
        #~(list "-DBUILD_TESTING=ON")))
      (native-inputs (list python))
      (home-page "https://github.com/ros/console_bridge")
      (synopsis "ROS-independent pure CMake package for logging")
      (description
       "Provides logging calls that mirror those found in rosconsole,
but for applications that are not necessarily using ROS")
      (license license:bsd-3))))

(define-public python-catkin-pkg
  (let ((commit "fb2468e6c2565802bc3ef6134a76db76ae9f3632")
        (revision "2"))
    (package
      (name "python-catkin-pkg")
      (version (git-version "1.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-infrastructure/catkin_pkg")
               (commit commit)))
         (sha256
          (base32 "0m5w3fq8gwh2kb08yvdy37sxrc8s490vab5r66sv6h2x9y20lxcl"))
         (file-name (git-file-name name version))))
      (build-system pyproject-build-system)
      (propagated-inputs (list python-pyparsing
                               python-dateutil
                               python-setuptools))
      (native-inputs (list python-docutils
                           python-flake8
                           python-flake8-blind-except
                           python-flake8-builtins
                           python-flake8-class-newline
                           python-flake8-comprehensions
                           python-flake8-deprecated
                           python-flake8-docstrings
                           python-flake8-import-order
                           python-flake8-quotes
                           python-pytest
                           python-setuptools
                           python-wheel))
      (home-page "http://wiki.ros.org/catkin_pkg")
      (synopsis "Catkin package library")
      (description "Catkin package library.")
      (license license:bsd-3))))


(define-public rosinstall-generator
  (package
    (name "rosinstall-generator")
    (version "0.1.23")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "rosinstall_generator" version))
       (sha256
        (base32 "0w8sj3628m0q8d59d7ckjn8cam39pa2k22fv6gid3nh4izxydb95"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-catkin-pkg python-pyyaml python-rosdistro
                             python-rospkg python-docutils))
    (native-inputs (list python-distro python-mock python-pytest
                         python-setuptools python-wheel))
    (native-search-paths
     (list $SSL_CERT_DIR $SSL_CERT_FILE))
    (home-page "http://wiki.ros.org/rosinstall_generator")
    (synopsis "Generates rosinstall files for ROS distributions")
    (description
     "Provides a tool for generating rosinstall files.
These files are used to download source code archives for ROS distributions.")
    (license license:bsd-3)))

(define-public python-rospkg
  (let ((commit "db7614e5209137faa6ec01e2edaf34f775780b1a")
        (revision "1"))
    (package
      (name "python-rospkg")
      (version "1.6.0")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-infrastructure/rospkg")
               (commit commit)))
         (sha256
          (base32 "1v0f8g3sycb8rkb6xqkl3pbpxikfya72xfrzpa37hgvpx9ixsxza"))
         (file-name (git-file-name name version))))
      (build-system pyproject-build-system)
      (propagated-inputs (list python-catkin-pkg python-distro python-pyyaml))
      (native-inputs (list python-docutils python-pytest python-setuptools
                           python-wheel))
      (home-page "http://wiki.ros.org/rospkg")
      (synopsis "ROS package library")
      (description "ROS package library.")
      (license license:bsd-3))))

(define-public python-rosdistro
  (let ((commit "9c909bfb7f34e13e8229f1742b6493b228a3cfa9")
        (revision "1"))
    (package
      (name "python-rosdistro")
      (version (git-version "1.0.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-infrastructure/rosdistro")
               (commit commit)))
         (sha256
          (base32 "1g4h2grqqa4952zrr3kyp2d22f8karx2ygyjqkhv86i8dg6i0fqi"))
         (file-name (git-file-name name version))))
      (build-system pyproject-build-system)
      (arguments
       (list
        #:test-flags
        ;; test requires internet and is hard to mock
        #~(list "--ignore=test/test_manifest_providers.py")))
      (propagated-inputs (list python-catkin-pkg python-pyyaml python-rospkg
                               python-setuptools))
      (native-inputs (list python-docutils
                           python-distro
                           python-pytest
                           python-setuptools
                           python-wheel
                           git))
      (home-page "http://wiki.ros.org/rosdistro")
      (synopsis "Tool to work with rosdistro files")
      (description
       "This package provides a tool to work with rosdistro files.")
      (license license:bsd-3))))

(define-public python-rosdep
  (let ((commit "78f3744f9054ed188bc23b830854080dc9face70")
        (revision "1"))
    (package
      (name "python-rosdep")
      (version (git-version "0.25.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-infrastructure/rosdep")
               (commit commit)))
         (sha256
          (base32 "1n7fw73ikp02c8hxgg0vx3nl6zxdyxqy9lcl70162f3ss0lxkrl2"))
         (file-name (git-file-name name version))))
      (build-system pyproject-build-system)
      (arguments
       (list
        #:tests? #f ;too many tests that depend on environment
        #:phases
        #~(modify-phases %standard-phases
            (add-before 'check 'pre-check
              (lambda _
                (setenv "HOME" "/tmp"))))))
      (propagated-inputs (list python-catkin-pkg python-pyyaml
                               python-rosdistro python-rospkg python-distro))
      (native-inputs (list python-docutils
                           python-flake8
                           python-flake8-builtins
                           python-flake8-comprehensions
                           python-flake8-quotes
                           python-pytest
                           python-setuptools
                           python-wheel))
      (home-page "http://wiki.ros.org/rosdep")
      (synopsis "Package manager abstraction tool for ROS")
      (description "Package manager abstraction tool for ROS.")
      (license license:bsd-3))))

(define-public urdfdom-headers
  (let ((commit "00c1c9c231e46b2300d04073ad696521758fa45c")
        (revision "0"))
    (package
      (name "urdfdom-headers")
      (version (git-version "1.0.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/urdfdom_headers")
               (commit commit)))
         (sha256
          (base32 "0vk34r9v75fy0z6xafkwhqf7qg5ncd8rd33454yna6jl94pcdqcx"))
         (file-name (git-file-name name version))))
      (build-system cmake-build-system)
      (arguments
       (list
        #:tests? #f)) ;there are no tests
      (propagated-inputs (list tinyxml))
      (home-page "https://wiki.ros.org/urdfdom_headers")
      (synopsis "Header files for urdfdom")
      (description "Header files urdfdom")
      (license license:bsd-3))))

(define-public urdfdom
  (let ((commit "0da4b20675cdbe14b532d484a1c17df85b4e1584")
        (revision "0"))
    (package
      (name "urdfdom")
      (version (git-version "1.0.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/urdfdom")
               (commit commit)))
         (sha256
          (base32 "0wambq06d7dvja25zcv4agc055q9rmf3xkrnxy8lsf4nic7ra2rr"))
         (file-name (git-file-name name version))
         (modules '((guix build utils)))
         (snippet '(substitute* "CMakeLists.txt"
                     (("console_bridge 0.3")
                      "console_bridge")))))
      (build-system cmake-build-system)
      (inputs (list console-bridge))
      (propagated-inputs (list tinyxml urdfdom-headers))
      (home-page "https://wiki.ros.org/urdfdom")
      (synopsis "Parsing for URDF files")
      (description "Parse URDF files.")
      (license license:bsd-3))))
