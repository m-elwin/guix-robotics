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
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages engineering)
  #:use-module (gnu packages game-development)
  #:use-module (ros-noetic bootstrap)
  #:use-module (ros-noetic common-msgs)
  #:use-module (ros-noetic ros-base)
  #:use-module (ros-noetic ros-core)
  #:use-module (ros-noetic roscpp-core)
  #:use-module (ros-noetic ros-comm)
  #:use-module (ros-noetic system))

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
      (propagated-inputs (list ros-noetic-geometry-msgs ros-noetic-rostime
                               ros-noetic-tf2-msgs))
      (arguments
       (list
        #:package-dir "tf2"))
      (home-page "https://wiki.ros.org/tf2")
      (synopsis "Second generation ROS transform library")
      (description
       "Second generation of the transform library, which lets
the user keep track of multiple coordinate frames over time. tf2
maintains the relationship between coordinate frames in a tree
structure buffered in time, and lets the user transform points,
vectors, etc between any two coordinate frames at any desired
point in time.")
      (license license:bsd-3))))

(define-public ros-noetic-tf2-py
  (let ((commit "40ce3df158c80cc4ac5edc5b1c22fe833d0cbc4c")
        (revision "0"))
    (package
      (name "ros-noetic-tf2-py")
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
      (propagated-inputs (list ros-noetic-tf2 ros-noetic-rospy))
      (arguments
       (list
        #:package-dir "tf2_py"))
      (home-page "https://wiki.ros.org/tf2_py")
      (synopsis "Convert tf2 and geometry_msgs to PyObjects")
      (description "Convert tf2 and geometry_msgs to PyObjects and
bind tf2 functionality to python.  This is an implementation
package, users generally should use tf2_ros.")
      (license license:bsd-3))))

(define-public ros-noetic-tf2-ros
  (let ((commit "40ce3df158c80cc4ac5edc5b1c22fe833d0cbc4c")
        (revision "0"))
    (package
      (name "ros-noetic-tf2-ros")
      (version (git-version "0.7.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/geometry2")
               (commit commit)))
         (sha256
          (base32 "18pwww192qrgfxzv1azlg6rlhf4rvsgx97x64ghpbiq1v3p3jypl"))
         (file-name (git-file-name name version))
         (modules '((guix build utils)))
         (snippet
          ;; There were known flakiness in time_reset_test.cpp and message_filter_test.cpp
          ;; that were never fully resolved: likely some race condition.
          ;; Issue as tracked here: https://github.com/ros/geometry2/issues/129
          ;; but never resolved. For maximum reproducability, disable these tests
          '(substitute* "tf2_ros/CMakeLists.txt"
             (("add_rostest\\(test/transform_listener_time_reset_test.launch\\)") "")))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-cmake-modules ros-noetic-rostest))
      (inputs (list ros-noetic-xmlrpcpp))
      (propagated-inputs (list ros-noetic-actionlib
                               ros-noetic-actionlib-msgs
                               ros-noetic-geometry-msgs
                               ros-noetic-message-filters
                               ros-noetic-roscpp
                               ros-noetic-rosgraph
                               ros-noetic-rospy
                               ros-noetic-std-msgs
                               ros-noetic-tf2
                               ros-noetic-tf2-msgs
                               ros-noetic-tf2-py))
      (arguments
       (list
        #:package-dir "tf2_ros"))
      (home-page "https://wiki.ros.org/tf2_ros")
      (synopsis "ROS bindings for the tf2 library")
      (description
       "ROS bindings for the tf2 library, including python and C++.")
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
      (propagated-inputs (list eigen ros-noetic-tf2 ros-noetic-geometry-msgs))
      (arguments
       (list
        #:package-dir "tf2_eigen"))
      (home-page "https://wiki.ros.org/tf2_eigen")
      (synopsis "Convert between geometry_msgs and eigen data types")
      (description
       "Templated conversions as specified in tf/convert.h.
Enables easy conversion from geometry_msgs Transform and Point types to
the types specified by the Eigen matrix algebra library.")
      (license license:bsd-3))))


(define-public ros-noetic-tf2-bullet
  (let ((commit "40ce3df158c80cc4ac5edc5b1c22fe833d0cbc4c")
        (revision "0"))
    (package
      (name "ros-noetic-tf2-bullet")
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
      (propagated-inputs (list bullet ros-noetic-tf2 ros-noetic-geometry-msgs))
      (arguments
       (list
        #:package-dir "tf2_bullet"))
      (home-page "https://wiki.ros.org/tf2_bullet")
      (synopsis "Convert between geometry_msgs and bullet data types")
      (description
       "Templated conversions as specified in tf/convert.h.
Enables easy conversion from geometry_msgs Transform and Point types to
the types specified by the Bullet engine API see http://bulletphysics.org.")
      (license license:bsd-3))))

(define-public ros-noetic-tf2-kdl
  (let ((commit "40ce3df158c80cc4ac5edc5b1c22fe833d0cbc4c")
        (revision "0"))
    (package
      (name "ros-noetic-tf2-kdl")
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
      (native-inputs (list ros-noetic-cmake-modules ros-noetic-rostest
                           ros-noetic-ros-environment))
      (propagated-inputs (list orocos-kinematics-dynamics
                               python-orocos-kinematics-dynamics
                               eigen
                               ros-noetic-tf2
                               ros-noetic-geometry-msgs
                               ros-noetic-tf2-ros))
      (arguments
       (list
        #:package-dir "tf2_kdl"))
      (home-page "https://wiki.ros.org/tf2_kdl")
      (synopsis "Convert between geometry_msgs and KDL data types")
      (description
       "Templated conversions as specified in tf/convert.h.
Enables easy conversion from geometry_msgs Transform and Point types to
the types specified by Orocos KDL.")
      (license license:bsd-3))))

(define-public ros-noetic-tf2-geometry-msgs
  (let ((commit "40ce3df158c80cc4ac5edc5b1c22fe833d0cbc4c")
        (revision "0"))
    (package
      (name "ros-noetic-tf2-geometry-msgs")
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
      (native-inputs (list ros-noetic-rostest ros-noetic-ros-environment))
      (propagated-inputs (list orocos-kinematics-dynamics python-orocos-kinematics-dynamics ros-noetic-tf2
                               ros-noetic-geometry-msgs ros-noetic-tf2-ros))
      (arguments
       (list
        #:package-dir "tf2_geometry_msgs"))
      (home-page "https://wiki.ros.org/tf2_geometry_msgs")
      (synopsis "Convert between various geometry_msgs data types")
      (description
       "This library is an implementation of the templated conversion
 interface specified in tf/convert.h.  It offers conversion and
transform convenience functions between various geometry_msgs data types,
such as Vector, Point, Pose, Transform, Quaternion, etc.")
      (license license:bsd-3))))

(define-public ros-noetic-tf2-sensor-msgs
  (let ((commit "40ce3df158c80cc4ac5edc5b1c22fe833d0cbc4c")
        (revision "0"))
    (package
      (name "ros-noetic-tf2-sensor-msgs")
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
      (native-inputs (list ros-noetic-rostest ros-noetic-geometry-msgs
                           ros-noetic-cmake-modules))
      (propagated-inputs (list eigen
                               ros-noetic-rospy
                               python-orocos-kinematics-dynamics
                               ros-noetic-tf2-ros
                               ros-noetic-tf2
                               ros-noetic-sensor-msgs))
      (arguments
       (list
        #:package-dir "tf2_sensor_msgs"))
      (home-page "https://wiki.ros.org/tf2_sensor_msgs")
      (synopsis "Convert sensor_msgs with tf")
      (description "Convert sensor_msgs such as PointCloud2 with tf types.")
      (license license:bsd-3))))

(define-public ros-noetic-tf2-tools
  (let ((commit "40ce3df158c80cc4ac5edc5b1c22fe833d0cbc4c")
        (revision "0"))
    (package
      (name "ros-noetic-tf2-tools")
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
      (propagated-inputs (list ros-noetic-tf2 ros-noetic-tf2-msgs
                               ros-noetic-tf2-ros))
      (arguments
       (list
        #:package-dir "tf2_tools"))
      (home-page "https://wiki.ros.org/tf2_tools")
      (synopsis "Tools for working with tf2")
      (description
       "Tools for working with transforms, as implemented by tf2.
Allows echoing frames and creating an graphical view of the frame
relationships")
      (license license:bsd-3))))

(define-public ros-noetic-geometry2
  (let ((commit "40ce3df158c80cc4ac5edc5b1c22fe833d0cbc4c")
        (revision "0"))
    (package
      (name "ros-noetic-geometry2")
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
      (propagated-inputs (list ros-noetic-tf2
                               ros-noetic-tf2-bullet
                               ros-noetic-tf2-eigen
                               ros-noetic-tf2-geometry-msgs
                               ros-noetic-tf2-kdl
                               ros-noetic-tf2-msgs
                               ros-noetic-tf2-py
                               ros-noetic-tf2-ros
                               ros-noetic-tf2-sensor-msgs
                               ros-noetic-tf2-tools))
      (arguments
       (list
        #:package-dir "geometry2"))
      (home-page "https://wiki.ros.org/geometry2")
      (synopsis "Metapackage for 2nd generation  ROS transform library, tf2")
      (description
       "Metapackage for 2nd generation  ROS transform library, tf2.")
      (license license:bsd-3))))
