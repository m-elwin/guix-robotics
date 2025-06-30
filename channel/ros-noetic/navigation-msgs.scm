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

(define-module (ros-noetic navigation-msgs)
  #:use-module (guix build-system catkin)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (ros-noetic common-msgs)
  #:use-module (ros-noetic ros-core))

;; Commentary:
;;
;; Packages that are part of ros-navigation-msgs
;;
;; Code:


(define-public ros-noetic-map-msgs
  (let ((commit "18fc8567a6ff86ca3b48370c610b2300c3f561f2")
        (revision "0"))
    (package
      (name "ros-noetic-map-msgs")
      (version (git-version "1.14.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-planning/navigation_msgs")
               (commit commit)))
         (sha256
          (base32 "0nigra7k57yq77jwia1dx8gayagsdj7q26la6f4vkdr3s5hc9ncy"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation ))
      (propagated-inputs (list ros-noetic-message-runtime
                               ros-noetic-std-msgs
                               ros-noetic-nav-msgs
                               ros-noetic-sensor-msgs))
      (arguments
       (list
        #:package-dir "map_msgs"))
      (home-page "https://wiki.ros.org/map_msgs")
      (synopsis
       "Messages commonly used in mapping packages")
      (description
       "Messages commonly used in mapping packages.")
      (license license:bsd-3))))
