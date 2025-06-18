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

(define-module (ros-noetic vision-opencv)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system catkin)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages image-processing)
  #:use-module (gnu packages python-xyz)
  #:use-module (ros-noetic ros)
  #:use-module (ros-noetic ros-comm)
  #:use-module (ros-noetic common-msgs))

;;; Commentary:
;;;
;;;
;;; Packages related to computer vision/OpenCV n ROS.
;;;
;;; Code:

(define-public ros-noetic-cv-bridge
  (let ((commit "08b012c038e575d7fe1d538f11235a994159dc93")
        (revision "0"))
    (package
      (name "ros-noetic-cv-bridge")
      (version (git-version "1.16.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-perception/vision_opencv")
               (commit commit)))
         (sha256
          (base32 "037a4ms8qkb9fnymgspp4agiikkfxj1h6qlzcsmp78dyvkx3kdfk"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (arguments (list #:package-dir "cv_bridge"))
      (native-inputs (list ros-noetic-rostest))
      (propagated-inputs (list boost opencv ros-noetic-rosconsole ros-noetic-sensor-msgs python-numpy))
      (home-page "https://wiki.ros.org/python_qt_binding")
      (synopsis "Convert between ROS Image messages and OpenCV images")
      (description "Convert between ROS Image messages and OpenCV images.")
      (license license:bsd-3))))

