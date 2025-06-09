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

(define-module (ros-noetic joint-state-publisher)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system catkin)
  #:use-module (ros-noetic common-msgs)
  #:use-module (ros-noetic ros-comm)
  #:use-module (ros-noetic ros-visualization))

;;; Commentary:
;;;
;;;
;;; Packages that are part of the joint_state_publisher
;;; repository. Includes the joint_state_publisher and the
;;; joint_state_publisher gui. Both should be on the same
;;; git revision
;;;
;;; Code:

(define-public ros-noetic-joint-state-publisher
  (let ((commit "ccb4446b9092e7f6d7956d7058d17745df7f8475")
        (revision "0"))
    (package
      (name "ros-noetic-joint-state-publisher")
      (version (git-version "1.15.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/joint_state_publisher")
               (commit commit)))
         (sha256
          (base32 "0i1ilshhxk5mvmzl9f4nrvf2cirxy52j1snv10d80ypgq91lh91m"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest))
      (propagated-inputs (list ros-noetic-rospy ros-noetic-sensor-msgs))
      (arguments
       (list
        #:package-dir "joint_state_publisher"))
      (home-page "https://wiki.ros.org/joint_state_publisher")
      (synopsis
       "Set and publish joint state values for a given URDF")
      (description
       "A tool for setting and publishing joint state values for a URDF")
      (license license:bsd-3))))

(define-public ros-noetic-joint-state-publisher-gui
  (let ((commit "ccb4446b9092e7f6d7956d7058d17745df7f8475")
        (revision "0"))
    (package
      (name "ros-noetic-joint-state-publisher-gui")
      (version (git-version "1.15.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/joint_state_publisher")
               (commit commit)))
         (sha256
          (base32 "0i1ilshhxk5mvmzl9f4nrvf2cirxy52j1snv10d80ypgq91lh91m"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest))
      (propagated-inputs (list ros-noetic-rospy
                               ros-noetic-joint-state-publisher
                               ros-noetic-python-qt-binding))
      (arguments
       (list
        #:package-dir "joint_state_publisher_gui"))
      (home-page "https://wiki.ros.org/joint_state_publisher_gui")
      (synopsis
       "GUI tool for setting and publishing joint state values for a given URDF")
      (description
       "GUI tool for setting and publishing joint state values for a URDF")
      (license license:bsd-3))))
