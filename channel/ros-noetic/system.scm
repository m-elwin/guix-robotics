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
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system pyproject)
  #:use-module (guix build-system python)
  #:use-module (guix git-download)
  #:use-module (guix search-paths)
  #:use-module (guix gexp)
  #:use-module (gnu packages apr)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages check)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages logging)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages version-control)
  )
;; Commentary:
;;
;; System dependencies that are not (yet) in upstream-guix
;; or older-versions kept around for ROS Noetic.
;;
;; Older versions used for ROS noetic will have a
;; package-name-version form and a package-name-noetic symbol
;; for use when developing ROS noetic packages
;;
;; Code:

(define-public log4cxx-0.11
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

(define-public log4cxx-noetic log4cxx-0.11)

;;; Fix nose (which is not maintained) for python3.11
(define-public python-nose-1.3.7-noetic
  (package
    (inherit python-nose)
    (version "1.3.7-noetic")
    (source
     (origin
       (inherit (package-source python-nose))
       (modules '((guix build utils)))
       (snippet
        '(substitute* '("nose/util.py" "nose/plugins/manager.py")
           ;; Convert the inspect.getargspec(...) into inspect.getfullargspec(...)
           ;; getfullargspec returns a named tuple and getargspec returns a tuple
           ;; so we convert the return value from a named-tuple into a tuple
           (("inspect.getargspec\\((.*)\\)" _ func-arg)
            (string-append
             "tuple(getattr(inspect.getfullargspec("
             func-arg
             "), attr) for attr in ['args', 'varargs', 'varkw', 'defaults'])"))))))))

(define-public python-nose-noetic python-nose-1.3.7-noetic)
