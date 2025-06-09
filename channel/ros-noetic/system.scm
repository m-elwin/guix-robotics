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
  #:use-module ((guix licenses) #:prefix license:) ;orocos-kdl uses this
  #:use-module (guix build-system cmake)
  #:use-module (guix download)
  #:use-module (guix gexp) ;orocos-kdl -uses this
  #:use-module (guix git-download) ; orocos-kdl uses this
  #:use-module (guix packages)
  #:use-module (gnu packages algebra) ; orocos-kdl uses this
  #:use-module (gnu packages check)
  #:use-module (gnu packages logging)
  #:use-module (gnu packages python) ;orocos-kdl uses this
  #:use-module (gnu packages python-xyz) ;orocos-kdl uses this
  )
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

(define-public orocos-kdl
  (let ((commit "db25b7e480e068df068232064f2443b8d52a83c7")
        (revision "0"))
    (package
      (name "orocos-kdl")
      (version (git-version "1.5.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/orocos/orocos_kinematics_dynamics")
               (commit commit)))
         (sha256
          (base32 "1y8288hfxpn8b7cl18jsyj38j1px201vjkb770b43x9gfhm3yl41"))
         (file-name (git-file-name name version))))
      (build-system cmake-build-system)
      (native-inputs (list cppunit))
      (propagated-inputs (list eigen))
      (arguments
       (list
        #:configure-flags '(list "-DENABLE_TESTS=ON")
        #:test-target "check"
        #:phases #~(modify-phases %standard-phases
                       (add-after 'unpack 'chdir
                         (lambda _ (chdir "orocos_kdl"))))))
      (home-page "https://docs.orocos.org/kdl/overview.html")
      (synopsis "Open Robot Control Software's Kinematics and Dynamics Library")
      (description "Library for computing kinematics and dynamics for kinematic chains.
A serial robot arm is one type of kinematic chain.")
      (license license:lgpl2.1+))))

(define-public python-orocos-kdl
  (let ((commit "db25b7e480e068df068232064f2443b8d52a83c7")
        (revision "0"))
    (package
      (name "python-orocos-kdl")
      (version (git-version "1.5.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/orocos/orocos_kinematics_dynamics")
               (commit commit)))
         (sha256
          (base32 "1y8288hfxpn8b7cl18jsyj38j1px201vjkb770b43x9gfhm3yl41"))
         (file-name (git-file-name name version))
         (modules '((guix build utils)))
         (snippet
          '(substitute* "python_orocos_kdl/CMakeLists.txt"
             (("add_subdirectory\\(pybind11\\)") "find_package(pybind11)")))))
      (build-system cmake-build-system)
      (native-inputs (list python pybind11 python-psutil))
      (inputs (list orocos-kdl))
      (arguments
       (list
        #:phases #~(modify-phases %standard-phases
                       (add-after 'unpack 'chdir
                         (lambda _ (chdir "python_orocos_kdl")))
                       (replace 'check 
                         (lambda _
                           (setenv "PYTHONPATH" "./")
                           (invoke "python3" "../python_orocos_kdl/tests/PyKDLtest.py"))))))
      (home-page "https://docs.orocos.org/kdl/overview.html")
      (synopsis "Python Bindings for Open Robot Control Software's Kinematics and Dynamics Library")
      (description "Library for computing kinematics and dynamics for kinematic chains.
A serial robot arm is one type of kinematic chain. These are the python bindings.")
      (license license:lgpl2.1+))))
