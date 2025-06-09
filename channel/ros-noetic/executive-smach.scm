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

(define-module (ros-noetic executive-smach)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system catkin)
  #:use-module (ros-noetic ros-core))

;;; Commentary:
;;;
;;;
;;; Packages that are part of the executive_smach package
;;; All packages in this file should generally come fro the
;;; same git commit and be the same version
;;;
;;; Code:

(define-public ros-noetic-smach-msgs
  (let ((commit "816b22a406cff5386689540e5d1277023b2b640f")
        (revision "0"))
    (package
      (name "ros-noetic-smach-msgs")
      (version (git-version "2.5.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/executive_smach")
               (commit commit)))
         (sha256
          (base32 "1sl0n38ivdz863n831g1a9z09jby8yqdsnfgbcwpf36xajqnh8xv"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation))
      (propagated-inputs (list ros-noetic-message-runtime ros-noetic-std-msgs))
      (arguments
       (list
        #:package-dir "smach_msgs"))
      (home-page "https://wiki.ros.org/eigen_conversions")
      (synopsis "Messages for smach introspection interfaces")
      (description "Messages for smach introspection interfaces")
      (license license:bsd-3))))
