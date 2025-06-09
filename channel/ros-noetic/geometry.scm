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

(define-module (ros-noetic geometry)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system catkin)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (gnu packages graphviz)
  #:use-module (ros-noetic common-msgs)
  #:use-module (ros-noetic ros)
  #:use-module (ros-noetic ros-core)
  #:use-module (ros-noetic roscpp-core)
  #:use-module (ros-noetic ros-comm)
  #:use-module (ros-noetic system))

;;; Commentary:
;;;
;;;
;;; Packages that are part of the geometry package
;;; and ROS packages that geometry depends on that
;;; are related to geometry
;;;
;;; Code:

(define-public ros-noetic-eigen-conversions
  (let ((commit "faeeae78261896159072ca08270491e7f4aed3e5")
        (revision "0"))
    (package
      (name "ros-noetic-eigen-conversions")
      (version (git-version "1.13.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/geometry")
               (commit commit)))
         (sha256
          (base32 "13m50fp9ylm9m05p2iisqmhwyhqpqsay62li6brj81gms1ljdgdv"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list
                          ros-noetic-rospy
                          ros-noetic-diagnostic-msgs
                          orocos-kdl
                          ros-noetic-geometry-msgs
                          ros-noetic-std-msgs))
      (arguments
       (list
        #:package-dir "eigen_conversions"))
      (home-page "https://wiki.ros.org/eigen_conversions")
      (synopsis "Conversions functions for eigen and KDL")
      (description "Convert between Eigen and KDL and
Eigen and geometry_msgs.")
      (license license:bsd-3))))

(define-public ros-noetic-kdl-conversions
  (let ((commit "faeeae78261896159072ca08270491e7f4aed3e5")
        (revision "0"))
    (package
      (name "ros-noetic-kdl-conversions")
      (version (git-version "1.13.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/geometry")
               (commit commit)))
         (sha256
          (base32 "13m50fp9ylm9m05p2iisqmhwyhqpqsay62li6brj81gms1ljdgdv"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list orocos-kdl ros-noetic-geometry-msgs))
      (arguments
       (list
        #:package-dir "kdl_conversions"))
      (home-page "https://wiki.ros.org/kdl_conversions")
      (synopsis "Conversions between KDL and geometry_msgs")
      (description "Conversions between KDL and geometry_msgs.")
      (license license:bsd-3))))

(define-public ros-noetic-tf
  (let ((commit "faeeae78261896159072ca08270491e7f4aed3e5")
        (revision "0"))
    (package
      (name "ros-noetic-tf")
      (version (git-version "1.13.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/geometry")
               (commit commit)))
         (sha256
          (base32 "13m50fp9ylm9m05p2iisqmhwyhqpqsay62li6brj81gms1ljdgdv"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation
                           ros-noetic-rostest
                           ros-noetic-rosunit))
      (inputs (list ros-noetic-angles graphviz))
      (propagated-inputs (list ros-noetic-geometry-msgs
                               ros-noetic-message-filters
                               ros-noetic-message-runtime
                               ros-noetic-rosconsole
                               ros-noetic-roscpp
                               ros-noetic-rostime
                               ros-noetic-sensor-msgs
                               ros-noetic-std-msgs
                               ros-noetic-roswtf))
      (arguments
       (list
        #:package-dir "tf"))
      (home-page "https://wiki.ros.org/tf")
      (synopsis "Tracks coordinate frames over time")
      (description "tf is a package that lets the user keep track of multiple coordinate
frames over time. tf maintains the relationship between coordinate
frames in a tree structure buffered in time, and lets the user
transform points, vectors, etc between any two coordinate frames at
any desired point in time.

Migration: Since ROS Hydro, tf has been \"deprecated\" in favor of tf2.
tf2 is an iteration on tf providing generally the same feature set more efficiently.
As well as adding a few new features.
As tf2 is a major change the tf API has been maintained in its current form.
Since tf2 has a superset of the tf features with a subset of the dependencies
the tf implementation has been removed and replaced with calls to tf2 under the hood.
This will mean that all users will be compatible with tf2.
It is recommended for new work to use tf2 directly as it has a cleaner interface.
However tf will continue to be supported for through at least J Turtle.")
      (license license:bsd-3))))

(define-public ros-noetic-angles
  (let ((commit "d2f5e3c0d09d52c28b982723f5d4d1b106babe94")
        (revision "0"))
    (package
      (name "ros-noetic-angles")
      (version (git-version "1.9.14" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/angles")
               (commit commit)))
         (sha256
          (base32 "0vgf8gz7lpm9608bwd900yyzjj1icbhinbsaqjri733k32gala9q"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rosunit))
      (arguments
       (list
        #:package-dir "angles"))
      (home-page "https://wiki.ros.org/angles")
      (synopsis "Math utilities to work with angles")
      (description
       "The utilities cover simple things like
normalizing an angle and conversion between degrees and
radians.  But even if you're trying to calculate things like
the shortest angular distance between two joint space
positions of your robot, but the joint motion is constrained
by joint limits, this package is what you need.  The code in
this package is stable and well tested.  There are no plans for
major changes in the near future.")
      (license license:bsd-3))))
