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

(define-module (ros-noetic diagnostics)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (gnu packages disk)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages python-xyz)
  #:use-module (ros-noetic bond-core)
  #:use-module (ros-noetic common-msgs)
  #:use-module (ros-noetic geometry)
  #:use-module (ros-noetic ros)
  #:use-module (ros-noetic ros-core)
  #:use-module (ros-noetic ros-comm)
  #:use-module (guix build-system catkin))

;;; Commentary:
;;;
;;;
;;; Packages that are part of the diagnostics metapackage
;;;
;;; Code:


(define-public ros-noetic-rosdiagnostic
  (let ((commit "43557d53cd1073d01affc1ad5dd10a3eb9cd8782")
        (revision "0"))
    (package
      (name "ros-noetic-rosdiagnostic")
      (version (git-version "1.12.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/diagnostics")
               (commit commit)))
         (sha256
          (base32 "1iy1aaxy67gk0wzisi0qq36n9f6cscn5cwriwk6vbg871dlasx53"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-rospy ros-noetic-diagnostic-msgs))
      (arguments
       (list
        #:package-dir "rosdiagnostic"))
      (home-page "https://github.com/ros/diagnostics/tree/1.12.1")
      (synopsis "Print aggregated diagnostic contents to the command line")
      (description "Print aggregated diagnostic contents to the command line.")
      (license license:bsd-3))))

(define-public ros-noetic-diagnostic-updater
  (let ((commit "43557d53cd1073d01affc1ad5dd10a3eb9cd8782")
        (revision "0"))
    (package
      (name "ros-noetic-diagnostic-updater")
      (version (git-version "1.12.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/diagnostics")
               (commit commit)))
         (sha256
          (base32 "1iy1aaxy67gk0wzisi0qq36n9f6cscn5cwriwk6vbg871dlasx53"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest))
      (propagated-inputs (list ros-noetic-roscpp
                               ros-noetic-diagnostic-msgs
                               ros-noetic-std-msgs))
      (arguments
       (list
        #:package-dir "diagnostic_updater"))
      (home-page "http://wiki.ros.org/diagnostic_updater")
      (synopsis "Tools for easily updating diagnostics")
      (description "Tools for easily updating diagnostics.
Commonly used in device drivers to keep track of the status
of output topics, device status, etc.")
      (license license:bsd-3))))

(define-public ros-noetic-diagnostic-common-diagnostics
  (let ((commit "43557d53cd1073d01affc1ad5dd10a3eb9cd8782")
        (revision "0"))
    (package
      (name "ros-noetic-diagnostic-common-diagnostics")
      (version (git-version "1.12.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/diagnostics")
               (commit commit)))
         (sha256
          (base32 "1iy1aaxy67gk0wzisi0qq36n9f6cscn5cwriwk6vbg871dlasx53"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest))
      (propagated-inputs (list ros-noetic-rospy
                               ros-noetic-diagnostic-msgs
                               ros-noetic-diagnostic-updater
                               python-psutil
                               lm-sensors
                               hddtemp
                               ros-noetic-tf))
      (arguments
       (list
        #:package-dir "diagnostic_common_diagnostics"))
      (home-page "http://wiki.ros.org/diagnostic_common_diagnostics")
      (synopsis "Common Diagnostics")
      (description "Common Diagnostics for ROS.")
      (license license:bsd-3))))

(define-public ros-noetic-diagnostic-analysis
  (let ((commit "43557d53cd1073d01affc1ad5dd10a3eb9cd8782")
        (revision "0"))
    (package
      (name "ros-noetic-diagnostic-analysis")
      (version (git-version "1.12.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/diagnostics")
               (commit commit)))
         (sha256
          (base32 "1iy1aaxy67gk0wzisi0qq36n9f6cscn5cwriwk6vbg871dlasx53"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest))
      (propagated-inputs (list ros-noetic-diagnostic-msgs ros-noetic-rosbag
                               ros-noetic-roslib))
      (arguments
       (list
        #:package-dir "diagnostic_analysis"))
      (home-page "http://wiki.ros.org/diagnostic_analysis")
      (synopsis "Convert diagnostic logs into CSV files")
      (description
       "Convert a log of diagnostics data
into a series of CSV files.  Robot logs are recorded with rosbag, and
can be processed offline using the scripts in this package")
      (license license:bsd-3))))

(define-public ros-noetic-diagnostic-aggregator
  (let ((commit "43557d53cd1073d01affc1ad5dd10a3eb9cd8782")
        (revision "0"))
    (package
      (name "ros-noetic-diagnostic-aggregator")
      (version (git-version "1.12.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/diagnostics")
               (commit commit)))
         (sha256
          (base32 "1iy1aaxy67gk0wzisi0qq36n9f6cscn5cwriwk6vbg871dlasx53"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest))
      (propagated-inputs (list ros-noetic-diagnostic-msgs
                               ros-noetic-pluginlib
                               ros-noetic-roscpp
                               ros-noetic-rospy
                               ros-noetic-xmlrpcpp
                               ros-noetic-bondcpp
                               ros-noetic-bondpy))
      (arguments
       (list
        #:package-dir "diagnostic_aggregator"))
      (home-page "http://wiki.ros.org/diagnostic_aggregator")
      (synopsis "Aggregate and perform basic analysis on robot diagnostics")
      (description
       "Aggregates and performs basic analysis on the diagnostics of a robot.
This package consists of the base node, or aggregator, and several
analyzers to collect and process diagnostics data.")
      (license license:bsd-3))))

(define-public ros-noetic-self-test
  (let ((commit "43557d53cd1073d01affc1ad5dd10a3eb9cd8782")
        (revision "0"))
    (package
      (name "ros-noetic-self-test")
      (version (git-version "1.12.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/diagnostics")
               (commit commit)))
         (sha256
          (base32 "1iy1aaxy67gk0wzisi0qq36n9f6cscn5cwriwk6vbg871dlasx53"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest))
      (propagated-inputs (list ros-noetic-diagnostic-msgs
                               ros-noetic-diagnostic-updater ros-noetic-roscpp))
      (arguments
       (list
        #:package-dir "self_test"))
      (home-page "http://wiki.ros.org/self_test")
      (synopsis
       "Used to sequence a set of tests to run in order to test a device")
      (description
       "Contains the self_test::TestRunner class that can be used
to sequence a set of tests to be run in order to test a device.
It advertises a self_test service.  When the service is called, the
self_test::TestRunner calls the tests that have been defined in order, and
combines the results into a diagnostic_msgs::DiagnosticsArray.
A detailed example can be found in selftest_example.cpp.")
      (license license:bsd-3))))
