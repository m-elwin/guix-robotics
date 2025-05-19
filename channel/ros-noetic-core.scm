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
  #:use-module (gnu packages boost)
  #:use-module (gnu packages check)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages cpp)
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

(define-public ros-noetic-genpy
  (let ((commit "323d861c512ba912a8c7e842647fe2d9657fd15b")
        (revision "0"))
    (package
      (name "ros-noetic-genpy")
      (version (git-version "0.6.18" revision commit))
    (source
     (origin
       (method git-fetch)
       (uri (git-reference (url "https://github.com/ros/genpy")
                           (commit commit)))
       (sha256
        (base32 "06a10p3kmy6m7mvkybj8pbl4pfrl9mm0wdgxbz67jr1disa1zj88"))
       (file-name (git-file-name name version))))
    (build-system catkin-build-system)
    (native-inputs (list ros-noetic-genmsg python-nose python-pyyaml python-numpy))
     (home-page "https://github.com/ros/genpy")
     (synopsis "Python ROS message and service generators")
     (description "Python ROS message and service generators.")
     (license license:bsd-3))))

(define-public ros-noetic-cmake-modules
  (let ((commit "3f8318d8f673e619023e9a526b6ee37536be1659")
        (revision "0"))
    (package
      (name "ros-noetic-cmake-modules")
      (version (git-version "0.5.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/cmake_modules")
                             (commit commit)))
         (sha256
          (base32 "0zaiv1hr5hx64mm64620kigin2bck1msfv87cdk36im7bzpa7jsv"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (home-page "https://github.com/ros/cmake_modules")
      (synopsis "CMake modules used by ROS but not included with CMake")
      (description "CMake modules used by ROS but not included with CMake")
      (license license:bsd-3))))

(define-public ros-noetic-class-loader
  (let ((commit "007c4e2d359bd9294671ff5605a771affebe8de6")
        (revision "0"))
    (package
      (name "ros-noetic-class-loader")
      (version (git-version "0.5.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/class_loader")
                             (commit commit)))
         (sha256
          (base32 "05chprdj4p5bs84zb36v13vfbr41biqi6g5zwq3px8sqhwlzkb3s"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list boost console-bridge
                           googletest poco ros-noetic-cmake-modules))
      (home-page "https://github.com/ros/class_loader")
      (synopsis "ROS-independent plugin loading package")
      (description "The class_loader package is a ROS-independent package for loading plugins during runtime and the foundation of the higher level ROS pluginlib library. class_loader utilizes the host operating system's runtime loader to open runtime libraries (e.g. .so/.dll/dylib files), introspect the library for exported plugin classes, and allows users to instantiate objects of said exported classes without the explicit declaration (i.e. header file) for those classes.")
      (license license:bsd-3))))

(define-public ros-noetic-message-generation
  (let ((commit "6dd393ba9c6a398784da4039c162fc9186f19796")
        (revision "0"))
    (package
      (name "ros-noetic-message-generation")
      (version (git-version "0.4.1" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/message_generation")
                             (commit commit)))
         (sha256
          (base32 "1m36aknbv42m4jjaacnclm4frk5hg6aw9nql26jiphcfk3559iir"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (inputs (list ros-noetic-gencpp ros-noetic-geneus ros-noetic-gennodejs ros-noetic-genlisp ros-noetic-genmsg ros-noetic-genpy))
      (home-page "https://github.com/ros/message_generation")
      (synopsis "Meta Package for Message generation")
      (description "Message packages depend on this metapackage to automatically bring in all message generators.")
      (license license:bsd-3))))


(define-public ros-noetic-cpp-common
  (let ((commit "2951f0579a94955f5529d7f24bb1c8c7f0256451")
        (revision "0"))
    (package
      (name "ros-noetic-cpp-common")
      (version (git-version "0.7.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/roscpp_core")
                             (commit commit)))
         (sha256
          (base32 "0zs0wlkldjkvyi2d74ri93hykbq2a5wmkb1x0jibnashlyiijiwj"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list boost console-bridge))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-cpp-core
                       (lambda _ (chdir "cpp_common"))))))
      (home-page "https://github.com/ros/roscpp_core")
      (synopsis "C++ code for doing things that are not necessarily ROS related")
      (description "C++ code for doing things that are not necessarily ROS
related, but are useful for multiple packages. This includes things like
the ROS_DEPRECATED and ROS_FORCE_INLINE macros, as well as code for getting
backtraces. This package is part of roscpp")
      (license license:bsd-3))))

(define-public ros-noetic-rostime
  (let ((commit "2951f0579a94955f5529d7f24bb1c8c7f0256451")
        (revision "0"))
    (package
      (name "ros-noetic-rostime")
      (version (git-version "0.7.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/roscpp_core")
                             (commit commit)))
         (sha256
          (base32 "0zs0wlkldjkvyi2d74ri93hykbq2a5wmkb1x0jibnashlyiijiwj"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list boost googletest ros-noetic-cpp-common))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-rostime
                       (lambda _ (chdir "rostime"))))))
      (home-page "http://wiki.ros.org/roscpp/Overview/Time")
      (synopsis "Time and Duration implementation for C++ libraries, including roscpp")
      (description "Time and Duration implementation for C++ libraries, including for roscpp.
This package is a part of roscpp.")
      (license license:bsd-3))))

(define-public ros-noetic-roscpp-traits
  (let ((commit "2951f0579a94955f5529d7f24bb1c8c7f0256451")
        (revision "0"))
    (package
      (name "ros-noetic-roscpp-traits")
      (version (git-version "0.7.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/roscpp_core")
                             (commit commit)))
         (sha256
          (base32 "0zs0wlkldjkvyi2d74ri93hykbq2a5wmkb1x0jibnashlyiijiwj"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-cpp-common ros-noetic-rostime))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-roscpp-traits
                       (lambda _ (chdir "roscpp_traits"))))))
      (home-page "http://wiki.ros.org/roscpp_traits")
      (synopsis "Message traits as defined in http://www.ros.org/wiki/roscpp/Overview/MessagesTraits")
      (description "Message traits as defined in http://www.ros.org/wiki/roscpp/Overview/MessagesTraits.
This package is a part of roscpp.")
      (license license:bsd-3))))

(define-public ros-noetic-roscpp-core
  (let ((commit "2951f0579a94955f5529d7f24bb1c8c7f0256451")
        (revision "0"))
    (package
      (name "ros-noetic-roscpp-core")
      (version (git-version "0.7.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/roscpp_core")
                             (commit commit)))
         (sha256
          (base32 "0zs0wlkldjkvyi2d74ri93hykbq2a5wmkb1x0jibnashlyiijiwj"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-cpp-common ros-noetic-roscpp-serialization ros-noetic-roscpp-traits ros-noetic-rostime))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-roscpp-core
                       (lambda _ (chdir "roscpp_core"))))))
      (home-page "http://wiki.ros.org/roscpp")
      (synopsis "Underlying data libraries for roscpp messages")
      (description "Underlying data libraries for roscpp messages.ros.org/wiki/roscpp/Overview/MessagesTraits.
This package is a part of roscpp.")
      (license license:bsd-3))))

(define-public ros-noetic-roscpp-serialization
  (let ((commit "2951f0579a94955f5529d7f24bb1c8c7f0256451")
        (revision "0"))
    (package
      (name "ros-noetic-roscpp-serialization")
      (version (git-version "0.7.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/roscpp_core")
                             (commit commit)))
         (sha256
          (base32 "0zs0wlkldjkvyi2d74ri93hykbq2a5wmkb1x0jibnashlyiijiwj"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-cpp-common ros-noetic-roscpp-traits ros-noetic-rostime))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-roscpp-serialization
                       (lambda _ (chdir "roscpp_serialization"))))))
      (home-page "https://github.com/ros/roscpp_core")
      (synopsis "Serialization, as described at https://www.ros.org/wiki/roscpp/Overview/MessageSerializationAndAdaptingTypes")
      (description "Enables serializaing/deserializing ROS messages to memory. This package is a part of roscpp.")
      (license license:bsd-3))))
(define-public ros-noetic-roscpp-serialization
  (let ((commit "2951f0579a94955f5529d7f24bb1c8c7f0256451")
        (revision "0"))
    (package
      (name "ros-noetic-roscpp-serialization")
      (version (git-version "0.7.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/roscpp_core")
                             (commit commit)))
         (sha256
          (base32 "0zs0wlkldjkvyi2d74ri93hykbq2a5wmkb1x0jibnashlyiijiwj"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-cpp-common ros-noetic-roscpp-traits ros-noetic-rostime))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-roscpp-serialization
                       (lambda _ (chdir "roscpp_serialization"))))))
      (home-page "https://github.com/ros/roscpp_core")
      (synopsis "Serialization, as described at https://www.ros.org/wiki/roscpp/Overview/MessageSerializationAndAdaptingTypes")
      (description "Enables serializaing/deserializing ROS messages to memory. This package is a part of roscpp.")
      (license license:bsd-3))))

(define-public ros-noetic-message-runtime
  (let ((commit "6dd393ba9c6a398784da4039c162fc9186f19796")
        (revision "0"))
    (package
      (name "ros-noetic-message-runtime")
      (version (git-version "0.4.13" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/message_runtime")
                             (commit commit)))
         (sha256
          (base32 "1m36aknbv42m4jjaacnclm4frk5hg6aw9nql26jiphcfk3559iir"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (inputs (list ros-noetic-cpp-common ros-noetic-roscpp-serialization ros-noetic-roscpp-traits ros-noetic-rostime ros-noetic-genpy))
      (home-page "https://github.com/ros/message_runtime")
      (synopsis "Meta Package for the runtime components of ROS messages")
      (description "Message packages depend on this metapackage at runtime to automatically bring in all message generators.")
      (license license:bsd-3))))

;;~~  - common_msgs
;;~~  - cpp_common
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
