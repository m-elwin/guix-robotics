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

(define-module (ros-noetic system)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:) ;for ogre
  #:use-module (gnu packages fonts) ;for ogre
  #:use-module (gnu packages image) ;for ogre
  #:use-module (gnu packages fontutils) ;for ogre
  #:use-module (gnu packages gl) ;for ogre
  #:use-module (gnu packages sdl) ;for ogre
  #:use-module (gnu packages xorg) ;for ogre
  #:use-module (gnu packages xml) ;for ogre
  #:use-module (gnu packages compression) ;for ogre
  #:use-module (gnu packages boost) ;for ogre
  #:use-module (gnu packages documentation) ;for ogre
  #:use-module (gnu packages pkg-config) ;for ogre
  #:use-module (guix build-system python) ; for pydot
  #:use-module (guix build-system pyproject) ;for pydot
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (gnu packages check)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages graphics) ; for ogre
  #:use-module (gnu packages graphviz) ; for pydot-noetic
  #:use-module (gnu packages python-build) ; for pydot-noetic
  #:use-module (gnu packages qt) ; for python-pyqt
  #:use-module (gnu packages logging))

;; Commentary:
;;
;; System dependencies that are not (yet) in upstream-guix
;; or older-versions kept around for ROS Noetic.
;;
;; Older versions used for ROS noetic will have a
;; package-name-noetic symbol for use with other
;; ROS noetic packages
;;
;; Code:

(define-public log4cxx-noetic
  (package
    (inherit log4cxx)
    (version "0.11.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://apache/logging/log4cxx/" version
                           "/apache-log4cxx-" version ".tar.gz"))
       (sha256
        (base32 "14xkb34svkgn08gz7qbama3idlk2a4q5y7ansccvkrf4wdg705n3"))))))

;;; Fix nose (which is not maintained) for python3.11
(define-public python-nose-noetic
  (package
    (inherit python-nose)
    (version "1.3.7-noetic")
    (source
     (origin
       (inherit (package-source python-nose))
       (modules '((guix build utils)))
       (snippet
        '(substitute*
          '("nose/util.py" "nose/plugins/manager.py")
          ;; Convert the inspect.getargspec(...) into inspect.getfullargspec(...)
          ;; getfullargspec returns a named tuple and getargspec returns a tuple
          ;; so we convert the return value of getfullargspec from a
          ;; named-tuple into a tuple
           (("inspect.getargspec\\((.*)\\)" _ func-arg)
            (string-append
             "tuple(getattr(inspect.getfullargspec("
             func-arg
             "), attr) for attr in ['args', 'varargs', 'varkw', 'defaults'])"))))))))

;; current pydot propagates pyparsing-2.4.7 which is an issue for other
;; packages that need pyparsing. Use the version that is closest to ROS 1
;; but that builds as close to the version in guix
(define-public python-pydot-noetic
  (package
    (inherit python-pydot)
    (version "2.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pydot" version))
       (sha256
        (base32
         "0d9j9wg7lqwyj5l9zw0d51pkm8nxcyz93mqwy9ia0gqj2pr6l930"))))
    (propagated-inputs
     (modify-inputs (package-propagated-inputs python-pydot)
       (replace "python-pyparsing" python-pyparsing)))))

;;; pyqt5 with sip4 support
;;; See https://github.com/ros-noetic-arch/ros-noetic-python-qt-binding/issues/7
(define-public python-pyqt-noetic
  (package
    (inherit python-pyqt)
    (version "5.15.10-noetic")
    (source
     (origin
       (inherit (package-source python-pyqt))
       (modules '((guix build utils)))
       (snippet '(substitute* "sip/QtCore/QtCoremod.sip"
                   ((", py_ssize_t_clean=True") "")))))
    ;; This package needs sip6 to build, but we propagate sip-4 since the dependencies need sip4
    ;; the runtime dependencies of sip6 and sip4 appear to be compatible
    ;; In other words: this package needs to be built with python-sip, but ROS users need to use
    ;; python-sip-4-noetic. However, the package itself, at runtime, works with either
    ;; Long-term solution would be to make rviz work with sip5
    (native-inputs (list python-sip python-pyqt-builder))
    (propagated-inputs (list python-sip-4 python-pyqt5-sip))))

(define-public ogre-noetic
  (package
    (name "ogre")
    (version "1.12.6")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/OGRECave/ogre")
             (commit (string-append "v" version))
             (recursive? #t)))          ;for Dear ImGui submodule
       (file-name (git-file-name name version))
       (sha256
        (base32 "1ap3krrl55hswv1n2r3ijf3xrb3kf9dnqvwyrc0fgnc7j7vd45sk"))
       (modules '((guix build utils)))
       (snippet
        '(begin
           (rename-file "CMake/FeatureSummary.cmake" "CMake/OgreFeatureSummary.cmake")
           (substitute* "CMakeLists.txt"
             (("FeatureSummary") "OgreFeatureSummary"))))))
    (build-system cmake-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (add-before 'configure 'pre-configure
           ;; CMakeLists.txt forces CMAKE_INSTALL_RPATH value.  As
           ;; a consequence, we cannot suggest ours in configure flags.  Fix
           ;; it.
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (substitute* "CMakeLists.txt"
               (("set\\(CMAKE_INSTALL_RPATH .*") ""))
             #t)))
       #:configure-flags
       (let* ((out (assoc-ref %outputs "out"))
              (runpath
               (string-join (list (string-append out "/lib")
                                  (string-append out "/lib/OGRE"))
                            ";")))
         (list (string-append "-DCMAKE_INSTALL_RPATH=" runpath)
               "-DOGRE_BUILD_DEPENDENCIES=OFF"
               "-DOGRE_BUILD_TESTS=TRUE"
               "-DOGRE_INSTALL_DOCS=TRUE"
               "-DOGRE_INSTALL_SAMPLES=TRUE"
               "-DOGRE_INSTALL_SAMPLES_SOURCE=TRUE"))))
    (native-inputs
     `(("boost" ,boost)
       ("doxygen" ,doxygen)
       ("googletest" ,googletest-1.8)
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("font-dejavu" ,font-dejavu)
       ("freeimage" ,freeimage)
       ("freetype" ,freetype)
       ("glu" ,glu)
       ("libxaw" ,libxaw)
       ("libxrandr" ,libxrandr)
       ("pugixml" ,pugixml)
       ("sdl2" ,sdl2)
       ("tinyxml" ,tinyxml)
       ("zziplib" ,zziplib)))
    (synopsis "Scene-oriented, flexible 3D engine written in C++")
    (description
     "OGRE (Object-Oriented Graphics Rendering Engine) is a scene-oriented,
flexible 3D engine written in C++ designed to make it easier and more intuitive
for developers to produce applications utilising hardware-accelerated 3D
graphics.")
    (home-page "https://www.ogre3d.org/")
    (license license:expat)))
