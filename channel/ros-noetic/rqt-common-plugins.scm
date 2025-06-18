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

(define-module (ros-noetic rqt-common-plugins)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system catkin)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (gnu packages check)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages python-xyz)
  #:use-module (ros-noetic bootstrap)
  #:use-module (ros-noetic common-msgs)
  #:use-module (ros-noetic qt-gui-core)
  #:use-module (ros-noetic ros)
  #:use-module (ros-noetic ros-comm)
  #:use-module (ros-noetic ros-core)
  #:use-module (ros-noetic ros-visualization)
  #:use-module (ros-noetic rqt))

;;; Commentary:
;;;
;;;
;;; Packages related to rqt_common_plugins, graphical tools that
;;; can be on/off at robot runtime
;;;
;;; Code:

(define-public ros-noetic-rqt-logger-level
  (let ((commit "cd551135b8a33ec2133409807a12ab49ab6ba2ed")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-logger-level")
      (version (git-version "0.4.11" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_logger_level")
               (commit commit)))
         (sha256
          (base32 "058vc6zjl03rsa3r92h8m211bgx8hznl0fa1p6vw098hvpw6phbv"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list python-rospkg
                               ros-noetic-python-qt-binding
                               ros-noetic-rosnode
                               ros-noetic-rosservice
                               ros-noetic-rospy
                               ros-noetic-rqt-gui
                               ros-noetic-rqt-gui-py))
      (home-page "https://wiki.ros.org/rqt_logger_level")
      (synopsis "GUI plugin for configuring the logger level or ROS nodes")
      (description "GUI plugin for configuring the logger level or ROS nodes.")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-console
  (let ((commit "6084e593dc362850f5fa20961c5dc25082d6143b")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-console")
      (version (git-version "0.4.11" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_console")
               (commit commit)))
         (sha256
          (base32 "1kv2xjnigd8m227anpp8s5vf5426b9x6hy0wvkkd2rg43psh1ncf"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list python-rospkg
                               ros-noetic-python-qt-binding
                               ros-noetic-roslib
                               ros-noetic-rospy
                               ros-noetic-rqt-gui
                               ros-noetic-rqt-gui-py
                               ros-noetic-rqt-logger-level
                               ros-noetic-rqt-py-common))
      (home-page "https://wiki.ros.org/rqt_console")
      (synopsis "GUI plugin for filtering and displaying ROS messages")
      (description "GUI plugin for filtering and displaying ROS messages")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-msg
  (let ((commit "ae57b4fbaef46e053f2844dbc164ffb4697763e9")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-msg")
      (version (git-version "0.4.11" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_msg")
               (commit commit)))
         (sha256
          (base32 "1zdjblby97ix4p5hri5wxh74s511xcmhx1ypn09z6nsa40gpf9jl"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list python-rospkg
                               ros-noetic-python-qt-binding
                               ros-noetic-roslib
                               ros-noetic-rosmsg
                               ros-noetic-rospy
                               ros-noetic-rqt-gui
                               ros-noetic-rqt-gui-py
                               ros-noetic-rqt-py-common
                               ros-noetic-rqt-console))
      (home-page "https://wiki.ros.org/rqt_msg")
      (synopsis "Python GUI plugin for introspecting ROS message types")
      (description
       "Python GUI plugin for introspecting ROS message types.
Note that the msgs available through this plugin are the ones stored on your machine,
not on the ROS core your rqt instance connects to.")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-action
  (let ((commit "0832bd7c6fa45afae0289bc514413f820be4afde")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-action")
      (version (git-version "0.4.11" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_action")
               (commit commit)))
         (sha256
          (base32 "12hv0ky5c5wd0ra2wkbwifhjhn1y8nc5m84x8hi6kcrzvdslwmdb"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-rospy ros-noetic-rqt-msg
                               ros-noetic-rqt-py-common))
      (home-page "https://wiki.ros.org/rqt_action")
      (synopsis "Introspect all avalible ROS action (from actionlib types)")
      (description
       "Introspect all avalible ROS action (from actionlib types).
By using rqt_msg, the output format is unifited with it and rqt_srv.
Note that the actions shown by this plugin are the ones that are stored
on your machine, not on the ROS core your rqt instance connects to.")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-bag
  (let ((commit "7c2983a9e4ae9eb1d3fa9bdfa030dc83e18da749")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-bag")
      (version (git-version "0.5.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_bag")
               (commit commit)))
         (sha256
          (base32 "01awyz5ysjyh9vibgxhkql276faddz21nsg87cl59wylcps1bjxy"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-python-qt-binding
                               python-rospkg
                               ros-noetic-rosbag
                               ros-noetic-rosgraph-msgs
                               ros-noetic-roslib
                               ros-noetic-rosnode
                               ros-noetic-rospy
                               ros-noetic-rqt
                               ros-noetic-rqt-gui-py))
      (arguments
       (list
        #:package-dir "rqt_bag"))
      (home-page "https://wiki.ros.org/rqt_bag")
      (synopsis "GUI plugin for displaying and replaying ROS bag files")
      (description "GUI plugin for displaying and replaying ROS bag files.")
      (license license:bsd-3))))


(define-public ros-noetic-rqt-plot
  ;; TODO: The option to use QwtPlot is not currently available,
  ;; as it would require adding more dependencies that are not in guix
  ;; and the matplotlib backend is good enough for now
  (let ((commit "da86985a4e60fa0987371b43b59a69ebb0bb6670")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-plot")
      (version (git-version "0.4.16" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_plot")
               (commit commit)))
         (sha256
          (base32 "0mmi5pa97hdni4sbarfdh50lspazqyfqk97w18sxrbnkcfd9icig"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list python-matplotlib
                               python-numpy
                               python-rospkg
                               ros-noetic-python-qt-binding
                               ros-noetic-qt-gui-py-common
                               ros-noetic-rosgraph
                               ros-noetic-rostopic
                               ros-noetic-rqt-gui
                               ros-noetic-rqt-gui-py
                               ros-noetic-rqt-py-common
                               ros-noetic-std-msgs))
      (home-page "https://wiki.ros.org/rqt_plot")
      (synopsis "GUI plugin for visualizing numeric values in a 2D plot")
      (description "GUI plugin for visualizing numeric values in a 2D plot,
 using different plotting backends.")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-bag-plugins
  (let ((commit "7c2983a9e4ae9eb1d3fa9bdfa030dc83e18da749")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-bag-plugins")
      (version (git-version "0.5.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_bag")
               (commit commit)))
         (sha256
          (base32 "01awyz5ysjyh9vibgxhkql276faddz21nsg87cl59wylcps1bjxy"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list python-pycairo
                               python-pillow
                               ros-noetic-rosbag
                               ros-noetic-roslib
                               ros-noetic-rospy
                               ros-noetic-rqt-bag
                               ros-noetic-rqt-gui
                               ros-noetic-rqt-gui-py
                               ros-noetic-rqt-plot
                               ros-noetic-sensor-msgs
                               ros-noetic-std-msgs))
      (arguments
       (list
        #:package-dir "rqt_bag"))
      (home-page "https://wiki.ros.org/rqt_bag")
      (synopsis "GUI plugin for displaying and replaying ROS bag files")
      (description "GUI plugin for displaying and replaying ROS bag files.")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-graph
  (let ((commit "f963f0fe020e254139aaf9ccbcd8638e0437aa49")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-graph")
      (version (git-version "0.4.16" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_graph")
               (commit commit)))
         (sha256
          (base32 "0mnapkwrww2d97p33yhx32z5nmkhwc3pq5yw0cwdfj6kbc3gah0w"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list python-rospkg
                               ros-noetic-python-qt-binding
                               ros-noetic-qt-dotgraph
                               ros-noetic-rosgraph
                               ros-noetic-rosgraph-msgs
                               ros-noetic-roslib
                               ros-noetic-rosnode
                               ros-noetic-rospy
                               ros-noetic-rosservice
                               ros-noetic-rostopic
                               ros-noetic-rqt-gui
                               ros-noetic-rqt-gui-py))
      (home-page "https://wiki.ros.org/rqt_dep")
      (synopsis "GUI plugin for visualizing the ROS computation graph")
      (description
       "GUI plguin for visualizing the ROS computation graph.
Its components are made generic so that other packages where you want to
achieve graph representation can depend upon this package.")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-dep
  (let ((commit "b095ffa3777764ff6d15456e874ad69ee6472e6c")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-dep")
      (version (git-version "0.4.14" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_dep")
               (commit commit)))
         (sha256
          (base32 "01iv89djkn4kiw245achx83nkqvrvkm2bsxbrlhqfynyvsyazj42"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list python-mock))
      (propagated-inputs (list python-rospkg
                               ros-noetic-python-qt-binding
                               ros-noetic-qt-dotgraph
                               ros-noetic-qt-gui
                               ros-noetic-qt-gui-py-common
                               ros-noetic-rqt-graph
                               ros-noetic-rqt-gui-py))
      (home-page "https://wiki.ros.org/rqt_dep")
      (synopsis "GUI plugin for visualizing the ROS dependency graph")
      (description "GUI plugin for visualizing the ROS dependency graph")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-image-view
  (let ((commit "ee9e0f08cbefa536b00d87a3fc9a9abc7a94a531")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-dep")
      (version (git-version "0.4.19" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_image_view")
               (commit commit)))
         (sha256
          (base32 "01iv89djkn4kiw245achx83nkqvrvkm2bsxbrlhqfynyvsyazj42"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list python-mock))
      (propagated-inputs (list ros-noetic-cv-bridge
                               ros-noetic-geometry-msgs
                               ros-noetic-image-transport
                               ros-noetic-
                               ros-noetic-python-qt-binding
                               ros-noetic-qt-dotgraph
                               ros-noetic-qt-gui
                               ros-noetic-qt-gui-py-common
                               ros-noetic-rqt-graph
                               ros-noetic-rqt-gui-py))
      (home-page "https://wiki.ros.org/rqt_dep")
      (synopsis "GUI plugin for visualizing the ROS dependency graph")
      (description "GUI plugin for visualizing the ROS dependency graph")
      (license license:bsd-3))))
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
                          ros-noetic-rqt-action
                          ros-noetic-rqt-bag
                          ros-noetic-rqt-bag-plugins
                          ros-noetic-rqt-console
                          ros-noetic-rqt-dep
                          ros-noetic-rqt-graph
;                          ros-noetic-rqt-image-view
;                          ros-noetic-rqt-launch
                          ros-noetic-rqt-logger-level
                          ros-noetic-rqt-msg
                          ros-noetic-rqt-plot
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
