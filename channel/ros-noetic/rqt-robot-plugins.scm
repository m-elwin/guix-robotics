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

(define-module (ros-noetic rqt-robot-plugins)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system catkin)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages check)
  #:use-module (gnu packages python-graphics)
  #:use-module (gnu packages qt)
  #:use-module (ros-noetic bootstrap)
  #:use-module (ros-noetic common-msgs)
  #:use-module (ros-noetic geometry)
  #:use-module (ros-noetic geometry2)
  #:use-module (ros-noetic ros-comm)
  #:use-module (ros-noetic qt-gui-core)
  #:use-module (ros-noetic ros-core)
  #:use-module (ros-noetic rqt)
  #:use-module (ros-noetic rqt-common-plugins)
  #:use-module (ros-noetic ros-visualization)
  )

;;; Commentary:
;;;
;;;
;;; Packages related to rqt_robot_plugins, graphical rqt plugins that
;;; are useful for using with robots at runtime
;;;
;;; Code:

(define-public ros-noetic-rqt-moveit
  (let ((commit "001811e03927d6c51dd363c733a0d25c9a608127")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-moveit")
      (version (git-version "0.5.13" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_moveit")
               (commit commit)))
         (sha256
          (base32 "1jby1h8zxq0iyixj6313cw3byglcsamgq25fqgpkvbzpf6wsf1bq"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-python-qt-binding
                               ros-noetic-rosnode
                               ros-noetic-rospy
                               ros-noetic-rqt-gui
                               ros-noetic-rqt-gui-py
                               ros-noetic-rqt-py-common
                               ros-noetic-rqt-topic
                               ros-noetic-sensor-msgs))
      (home-page "https://wiki.ros.org/rqt_moveit")
      (synopsis "Rqt tool for monitoring MoveIt planner tasks")
      (description
       "Assists in monitoring tasks for the MoveIt motion planner
framework. Currently the following items are monitored if they are either
running, existing, or published:
Node: /movegroup
Parameter: /robot_description /robot_description_semantic
Topic: sensor_msgs/PointCloud, sensor_msgs/PointCloud2
       sensor_msgs/Image, sensor_msgs/CameraInfo

This package is not made by the MoveIt! development team.")
      (license license:bsd-3))))


(define-public ros-noetic-rqt-nav-view
  (let ((commit "7cda2e850ebfe9772fbb66b1524ab2e5d2443bc6")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-nav-view")
      (version (git-version "0.5.8" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_nav_view")
               (commit commit)))
         (sha256
          (base32 "0zyb3k3rx5by9gxp5djb9kdjyrrzm5a27nh2bxqb28l5s8ymnq99"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-geometry-msgs
                               ros-noetic-nav-msgs
                               ros-noetic-python-qt-binding
                               ros-noetic-qt-gui
                               ros-noetic-rospy
                               ros-noetic-rqt-gui
                               ros-noetic-rqt-gui-py
                               ros-noetic-rqt-py-common
                               ros-noetic-tf))
      (home-page "https://wiki.ros.org/rqt_nav_view")
      (synopsis "Gui for viewing navigation maps and paths")
      (description "Gui for viewing navigation maps and paths")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-pose-view
  (let ((commit "3259af8635df3b2d603267cb5f00f7137ee2f5d7")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-pose-view")
      (version (git-version "0.5.13" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_pose_view")
               (commit commit)))
         (sha256
          (base32 "1rha7cxnkmj1z6cplnx6igjn1drwv1wvz1b99dan01j2g0px84rg"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list python-pyopengl
                               ros-noetic-python-qt-binding
                               python-rospkg
                               ros-noetic-rospy
                               ros-noetic-rostopic
                               ros-noetic-rqt-gui
                               ros-noetic-rqt-gui-py
                               ros-noetic-rqt-py-common
                               ros-noetic-tf))
      (home-page "https://wiki.ros.org/rqt_pose_view")
      (synopsis "Gui for viewing 3D Poses")
      (description "Gui for viewing 3D poses")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-robot-monitor
  (let ((commit "f9412e219d31b8d98a48b51d647dc70f9687d7c4")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-robot-monitor")
      (version (git-version "0.5.15" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_robot_monitor")
               (commit commit)))
         (sha256
          (base32 "0223sw42zjfshrb0v2rqa6sqdzj6vm44y6l6zqh6890hkipw0nvd"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-diagnostic-msgs
                               python-rospkg
                               ros-noetic-python-qt-binding
                               ros-noetic-qt-gui
                               ros-noetic-qt-gui-py-common
                               ros-noetic-rospy
                               ros-noetic-rqt-py-common
                               ros-noetic-rqt-gui
                               ros-noetic-rqt-gui-py
                               ros-noetic-rqt-bag))
      (home-page "https://wiki.ros.org/rqt_robot_monitor")
      (synopsis "Display diagnostics_agg topics messages")
      (description "Display diagnostics_agg topics messages that
are published by diagnostic_aggregator.")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-robot-dashboard
  (let ((commit "5c15781848b70a408fd364f430b8211aab379376")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-robot-dashboard")
      (version (git-version "0.5.8" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_robot_dashboard")
               (commit commit)))
         (sha256
          (base32 "0xlfdm75434j2rfdss4sm06mwvynsfr8w1z1qycq5nyqw3pymq7c"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-diagnostic-msgs
                               ros-noetic-python-qt-binding
                               ros-noetic-qt-gui
                               ros-noetic-rospy
                               ros-noetic-rqt-console
                               ros-noetic-rqt-gui
                               ros-noetic-rqt-gui-py
                               ros-noetic-rqt-nav-view
                               ros-noetic-rqt-robot-monitor))
      (home-page "https://wiki.ros.org/rqt_robot_dashboard")
      (synopsis "Infrastructure for building robot dashboard plugins in qt")
      (description
       "Infrastructure for building robot dashboard plugins in qt.")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-robot-steering
  (let ((commit "322885f396b2d140b9875b69ad5bd66b42cc1837")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-robot-steering")
      (version (git-version "0.5.14" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_robot_steering")
               (commit commit)))
         (sha256
          (base32 "1qlvhv4431lmjyzf3lbv9x35sjf41vzz2ri7hssxq51zccf9bmd7"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-geometry-msgs
                               ros-noetic-python-qt-binding python-rospkg
                               ros-noetic-rqt-gui ros-noetic-rqt-gui-py))
      (home-page "https://wiki.ros.org/rqt_robot_steering")
      (synopsis "GUI plugin for steering a robot with Twist messages")
      (description "GUI plugin for steering a robot with Twist messages")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-runtime-monitor
  (let ((commit "a3183c159d3a6bd61958a205f4731b0bc34169d0")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-runtime-monitor")
      (version (git-version "0.5.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_runtime_monitor")
               (commit commit)))
         (sha256
          (base32 "0ig4rgjc91d7h7mc8jikv7098hakj9ysl1iaf907f5f572h22qrh"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-diagnostic-msgs
                               ros-noetic-python-qt-binding
                               python-rospkg
                               ros-noetic-qt-gui
                               ros-noetic-rospy
                               ros-noetic-rqt-gui
                               ros-noetic-rqt-gui-py))
      (home-page "https://wiki.ros.org/rqt_runtime_monitor")
      (synopsis "GUI plugin for viewing DiagnosticsArray Messages")
      (description "GUI plugin for viewing DiagnosticsArray Messages")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-rviz
  (let ((commit "e3cacb5e792f7fb938032efc444d7eeae8c0868c")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-rviz")
      (version (git-version "0.7.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_rviz")
               (commit commit)))
         (sha256
          (base32 "1h0ad7yiih7z9nk78hxdhjc2xc8i1jwhs7g8gnm075nl00x4z8yj"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (inputs (list boost
                    ros-noetic-class-loader
                    qtbase-5
                    ros-noetic-rqt-gui
                    ros-noetic-rqt-gui-cpp))
      (propagated-inputs (list ros-noetic-rviz))
      (home-page "https://wiki.ros.org/rqt_rviz")
      (synopsis "GUI plugin embedding for rviz")
      (description "An rqt plugin for embedding RViz.
This package does not supersed RViz, rather it depends on it.")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-tf-tree
  (let ((commit "5cd6e23fc136508cdfbcaa2cd523806ab83c67a8")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-tf-tree")
      (version (git-version "0.6.5" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_tf_tree")
               (commit commit)))
         (sha256
          (base32 "1qnfcnaajpq9prvwahc898nxyi9013kcm3ias0afx5046cczs0rh"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list python-mock))
      (propagated-inputs (list ros-noetic-python-qt-binding
                               python-rospkg
                               ros-noetic-qt-dotgraph
                               ros-noetic-rospy
                               ros-noetic-rqt-graph
                               ros-noetic-rqt-gui
                               ros-noetic-rqt-gui-py
                               ros-noetic-tf2-msgs
                               ros-noetic-tf2-ros))
      (home-page "https://wiki.ros.org/rqt_tf_tree")
      (synopsis "GUI plugin for visualizing the ROS TF frame tree")
      (description "GUI plugin for visualizing the ROS TF frame tree.")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-robot-plugins
  (let ((commit "aa078795cddead2dc6232acc519364d65696873f")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-robot-plugins")
      (version (git-version "0.5.8" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_robot_plugins")
               (commit commit)))
         (sha256
          (base32 "16sxp7k7ipwpbvypxfih62b73wkmqihjjh62r29bwn18852m3ndw"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list
                          ros-noetic-rqt-moveit
                          ros-noetic-rqt-nav-view
                          ros-noetic-rqt-pose-view
                          ros-noetic-rqt-robot-dashboard
                          ros-noetic-rqt-robot-monitor
                          ros-noetic-rqt-robot-steering
                          ros-noetic-rqt-runtime-monitor
                          ros-noetic-rqt-rviz
                          ros-noetic-rqt-tf-tree))
      (home-page "https://wiki.ros.org/rqt_robot_plugins")
      (synopsis "Visual rqt plugins particularly useful at robot runtime")
      (description
       "Visual rqt plugins particularly useful at robot runtime.
TO run any rqt plugins, just type in 'rqt' then select the plugins from the gui.")
      (license license:bsd-3))))
