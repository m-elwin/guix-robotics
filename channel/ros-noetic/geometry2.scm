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

(define-module (ros-noetic geometry2)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system catkin)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (ros-noetic bootstrap)
  #:use-module (ros-noetic common-msgs)
;  #:use-module (ros-noetic ros)
  #:use-module (ros-noetic ros-core)
  #:use-module (ros-noetic roscpp-core))
;  #:use-module (ros-noetic ros-comm)
;  #:use-module (ros-noetic system))

;;; Commentary:
;;;
;;;
;;; Packages that are part of the geometry2 package
;;; and ROS packages that geometry depends on that
;;; are related to geometry. This is the second
;;; updated implementation. ROS geometry depends on
;;; geometry2. All packages here should be on
;;; the same commit
;;;
;;; Code:

(define-public ros-noetic-tf2-msgs
  (let ((commit "40ce3df158c80cc4ac5edc5b1c22fe833d0cbc4c")
        (revision "0"))
    (package
      (name "ros-noetic-tf2-msgs")
      (version (git-version "0.7.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/geometry2")
               (commit commit)))
         (sha256
          (base32 "18pwww192qrgfxzv1azlg6rlhf4rvsgx97x64ghpbiq1v3p3jypl"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      ;; This package has message_generation as a runtime dependency
      (propagated-inputs (list ros-noetic-actionlib-msgs
                               ros-noetic-geometry-msgs
                               ros-noetic-message-generation))
      (arguments
       (list
        #:package-dir "tf2_msgs"))
      (home-page "https://wiki.ros.org/tf2_msgs")
      (synopsis "Messages for maintaining the tf2 tree")
      (description "Messages for maintaining the tf2 tree.")
      (license license:bsd-3))))

(define-public ros-noetic-tf2
  (let ((commit "40ce3df158c80cc4ac5edc5b1c22fe833d0cbc4c")
        (revision "0"))
    (package
      (name "ros-noetic-tf2")
      (version (git-version "0.7.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/geometry2")
               (commit commit)))
         (sha256
          (base32 "18pwww192qrgfxzv1azlg6rlhf4rvsgx97x64ghpbiq1v3p3jypl"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (inputs (list console-bridge))
      (propagated-inputs (list ros-noetic-geometry-msgs
                               ros-noetic-rostime
                               ros-noetic-tf2-msgs))
      (arguments
       (list
        #:package-dir "tf2"))
      (home-page "https://wiki.ros.org/tf2")
      (synopsis "Second generation ROS transform library")
      (description "Second generation of the transform library, which lets
the user keep track of multiple coordinate frames over time. tf2
maintains the relationship between coordinate frames in a tree
structure buffered in time, and lets the user transform points,
vectors, etc between any two coordinate frames at any desired
point in time.")
      (license license:bsd-3))))

(define-public ros-noetic-tf2-eigen
  (let ((commit "40ce3df158c80cc4ac5edc5b1c22fe833d0cbc4c")
        (revision "0"))
    (package
      (name "ros-noetic-tf2-eigen")
      (version (git-version "0.7.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/geometry2")
               (commit commit)))
         (sha256
          (base32 "18pwww192qrgfxzv1azlg6rlhf4rvsgx97x64ghpbiq1v3p3jypl"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-cmake-modules))
      (propagated-inputs (list eigen ros-noetic-tf2))
      (arguments
       (list
        #:package-dir "tf2_eigen"))
      (home-page "https://wiki.ros.org/tf2_eigen")
      (synopsis "Convert between geometry_msgs and eigen data types")
      (description "Templated conversions as specified in tf/convert.h.
Enables easy conversion from geometry_msgs Transform and Point types to
the types specified by the Eigen matrix algebra library.")
      (license license:bsd-3))))

