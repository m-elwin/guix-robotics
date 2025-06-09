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

(define-module (ros-noetic robot)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (gnu packages boost)
  #:use-module (ros-noetic common-msgs)
  #:use-module (ros-noetic ros)
  #:use-module (ros-noetic ros-comm)
  #:use-module (ros-noetic ros-core)
  #:use-module (guix build-system catkin))

;;; Commentary:
;;;
;;;
;;; Packages that are part of the robot metapacakge
;;;
;;; Code:

(define-public ros-noetic-control-msgs
  (let ((commit "c7b118501c24278467153822dd70e8c53baad3d5")
        (revision "0"))
    (package
      (name "ros-noetic-control-msgs")
      (version (git-version "1.5.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-controls/control_msgs")
               (commit commit)))
         (sha256
          (base32 "133fmjxhk0w3w2pyhh4ymgi80h9hcn708lw10qfxqlghjxzs2rid"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation))
      (propagated-inputs (list ros-noetic-message-runtime
                               ros-noetic-actionlib-msgs
                               ros-noetic-geometry-msgs
                               ros-noetic-trajectory-msgs))
      (arguments (list
        #:package-dir "control_msgs"))
      (home-page "http://wiki.ros.org/control_msgs")
      (synopsis "Messages and actions useful for controlling robots")
      (description "Base messages and actions useful for controlling
robots.  It provides representations for controller setpoints and joint
and cartesian trajectories.")
      (license license:bsd-3))))

(define-public ros-noetic-filters
  (let ((commit "126188027067f6822c39003dcc2aa86002d27f9f")
        (revision "0"))
    (package
      (name "ros-noetic-filters")
      (version (git-version "1.9.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/filters")
               (commit commit)))
         (sha256
          (base32 "1468prq2hq6xnn463h91zbw26y8sqab1vigzzskzd1kmipafxhah"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest))
      (propagated-inputs (list ros-noetic-roslib ros-noetic-rosconsole
                               ros-noetic-roscpp ros-noetic-pluginlib boost))
      (home-page "http://wiki.ros.org/filters")
      (synopsis "Standardized interface for processing data in sequence")
      (description
       "This library provides a standardized interface for
processing data as a sequence of filters.  This package contains a base
class upon which to build specific implementations as well as an interface
which dynamically loads filters based on runtime parameters.")
      (license license:bsd-3))))
