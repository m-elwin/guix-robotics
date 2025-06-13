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

(define-module (ros-noetic rqt)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system catkin)
  #:use-module (guix packages)
  #:use-module (guix git-download))

;;; Commentary:
;;;
;;;
;;; Packages related to rqt_common_plugins, graphical tools that
;;; can be on/off at robot runtime
;;;
;;; Code:


(define-public ros-noetic-rqt-common-plugins
  (let ((commit "73b0ebc69a6a36fbbce68d56c05dcf961a50ea59")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-common-plugins")
      (version (git-version "0.4.11" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_common_plugins")
               (commit commit)))
         (sha256
          (base32 "0iwspznn0dmjhf0lbv7snjj17gadrmmzsbvp21sjpmjfimznifl9"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list
;                          ros-noetic-rqt-action
;                          ros-noetic-rqt-bag
;                          ros-noetic-rqt-bag-plugins
;                          ros-noetic-rqt-console
;                          ros-noetic-rqt-dep
;                          ros-noetic-rqt-graph
;                          ros-noetic-rqt-image-view
;                          ros-noetic-rqt-launch
;                          ros-noetic-rqt-logger-level
;                          ros-noetic-rqt-msg
;                          ros-noetic-rqt-plot
;                          ros-noetic-rqt-publisher
;                          ros-noetic-rqt-py-common
;                          ros-noetic-rqt-py-console
;                          ros-noetic-rqt-reconfigure
;                          ros-noetic-rqt-service-caller
;                          ros-noetic-rqt-shell
;                          ros-noetic-rqt-srv
;                          ros-noetic-rqt-top
;                          ros-noetic-rqt-topic
;                         ros-noetic-rqt-web
                          ))
      (home-page "https://wiki.ros.org/rqt_common_plugins")
      (synopsis "ROS backend graphical tools suite")
      (description "ROS backend graphical tools suite that can be
used on/off at robot runtime.
To run any rqt plugins, just run rqt and select the desired plugins from the gui.
rqt consists of 3 metapackages:
rqt - core modules of the ROS GUI framework
rqt_common_plugins - This package
rqt_robot_plugins - plugins used with robots during runtime.")
      (license license:bsd-3))))
