;;; ROS noetic core dependencies
(define-module (ros-noetic core)
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
  #:use-module (contributed)
  #:use-module (ros-noetic ros-comm)
  #:use-module (ros-noetic roscpp-core)
  #:use-module (ros-noetic bootstrap))

(define ros-root-search-path
  (search-path-specification (variable "ROS_ROOT") (files (list "share/ros"))))

(define ros-package-path-search-path
  (search-path-specification (variable "ROS_PACKAGE_PATH") (files (list "share"))))

;;; We define an unused variable ROS_CMAKE_PREFIX_PATH to hold
;;; The catkin build-system then wraps all executables
;;; (e.g., files catkin puts in bin/)
;;; such that they set the CMAKE_PREFIX_PATH to ROS_CMAKE_PREFIX_PATH
;;; In this way each catkin executable sets the proper CMAKE_PREFIX_PATH
;;; without it interfering with other programs that may use CMAKE_PREFIX_PATH
(define ros-cmake-prefix-path-search-path
  (search-path-specification (variable "ROS_CMAKE_PREFIX_PATH") (files (list ""))))

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
    (native-search-paths (list ros-cmake-prefix-path-search-path))
    (native-inputs (list fish zsh coreutils))
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
            (add-after 'unpack 'fix-paths
              (lambda* (#:key inputs #:allow-other-keys)
                ;;replace hard-coded paths with the proper location for guix
                      (substitute* "cmake/templates/python_distutils_install.sh.in"
                        (("/usr/bin/env") (search-input-file inputs "/bin/env")))
                      (substitute* "test/unit_tests/test_environment_cache.py"
                        (("#! /usr/bin/env sh") (string-append "#! " (search-input-file inputs "/bin/env") " sh")))
                      (substitute* "test/utils.py"
                        (("/bin/ln") (search-input-file inputs "/bin/ln")))
                 ;; make sure to find guix's python.
                      (substitute* "cmake/python.cmake"
                        (("find_package\\(PythonInterp \\$\\{PYTHON_VERSION\\} REQUIRED\\)")
                         (string-append
                          "set(PYTHON_EXECUTABLE "
                          (search-input-file inputs "/bin/python3")
                          " CACHE STRING \"Use GUIX python by default\")\n"
                          "find_package(PythonInterp ${PYTHON_VERSION} REQUIRED)")))
                      ;; don't use lsb
                      (substitute* "cmake/all.cmake"
                        (("platform/lsb") ""))))
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
    (propagated-inputs (list ros-noetic-genmsg))
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
    (propagated-inputs (list ros-noetic-genmsg))
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
    (propagated-inputs (list ros-noetic-genmsg))
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
    (propagated-inputs (list ros-noetic-genmsg))
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
    (propagated-inputs (list python-pyyaml python-numpy ros-noetic-genmsg))
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
      (native-inputs (list ros-noetic-cmake-modules))
      (propagated-inputs (list boost console-bridge poco))
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
      (propagated-inputs (list ros-noetic-gencpp ros-noetic-geneus ros-noetic-gennodejs ros-noetic-genlisp ros-noetic-genmsg ros-noetic-genpy))
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
                     (add-after 'unpack 'switch-to-pkg-src
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
      (native-inputs (list boost ros-noetic-cpp-common))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
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
                     (add-after 'unpack 'switch-to-pkg-src
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
                     (add-after 'unpack 'switch-to-pkg-src
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
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "roscpp_serialization"))))))
      (home-page "https://github.com/ros/roscpp_core")
      (synopsis "Serialization, as described at https://www.ros.org/wiki/roscpp/Overview/MessageSerializationAndAdaptingTypes")
      (description "Enables serializaing/deserializing ROS messages to memory. This package is a part of roscpp.")
      (license license:bsd-3))))

(define-public ros-noetic-message-runtime
  (let ((commit "ebd0e5fc1b66f69c8301dfef55b31ceed83c1e15")
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
          (base32 "148jhpxir4fwp8xgk72gcn4m58kricg4ckmhnsilbrsq5ci4h1iy"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-cpp-common ros-noetic-roscpp-serialization ros-noetic-roscpp-traits ros-noetic-rostime ros-noetic-genpy))
      (home-page "https://github.com/ros/message_runtime")
      (synopsis "Meta Package for the runtime components of ROS messages")
      (description "Message packages depend on this metapackage at runtime to automatically bring in all message generators.")
      (license license:bsd-3))))

(define-public ros-noetic-std-msgs
  (let ((commit "2d12e5b826da883d4c8a09f681ad27f960c86ca1")
        (revision "0"))
    (package
      (name "ros-noetic-std-msgs")
      (version (git-version "0.5.14" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/std_msgs")
                             (commit commit)))
         (sha256
          (base32 "0d150h4j2r8km7mx4xhichvliixg69czjbwb14jwa0jkzg5ks093"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation))
      (propagated-inputs (list ros-noetic-message-runtime))
      (home-page "https://wiki.ros.org/std_msgs")
      (synopsis "Standard ROS messages including common message types representing primitive data types")
      (description "Standard ROS Messages including common message types representing primitive data types and other basic message constructs, such as multiarrays.
For common, generic robot-specific message types, please see http://www.ros.org/wiki/common_msgs.")
      (license license:bsd-3))))

(define-public ros-noetic-actionlib-msgs
  (let ((commit "1230f39a7068d1d73d1039eb0eb970c922b6bcf7")
        (revision "0"))
    (package
      (name "ros-noetic-actionlib-msgs")
      (version (git-version "1.13.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/common_msgs")
                             (commit commit)))
         (sha256
          (base32 "02wqhg70a2h3fsfkavcpvk5rvfy1nai2094irvpywmc0w4wd46sm"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation ros-noetic-std-msgs))
      (propagated-inputs (list ros-noetic-message-runtime ros-noetic-message-generation ros-noetic-std-msgs))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "actionlib_msgs"))))))
      (home-page "https://wiki.ros.org/actionlib_msgs")
      (synopsis "Common messages to interact with an action server and action client")
      (description "Common messages to interact with an action server and action client.")
      (license license:bsd-3))))

(define-public ros-noetic-diagnostic-msgs
  (let ((commit "1230f39a7068d1d73d1039eb0eb970c922b6bcf7")
        (revision "0"))
    (package
      (name "ros-noetic-diagnostic-msgs")
      (version (git-version "1.13.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/common_msgs")
                             (commit commit)))
         (sha256
          (base32 "02wqhg70a2h3fsfkavcpvk5rvfy1nai2094irvpywmc0w4wd46sm"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation ros-noetic-std-msgs))
      (propagated-inputs (list ros-noetic-message-runtime ros-noetic-message-generation ros-noetic-std-msgs))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "diagnostic_msgs"))))))
      (home-page "https://wiki.ros.org/diagnostic_msgs")
      (synopsis "Standardized interface for diagnostic and runtime monitoring in ROS")
      (description "Holds the diagnostic messages which provide the
standardized interface for the diagnostic and runtime monitoring
systems in ROS. These messages are currently used by
the http://wiki.ros.org/diagnostics Stack, which provides libraries for simple ways to set and access
the messages, as well as automated ways to process the diagnostic data.

These messages are used for long term logging and will not be
changed unless there is a very important reason.")
      (license license:bsd-3))))

(define-public ros-noetic-geometry-msgs
  (let ((commit "1230f39a7068d1d73d1039eb0eb970c922b6bcf7")
        (revision "0"))
    (package
      (name "ros-noetic-geometry-msgs")
      (version (git-version "1.13.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/common_msgs")
                             (commit commit)))
         (sha256
          (base32 "02wqhg70a2h3fsfkavcpvk5rvfy1nai2094irvpywmc0w4wd46sm"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation ros-noetic-std-msgs))
      (propagated-inputs (list ros-noetic-message-runtime ros-noetic-std-msgs))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "geometry_msgs"))))))
      (home-page "https://wiki.ros.org/geometry_msgs")
      (synopsis "Messages for common geometric primitives")
      (description "Provides messages for common geometric primitives
such as points, vectors, and poses. These primitives are designed
to provide a common data type and facilitate interoperability
throughout the system.")
      (license license:bsd-3))))

(define-public ros-noetic-nav-msgs
  (let ((commit "1230f39a7068d1d73d1039eb0eb970c922b6bcf7")
        (revision "0"))
    (package
      (name "ros-noetic-nav-msgs")
      (version (git-version "1.13.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/common_msgs")
                             (commit commit)))
         (sha256
          (base32 "02wqhg70a2h3fsfkavcpvk5rvfy1nai2094irvpywmc0w4wd46sm"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation))
      (propagated-inputs (list
               ros-noetic-actionlib-msgs
               ros-noetic-message-runtime
               ros-noetic-geometry-msgs
               ros-noetic-std-msgs))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "nav_msgs"))))))
      (home-page "https://wiki.ros.org/nav_msgs")
      (synopsis "Messages for the navigation stack")
      (description "Messages for the navigation stack.")
      (license license:bsd-3))))

(define-public ros-noetic-sensor-msgs
  (let ((commit "1230f39a7068d1d73d1039eb0eb970c922b6bcf7")
        (revision "0"))
    (package
      (name "ros-noetic-sensor-msgs")
      (version (git-version "1.13.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/common_msgs")
                             (commit commit)))
         (sha256
          (base32 "02wqhg70a2h3fsfkavcpvk5rvfy1nai2094irvpywmc0w4wd46sm"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation
                           ros-noetic-rosbag
                           ros-noetic-rosunit))
      (propagated-inputs (list
               ros-noetic-message-runtime
               ros-noetic-geometry-msgs
               ros-noetic-std-msgs))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "sensor_msgs"))))))
      (home-page "https://wiki.ros.org/sensor_msgs")
      (synopsis "Messages for commonly used sensors")
      (description "Messages for commonly used sensors including cameras and scanning
laser rangefinders.")
      (license license:bsd-3))))

(define-public ros-noetic-shape-msgs
  (let ((commit "1230f39a7068d1d73d1039eb0eb970c922b6bcf7")
        (revision "0"))
    (package
      (name "ros-noetic-shape-msgs")
      (version (git-version "1.13.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/common_msgs")
                             (commit commit)))
         (sha256
          (base32 "02wqhg70a2h3fsfkavcpvk5rvfy1nai2094irvpywmc0w4wd46sm"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation))
      (propagated-inputs (list
               ros-noetic-message-runtime
               ros-noetic-geometry-msgs
               ros-noetic-std-msgs))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "shape_msgs"))))))
      (home-page "https://wiki.ros.org/shape_msgs")
      (synopsis "Messages for defining shapes")
      (description "Messages for defining shapes such as simple solid object
primitives (cube, sphere, etc.), planes, and meshes.")
      (license license:bsd-3))))

(define-public ros-noetic-stereo-msgs
  (let ((commit "1230f39a7068d1d73d1039eb0eb970c922b6bcf7")
        (revision "0"))
    (package
      (name "ros-noetic-stereo-msgs")
      (version (git-version "1.13.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/common_msgs")
                             (commit commit)))
         (sha256
          (base32 "02wqhg70a2h3fsfkavcpvk5rvfy1nai2094irvpywmc0w4wd46sm"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation))
      (propagated-inputs (list
               ros-noetic-message-runtime
               ros-noetic-sensor-msgs
               ros-noetic-std-msgs))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "stereo_msgs"))))))
      (home-page "https://wiki.ros.org/stereo_msgs")
      (synopsis "Messages specific to stereo processing, such as disparity images")
      (description "Messages specific to stereo processing, such as disparity images.")
      (license license:bsd-3))))

(define-public ros-noetic-trajectory-msgs
  (let ((commit "1230f39a7068d1d73d1039eb0eb970c922b6bcf7")
        (revision "0"))
    (package
      (name "ros-noetic-trajectory-msgs")
      (version (git-version "1.13.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/common_msgs")
                             (commit commit)))
         (sha256
          (base32 "02wqhg70a2h3fsfkavcpvk5rvfy1nai2094irvpywmc0w4wd46sm"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation))
      (propagated-inputs (list
               ros-noetic-message-runtime
               ros-noetic-geometry-msgs
               ros-noetic-std-msgs
               ros-noetic-rosbag-migration-rule))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "trajectory_msgs"))))))
      (home-page "https://wiki.ros.org/trajectory_msgs")
      (synopsis "Messages for defining robot trajectories")
      (description "Messages for defining robot trajectories.
These messages are also the building blocks of most of the control_msgs actions.")
      (license license:bsd-3))))


(define-public ros-noetic-visualization-msgs
  (let ((commit "1230f39a7068d1d73d1039eb0eb970c922b6bcf7")
        (revision "0"))
    (package
      (name "ros-noetic-visualization-msgs")
      (version (git-version "1.13.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/common_msgs")
                             (commit commit)))
         (sha256
          (base32 "02wqhg70a2h3fsfkavcpvk5rvfy1nai2094irvpywmc0w4wd46sm"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation))
      (propagated-inputs (list
               ros-noetic-message-runtime
               ros-noetic-geometry-msgs
               ros-noetic-std-msgs))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "visualization_msgs"))))))
      (home-page "https://wiki.ros.org/visualization_msgs")
      (synopsis "Messages for visualization data, used by packages such as rviz")
      (description "visualization_msgs is a set of messages used by
higher level packages, such as rviz, that deal in visualization-specific data.

The main messages in visualization_msgs is visualization_msgs/Marker.
The marker message is used to send visualization \"markers\" such as boxes,
spheres, arrows, lines, etc. to a visualization environment such as rviz.
See the rviz tutorial http://www.ros.org/wiki/rviz/Tutorials
for more information.")
      (license license:bsd-3))))

(define-public ros-noetic-common-msgs
  (let ((commit "1230f39a7068d1d73d1039eb0eb970c922b6bcf7")
        (revision "0"))
    (package
      (name "ros-noetic-common-msgs")
      (version (git-version "1.13.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/common_msgs")
                             (commit commit)))
         (sha256
          (base32 "02wqhg70a2h3fsfkavcpvk5rvfy1nai2094irvpywmc0w4wd46sm"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation))
      (propagated-inputs
       (list
        ros-noetic-message-runtime
        ros-noetic-actionlib-msgs
        ros-noetic-geometry-msgs
        ros-noetic-nav-msgs
        ros-noetic-sensor-msgs
        ros-noetic-shape-msgs
        ros-noetic-stereo-msgs
        ros-noetic-trajectory-msgs
        ros-noetic-visualization-msgs))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "common_msgs"))))))
      (home-page "https://wiki.ros.org/common_msgs")
      (synopsis "Messages that are widely used by other ROS packages")
      (description "Messages that are widely used by other ROS packages.
These includes messages for actions (actionlib_msgs),
diagnostics (diagnostic_msgs), geometric primitives (geometry_msgs),
robot navigation (nav_msgs), and common sensors (sensor_msgs)
such as laser range finders, cameras, point clouds.")
      (license license:bsd-3))))

(define-public ros-noetic-rospack
  (let ((commit "63bf5288618e6a44e2f12fbd43ea6fd4e6b5e984")
        (revision "0"))
    (package
      (name "ros-noetic-rospack")
      (version (git-version "1.15.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/rospack")
                             (commit commit)))
         (sha256
          (base32 "025y5zvmh29xvzqdrif4rymwli4xqm3h7d2kvcxsndflpv4cg1m4"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs
       (list boost
             pkg-config
             tinyxml2
             ros-noetic-cmake-modules
             ros-noetic-message-generation))
      (inputs (list ros-noetic-message-runtime python-rosdep))
      (home-page "https://wiki.ros.org/rospack")
      (synopsis "ROS Package Tool")
      (description "Retrieves information about ROS packages from the filesystem")
      (license license:bsd-3))))

(define-public ros-noetic-rosbuild
  (let ((commit "f143ced5be791fd844e697fd5bf6b8d0a1f633e0")
        (revision "0"))
    (package
      (name "ros-noetic-rosbuild")
      (version (git-version "1.15.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros")
                             (commit commit)))
         (sha256
          (base32 "035w9l1d2z5f5bvry8mgdakg60j67sc27npgn0k4f773588q2p37"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list pkg-config ros-noetic-message-generation))
      (propagated-inputs (list ros-noetic-message-runtime))
      (native-search-paths (list ros-root-search-path))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "core/rosbuild"))))))
      (home-page "https://wiki.ros.org/rosbuild")
      (synopsis "Scripts for managing CMake-based build system for ROS.")
      (description "This is the build-tool that existied before catkin, not sure why it's still in noetic.")
      (license license:bsd-3))))

(define-public ros-noetic-roslang
  (let ((commit "f143ced5be791fd844e697fd5bf6b8d0a1f633e0")
        (revision "0"))
    (package
      (name "ros-noetic-roslang")
      (version (git-version "1.15.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros")
                             (commit commit)))
         (sha256
          (base32 "035w9l1d2z5f5bvry8mgdakg60j67sc27npgn0k4f773588q2p37"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list pkg-config ros-noetic-message-generation))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "core/roslang"))))))
      (home-page "https://wiki.ros.org/roslang")
      (synopsis "Common package that all client libraries depend on")
      (description "Mainly used to find client libraries (via 'rospack depends-on1 roslang').")
      (license license:bsd-3))))

(define-public ros-noetic-rosmake
  (let ((commit "f143ced5be791fd844e697fd5bf6b8d0a1f633e0")
        (revision "0"))
    (package
      (name "ros-noetic-rosmake")
      (version (git-version "1.15.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros")
                             (commit commit)))
         (sha256
          (base32 "035w9l1d2z5f5bvry8mgdakg60j67sc27npgn0k4f773588q2p37"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list python-rospkg))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "tools/rosmake"))))))
      (home-page "https://wiki.ros.org/rosmake")
      (synopsis "A ros dependency aware build tool")
      (description "A tool that can build all ros dependencies in the correct order")
      (license license:bsd-3))))

(define-public ros-noetic-mk
  (let ((commit "f143ced5be791fd844e697fd5bf6b8d0a1f633e0")
        (revision "0"))
    (package
      (name "ros-noetic-mk")
      (version (git-version "1.15.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros")
                             (commit commit)))
         (sha256
          (base32 "035w9l1d2z5f5bvry8mgdakg60j67sc27npgn0k4f773588q2p37"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-rosbuild ros-noetic-rosmake))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "core/mk"))))))
      (home-page "https://wiki.ros.org/mk")
      (synopsis "A collection of .mk include files for building ROS architectural elements")
      (description "Most package authors should use cmake .mk, which calls CMake for the build of the package.
    The other files in this package are intended for use in exotic situations that mostly arise when importing 3rdparty code.")
      (license license:bsd-3))))

(define-public ros-noetic-ros-environment
  (let ((commit "090da7f2ba21fc17f44bba782fb39f3e6da93308")
        (revision "0"))
    (package
      (name "ros-noetic-ros-environment")
      (version (git-version "1.3.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros_environment")
                             (commit commit)))
         (sha256
          (base32 "1kpj8zaw3gkwhjkaxx1ccy5jlpc0zcsf2qwzppx5whv7pl9k7ygf"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-search-paths (list ros-package-path-search-path))
      (home-page "https://wiki.ros.org/ros_environment")
      (synopsis "Provides the environment variables ROS_VERSION, ROS_DISTRO, and ROS_PACKAGE_PATH, and ROS_ETC_DIR")
      (description "Provides the environment variables ROS_VERSION, ROS_DISTRO, and ROS_PACKAGE_PATH, and ROS_ETC_DIR.")
      (license license:apsl2))))

(define-public ros-noetic-roslib
  (let ((commit "f143ced5be791fd844e697fd5bf6b8d0a1f633e0")
        (revision "0"))
    (package
      (name "ros-noetic-roslib")
      (version (git-version "1.15.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros")
                             (commit commit)))
         (sha256
          (base32 "035w9l1d2z5f5bvry8mgdakg60j67sc27npgn0k4f773588q2p37"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list boost ros-noetic-rosmake))
      (propagated-inputs
       (list ros-noetic-rospack ros-noetic-ros-environment python-rospkg))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "core/roslib"))))))
      (home-page "https://wiki.ros.org/roslib")
      (synopsis "Base dependencies and support libraries for ROS")
      (description "Contains many of the common data structures and tools that
are shared across ROS client library implementations")
      (license license:bsd-3))))

(define-public ros-noetic-rosbash
  (let ((commit "f143ced5be791fd844e697fd5bf6b8d0a1f633e0")
        (revision "0"))
    (package
      (name "ros-noetic-rosbash")
      (version (git-version "1.15.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros")
                             (commit commit)))
         (sha256
          (base32 "035w9l1d2z5f5bvry8mgdakg60j67sc27npgn0k4f773588q2p37"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-rospack))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "tools/rosbash"))))))
      (home-page "https://wiki.ros.org/rosbash")
      (synopsis "Assorted shell commands for using ros with bash")
      (description "Assorted shell commands for using ros with bash.")
      (license license:bsd-3))))


(define-public ros-noetic-rosboost-cfg
  (let ((commit "f143ced5be791fd844e697fd5bf6b8d0a1f633e0")
        (revision "0"))
    (package
      (name "ros-noetic-rosboost-cfg")
      (version (git-version "1.15.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros")
                             (commit commit)))
         (sha256
          (base32 "035w9l1d2z5f5bvry8mgdakg60j67sc27npgn0k4f773588q2p37"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-rospack))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "tools/rosboost_cfg"))))))
      (home-page "https://wiki.ros.org/rosboost_cfg")
      (synopsis "Used by the rosboost-cfg tool for termining cflgags/iflags etc. of boost on your system")
      (description "Used by the rosboost-cfg tool for termining cflgags/iflags etc. of boost on your system")
      (license license:bsd-3))))


(define-public ros-noetic-rosclean
  (let ((commit "f143ced5be791fd844e697fd5bf6b8d0a1f633e0")
        (revision "0"))
    (package
      (name "ros-noetic-rosclean")
      (version (git-version "1.15.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros")
                             (commit commit)))
         (sha256
          (base32 "035w9l1d2z5f5bvry8mgdakg60j67sc27npgn0k4f773588q2p37"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list python-rospkg))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "tools/rosclean")))
                     (add-after 'wrap 'wrap-script
                       (lambda _
                         (wrap-program (string-append #$output "/bin/rosclean")
                           `("PATH" ":" prefix
                             ,(list (string-append #$coreutils "/bin")))))))))
      (home-page "https://wiki.ros.org/rosclean")
      (synopsis "Cleanup file system resources (e.g. log files)")
      (description "Cleanup file system resources (e.g. log files).")
      (license license:bsd-3))))

(define-public ros-noetic-roscreate
  (let ((commit "f143ced5be791fd844e697fd5bf6b8d0a1f633e0")
        (revision "0"))
    (package
      (name "ros-noetic-roscreate")
      (version (git-version "1.15.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros")
                             (commit commit)))
         (sha256
          (base32 "035w9l1d2z5f5bvry8mgdakg60j67sc27npgn0k4f773588q2p37"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-roslib python-rospkg))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "tools/roscreate"))))))
      (home-page "https://wiki.ros.org/roscreate")
      (synopsis "Tool taht assists in creating ROS filesystem resources")
      (description "It provides roscreate-pkg, which creates a new package directory, including the appropriate build and manifest files.")
      (license license:bsd-3))))

(define-public ros-noetic-rosunit
  (let ((commit "f143ced5be791fd844e697fd5bf6b8d0a1f633e0")
        (revision "0"))
    (package
      (name "ros-noetic-rosunit")
      (version (git-version "1.15.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros")
                             (commit commit)))
         (sha256
          (base32 "035w9l1d2z5f5bvry8mgdakg60j67sc27npgn0k4f773588q2p37"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-roslib))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "tools/rosunit"))))))
      (home-page "https://wiki.ros.org/rosunit")
      (synopsis "Unit-testing package for ROS")
      (description "Lower-level library for rostest that handles
unit tests, whereas rostest handles integration tests.")
      (license license:bsd-3))))

(define-public ros-noetic-ros
  (let ((commit "f143ced5be791fd844e697fd5bf6b8d0a1f633e0")
        (revision "0"))
    (package
      (name "ros-noetic-ros")
      (version (git-version "1.15.10" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/ros")
                             (commit commit)))
         (sha256
          (base32 "035w9l1d2z5f5bvry8mgdakg60j67sc27npgn0k4f773588q2p37"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list
                          catkin
                          ros-noetic-mk
                          ros-noetic-rosbuild
                          ros-noetic-roslang
                          ros-noetic-roslib
                          ros-noetic-rosbash
                          ros-noetic-rosboost-cfg
                          ros-noetic-rosclean
                          ros-noetic-roscreate
                          ros-noetic-rosmake
                          ros-noetic-rosunit))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "ros"))))))
      (home-page "https://wiki.ros.org/ros")
      (synopsis "ROS Packaging System")
      (description "ROS Packaging System")
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

(define-public ros-noetic-rosconsole
  (let ((commit "44ad0b1f0eccc7f5abd14144e4fe5f74f85592d6")
        (revision "0"))
    (package
      (name "ros-noetic-rosconsole")
      (version (git-version "1.14.4" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/rosconsole")
                             (commit commit)))
         (sha256
          (base32 "0dgxs7x9f8gbigvnbnkn2j066fzlz38avk28av90214bc0ny27yv"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-rosunit))
      (inputs (list apr
                    boost
                    ros-noetic-rosbuild))
      (propagated-inputs (list log4cxx-noetic ros-noetic-cpp-common ros-noetic-rostime))
      (home-page "https://wiki.ros.org/rosconsole")
      (synopsis "ROS console output library")
      (description "ROS console output library. ")
      (license license:bsd-3))))


(define-public ros-noetic-roslisp
  (let ((commit "bf35424b9be97417236237145b7c5c2b33783b5e")
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



(define-public ros-noetic-pluginlib
  (let ((commit "8d4bf7e4fab132d6b7d894d446631a9161f2afec")
        (revision "0"))
    (package
      (name "ros-noetic-pluginlib")
      (version (git-version "1.13.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/pluginlib")
                             (commit commit)))
         (sha256
          (base32 "133bxdlw4ggsicyzql82hmvfji8lpd60qj2cqrvci3bfc1nr2j7z"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (inputs (list tinyxml2
                    ros-noetic-cmake-modules
                    boost))
      (propagated-inputs (list ros-noetic-class-loader
                               ros-noetic-rosconsole
                               ros-noetic-roslib
                               ))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                               (add-after 'unpack 'switch-to-pkg-src
                                 (lambda _ (chdir "pluginlib"))))))
      (home-page "https://wiki.ros.org/pluginlib")
      (synopsis "Tools for writing and dynamically loading plugins using the ROS build infrastructure")
      (description "These tools require plugin providers to register their plugins in the package.xml of their package.")
  (license license:bsd-3))))



(define-public ros-noetic-rosbag-migration-rule
  (let ((commit "c5c63f7b646be4c7c25218d5abe0c897a29c2e14")
        (revision "0"))
    (package
      (name "ros-noetic-rosbag-migration-rule")
      (version (git-version "1.0.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/rosbag_migration_rule")
                             (commit commit)))
         (sha256
          (base32 "0a6vl6vlypv2ywxpf2wvjrvqvmbra20k0nsvrrv9z4bbpxj048pc"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (home-page "http://wiki.ros.org/rosbag_migration_rule")
      (synopsis "Empty package to allow exporting rosbag migration rule files without depending on rosbag")
      (description "Empty package to allow exporting rosbag migration rule files without depending on rosbag.")
      (license license:bsd-3))))

(define-public ros-noetic-rosconsole-bridge
  (let ((commit "ba01216e44b3f70cb1166b5b2d292ba594718205")
        (revision "0"))
    (package
      (name "ros-noetic-rosconsole-bridge")
      (version (git-version "0.5.5" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/rosconsole_bridge")
                             (commit commit)))
         (sha256
          (base32 "13pjbfscx6cwr8fkdh8fq4ga1kbmdyf6sjzcyvpbwdycz70y4fgc"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs
       (list ros-noetic-cpp-common
             console-bridge
             ros-noetic-rosconsole))
      (home-page "http://wiki.ros.org/rosconsole_bridge")
      (synopsis "Used in conjunction with console_bridge and rosconsole to connect console_bridge-based logging to rosconsole-logging")
      (description "Used in conjunction with consoel_bridge and rosconsole to connect console_bridge-based logging to rosconsole-logging.")
      (license license:bsd-3))))


(define-public ros-noetic-ros-core
  (let ((commit "482da3e297f47a2e06f54d54c16de7e3cb7ec0f4")
        (revision "0"))
    (package
      (name "ros-noetic-ros-core")
      (version (git-version "1.5.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference (url "https://github.com/ros/metapackages")
                             (commit commit)))
         (sha256
          (base32 "0asbsc1r566i1ijmd5gbgx6pxsznki6ajryc4al2mnn7vn61rn6l"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs
       (list
        ros-noetic-class-loader
        ros-noetic-cmake-modules
        ros-noetic-common-msgs
        ros-noetic-gencpp
        ros-noetic-geneus
        ros-noetic-genlisp
        ros-noetic-genmsg
        ros-noetic-gennodejs
        ros-noetic-genpy
        ros-noetic-message-generation
        ros-noetic-message-runtime
        ros-noetic-pluginlib
        ros-noetic-ros
        ros-noetic-ros-comm
        ros-noetic-rosbag-migration-rule
        ros-noetic-rosconsole
        ros-noetic-rosconsole-bridge
        ros-noetic-roscpp-core
        ros-noetic-rosgraph-msgs
        ros-noetic-roslisp
        ros-noetic-rospack
        ros-noetic-std-msgs
        ros-noetic-std-srvs))
      (arguments (list
                  #:phases #~(modify-phases %standard-phases
                               ;; go to the directory for the ros package
                     (add-after 'unpack 'switch-to-pkg-src
                       (lambda _ (chdir "ros_core"))))))
      (home-page "http://wiki.ros.org/ros_core")
      (synopsis "Aggregates the packages required to use core ROS concepts")
      (description "A metapackage to aggregate the packages required to
use publish / subscribe, services, launch files, and other core ROS concepts")
      (license license:bsd-3))))
