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
  #:use-module (gnu packages qt)
  #:use-module (gnu packages python-xyz)
  #:use-module (ros-noetic bootstrap)
  #:use-module (ros-noetic common-msgs)
  #:use-module (ros-noetic qt-gui-core)
  #:use-module (ros-noetic ros)
  #:use-module (ros-noetic robot)
  #:use-module (ros-noetic ros-base)
  #:use-module (ros-noetic ros-comm)
  #:use-module (ros-noetic ros-core)
  #:use-module (ros-noetic ros-visualization)
  #:use-module (ros-noetic image-common)
  #:use-module (ros-noetic vision-opencv)
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
      (name "ros-noetic-rqt-image-view")
      (version (git-version "0.4.19" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_image_view")
               (commit commit)))
         (sha256
          (base32 "1vian4cjfp1f41r36sbvgir0sdwj718k56hya5m4k0zpcizx33ij"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-cv-bridge
                               ros-noetic-geometry-msgs
                               ros-noetic-image-transport
                               ros-noetic-python-qt-binding
                               ros-noetic-qt-dotgraph
                               ros-noetic-qt-gui
                               ros-noetic-qt-gui-py-common
                               ros-noetic-rqt-graph
                               ros-noetic-rqt-gui-cpp
                               ros-noetic-rqt-gui-py
                               qtbase-5))
      (home-page "https://wiki.ros.org/rqt_image_view")
      (synopsis "GUI plugin for displaying images using image transport")
      (description "GUI plugin for displaying images using image transport.")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-launch
  (let ((commit "f95c99093aabe3f94ecfc720806f2032f0258785")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-launch")
      (version (git-version "0.4.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_launch")
               (commit commit)))
         (sha256
          (base32 "1xs506gbpdm454mgmy9akpfrf5jz08dlqdrpismdiawhx3nffmbj"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-rqt-py-common
                               ros-noetic-roslaunch
                               ros-noetic-rospy
                               ros-noetic-rqt-console
                               ros-noetic-rqt-gui
                               ros-noetic-rqt-gui-py))
      (home-page "https://wiki.ros.org/rqt_launch")
      (synopsis "Provide an easy view of launch files")
      (description "Provides an easy view of launchfiles and lets
the user start and stop individual nodes in a launchfile.")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-publisher
  (let ((commit "dbeedea0f1f7e3287b5d85643fc8d47028f4df83")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-publisher")
      (version (git-version "0.4.12" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_publisher")
               (commit commit)))
         (sha256
          (base32 "1yg63cylrwnfg52g8058qfxf0612nwx0gql6hzbmhr65cm3ifygn"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list python-rospkg
                               ros-noetic-python-qt-binding
                               ros-noetic-qt-gui-py-common
                               ros-noetic-roslib
                               ros-noetic-rosmsg
                               ros-noetic-rqt-gui
                               ros-noetic-rqt-gui-py
                               ros-noetic-rqt-py-common))
      (home-page "https://wiki.ros.org/rqt_launch")
      (synopsis "GUI plugin for publishing arbitrary messages")
      (description "GUI plugin for publishing arbitrary messages
with fixed or computed field values.")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-py-console
  (let ((commit "9f48b5ee299e3d70a8a289c70e5c2aa077811fe1")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-py-console")
      (version (git-version "0.4.12" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_py_console")
               (commit commit)))
         (sha256
          (base32 "1kwkbf6w08brchwl9x92clcr3hiz0gszsl14w43lwdbmlkkrjbkc"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list python-rospkg
                               ros-noetic-python-qt-binding
                               ros-noetic-qt-gui
                               ros-noetic-qt-gui-py-common
                               ros-noetic-rospy
                               ros-noetic-rqt-gui
                               ros-noetic-rqt-gui-py))
      (home-page "https://wiki.ros.org/rqt_py_console")
      (synopsis "GUI plugin for an interactive python console")
      (description "GUI plugin for an interactive python console.")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-reconfigure
  (let ((commit "e0b0f61dfeb1bef85a503787d967a572e02e0933")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-reconfigure")
      (version (git-version "0.5.7" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_reconfigure")
               (commit commit)))
         (sha256
          (base32 "1wg6fmspfmn1r77y57a0bs2kjnrv87ifcykpacjf4al74kb27a13"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-roslint ros-noetic-rostest))
      (propagated-inputs (list ros-noetic-dynamic-reconfigure
                               ros-noetic-python-qt-binding
                               python-pyyaml
                               ros-noetic-rospy
                               ros-noetic-rqt-console
                               ros-noetic-rqt-gui
                               ros-noetic-rqt-gui-py
                               ros-noetic-rqt-py-common))
      (home-page "https://wiki.ros.org/rqt_reconfigure")
      (synopsis
       "GUI plugin for viewing and and editing dynamic_reconfigure parameters")
      (description
       "GUI plugin for viewing and and editing dynamic_reconfigure parameters.
Succeeds the reconfigure_gui.  In the future, arbitrary parameters that are not associated
with any nodes (which are not handled by dynamic_reconfigure) might become handled.
However, currently as the name indicates, this package solely is dependent
on dynamic_reconfigure that allows access to only those parameters latched to nodes.")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-service-caller
  (let ((commit "fdbae3309acdd94efa71af860d2636b6175b1fe3")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-service-caller")
      (version (git-version "0.4.12" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_service_caller")
               (commit commit)))
         (sha256
          (base32 "14slz54gy6kqsp4f65rcvmg2db5mwz0q42kkyag83fv8dpdynzhp"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-roslint ros-noetic-rostest))
      (propagated-inputs (list python-rospkg ros-noetic-rosservice
                               ros-noetic-rqt-gui ros-noetic-rqt-gui-py
                               ros-noetic-rqt-py-common))
      (home-page "https://wiki.ros.org/rqt_service_caller")
      (synopsis "GUI plugin for calling arbitrary services")
      (description "GUI plugin for calling arbitrary services.")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-shell
  (let ((commit "93d5913b2a9fb10665c8f8a9eed626a9a55a6366")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-shell")
      (version (git-version "0.4.13" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_shell")
               (commit commit)))
         (sha256
          (base32 "15c2sh5fl9k4mc7ijf3yqxvdgsc84m0q8c8nrzp00f89dmahg3ny"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list python-rospkg
                               ros-noetic-python-qt-binding
                               ros-noetic-qt-gui
                               ros-noetic-qt-gui-py-common
                               ros-noetic-rqt-gui
                               ros-noetic-rqt-gui-py))
      (home-page "https://wiki.ros.org/rqt_shell")
      (synopsis "GUI plugin providing an interactive shell")
      (description "GUI plugin providing an interactive shell.")
      (license license:bsd-3))))


(define-public ros-noetic-rqt-srv
  (let ((commit "1bfd76b033d9fab9a9c60c7fc0a18c19010c46b8")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-srv")
      (version (git-version "0.4.11" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_srv")
               (commit commit)))
         (sha256
          (base32 "0f01c5f93dxbmkbry16y78bh3rrrwkq9wfayrjvfak25ync18k25"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-rosmsg ros-noetic-rospy
                               ros-noetic-rqt-gui ros-noetic-rqt-gui-py
                               ros-noetic-rqt-msg))
      (home-page "https://wiki.ros.org/rqt_srv")
      (synopsis "GUI plugin for introspecting available service types")
      (description
       "GUI plugin for introspecting available service types.
Note that the services avalailable through this plugin are the ones stored
on your machine, not on the ROS core your rqt instance connects to.")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-top
  (let ((commit "1cc0b3dc3d5a43c622341e3deb3336fe0afda529")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-top")
      (version (git-version "0.4.11" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_top")
               (commit commit)))
         (sha256
          (base32 "1gxdk7ddarkmg2x6fn2aswi90n3l7nsmq5mslfgi6knb30m6rkd5"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list python-psutil ros-noetic-python-qt-binding
                               ros-noetic-rospy ros-noetic-rqt-gui
                               ros-noetic-rqt-gui-py))
      (home-page "https://wiki.ros.org/rqt_top")
      (synopsis "GUI plugin for managing ROS processes")
      (description "GUI plugin for managing ROS processes.")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-topic
  (let ((commit "27feb7b57bb760127c1ef4d331909e5774b53a03")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-topic")
      (version (git-version "0.4.15" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_topic")
               (commit commit)))
         (sha256
          (base32 "1akf10ni03q805wn8yg70n58wx79vivwfi58z8r715wf0p8cbmyj"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list python-rospkg ros-noetic-python-qt-binding
                               ros-noetic-rostopic ros-noetic-rqt-gui
                               ros-noetic-rqt-gui-py))
      (home-page "https://wiki.ros.org/rqt_topic")
      (synopsis "GUI plugin for displaying debug information about ROS topics")
      (description
       "GUI plugin for displaying debug information for ROS topics.
Includes information about publishers, subscribers, publishing rate
and ROS messages.")
      (license license:bsd-3))))

(define-public ros-noetic-rqt-web
  ;; TODO: This does not work, it needs a dependency on pyqt5-webkit, which are
  ;; python bindings for the QtWebkit. A custom version of qt is likely needed to implement that
  (let ((commit "7b3442e70e7256cb1beaaae192ad6e7f3fdacd31")
        (revision "0"))
    (package
      (name "ros-noetic-rqt-web")
      (version (git-version "0.4.11" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros-visualization/rqt_web")
               (commit commit)))
         (sha256
          (base32 "1xyhdp8p7f9z146wr7da2a827skgf9pcac5dz2d37fc01m4yxa17"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-python-qt-binding
                               python-rospkg
                               ros-noetic-qt-gui
                               ros-noetic-rospy
                               ros-noetic-rqt-gui
                               ros-noetic-rqt-gui-py))
      (home-page "https://wiki.ros.org/rqt_web")
      (synopsis "Simple web content viewer for rqt")
      (description
       "Web content viewer for rqt.
Users can show web content in Qt-based window by specifying its URL.")
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
          (base32 "0bi82bbvpqdasnabxxahiks3rw1hblpchn5lrjjnk40i41f9r7jk"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-rqt-action
                               ros-noetic-rqt-bag
                               ros-noetic-rqt-bag-plugins
                               ros-noetic-rqt-console
                               ros-noetic-rqt-dep
                               ros-noetic-rqt-graph
                               ros-noetic-rqt-image-view
                               ros-noetic-rqt-launch
                               ros-noetic-rqt-logger-level
                               ros-noetic-rqt-msg
                               ros-noetic-rqt-plot
                               ros-noetic-rqt-publisher
                               ros-noetic-rqt-py-common
                               ros-noetic-rqt-py-console
                               ros-noetic-rqt-reconfigure
                               ros-noetic-rqt-service-caller
                               ros-noetic-rqt-shell
                               ros-noetic-rqt-srv
                               ros-noetic-rqt-top
                               ros-noetic-rqt-topic
                               ros-noetic-rqt-web))
      (home-page "https://wiki.ros.org/rqt_common_plugins")
      (synopsis "ROS backend graphical tools suite")
      (description
       "ROS backend graphical tools suite that can be
used on/off at robot runtime.
To run any rqt plugins, just run rqt and select the desired plugins from the gui.
rqt consists of 3 metapackages:
rqt - core modules of the ROS GUI framework
rqt_common_plugins - This package
rqt_robot_plugins - plugins used with robots during runtime.")
      (license license:bsd-3))))
