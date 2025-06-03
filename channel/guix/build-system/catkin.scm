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
(define-module (guix build-system catkin)
  #:use-module (guix build utils)
  #:use-module (guix build-system)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system python)
  #:use-module (guix search-paths)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix gexp)
  #:use-module (gnu packages check)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages linux)
  #:use-module (ros-noetic bootstrap)
  #:use-module (ros-noetic system))

;; Commentary:
;;
;; Standard build procedure for packages using catkin. This is implemented as an
;; extension of `cmake-build-system'. Essentially it uses cmake to build packages
;; but also provides necessary inputs for the catkin-cmake extentions and for
;; python because catkin uses cmake to also install python code
;;
;; Code:

(define (default-catkin)
  "Return the default catkin package."
  ;; Do not use `@' to avoid introducing circular dependencies.
  ;; This is borrowed from (default-cmake) in guix/build-system/cmake.scm
  ;; I think what the comment above means is we don't use the module that contains catkin here
  ;; because catkin uses catkin-build-system to build itself, so instead we fetch the catkin package
  ;; directly
  (let ((module (resolve-interface '(ros-noetic core))))
    (module-ref module
                'catkin)))

(define %catkin-build-system-modules
  ;; Build-side modules imported by default.
  `((guix build catkin-build-system)
    ,@%cmake-build-system-modules
    ,@%python-build-system-modules))

;;; adds some python phases to gnu
;;; Defined to augment the native inputs of anything that uses this build system
(define* (lower-catkin name
                       #:key (catkin? #t)
                       (test-target "run_tests")
                       (package-dir ".")
                       #:allow-other-keys #:rest arguments)
  "Lower into a bag. Uses the cmake lower function but adjusts arguments.
CATKIN? Include catkin as an input. Set to #f so we can use the rest of this with the catkin package.
TEST-TARGET (defaults to run_tests) the test target to pass to make.
PACKAGE-DIR - if set, specifies a subdirectory of the source code to cd into prior to building."
  (define lower
    (build-system-lower cmake-build-system))
  "Return a bag for NAME. catkin? is #f to not include catkin as an input, such as when building the catkin package itself"
  (define private-keywords
    '(#:catkin? #:package-dir))
  (apply lower name
         (substitute-keyword-arguments (strip-keyword-arguments
                                        private-keywords
                                        (append arguments
                                                (list #:test-target
                                                      test-target)))
           ((#:native-inputs original-native-inputs
             '())
            (append (if catkin?
                        `(("catkin" ,(default-catkin)))
                        '())
                    `(("python-wrapper" ,python-wrapper)
                      ("python-catkin-pkg" ,python-catkin-pkg)
                      ("python-empy" ,python-empy)
                      ("googletest" ,googletest)
                      ("python-nose-noetic" ,python-nose-noetic)
                      ("util-linux" ,util-linux)) original-native-inputs))
           ((#:modules orig-modules
             '())
            (append `(((guix build cmake-build-system)
                       #:select (cmake-build))
                      (guix build catkin-build-system)
                      (guix build utils)) orig-modules))
           ((#:imported-modules orig-imported-modules
             '())
            (append %catkin-build-system-modules orig-imported-modules))
           ((#:phases orig-phases '%standard-phases)
            #~(modify-phases #$orig-phases
                (replace 'unpack
                  ;; we want to change directory after 'unpack and
                  ;; have this treated as part of the 'unpack phase
                  (lambda args
                    (apply (assoc-ref #$orig-phases 'unpack) args)
                    (chdir #$package-dir))))))))

(define-public catkin-build-system
  (build-system (name "catkin-build-system")
                (description "The build system for ros-noetic using catkin")
                (lower lower-catkin)))

