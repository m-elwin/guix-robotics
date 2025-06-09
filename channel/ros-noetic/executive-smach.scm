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
  #:use-module (ros-noetic common-msgs)
  #:use-module (ros-noetic ros-base)
  #:use-module (ros-noetic ros-comm)
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
      (home-page "https://wiki.ros.org/smach_msgs")
      (synopsis "Messages for smach introspection interfaces")
      (description "Messages for smach introspection interfaces")
      (license license:bsd-3))))

(define-public ros-noetic-smach
  (let ((commit "816b22a406cff5386689540e5d1277023b2b640f")
        (revision "0"))
    (package
      (name "ros-noetic-smach")
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
      (arguments
       (list
        #:package-dir "smach"))
      (home-page "https://wiki.ros.org/smach")
      (synopsis
       "Task-level architecture for rapidly creating complex robot behavior")
      (description
       "A task-level architecture
for rapidly creating complex robot behavior.
At its core, SMACH is a ROS-independent Python library to build
hierarchical state machines.  SMACH is a new library that takes advantage of
very old concepts in order to quickly create robust robot behavior with
maintainable and modular code.")
      (license license:bsd-3))))

(define-public ros-noetic-smach-ros
  (let ((commit "816b22a406cff5386689540e5d1277023b2b640f")
        (revision "0"))
    (package
      (name "ros-noetic-smach-ros")
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
      (native-inputs (list ros-noetic-rostest))
      (propagated-inputs (list ros-noetic-rospy
                               ros-noetic-rostopic
                               ros-noetic-std-msgs
                               ros-noetic-std-srvs
                               ros-noetic-actionlib
                               ros-noetic-actionlib-msgs
                               ros-noetic-smach
                               ros-noetic-smach-msgs))
      (arguments
       (list
        #:package-dir "smach_ros"))
      (home-page "https://wiki.ros.org/smach_ros")
      (synopsis "Extensions for SMACH to integrate it with ROS")
      (description
       "Contains extensions for the SMACH library to
integrate it tightly with ROS.  For example, SMACH-ROS can call
ROS services, listen to ROS topics, and integrate
with actionlib both as a client, and a provider of action servers.
SMACH is a new library that takes advantage of very old concepts
in order to quickly create robust robot behavior with maintainable
and modular code.")
      (license license:bsd-3))))

(define-public ros-noetic-executive-smach
  (let ((commit "816b22a406cff5386689540e5d1277023b2b640f")
        (revision "0"))
    (package
      (name "ros-noetic-executive-smach")
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
      (propagated-inputs (list ros-noetic-smach ros-noetic-smach-ros
                               ros-noetic-smach-msgs))
      (arguments
       (list
        #:package-dir "executive_smach"))
      (home-page "https://wiki.ros.org/executive_smach")
      (synopsis "Metapackage for SMACH")
      (description
       "Metapackage for SMACH, a ROS system and python library
for creating complex robot behaviors with easy-to-maintain code")
      (license license:bsd-3))))
