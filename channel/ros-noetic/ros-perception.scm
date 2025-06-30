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

(define-module (ros-noetic ros-perception)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system catkin)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages python-xyz)
  #:use-module (ros-noetic common-msgs)
  #:use-module (ros-noetic geometry)
  #:use-module (ros-noetic geometry2)
  #:use-module (ros-noetic ros-comm)
  #:use-module (ros-noetic ros))

;;; Commentary:
;;;
;;;
;;; Packages related to sensor perception in ROS.
;;;
;;; Code:

(define-public ros-noetic-laser-geometry
  (let ((commit "1dd8476f543427f0a82ce952bd13f9870c2e2d19")
        (revision "0"))
    (package
      (name "ros-noetic-laser-geometry")
      (version (git-version "1.6.8" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-perception/laser_geometry")
               (commit commit)))
         (sha256
          (base32 "185rb9y97cw65rb6bf8avz8sylz69hdpdfi8d1mr5jzqxxj8adnx"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest ros-noetic-rosunit))
      (propagated-inputs (list eigen
                               boost
                               ros-noetic-angles
                               ros-noetic-roscpp
                               ros-noetic-sensor-msgs
                               ros-noetic-tf
                               ros-noetic-tf2
                               ros-noetic-tf2-geometry-msgs
                               python-numpy))
      (home-page "https://wiki.ros.org/laser_geometry")
      (synopsis "Convert 2D laser scans into 3D point clouds")
      (description
       "Converts from 2D laser scans as defined by sensor_msgs/LaserScan
into point cloulds as defined by sensor_msgs/PointCloud or
sensor_msgs/PointCloud2.  In particular, it contains functionality to account
for the skew resulting from moving robots or tilting laser scanners.")
      (license license:bsd-3))))
