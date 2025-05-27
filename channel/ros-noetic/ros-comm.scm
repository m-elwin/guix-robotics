(define-module (ros-noetic ros-comm)
  #:use-module (guix build-system catkin)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix build-system pyproject)
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
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-crypto)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages xml)
  #:use-module (ros-noetic bootstrap)
  #:use-module (ros-noetic core)
  #:use-module (ros-noetic common-msgs)
  #:use-module (ros-noetic ros)
  #:use-module (ros-noetic roscpp-core)
  #:use-module (srfi srfi-1)
  #:use-module (contributed))

(define-public ros-noetic-xmlrpcpp
  (let ((commit "25d371664e34ec9d26ee331434de9a38c412c890")
        (revision "0"))
    (package
      (name "ros-noetic-xmlrpcpp")
      (version (git-version "1.17.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/ros_comm")
               (commit commit)))
         (sha256
          (base32 "0zs4qgn4l0p0y07i4fblk1i5vjwnqyxdx04303as7vnsbvqy9hcx"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-cpp-common boost))
      (propagated-inputs (list ros-noetic-rostime))
      (arguments
       (list
        #:phases
        #~(modify-phases %standard-phases
            ;; go to the directory for the ros package
            (add-after 'unpack 'switch-to-pkg-src
              (lambda _
                (chdir "utilities/xmlrpcpp"))))))
      (home-page "https://wiki.ros.org/xmlrpcpp")
      (synopsis "C++ implementation of the XML-RPC protocol")
      (description
       "This version is heavily modified from the package available
on SourceForge in order to support roscpp's threading model.
 As such, we are maintaining our own fork.")
      (license license:bsd-3))))


(define-public ros-noetic-roscpp
  (let ((commit "25d371664e34ec9d26ee331434de9a38c412c890")
        (revision "0"))
    (package
      (name "ros-noetic-roscpp")
      (version (git-version "1.17.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/ros_comm")
               (commit commit)))
         (sha256
          (base32 "0zs4qgn4l0p0y07i4fblk1i5vjwnqyxdx04303as7vnsbvqy9hcx"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list pkg-config ros-noetic-message-generation))
      (propagated-inputs (list boost
                               ros-noetic-cpp-common
                               ros-noetic-rosgraph-msgs
                               ros-noetic-rosconsole
                               ros-noetic-roscpp-serialization
                               ros-noetic-roscpp-traits
                               ros-noetic-roslang
                               ros-noetic-message-runtime
                               ros-noetic-rostime
                               ros-noetic-std-msgs
                               ros-noetic-xmlrpcpp))
      (arguments
       (list
        #:phases
        #~(modify-phases %standard-phases
            ;; go to the directory for the ros package
            (add-after 'unpack 'switch-to-pkg-src
              (lambda _
                (chdir "clients/roscpp"))))))
      (home-page "https://wiki.ros.org/roscpp")
      (synopsis "The C++ implementation of ROS")
      (description
       "Provides a client library that enables C++ programmers
to quickly interface with ROS Topics, Services, and Parameters.")
      (license license:bsd-3))))

(define-public ros-noetic-rosgraph
  (let ((commit "25d371664e34ec9d26ee331434de9a38c412c890")
        (revision "0"))
    (package
      (name "ros-noetic-rosgraph")
      (version (git-version "1.17.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/ros_comm")
               (commit commit)))
         (sha256
          (base32 "0zs4qgn4l0p0y07i4fblk1i5vjwnqyxdx04303as7vnsbvqy9hcx"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list python-mock))
      (propagated-inputs (list python-netifaces python-rospkg python-pyyaml))
      (arguments
       (list
        #:phases
        #~(modify-phases %standard-phases
            ;; go to the directory for the ros package
            (add-after 'unpack 'switch-to-pkg-src-and-patch
              (lambda _
                (chdir "tools/rosgraph")
                ;; specify the full path to rosgraph so Popen can find it
                (substitute* "test/test_rosgraph_command_offline.py"
                  (("cmd = 'rosgraph'")
                   (string-append "cmd = '"
                                  (getcwd) "/../build/devel/bin/rosgraph'")))
                ;; account for the wrapper:
                ;; __file__ is wrong (so ignore it in the regex)
                ;; The logging always comes from a <module>
                (substitute* "test/test_roslogging.py"
                  (("re.escape\\(this_file\\)")
                   "'.*'")
                  (("function = 'logging_on_function'")
                   "function = '<module>'")
                  (("function = 'LoggingOnClass.__init__'")
                   "function = '<module>'"))))
            ;; Need to specify the log config file
            (add-before 'check 'pre-check
              (lambda _
                (setenv "ROS_PYTHON_LOG_CONFIG_FILE"
                        (string-append (getcwd)
                         "/../rosgraph/conf/python_logging.conf")))))))
      (home-page "https://wiki.ros.org/rosgraph")
      (synopsis "Contains the rosgraph command-line tool")
      (description
       "The rosgraph command-line tool prints information
about the ROS Computation Graph. it also provides an internal library
that can be used by graphical tools.")
      (license license:bsd-3))))

(define-public ros-noetic-rosmaster
  (let ((commit "25d371664e34ec9d26ee331434de9a38c412c890")
        (revision "0"))
    (package
      (name "ros-noetic-rosmaster")
      (version (git-version "1.17.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/ros_comm")
               (commit commit)))
         (sha256
          (base32 "0zs4qgn4l0p0y07i4fblk1i5vjwnqyxdx04303as7vnsbvqy9hcx"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list python-defusedxml ros-noetic-rosgraph))
      (arguments
       (list
        #:phases
        #~(modify-phases %standard-phases
            ;; go to the directory for the ros package
            (add-after 'unpack 'switch-to-pkg-src
              (lambda _
                (chdir "tools/rosmaster"))))))
      (home-page "https://wiki.ros.org/rosmaster")
      (synopsis "ROS Master implementation")
      (description "All ROS 1 systems must run a rosmaster to coordinate
communication.")
      (license license:bsd-3))))


(define-public ros-noetic-rosparam
  (let ((commit "25d371664e34ec9d26ee331434de9a38c412c890")
        (revision "0"))
    (package
      (name "ros-noetic-rosparam")
      (version (git-version "1.17.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/ros_comm")
               (commit commit)))
         (sha256
          (base32 "0zs4qgn4l0p0y07i4fblk1i5vjwnqyxdx04303as7vnsbvqy9hcx"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list python-pyyaml ros-noetic-rosgraph))
      (arguments
       (list
        #:phases
        #~(modify-phases %standard-phases
            ;; go to the directory for the ros package
            (add-after 'unpack 'switch-to-pkg-src
              (lambda _
                (chdir "tools/rosparam"))))))
      (home-page "https://wiki.ros.org/rosparam")
      (synopsis
       "The rosparam command-line tool for getting and setting ROS parameters")
      (description
       "The rosparam command-line tool for getting and setting ROS parameters
on the Parameter Server using YAML-encoded files.  It also contains an experimental
library for using YAML with the Paramter Server.
This library is intended for internal use only.
rosparam can be invoked within a roslaunch file.")
      (license license:bsd-3))))

(define-public ros-noetic-rosout
  (let ((commit "25d371664e34ec9d26ee331434de9a38c412c890")
        (revision "0"))
    (package
      (name "ros-noetic-rosout")
      (version (git-version "1.17.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/ros_comm")
               (commit commit)))
         (sha256
          (base32 "0zs4qgn4l0p0y07i4fblk1i5vjwnqyxdx04303as7vnsbvqy9hcx"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (inputs (list ros-noetic-roscpp ros-noetic-rosgraph-msgs))
      (arguments
       (list
        #:phases
        #~(modify-phases %standard-phases
            ;; go to the directory for the ros package
            (add-after 'unpack 'switch-to-pkg-src
              (lambda _
                (chdir "tools/rosout"))))))
      (home-page "https://wiki.ros.org/rosout")
      (synopsis
       "System-wide logging mechanism for messages sent to the /rosout topic")
      (description
       "System-wide logging mechanism for messages sent to the /rosout topic.")
      (license license:bsd-3))))

(define-public ros-noetic-roslaunch
  (let ((commit "25d371664e34ec9d26ee331434de9a38c412c890")
        (revision "0"))
    (package
      (name "ros-noetic-roslaunch")
      (version (git-version "1.17.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/ros_comm")
               (commit commit)))
         (sha256
          (base32 "0zs4qgn4l0p0y07i4fblk1i5vjwnqyxdx04303as7vnsbvqy9hcx"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rosbuild ros-noetic-rosunit))
      (inputs (list ros-noetic-rosout))
      (propagated-inputs (list python-paramiko
                               python-rospkg
                               python-pyyaml
                               ros-noetic-rosclean
                               ros-noetic-rosgraph-msgs
                               ros-noetic-roslib
                               ros-noetic-rosmaster
                               ros-noetic-rosparam))
      (arguments
       (list
        #:phases
        #~(modify-phases %standard-phases
            ;; go to the directory for the ros package
            (add-after 'unpack 'switch-to-pkg-src-and-patch
              (lambda _
                (chdir "tools/roslaunch")
                ;; Some of these tests depend on the $HOME
                ;; directory existing in the build environment
                ;; so set it to /tmp
                (setenv "HOME" "/tmp")
                ;; help the test find roslaunch
                (substitute* '("test/unit/test_roslaunch_dump_params.py"
                               "test/unit/test_roslaunch_list_files.py")
                  (("cmd = 'roslaunch'")
                   (string-append "cmd = '"
                                  (getcwd) "/../build/devel/bin/roslaunch'"))))))))
      (home-page "https://wiki.ros.org/roslaunch")
      (synopsis
       "Launch multiple ROS nodes locally and remotely and set ROS parameters")
      (description
       "A tool for easily launching multiple ROS nodes locally and remotely
as well as setting parameters on the Paramter Server.  Includes options to
automatically respawn processes that have already died.  roslaunch takes in one or
more XML configuration files (with the .launch extension) that specify the
parameters to set and nodes to launch, as well as the machines that they should
be run on.")
      (license license:bsd-3))))

(define-public ros-noetic-rospy
  (let ((commit "25d371664e34ec9d26ee331434de9a38c412c890")
        (revision "0"))
    (package
      (name "ros-noetic-rospy")
      (version (git-version "1.17.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/ros_comm")
               (commit commit)))
         (sha256
          (base32 "0zs4qgn4l0p0y07i4fblk1i5vjwnqyxdx04303as7vnsbvqy9hcx"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list python-numpy
                               python-rospkg
                               python-pyyaml
                               ros-noetic-roscpp
                               ros-noetic-rosgraph
                               ros-noetic-rosgraph-msgs
                               ros-noetic-roslib
                               ros-noetic-std-msgs))
      (arguments
       (list
        #:phases
        #~(modify-phases %standard-phases
            ;; go to the directory for the ros package
            (add-after 'unpack 'switch-to-pkg-src
              (lambda _
                (chdir "clients/rospy"))))))
      (home-page "https://wiki.ros.org/rospy")
      (synopsis "The Python client library for ROS")
      (description
       "Pure Python client library for ROS. The rospy client
API enables Python programmers to quickly interface with ROS Topics,
Services, and Parameters.  The design of rospy favors implementation speed
(i.e. developer time) over runtime performance so that algorithms can be quickly
prototyped and tested within ROS.  It is also ideal for non-critical-path code,
such as configuration and initialization code.
Many of the ROS tools, such rostopic and rosservice
are built on top of rospy")
      (license license:bsd-3))))


(define-public ros-noetic-roslz4
  (let ((commit "25d371664e34ec9d26ee331434de9a38c412c890")
        (revision "0"))
    (package
      (name "ros-noetic-roslz4")
      (version (git-version "1.17.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/ros_comm")
               (commit commit)))
         (sha256
          (base32 "0zs4qgn4l0p0y07i4fblk1i5vjwnqyxdx04303as7vnsbvqy9hcx"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rosunit))
      (propagated-inputs (list lz4 ros-noetic-cpp-common))
      (arguments
       (list
        #:phases
        #~(modify-phases %standard-phases
            ;; go to the directory for the ros package
            (add-after 'unpack 'switch-to-pkg-src
              (lambda _
                (chdir "utilities/roslz4"))))))
      (home-page "https://wiki.ros.org/roslz4")
      (synopsis "Python and C++ implementation of the LZ4 streaming format")
      (description
       "A Pyhthon and C++ implementation of the LZ4 streaming format.
Large data streams are split into blocks which are compressed using the very fast
LZ4 compression algorithm.")
      (license license:bsd-3))))

(define-public ros-noetic-rostest
  (let ((commit "25d371664e34ec9d26ee331434de9a38c412c890")
        (revision "0"))
    (package
      (name "ros-noetic-rostest")
      (version (git-version "1.17.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/ros_comm")
               (commit commit)))
         (sha256
          (base32 "0zs4qgn4l0p0y07i4fblk1i5vjwnqyxdx04303as7vnsbvqy9hcx"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-std-srvs))
      (propagated-inputs (list boost
                               ros-noetic-rosgraph
                               ros-noetic-roslaunch
                               ros-noetic-rosmaster
                               ros-noetic-rosservice
                               ros-noetic-rospy
                               ros-noetic-rosunit))
      (arguments
       (list
        #:phases
        #~(modify-phases %standard-phases
            ;; go to the directory for the ros package
            (add-after 'unpack 'switch-to-pkg-src-and-patch
              (lambda _
                (chdir "tools/rostest")
                ;; test nodes shebangs refer to "python"
                ;; switch to "python3" so patch-shebangs works
                (substitute* '("test_nodes/talker.py"
                               "test_nodes/service_server.py"
                               "test_nodes/listener.py"
                               "test_nodes/publish_once.py"
                               "test/time_limit_test.py"
                               "test/test_distro_version.py"
                               "test/test_clean_master.py"
                               "test/test_dotname.py"
                               "scripts/rostest")
                  (("#!/usr/bin/env python") "#!/usr/bin/env python3"))
                ;; publishtest.test depends on rostopic, which is is cyclic dep
                ;; Partially fixed in https://github.com/ros/ros_comm/pull/2002/
                ;; But need to apply the same change to publishtest.test
                (substitute* '("test/publishtest.test"
                               "test/advertisetest.test")
                  (("pkg=\"rostopic\" type=\"rostopic\" name=\"freq.*")
                   "pkg=\"rostest\" type=\"talker.py\" name=\"freq_topic_pub\"/>\n")
                  (("pkg=\"rostopic\" type=\"rostopic\" name=\"once.*")
                   "pkg=\"rostest\" type=\"publish_once.py\" name=\"once_topic_pub\"/>")
                  (("frequent_topic") "chatter"))
                ;; the subscribetest node imports rosservice but does not use it so remove
                (substitute* '("nodes/subscribetest")
                  (("import rosservice") ""))
                ;; we wrap the rostest executable with guix (so it is a shell script)
                ;; need to make sure it's not called with python3 prefixed
                (substitute* "cmake/rostest-extras.cmake.em"
                  (("ROSTEST_EXE \"\\$\\{PYTHON_EXECUTABLE\\}") "ROSTEST_EXE \""))))
            ;;; tests need a home directory to work
            (add-before 'check 'set-home-dir
              (lambda _
                (setenv "HOME" "/tmp"))))))
      (home-page "https://wiki.ros.org/rostest")
      (synopsis "Integration test suite based on roslaunch")
      (description
       "Integration test suite based on roslaunch.
It is compatibile with xUnit frameworks.")
      (license license:bsd-3))))

(define-public ros-noetic-rostest-minimal
  (package
    (inherit ros-noetic-rostest)
    (name "ros-noetic-rostest-minimal")
    ;; remove ros-noetic-rosservice from the propagated inputsinputs
    (propagated-inputs (remove (lambda (pkg)
                                 (string=? (car pkg) "ros-noetic-rosservice"))
                               (package-propagated-inputs ros-noetic-rostest)))
    (arguments
     (substitute-keyword-arguments (package-arguments ros-noetic-rostest)
       ((#:phases orig-phases)
        #~(modify-phases #$orig-phases
            ;; Remove the advertisetest node and its associated tests
            (add-after 'switch-to-pkg-src-and-patch 'remove-advertisetest
              (lambda _
                (substitute* "CMakeLists.txt"
                  (("nodes/advertisetest")
                   "")
                  (("add_rostest\\(test/advertisetest.test\\)")
                   ""))))))))
    (synopsis "Used by ros-noetic-topic-tools to avoid a circular dependency")
    (description "The ros-noetic-topic-tools package needs rostest as a
propagated-input because one of it's installed scripts uses rostest.  It does not,
however, need the advertisetest node.  The advertisetest node needs rosservice
which depends on topic-tools, so by removing advertisetest, rostest can avoid
depending on topic-tools, breaking a circular dependency.")))


(define-public ros-noetic-rosbag-storage
  (let ((commit "25d371664e34ec9d26ee331434de9a38c412c890")
        (revision "0"))
    (package
      (name "ros-noetic-rosbag-storage")
      (version (git-version "1.17.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/ros_comm")
               (commit commit)))
         (sha256
          (base32 "0zs4qgn4l0p0y07i4fblk1i5vjwnqyxdx04303as7vnsbvqy9hcx"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      ;; The package.xml includes <rostest> as a build dep
      ;; and  the CMakeLists.txt calls find_package(rostest)
      ;; however, rostest is not used (and cannot be used as it creates
      ;; a circular dependency)
      (native-inputs (list ros-noetic-std-msgs))
      (propagated-inputs (list boost
                               bzip2
                               console-bridge
                               gpgme
                               openssl
                               ros-noetic-cpp-common
                               ros-noetic-pluginlib
                               ros-noetic-roslz4
                               ros-noetic-roscpp-serialization
                               ros-noetic-rostime
                               ros-noetic-roscpp-traits))
      (arguments
       (list
        #:phases
        #~(modify-phases %standard-phases
            ;; go to the directory for the ros package
            (add-after 'unpack 'switch-to-pkg-src
              (lambda _
                (chdir "tools/rosbag_storage")))
            ;; needs a real home directory for tests to pass
            (add-before 'check 'pre-check
              (lambda _
                (setenv "HOME" "/tmp"))))))
      (home-page "https://wiki.ros.org/rosbag_storage")
      (synopsis
       "Record and play back ROS messages without the ROS client library")
      (description
       "Tools for recording from and playing
 back ROS messages without relying on the ROS client library")
      (license license:bsd-3))))

(define-public ros-noetic-topic-tools
  (let ((commit "25d371664e34ec9d26ee331434de9a38c412c890")
        (revision "0"))
    (package
      (name "ros-noetic-topic-tools")
      (version (git-version "1.17.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0zs4qgn4l0p0y07i4fblk1i5vjwnqyxdx04303as7vnsbvqy9hcx"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest-minimal
                           ros-noetic-message-generation
                           ros-noetic-rosbash))
      (inputs (list ros-noetic-cpp-common
                    ros-noetic-rosconsole
                    ros-noetic-rostopic
                    ros-noetic-roscpp
                    ros-noetic-rostime
                    ros-noetic-std-msgs
                    ros-noetic-xmlrpcpp))

      (arguments (list
                  #:phases
                  #~(modify-phases %standard-phases
                      ;; go to the directory for the ros package
                      (add-after 'unpack 'switch-to-pkg-src
                        (lambda _
                          (chdir "tools/topic_tools")
                          ;;; some of the tests rely on rostopic which would create
                          ;;; a circular dependency
 
                          )))))
      (home-page "https://wiki.ros.org/topic_tools")
      (synopsis "Tools for messing with ROS topics at the meta level")
      (description "Tools for directing, throttling, selecting, and otherwise messing with ROS topics at a meta level.
None of the programs in this package actually know about the topics whose streams they are altering; instead, these
tools deal with messages as generic binary blobs. This means they can be applied to any ROS topic.")
      (license license:bsd-3))))

(define-public ros-noetic-rosbag
  (let ((commit "25d371664e34ec9d26ee331434de9a38c412c890")
        (revision "0"))
    (package
      (name "ros-noetic-rosbag")
      (version (git-version "1.17.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0zs4qgn4l0p0y07i4fblk1i5vjwnqyxdx04303as7vnsbvqy9hcx"))
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

;;; minimal version of rosbag that does not depend on topic tools
;;; This breaks a dependency cycle: rostopic depends on rosbag
;;; which depends on topic-tools, and topic-tools depends on rostopic.
;;; Instead, rostopic will depend on ros-noetic-rosbag-minimal
(define-public ros-noetic-rosbag-minimal
  (let ((commit "25d371664e34ec9d26ee331434de9a38c412c890")
        (revision "0"))
    (package
      (name "ros-noetic-rosbag-minimal")
      (version (git-version "1.17.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0zs4qgn4l0p0y07i4fblk1i5vjwnqyxdx04303as7vnsbvqy9hcx"))
         (file-name (git-file-name name version))))
      (build-system pyproject-build-system)
      (native-inputs (list catkin python-wheel))
      (propagated-inputs (list
               python-pycryptodomex
               ros-noetic-rosbag-storage
               python-gnupg
               python-rospkg
               ros-noetic-rospy))
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
  (let ((commit "25d371664e34ec9d26ee331434de9a38c412c890")
        (revision "0"))
    (package
      (name "ros-noetic-rosmsg")
      (version (git-version "1.17.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0zs4qgn4l0p0y07i4fblk1i5vjwnqyxdx04303as7vnsbvqy9hcx"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-std-msgs
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
  (let ((commit "25d371664e34ec9d26ee331434de9a38c412c890")
        (revision "0"))
    (package
      (name "ros-noetic-rosservice")
      (version (git-version "1.17.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0zs4qgn4l0p0y07i4fblk1i5vjwnqyxdx04303as7vnsbvqy9hcx"))
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
  (let ((commit "25d371664e34ec9d26ee331434de9a38c412c890")
        (revision "0"))
    (package
      (name "ros-noetic-rostopic")
      (version (git-version "1.17.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0zs4qgn4l0p0y07i4fblk1i5vjwnqyxdx04303as7vnsbvqy9hcx"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rostest-minimal))
      (propagated-inputs
       (list ros-noetic-genpy
             ros-noetic-rospy
             ros-noetic-rosbag-minimal))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                               (add-after 'unpack 'switch-to-pkg-src-and-patch-tests
                                 (lambda _
                                   (chdir "tools/rostopic")
                                   (substitute* '("test_nodes/talker.py"
                                                  "test/test_rostopic.py"
                                                  "test/test_rostopic_command_line_offline.py"
                                                  "test/check_rostopic_command_line_online.py")
                                     (("#!/usr/bin/env python") "#!/usr/bin/env python3"))
                                   (substitute* '("test/test_rostopic.py"
                                                  "test/test_rostopic_command_line_offline.py"
                                                  "test/check_rostopic_command_line_online.py"
                                                  )
                                     (("cmd = 'rostopic'")
                                      (string-append "cmd = '"
                                                     (getcwd) "/../build/devel/bin/rostopic'")))
                                   (substitute* "test/test_rostopic_command_line_offline.py"
                                     (("%\\(cmd, c\\)") "%('rostopic', c)"))))
                               (add-before 'check 'set-home
                                 ; rostest tests require a home directory to be set
                                 (lambda _ (setenv "HOME" "/tmp"))))))
      (home-page "https://wiki.ros.org/rostopic")
      (synopsis "The rostopic command-line tool for displaying debug information about ROS topics")
      (description "The rostopic command-line tool for displaying
debug information about ROS Topics, including publishers, subscribers,
publishing rate,and ROS Messages. It also contains an experimental Python library
for getting information about and interacting with topics dynamically. This library is for internal-use only as the code API may change, though it does provide
examples of how to implement dynamic subscription and publication behaviors in ROS.")
      (license license:bsd-3))))

(define-public ros-noetic-rosnode
  (let ((commit "25d371664e34ec9d26ee331434de9a38c412c890")
        (revision "0"))
    (package
      (name "ros-noetic-rosnode")
      (version (git-version "1.17.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0zs4qgn4l0p0y07i4fblk1i5vjwnqyxdx04303as7vnsbvqy9hcx"))
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
  (let ((commit "25d371664e34ec9d26ee331434de9a38c412c890")
        (revision "0"))
    (package
      (name "ros-noetic-roswtf")
      (version (git-version "1.17.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0zs4qgn4l0p0y07i4fblk1i5vjwnqyxdx04303as7vnsbvqy9hcx"))
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
  (let ((commit "25d371664e34ec9d26ee331434de9a38c412c890")
        (revision "0"))
    (package
      (name "ros-noetic-message-filters")
      (version (git-version "1.17.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0zs4qgn4l0p0y07i4fblk1i5vjwnqyxdx04303as7vnsbvqy9hcx"))
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
  (let ((commit "25d371664e34ec9d26ee331434de9a38c412c890")
        (revision "0"))
    (package
      (name "ros-noetic-ros-comm")
      (version (git-version "1.17.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm")
                             (commit commit)))
         (sha256
          (base32 "0zs4qgn4l0p0y07i4fblk1i5vjwnqyxdx04303as7vnsbvqy9hcx"))
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

(define-public ros-noetic-rosgraph-msgs
  (let ((commit "2475ee81a55297a8e8007fea4d5bffaad36a2401")
        (revision "0"))
    (package
      (name "ros-noetic-rosgraph-msgs")
      (version (git-version "1.11.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm_msgs")
                             (commit commit)))
         (sha256
          (base32 "0m6qc7ddi7j4aw5dn4ly8vdc3apciwm4x5bmszi3wdm4rbb8vsv8"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation))
      (propagated-inputs (list ros-noetic-message-runtime ros-noetic-std-msgs))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "rosgraph_msgs/"))))))
      (home-page "https://wiki.ros.org/rosgraph_msgs")
      (synopsis "Messages relating to the ROS Computation Graph")
      (description "These are generally considered to be low-level messages
that end users do not interact with.")
      (license license:bsd-3))))

(define-public ros-noetic-std-srvs
  (let ((commit "2475ee81a55297a8e8007fea4d5bffaad36a2401")
        (revision "0"))
    (package
      (name "ros-noetic-std-srvs")
      (version (git-version "1.11.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_comm_msgs")
                             (commit commit)))
         (sha256
          (base32 "0m6qc7ddi7j4aw5dn4ly8vdc3apciwm4x5bmszi3wdm4rbb8vsv8"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation))
      (propagated-inputs (list ros-noetic-message-runtime))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "std_srvs/"))))))
      (home-page "https://wiki.ros.org/std_srvs")
      (synopsis "Common service definitions")
      (description "Common service definitions")
      (license license:bsd-3))))

;; technically not part of ros-comm, but it is the lisp client library
;; (analagous to roscpp and rospy)
(define-public ros-noetic-roslisp
  (let ((commit "bf35424b9be97417.46237145b7c5c2b33783b5e")
        (revision "0"))
    (package
      (name "ros-noetic-roslisp")
      (version (git-version "1.9.25" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/roslisp")
                             (commit commit)))
         (sha256
          (base32 "14xhaibfdzi332cpxgz7iprzss012qczj7ymfnjc4236l14ih1pp"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (inputs (list ros-noetic-roslang
                    sbcl
                    ros-noetic-rospack
                    ros-noetic-rosgraph-msgs
                    ros-noetic-std-srvs
                    ros-noetic-ros-environment))
      (home-page "https://wiki.ros.org/roslisp")
      (synopsis "Lisp client library for ROS")
      (description "Lisp client library for ROS")
      (license license:bsd-3))))
