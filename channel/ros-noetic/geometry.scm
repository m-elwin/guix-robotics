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
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (ros-noetic common-msgs)
  #:use-module (ros-noetic ros-core)
  #:use-module (ros-noetic ros-comm)
  #:use-module (ros-noetic system)
  #:use-module (guix build-system catkin))

;;; Commentary:
;;;
;;;
;;; Packages that are part of the geometry package
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
      (home-page "https://github.com/ros/diagnostics/tree/1.12.1")
      (synopsis "Print aggregated diagnostic contents to the command line")
      (description "Print aggregated diagnostic contents to the command line.")
      (license license:bsd-3))))
