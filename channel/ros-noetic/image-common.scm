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

(define-module (ros-noetic image-common)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system catkin)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages image-processing)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages python-xyz)
  #:use-module (ros-noetic ros)
  #:use-module (ros-noetic ros-core)
  #:use-module (ros-noetic ros-comm)
  #:use-module (ros-noetic roscpp-core)
  #:use-module (ros-noetic common-msgs))

;;; Commentary:
;;;
;;;
;;; Packages related to working with camera images in ROS
;;;
;;; Code:

(define-public ros-noetic-image-transport
  (let ((commit "5559cc5ff15c4e94bef7912eabe5e330de62475c")
        (revision "0"))
    (package
      (name "ros-noetic-image-transport")
      (version (git-version "1.12.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-perception/image_common")
               (commit commit)))
         (sha256
          (base32 "0bcraxpz3ffyha36zwnjhs22vsf94s7lvha37mfw1ixycjaxda5p"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (arguments
       (list
        #:package-dir "image_transport"))
      ;; the default gcc-toolchain segfaults when building this package
      ;; so use an updated gcc version
      (native-inputs (list gcc-toolchain-12))
      (inputs (list ros-noetic-roslib))
      (propagated-inputs (list ros-noetic-message-filters ros-noetic-pluginlib
                               ros-noetic-rosconsole ros-noetic-roscpp
                               ros-noetic-sensor-msgs))
      (home-page "https://wiki.ros.org/image_transport")
      (synopsis "Used for transmitting images in compressed formats")
      (description
       "Used to subscribe and publish images. Provides
transparent support for transporting images in low-bandwidth and
compressed formats.  Examples (provided by separate plugin packages)
include JPEG/PNG compression and Theora sreaming video.")
      (license license:bsd-3))))

(define-public ros-noetic-camera-calibration-parsers
  (let ((commit "5559cc5ff15c4e94bef7912eabe5e330de62475c")
        (revision "0"))
    (package
      (name "ros-noetic-camera-calibration-parsers")
      (version (git-version "1.12.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-perception/image_common")
               (commit commit)))
         (sha256
          (base32 "0bcraxpz3ffyha36zwnjhs22vsf94s7lvha37mfw1ixycjaxda5p"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (arguments
       (list
        #:package-dir "camera_calibration_parsers"))
      (native-inputs (list ros-noetic-rosbash ros-noetic-rosunit))
      (inputs (list yaml-cpp ros-noetic-roscpp ros-noetic-roscpp-serialization))
      (propagated-inputs (list boost ros-noetic-sensor-msgs))
      (home-page "https://wiki.ros.org/camera_calibration_parsers")
      (synopsis "Read and and write camera calibration parameters")
      (description "Read and write camera calibration parameters.")
      (license license:bsd-3))))

(define-public ros-noetic-camera-info-manager
  (let ((commit "5559cc5ff15c4e94bef7912eabe5e330de62475c")
        (revision "0"))
    (package
      (name "ros-noetic-camera-info-manager")
      (version (git-version "1.12.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-perception/image_common")
               (commit commit)))
         (sha256
          (base32 "0bcraxpz3ffyha36zwnjhs22vsf94s7lvha37mfw1ixycjaxda5p"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (arguments
       (list
        #:package-dir "camera_info_manager"))
      (native-inputs (list ros-noetic-rostest ros-noetic-image-transport))
      (inputs (list ros-noetic-roslib))
      (propagated-inputs (list boost ros-noetic-camera-calibration-parsers
                               ros-noetic-roscpp ros-noetic-sensor-msgs))
      (home-page "https://wiki.ros.org/camera_info_manager")
      (synopsis "C++ interface for camera calibration information")
      (description
       "Provides CameraInfo and handles SetCameraInfo
service requests, saving and restoring the camera calibration data.")
      (license license:bsd-3))))

(define-public ros-noetic-polled-camera
  (let ((commit "5559cc5ff15c4e94bef7912eabe5e330de62475c")
        (revision "0"))
    (package
      (name "ros-noetic-polled-camera")
      (version (git-version "1.12.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-perception/image_common")
               (commit commit)))
         (sha256
          (base32 "0bcraxpz3ffyha36zwnjhs22vsf94s7lvha37mfw1ixycjaxda5p"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (arguments
       (list
        #:package-dir "polled_camera"))
      (native-inputs (list ros-noetic-message-generation))
      (inputs (list ros-noetic-image-transport))
      (propagated-inputs (list ros-noetic-roscpp ros-noetic-sensor-msgs
                               ros-noetic-std-msgs ros-noetic-message-runtime))
      (home-page "https://wiki.ros.org/polled_camera")
      (synopsis "Service and C++ classes for polled camera driver nodes")
      (description
       "Currently this package is for internal use as APIs are still under development.")
      (license license:bsd-3))))
