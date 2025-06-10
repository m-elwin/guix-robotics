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
(define-module (guix build catkin-build-system)
  #:use-module ((guix build cmake-build-system)
                #:prefix cmake-build:)
  #:use-module ((guix build python-build-system)
                #:prefix py-build:)
  #:use-module (guix build utils)
  #:use-module (ice-9 match)
  #:use-module (ice-9 rdelim)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26)
  #:use-module (sxml simple)
  #:export (%standard-phases))

;; Commentary:
;;
;; Builder-side code of the standard catkin build procedure
;; Mostly follows the template and reuses cmake-build-system
;;
;; Code:

(define (ros-package-name builddir)
  "Get the ROS package name from the cmake cache, given the build directory"
  (with-input-from-file (string-append builddir "/CMakeCache.txt")
    (lambda ()
      (let loop ()
        (let ((line (read-line)))
          (cond
           ((eof-object? line) #f) ; end of file
           ((string-prefix? "CMAKE_PROJECT_NAME" line) ; line has the project
            (substring line (+ (string-index line #\=) 1))) ;get teh part after the =
           (else (loop))))))))

;;; Modified from guix/build/python-build-system wrap
;;; Changed to wrap python executables in /lib because
;;; ROS installs python executables into /lib/packagename
(define* (wrap-lib-bin #:key source inputs outputs #:allow-other-keys)
  (define (list-of-files dir)
    (find-files dir (lambda (file stat)
                      (and (eq? 'regular (stat:type stat))
                           (not (wrapped-program? file))))))
  (define bindirs
    (append-map (match-lambda
                  ((_ . dir)
                   (list (string-append dir "/bin")
                         (string-append dir "/sbin")
                         (string-append dir "/lib/" (ros-package-name
                                                     (getcwd))))))
                outputs))

  ;; Do not require "bash" to be present in the package inputs
  ;; even when there is nothing to wrap.
  ;; Also, calculate (sh) only once to prevent some I/O.
  (define %sh (delay (search-input-file inputs "bin/bash")))
  (define (sh) (force %sh))

  (let* ((var `("GUIX_PYTHONPATH" prefix
                ,(search-path-as-string->list
                  (or (getenv "GUIX_PYTHONPATH") "")))))
    (for-each (lambda (dir)
                (let ((files (list-of-files dir)))
                  (for-each (cut wrap-program <> #:sh (sh) var)
                            files)))
              bindirs)))



(define* (ros-wrap #:key outputs #:allow-other-keys)
  "Set's ROS Environment variables for each ROS-related program.
See http://wiki.ros.org/ROS/EnvironmentVariables.
Also creates an opt/ros/ directory with noetic symlinking back."
  (for-each (lambda (file)
               ;wrap all binaries with the proper ROS env variables
              (display (string-append "ROS Wrapping " file))
              (newline)
              (wrap-program file
                ;; the distro for catkin is noetic
                `("ROS_DISTRO" = ,(list "noetic"))
                ;; override the os to be guix.
                ;; Note that guix can be used ontop of other os's
                ;; so this follows a pattern with similar environments
                ;; such as conda, which is detected by checking
                ;; ROS_OS_OVERRIDE for "conda" (see rospkg/os_detect.py)
                `("ROS_OS_OVERRIDE" = ,(list "guix::"))
                `("ROS_MASTER_URI" =
                  ,(list "${ROS_MASTER_URI:=http://localhost:11311}"))
                `("CMAKE_PREFIX_PATH" prefix
                  ,(list "${GUIX_ROS_CMAKE_PREFIX_PATH}"))
                `("ROS_PACKAGE_PATH" prefix
                  ,(list "${GUIX_ROS_PACKAGE_PATH}"))))
            (find-files (string-append (assoc-ref outputs "out") "/bin")
                        "^[^\\.].*")))

(define* (catkin-test-results #:key inputs outputs #:allow-other-keys)
  "Run catkin-test-results so that the result or run_tests failing will cause the build to fail"
  (let ((catkin (assoc-ref inputs "catkin")))
    (if catkin ;when catkin? was #f, catkin is not an input so we can't run this step
        (invoke (string-append catkin "/bin/catkin_test_results")))))

(define (check-with-results . args)
  "Run the check then run catkin-test-results so check fails if tests did"
  ;; Must be a writeable dir for some ROS integration tests
  ;; Parent directory should have normal permissions due to rosunit
  (mkdir "/tmp/guix-ros-tmp")
  (setenv "ROS_LOG_DIR" "/tmp/guix-ros-tmp")
  (setenv "ROS_HOME" "/tmp/guix-ros-tmp")
  (setenv "ROS_OS_OVERRIDE" "guix::")
  (apply (assoc-ref cmake-build:%standard-phases
                    'check) args)
  (apply catkin-test-results args))




(define %standard-phases
  (modify-phases cmake-build:%standard-phases
    (add-after 'unpack 'ensure-no-mtimes-pre-1980
      (assoc-ref py-build:%standard-phases
                 'ensure-no-mtimes-pre-1980))
    (add-after 'ensure-no-mtimes-pre-1980 'enable-bytecode-determinism
      (assoc-ref py-build:%standard-phases
                 'enable-bytecode-determinism))
    (add-after 'enable-bytecode-determinism 'ensure-no-cythonized-files
      (assoc-ref py-build:%standard-phases
                 'ensure-no-cythonized-files))
    (add-after 'install 'add-install-to-pythonpath
      (assoc-ref py-build:%standard-phases
                 'add-install-to-pythonpath))
    (add-after 'add-install-to-pythonpath 'add-install-to-path
      (assoc-ref py-build:%standard-phases
                 'add-install-to-path))
    (add-after 'add-install-to-path 'wrap
      wrap-lib-bin)
    (add-after 'wrap 'ros-wrap
      ros-wrap)
    (replace 'check
      check-with-results)))
