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

(define-module (ros-noetic nodelet-core)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system catkin)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages linux)
  #:use-module (ros-noetic bond-core)
  #:use-module (ros-noetic ros)
  #:use-module (ros-noetic ros-base)
  #:use-module (ros-noetic ros-comm)
  #:use-module (ros-noetic ros-core)
  #:use-module (ros-noetic roscpp-core))

;;; Commentary:
;;;
;;;
;;; Packages that are part of nodelet-core
;;; They should all be generally from the same git commit
;;;
;;; Code:


(define-public ros-noetic-nodelet
  (let ((commit "ed2a4e13298e45fc6b8b60fbd3d06c4e65f6d434")
        (revision "0"))
    (package
      (name "ros-noetic-nodelet")
      (version (git-version "1.11.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/nodelet_core")
               (commit commit)))
         (sha256
          (base32 "1ki6rdz3p5v3xa4rw15r9mgkzxnkd21pdcag5mb5rvkq86j1r9cn"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-cmake-modules
                           ros-noetic-message-generation))
      (inputs (list `(,util-linux "lib") ros-noetic-pluginlib))
      (propagated-inputs (list boost
                               ros-noetic-bondcpp
                               ros-noetic-rosconsole
                               ros-noetic-roscpp
                               ros-noetic-std-msgs
                               ros-noetic-message-runtime
                               ros-noetic-rospy))
      (arguments
       (list
        #:package-dir "nodelet"))
      (home-page "https://wiki.ros.org/nodelet")
      (synopsis "Allow multiple algorithms to run in the same process")
      (description
       "Provides a way to run multiple
algorithms in the same process with zero copy transport between
algorithms.

This package provides both the nodelet base class needed for
implementing a nodelet, as well as the NodeletLoader class used
for instantiating nodelets.")
      (license license:bsd-3))))

(define-public ros-noetic-nodelet-topic-tools
  (let ((commit "ed2a4e13298e45fc6b8b60fbd3d06c4e65f6d434")
        (revision "0"))
    (package
      (name "ros-noetic-nodelet-topic-tools")
      (version (git-version "1.11.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/nodelet_core")
               (commit commit)))
         (sha256
          (base32 "1ki6rdz3p5v3xa4rw15r9mgkzxnkd21pdcag5mb5rvkq86j1r9cn"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-cmake-modules
                           ros-noetic-message-generation))
      (inputs (list `(,util-linux "lib") ros-noetic-bondcpp
                    ros-noetic-pluginlib))
      (propagated-inputs (list boost
                               ros-noetic-dynamic-reconfigure
                               ros-noetic-message-filters
                               ros-noetic-nodelet
                               ros-noetic-pluginlib
                               ros-noetic-roscpp))
      (arguments
       (list
        #:package-dir "nodelet_topic_tools"))
      (home-page "https://wiki.ros.org/nodelet_topic_tools")
      (synopsis "Common nodelet tools")
      (description "Common nodelet tools like mux, demux, and throttle.")
      (license license:bsd-3))))

(define-public ros-noetic-nodelet-core
  (let ((commit "ed2a4e13298e45fc6b8b60fbd3d06c4e65f6d434")
        (revision "0"))
    (package
      (name "ros-noetic-nodelet-core")
      (version (git-version "1.11.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/nodelet_core")
               (commit commit)))
         (sha256
          (base32 "1ki6rdz3p5v3xa4rw15r9mgkzxnkd21pdcag5mb5rvkq86j1r9cn"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-nodelet
                               ros-noetic-nodelet-topic-tools))
      (arguments
       (list
        #:package-dir "nodelet_core"))
      (home-page "https://wiki.ros.org/nodelet_core")
      (synopsis "Nodelet Core Metapackage")
      (description "Nodelet Core Metapackage")
      (license license:bsd-3))))
