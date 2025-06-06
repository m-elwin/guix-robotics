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

(define-module (ros-noetic bond-core)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system catkin)
  #:use-module (gnu packages boost)
  #:use-module (ros-noetic ros-comm)
  #:use-module (ros-noetic ros-core))

;;; Commentary:
;;;
;;;
;;; Packages that are part of bond_core.
;;; They generally should all be on the same commit
;;;
;;; Code:

(define-public ros-noetic-bond
  (let ((commit "5e299fbfc512b60434b20f2b828b44ae25697e46")
        (revision "0"))
    (package
      (name "ros-noetic-bond")
      (version (git-version "1.8.7" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/bond_core")
               (commit commit)))
         (sha256
          (base32 "007mzlbjxsbxc0y542bz4ry4r9m4yzgx3fsp7s8pchhdrbk1g77i"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation))
      (propagated-inputs (list ros-noetic-message-runtime
                               ros-noetic-std-msgs))
      (arguments
       (list
        #:package-dir "bond"))
      (home-page "https://wiki.ros.org/bond")
      (synopsis "Allow two processes to know when the other has terminated")
      (description "A bond allows two processes, A and B, to know when the other has
terminated, either cleanly or by crashing.  The bond remains
connected until it is either broken explicitly or until a
heartbeat times out.")
      (license license:bsd-3))))


(define-public ros-noetic-bondcpp
  (let ((commit "5e299fbfc512b60434b20f2b828b44ae25697e46")
        (revision "0"))
    (package
      (name "ros-noetic-bondcpp")
      (version (git-version "1.8.7" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/bond_core")
               (commit commit)))
         (sha256
          (base32 "007mzlbjxsbxc0y542bz4ry4r9m4yzgx3fsp7s8pchhdrbk1g77i"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-cmake-modules))
      (propagated-inputs (list
                          boost
                          ros-noetic-bond
                          ros-noetic-roscpp
                          ros-noetic-smclib))
      (arguments
       (list
        #:package-dir "bondcpp"))
      (home-page "https://wiki.ros.org/bondcpp")
      (synopsis "C++ implementation of bond")
      (description "C++ implementation of bond, a mechanism for checking when
another process has terminated.")
      (license license:bsd-3))))

(define-public ros-noetic-smclib
  (let ((commit "5e299fbfc512b60434b20f2b828b44ae25697e46")
        (revision "0"))
    (package
      (name "ros-noetic-smclib")
      (version (git-version "1.8.7" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/bond_core")
               (commit commit)))
         (sha256
          (base32 "007mzlbjxsbxc0y542bz4ry4r9m4yzgx3fsp7s8pchhdrbk1g77i"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (arguments
       (list
        #:package-dir "smclib"))
      (home-page "https://smc.sourceforge.net")
      (synopsis "State Machine Compiler (SMC)")
      (description "The State Machine Compiler (SMC)
converts a language-independent description of a state machine
into the source code to support that state machine.

This package contains the libraries that a compiled state machine
depends on, but it does not contain the compiler itself.")
      (license license:bsd-3))))
