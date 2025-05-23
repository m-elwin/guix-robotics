(define-module (ros-noetic ros-comm)
  #:use-module (guix build-system catkin)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix search-paths)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (gnu packages apr)
  #:use-module (gnu packages base)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages check)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages cpp)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages lisp)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-crypto)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages xml)
  #:use-module (ros-noetic bootstrap)
  #:use-module (ros-noetic core)
  #:use-module (ros-noetic common-msgs)
  #:use-module (ros-noetic ros)
  #:use-module (ros-noetic ros-comm-msgs)
  #:use-module (ros-noetic roscpp-core)
  #:use-module (contributed))


(define-public ros-noetic-xmlrpcpp
  (let ((commit "b6c57e76a764252cf50d8d24053f32e2ad54a264")
        (revision "0"))
    (package
      (name "ros-noetic-xmlrpcpp")
      (version (git-version "1.17.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0baagfh3933y2si4sz7iqr5mzcyncjghgj4jz0bd7axv9y46nkzb"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-cpp-common boost))
      (propagated-inputs (list ros-noetic-rostime))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "utilities/xmlrpcpp"))))))
      (home-page "https://wiki.ros.org/xmlrpcpp")
      (synopsis "C++ implementation of the XML-RPC protocol")
      (description "This version is heavily modified from the package available
on SourceForge in order to support roscpp's threading model.
 As such, we are maintaining our own fork.")
      (license license:bsd-3))))


(define-public ros-noetic-roscpp
  (let ((commit "b6c57e76a764252cf50d8d24053f32e2ad54a264")
        (revision "0"))
    (package
      (name "ros-noetic-roscpp")
      (version (git-version "1.17.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0baagfh3933y2si4sz7iqr5mzcyncjghgj4jz0bd7axv9y46nkzb"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (inputs (list boost
                    pkg-config
                    ros-noetic-message-generation
                    ros-noetic-roscpp-serialization
                    ros-noetic-roscpp-traits))
      (propagated-inputs (list ros-noetic-cpp-common
                               ros-noetic-rosconsole
                               ros-noetic-rosgraph-msgs
                               ros-noetic-std-msgs
                               ros-noetic-xmlrpcpp
                               ros-noetic-roslang
                               ros-noetic-rostime
                               ros-noetic-message-runtime))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "clients/roscpp"))))))
      (home-page "https://wiki.ros.org/roscpp")
      (synopsis "The C++ implementation of ROS")
      (description "Provides a client library that enables C++ programmers
to quickly interface with ROS Topics, Services, and Parameters.")
      (license license:bsd-3))))

(define-public ros-noetic-rosgraph
  (let ((commit "b6c57e76a764252cf50d8d24053f32e2ad54a264")
        (revision "0"))
    (package
      (name "ros-noetic-rosgraph")
      (version (git-version "1.17.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0baagfh3933y2si4sz7iqr5mzcyncjghgj4jz0bd7axv9y46nkzb"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list python-mock))
      (propagated-inputs (list python-netifaces python-rospkg python-pyyaml))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                               (add-after 'unpack 'switch-to-pkg-src
                                 (lambda _ (chdir "tools/rosgraph"))))))
      (home-page "https://wiki.ros.org/rosgraph")
      (synopsis "Contains the rosgraph command-line tool.")
      (description "The rosgraph command-line tool prints information
about the ROS Computation Graph. it also provides an internal library
that can be used by graphical tools.")
      (license license:bsd-3))))

(define-public ros-noetic-rosmaster
  (let ((commit "b6c57e76a764252cf50d8d24053f32e2ad54a264")
        (revision "0"))
    (package
      (name "ros-noetic-rosmaster")
      (version (git-version "1.17.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0baagfh3933y2si4sz7iqr5mzcyncjghgj4jz0bd7axv9y46nkzb"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list python-defusedxml ros-noetic-rosgraph))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                               (add-after 'unpack 'switch-to-pkg-src
                                 (lambda _ (chdir "tools/rosmaster"))))))
      (home-page "https://wiki.ros.org/rosmaster")
      (synopsis "ROS Master implementation")
      (description "All ROS 1 systems must run a rosmaster to coordinate
communication.")
      (license license:bsd-3))))


(define-public ros-noetic-rosparam
  (let ((commit "b6c57e76a764252cf50d8d24053f32e2ad54a264")
        (revision "0"))
    (package
      (name "ros-noetic-rosparam")
      (version (git-version "1.17.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0baagfh3933y2si4sz7iqr5mzcyncjghgj4jz0bd7axv9y46nkzb"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list python-pyyaml ros-noetic-rosgraph))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                               (add-after 'unpack 'switch-to-pkg-src
                                 (lambda _ (chdir "tools/rosparam"))))))
      (home-page "https://wiki.ros.org/rosparam")
      (synopsis "The rosparam command-line tool for getting and setting ROS parameters")
      (description "The rosparam command-line tool for getting and setting ROS parameters
on the Parameter Server using YAML-encoded files. It also contains an experimental
library for using YAML with the Paramter Server. This library is intended for internal use only. rosparam can be invoked within a roslaunch file.")
      (license license:bsd-3))))

(define-public ros-noetic-rosout
  (let ((commit "b6c57e76a764252cf50d8d24053f32e2ad54a264")
        (revision "0"))
    (package
      (name "ros-noetic-rosout")
      (version (git-version "1.17.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0baagfh3933y2si4sz7iqr5mzcyncjghgj4jz0bd7axv9y46nkzb"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (inputs (list ros-noetic-roscpp ros-noetic-rosgraph-msgs))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                               (add-after 'unpack 'switch-to-pkg-src
                                 (lambda _ (chdir "tools/rosout"))))))
      (home-page "https://wiki.ros.org/rosout")
      (synopsis "System-wide logging mechanism for messages sent to the /rosout topic")
      (description "System-wide logging mechanism for messages sent to the /rosout topic.")
      (license license:bsd-3))))

(define-public ros-noetic-roslaunch
  (let ((commit "b6c57e76a764252cf50d8d24053f32e2ad54a264")
        (revision "0"))
    (package
      (name "ros-noetic-roslaunch")
      (version (git-version "1.17.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0baagfh3933y2si4sz7iqr5mzcyncjghgj4jz0bd7axv9y46nkzb"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rosbuild))
      (propagated-inputs
       (list python-paramiko
             python-rospkg
             python-pyyaml
             ros-noetic-rosclean
             ros-noetic-rosgraph-msgs
             ros-noetic-roslib
             ros-noetic-rosmaster
             ros-noetic-rosout
             ros-noetic-rosparam
             ros-noetic-rosunit))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                               (add-after 'unpack 'switch-to-pkg-src
                                 (lambda _ (chdir "tools/roslaunch"))))))
      (home-page "https://wiki.ros.org/roslaunch")
      (synopsis "A tool for easily launching multiple ROS nodes locally and remotely as well as setting parameters on the Paramter Server")
      (description "A tool for easily launching multiple ROS nodes locally and remotely as well as setting parameters on the Paramter Server. Includes options to
automatically respawn processes that have already died. roslaunch takes in one or
more XML configuration files (with the .launch extension) that specify the
parameters to set and nodes to launch, as well as the machines that they should
be run on.")
      (license license:bsd-3))))

(define-public ros-noetic-rospy
  (let ((commit "b6c57e76a764252cf50d8d24053f32e2ad54a264")
        (revision "0"))
    (package
      (name "ros-noetic-rospy")
      (version (git-version "1.17.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0baagfh3933y2si4sz7iqr5mzcyncjghgj4jz0bd7axv9y46nkzb"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (inputs (list ros-noetic-roscpp))
      (propagated-inputs (list python-numpy python-rospkg python-pyyaml
                    ros-noetic-rosgraph ros-noetic-rosgraph-msgs ros-noetic-roslib
                    ros-noetic-std-msgs))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                               (add-after 'unpack 'switch-to-pkg-src
                                 (lambda _ (chdir "clients/rospy"))))))
      (home-page "https://wiki.ros.org/rospy")
      (synopsis "The Python client library for ROS")
      (description "rospy is a pure Python client library for ROS. The rospy client
API enables Python programmers to quickly interface with ROS Topics,
Services, and Parameters. The design of rospy favors implementation speed
(i.e. developer time) over runtime performance so that algorithms can be quickly
prototyped and tested within ROS. It is also ideal for non-critical-path code,
such as configuration and initialization code.
any of the ROS tools are written in rospy to take advantage of the type introspection capabilities.

Many of the ROS tools, such rostopic and rosservice are built on top of rospy")
  (license license:bsd-3))))


(define-public ros-noetic-roslz4
  (let ((commit "b6c57e76a764252cf50d8d24053f32e2ad54a264")
        (revision "0"))
    (package
      (name "ros-noetic-roslz4")
      (version (git-version "1.17.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0baagfh3933y2si4sz7iqr5mzcyncjghgj4jz0bd7axv9y46nkzb"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rosunit))
      (inputs (list lz4
                    ros-noetic-cpp-common))

      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                               (add-after 'unpack 'switch-to-pkg-src
                                 (lambda _ (chdir "utilities/roslz4"))))))
      (home-page "https://wiki.ros.org/rostest")
      (synopsis "A Python and C++ implementation of the LZ4 streaming format")
      (description "A Pyhthon and C++ implementation of the LZ4 streaming format.
Large data streams are split into blocks which are compressed using the very fast
LZ4 compression algorithm.")
      (license license:bsd-3))))

(define-public ros-noetic-rostest
  (let ((commit "b6c57e76a764252cf50d8d24053f32e2ad54a264")
        (revision "0"))
    (package
      (name "ros-noetic-rostest")
      (version (git-version "1.17.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0baagfh3933y2si4sz7iqr5mzcyncjghgj4jz0bd7axv9y46nkzb"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (inputs (list boost))
      (propagated-inputs
       (list
        ros-noetic-rosgraph
        ros-noetic-roslaunch
        ros-noetic-rosmaster
        ros-noetic-rospy
        ros-noetic-rosunit))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                               (add-after 'unpack 'switch-to-pkg-src
                                 (lambda _ (chdir "tools/rostest"))))))
      (home-page "https://wiki.ros.org/rostest")
      (synopsis "Integration test suite based on roslaunch that is compatibile with xUnit frameworks")
      (description"Integration test suite based on roslaunch that is compatibile with xUnit frameworks.")
      (license license:bsd-3))))

(define-public ros-noetic-rosbag-storage
  (let ((commit "b6c57e76a764252cf50d8d24053f32e2ad54a264")
        (revision "0"))
    (package
      (name "ros-noetic-rosbag-storage")
      (version (git-version "1.17.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0baagfh3933y2si4sz7iqr5mzcyncjghgj4jz0bd7axv9y46nkzb"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest))
      (inputs (list bzip2
                    boost
                    console-bridge
                    gpgme
                    openssl
                    ros-noetic-cpp-common
                    ros-noetic-roscpp-serialization
                    ros-noetic-roscpp-traits))
      (propagated-inputs (list ros-noetic-pluginlib
                               ros-noetic-roslz4
                               ros-noetic-rostime
                               ros-noetic-std-msgs))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                               (add-after 'unpack 'switch-to-pkg-src
                                 (lambda _ (chdir "tools/rosbag_storage"))))))
      (home-page "https://wiki.ros.org/rosbag_storage")
      (synopsis "Tools for recording from and playinb back ROS messages without relying on the ROS client library")
      (description "Tools for recording from and playinb back ROS messages without relying on the ROS client library")
      (license license:bsd-3))))

(define-public ros-noetic-topic-tools
  (let ((commit "b6c57e76a764252cf50d8d24053f32e2ad54a264")
        (revision "0"))
    (package
      (name "ros-noetic-topic-tools")
      (version (git-version "1.17.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0baagfh3933y2si4sz7iqr5mzcyncjghgj4jz0bd7axv9y46nkzb"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest
                           ros-noetic-message-generation
                           ros-noetic-rosbash))
      (inputs (list ros-noetic-cpp-common
                    ros-noetic-rosconsole
                    ros-noetic-roscpp
                    ros-noetic-rostime
                    ros-noetic-std-msgs
                    ros-noetic-xmlrpcpp))

      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                               (add-after 'unpack 'switch-to-pkg-src
                                 (lambda _ (chdir "tools/topic_tools"))))))
      (home-page "https://wiki.ros.org/topic_tools")
      (synopsis "Tools for messing with ROS topics at the meta level")
      (description "Tools for directing, throttling, selecting, and otherwise messing with ROS topics at a meta level.
None of the programs in this package actually know about the topics whose streams they are altering; instead, these
tools deal with messages as generic binary blobs. This means they can be applied to any ROS topic.")
      (license license:bsd-3))))

(define-public ros-noetic-rosbag
  (let ((commit "b6c57e76a764252cf50d8d24053f32e2ad54a264")
        (revision "0"))
    (package
      (name "ros-noetic-rosbag")
      (version (git-version "1.17.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0baagfh3933y2si4sz7iqr5mzcyncjghgj4jz0bd7axv9y46nkzb"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list python-pillow
                           ros-noetic-roscpp-serialization))
      (inputs (list
               boost
               ros-noetic-cpp-common))
      (propagated-inputs (list
               python-pycryptodomex
               ros-noetic-rosbag-storage
               ros-noetic-rosconsole
               python-gnupg
               python-rospkg
               ros-noetic-roscpp
               ros-noetic-roslib
               ros-noetic-rospy
               ros-noetic-std-srvs
               ros-noetic-topic-tools
               ros-noetic-xmlrpcpp))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                               (add-after 'unpack 'switch-to-pkg-src
                                 (lambda _ (chdir "tools/rosbag"))))))
      (home-page "https://wiki.ros.org/rosbag")
      (synopsis "Tools for recording and playing back to ROS topics")
      (description "Tools for recording and playing back ROS topics to ROS bags. It is intended to
be high performance and avoids deserialization and reserialization of messages.")
      (license license:bsd-3))))

(define-public ros-noetic-rosmsg
  (let ((commit "b6c57e76a764252cf50d8d24053f32e2ad54a264")
        (revision "0"))
    (package
      (name "ros-noetic-rosmsg")
      (version (git-version "1.17.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0baagfh3933y2si4sz7iqr5mzcyncjghgj4jz0bd7axv9y46nkzb"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest
                           ros-noetic-std-msgs
                           ros-noetic-std-srvs
                           ros-noetic-diagnostic-msgs))
      (propagated-inputs (list ros-noetic-genmsg
                    ros-noetic-genpy
                    python-rospkg
                    ros-noetic-rosbag
                    ros-noetic-roslib))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                               (add-after 'unpack 'switch-to-pkg-src
                                 (lambda _ (chdir "tools/rosmsg"))))))
      (home-page "https://wiki.ros.org/rosmsg")
      (synopsis "The rosmsg and rossrv command-line tools for displaying message/service type information")
      (description "The rosmsg and rossrv command-line tools. rosmsg displays information about message types.
rossrv displays information about serfvice types.")
      (license license:bsd-3))))

(define-public ros-noetic-rosservice
  (let ((commit "b6c57e76a764252cf50d8d24053f32e2ad54a264")
        (revision "0"))
    (package
      (name "ros-noetic-rosservice")
      (version (git-version "1.17.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0baagfh3933y2si4sz7iqr5mzcyncjghgj4jz0bd7axv9y46nkzb"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-genpy
                    ros-noetic-rosgraph
                    ros-noetic-roslib
                    ros-noetic-rospy
                    ros-noetic-rosmsg))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                               (add-after 'unpack 'switch-to-pkg-src
                                 (lambda _ (chdir "tools/rosservice"))))))
      (home-page "https://wiki.ros.org/rosservice")
      (synopsis "The rosservice command-line tool for listing and querying ROS services")
      (description "The rosservice command-line tool for listing and querying ROS services.
Also contains a Python library for tetrieving information about
Services and dynamically invoking them. The Python library is experimental and is for
internal-use only.")
      (license license:bsd-3))))

(define-public ros-noetic-rostopic
  (let ((commit "b6c57e76a764252cf50d8d24053f32e2ad54a264")
        (revision "0"))
    (package
      (name "ros-noetic-rostopic")
      (version (git-version "1.17.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0baagfh3933y2si4sz7iqr5mzcyncjghgj4jz0bd7axv9y46nkzb"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest))
      (propagated-inputs
       (list ros-noetic-genpy
             ros-noetic-rospy
             ros-noetic-rosbag))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                               (add-after 'unpack 'switch-to-pkg-src
                                 (lambda _ (chdir "tools/rostopic"))))))
      (home-page "https://wiki.ros.org/rostopic")
      (synopsis "The rostopic command-line tool for displaying debug information about ROS topics")
      (description "The rostopic command-line tool for displaying
debug information about ROS Topics, including publishers, subscribers,
publishing rate,and ROS Messages. It also contains an experimental Python library
for getting information about and interacting with topics dynamically. This library is for internal-use only as the code API may change, though it does provide
examples of how to implement dynamic subscription and publication behaviors in ROS.")
      (license license:bsd-3))))

(define-public ros-noetic-rosnode
  (let ((commit "b6c57e76a764252cf50d8d24053f32e2ad54a264")
        (revision "0"))
    (package
      (name "ros-noetic-rosnode")
      (version (git-version "1.17.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0baagfh3933y2si4sz7iqr5mzcyncjghgj4jz0bd7axv9y46nkzb"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest))
      (propagated-inputs (list ros-noetic-rosgraph
                    ros-noetic-rostopic))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                               (add-after 'unpack 'switch-to-pkg-src
                                 (lambda _ (chdir "tools/rosnode"))))))
      (home-page "https://wiki.ros.org/rosnode")
      (synopsis "The rosnode command-line tool for displaying debug information about ROS nodes")
      (description  "A command-line tool for displaying debug information about ROS Nodes,
including publications, subscriptions and connections. It also contains an experimental library for retrieving node
information. This library is intended for internal use only.")
      (license license:bsd-3))))


(define-public ros-noetic-roswtf
  (let ((commit "b6c57e76a764252cf50d8d24053f32e2ad54a264")
        (revision "0"))
    (package
      (name "ros-noetic-roswtf")
      (version (git-version "1.17.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0baagfh3933y2si4sz7iqr5mzcyncjghgj4jz0bd7axv9y46nkzb"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest
                           ros-noetic-cmake-modules
                           ros-noetic-rosbag
                           ros-noetic-roslang
                           ros-noetic-std-srvs))
      (inputs (list python-distro))
      (propagated-inputs
       (list
        ros-noetic-rosbuild
        ros-noetic-rosgraph
        ros-noetic-roslaunch
        ros-noetic-roslib
        ros-noetic-rosnode
        ros-noetic-rosservice))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                               (add-after 'unpack 'switch-to-pkg-src
                                 (lambda _ (chdir "utilities/roswtf"))))))
      (home-page "https://wiki.ros.org/roswtf")
      (synopsis "A tool for diagnosing issues with the ROS system")
      (description  "A tool for diagnosing issues with the ROS system.
Think of it as a FAQ implemented in code.")
      (license license:bsd-3))))

(define-public ros-noetic-message-filters
  (let ((commit "b6c57e76a764252cf50d8d24053f32e2ad54a264")
        (revision "0"))
    (package
      (name "ros-noetic-message-filters")
      (version (git-version "1.17.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0baagfh3933y2si4sz7iqr5mzcyncjghgj4jz0bd7axv9y46nkzb"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest
                           ros-noetic-rosunit))
      (inputs (list boost
                    ros-noetic-rosconsole
                    ros-noetic-roscpp))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                               (add-after 'unpack 'switch-to-pkg-src
                                 (lambda _ (chdir "utilities/message_filters"))))))
      (home-page "https://wiki.ros.org/message_filters")
      (synopsis "A set of message filters for ROS messages")
      (description  "A set of message filters which take in messages and may output those messages at a later time, based on the conditions that filter needs met.")
      (license license:bsd-3))))


(define-public ros-noetic-ros-comm
  (let ((commit "b6c57e76a764252cf50d8d24053f32e2ad54a264")
        (revision "0"))
    (package
      (name "ros-noetic-ros-comm")
      (version (git-version "1.17.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0baagfh3933y2si4sz7iqr5mzcyncjghgj4jz0bd7axv9y46nkzb"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list
                          ros-noetic-roscpp
                          ros-noetic-rospy
                          ros-noetic-rosgraph-msgs
                          ros-noetic-std-srvs
                          ros-noetic-ros
                          ros-noetic-rosbag
                          ros-noetic-rosconsole
                          ros-noetic-rosgraph
                          ros-noetic-roslaunch
                          ros-noetic-roslisp
                          ros-noetic-rosmaster
                          ros-noetic-rosmsg
                          ros-noetic-rosnode
                          ros-noetic-rosout
                          ros-noetic-rosparam
                          ros-noetic-rosservice
                          ros-noetic-rostest
                          ros-noetic-rostopic
                          ros-noetic-topic-tools
                          ros-noetic-message-filters
                          ros-noetic-roswtf
                          ros-noetic-xmlrpcpp))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                               (add-after 'unpack 'switch-to-pkg-src
                                 (lambda _ (chdir "ros_comm"))))))
      (home-page "https://wiki.ros.org/ros_comm")
      (synopsis "ROS communications-related packages")
      (description "ROS communications-related packages, including core
client libraries (roscpp, rospy) and graph introspection tools (rostopic, rosnode, rosservice, rosparam).")
      (license license:bsd-3))))
