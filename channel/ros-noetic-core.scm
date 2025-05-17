;;; ROS noetic core dependencies
(define-module (ros-noetic-core)
  #:use-module (guix build-system catkin)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix search-paths)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (gnu packages base)
  #:use-module (gnu packages check)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages shells)
  #:use-module (ros-noetic-deps))

(define-public catkin
  (let ((commit "fdf0b3e13e4281cf90821aeea75aa4932a7ff4f3")
        (revision "0"))
    (package
      (name "catkin")
    (version (git-version "0.8.12" revision commit))
    (source
     (origin
       (method git-fetch)
       (uri (git-reference (url "https://github.com/ros/catkin")
                           (commit commit)))
       (sha256
        (base32 "10cci6qxjp9gdyr7awvwq72zzrazqny7mc2jyfzrp6hzvmm5746d"))
         (file-name (git-file-name name version))))
    (build-system catkin-build-system)
    (native-inputs (list fish zsh googletest python-nose coreutils))
    (inputs (list cmake))
    ;; The only input is cmake because calling cmake is hard-coded into catkin
    ;; However, cmake itself can find different compilers and be used with Make or ninja, etc
    ;; Thus, the choice of make and compiler etc is left to the environment.
    (arguments
     (list
      #:catkin? #f
      #:phases
      #~(begin
           (modify-phases %standard-phases
            (add-after 'unpack 'fix-usr-bin-env
              (lambda* (#:key inputs #:allow-other-keys)
                ;;replace hard-coded paths with the proper location for guix
                      (substitute* "cmake/templates/python_distutils_install.sh.in"
                        (("/usr/bin/env") (search-input-file inputs "/bin/env")))
                      (substitute* "test/unit_tests/test_environment_cache.py"
                        (("#! /usr/bin/env sh") (string-append "#! " (search-input-file inputs "/bin/env") " sh")))
                      (substitute* "test/utils.py"
                        (("/bin/ln") (search-input-file inputs "/bin/ln")))))
            (add-after 'wrap 'wrap-script
              (lambda _
                  (for-each
                   (lambda (file)
                     (display (string-append "Wrapping " file))
                     (newline)
                     (wrap-program file
                       `("PATH" prefix
                         ,(list (string-append #$cmake "/bin")))))
                  (find-files (string-append #$output "/bin") "^catkin_*"))))))))
    (home-page "http://wiki.ros.org/catkin")
    (synopsis "catkin build tool")
    (description "ROS 1 Catkin build tool")
    (license license:bsd-3))))

(define-public ros-noetic-genmsg
  (let ((commit "393871225e1458d2a8db41761759e57ca01a1801")
        (revision "0"))
    (package
      (name "ros-noetic-genmsg")
      (version (git-version "0.6.1" revision commit))
    (source
     (origin
       (method git-fetch)
       (uri (git-reference (url "https://github.com/ros/genmsg")
                           (commit commit)))
       (sha256
        (base32 "06z6fvkfifkjv58fkr9m0hfcjn279l056agclqgy4xmsvg3f8p0j"))
       (file-name (git-file-name name version))))
    (build-system catkin-build-system)
    (native-inputs (list python-nose))
     (home-page "https://docs.ros.org/en/api/genmsg/html/")
     (synopsis "Decouple code generation from .msg .srv files from build system")
     (description "Project genmsg exists in order to decouple code generation from .msg & .srv format
files from the parsing of these files and from impementation details of the build system
(project directory layout, existence or nonexistence of utilities like rospack, values of environment
variables such as ROS_PACKAGE_PATH): i.e. none of these are required to be set in any particular way.")
     (license license:bsd-3))))

(define-public ros-noetic-gencpp
  (let ((commit "cc7e11cf67ec5c5f49b1d539e80475073f3864b4")
        (revision "0"))
    (package
      (name "ros-noetic-gencpp")
      (version (git-version "0.7.2" revision commit))
    (source
     (origin
       (method git-fetch)
       (uri (git-reference (url "https://github.com/ros/gencpp")
                           (commit commit)))
       (sha256
        (base32 "1nwia7j7390x8574cw1iz4w1phv8q67w3khykfphsssbbxly3v44"))
       (file-name (git-file-name name version))))
    (build-system catkin-build-system)
    (native-inputs (list ros-noetic-genmsg))
     (home-page "https://wiki.ros.org/gencpp")
     (synopsis "ROS C++ message definition and serialization generators")
     (description "Generate ROS msgs and srvs for C++")
     (license license:bsd-3))))

(define-public ros-noetic-geneus
  (let ((commit "ec388e279ce4fd52ec78a4144ba52014ab4dd824")
        (revision "0"))
    (package
      (name "ros-noetic-geneus")
      (version (git-version "3.0.0" revision commit))
    (source
     (origin
       (method git-fetch)
       (uri (git-reference (url "https://github.com/jsk-ros-pkg/geneus")
                           (commit commit)))
       (sha256
        (base32 "0hz6jy7f9wxn9m1ni4zawmiqk87zqc0hcf652prxnlm79xri0aj6"))
       (file-name (git-file-name name version))))
    (build-system catkin-build-system)
    (native-inputs (list ros-noetic-genmsg))
     (home-page "https://github.com/jsk-ros-pkg/geneus")
     (synopsis "EusLisp ROS message and service generators")
     (description "EusLisp ROS message and service generators.")
     (license license:bsd-3))))

(define-public ros-noetic-genlisp
  (let ((commit "3ac633abacdf5ab321d23ed013c7d5b7da97736d")
        (revision "0"))
    (package
      (name "ros-noetic-genlisp")
      (version (git-version "0.4.18" revision commit))
    (source
     (origin
       (method git-fetch)
       (uri (git-reference (url "https://github.com/ros/genlisp")
                           (commit commit)))
       (sha256
        (base32 "07qx0blkfx6n8i5c5mj1yzpi9y099npw4f0rzbs5p3gjpq2gh0m2"))
       (file-name (git-file-name name version))))
    (build-system catkin-build-system)
    (native-inputs (list ros-noetic-genmsg))
     (home-page "https://github.com/ros/genlisp")
     (synopsis "Common-Lisp ROS message and service generators")
     (description "Common-Lisp ROS emssage and service generators.")
     (license license:bsd-3))))

(define-public ros-noetic-gennodejs
  (let ((commit "53cf97ce44a6f592c69cd6f6d07bb7825b6ea243")
        (revision "0"))
    (package
      (name "ros-noetic-gennodejs")
      (version (git-version "2.0.2" revision commit))
    (source
     (origin
       (method git-fetch)
       (uri (git-reference (url "https://github.com/sloretz/gennodejs")
                           (commit commit)))
       (sha256
        (base32 "0ybiih22mmcbkdcpyv6b4yfnssmc5n8ksl74ghvkjpyr55h7k6v7"))
       (file-name (git-file-name name version))))
    (build-system catkin-build-system)
    (native-inputs (list ros-noetic-genmsg))
     (home-page "https://github.com/ros/genlisp")
     (synopsis "Javascript ROS message and service generators")
     (description "Javascript ROS emssage and service generators.")
     (license license:bsd-3))))
;
;(define-public ros-noetic-genpy
;  (let ((commit "323d861c512ba912a8c7e842647fe2d9657fd15b")
;        (revision "0"))
;    (package
;      (name "ros-noetic-genpy")
;      (version (git-version "0.6.18" revision commit))
;    (source
;     (origin
;       (method git-fetch)
;       (uri (git-reference (url "https://github.com/ros/genpy")
;                           (commit commit)))
;       (sha256
;        (base32 "06a10p3kmy6m7mvkybj8pbl4pfrl9mm0wdgxbz67jr1disa1zj88"))
;       (file-name (git-file-name name version))))
;    (build-system cmake-build-system)
;    (native-inputs (list catkin python ros-noetic-genmsg))
;     (home-page "https://github.com/ros/genpy")
;     (synopsis "Python ROS message and service generators")
;     (description "Python ROS message and service generators.")
;     (license license:bsd-3))))
;
;(define-public ros-noetic-cmake-modules
;  (let ((commit "3f8318d8f673e619023e9a526b6ee37536be1659")
;        (revision "0"))
;    (package
;      (name "ros-noetic-cmake-modules")
;      (version (git-version "0.5.2" revision commit))
;    (source
;     (origin
;       (method git-fetch)
;       (uri (git-reference (url "https://github.com/ros/cmake_modules")
;                           (commit commit)))
;       (sha256
;        (base32 "0zaiv1hr5hx64mm64620kigin2bck1msfv87cdk36im7bzpa7jsv"))
;       (file-name (git-file-name name version))))
;    (build-system cmake-build-system)
;    (native-inputs (list catkin python))
;     (home-page "https://github.com/ros/cmake_modules")
;     (synopsis "CMake modules used by ROS but not included with CMake")
;     (description "CMake modules used by ROS but not included with CMake")
;     (license license:bsd-3))))
;
;;~~  - class_loader
;;~~  - common_msgs
;;~~  - cpp_common
;;~~  - message_generation
;;~~  - message_runtime
;;~~  - mk
;;~~  - ros
;;~~  - ros_comm
;;~~  - ros_core
;;~~  - ros_environment
;;~~  - rosbag_migration_rule
;;~~  - rosbash
;;~~  - rosboost_cfg
;;~~  - rosbuild
;;~~  - rosclean
;;~~  - roscpp_core
;;~~  - roscpp_traits
;;~~  - roscreate
;;~~  - rosgraph
;;~~  - roslang
;;~~  - roslisp
;;~~  - rosmake
;;~~  - rosmaster
;;~~  - rospack
;;~~  - roslib
;;~~  - rosparam
;;~~  - rospy
;;~~  - rosservice
;;~~  - rostime
;;~~  - roscpp_serialization
;;~~  - roslaunch
;;~~  - rosunit
;;~~  - rosconsole
;;~~  - pluginlib
;;~~  - rosconsole_bridge
;;~~  - roslz4
;;~~  - rostest
;;~~  - std_msgs
;;~~  - actionlib_msgs
;;~~  - diagnostic_msgs
;;~~  - geometry_msgs
;;~~  - nav_msgs
;;~~  - rosgraph_msgs
;;~~  - shape_msgs
;;~~  - std_srvs
;;~~  - trajectory_msgs
;;~~  - visualization_msgs
;;~~  - xmlrpcpp
;;~~  - roscpp
;;~~  - rosout
;;~~  - message_filters
;;~~  - rosbag_storage
;;~~  - rosmsg
;;~~  - rosnode
;;~~  - rostopic
;;~~  - topic_tools
;;~~  - rosbag
;;~~  - roswtf
;;~~  - sensor_msgs
;;~~  - stereo_msgs
