;;; ROS noetic core dependencies
(define-module (ros-noetic ros)
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
  #:use-module (ros-noetic core)
  #:use-module (ros-noetic ros-comm)
  #:use-module (ros-noetic roscpp-core)
  #:use-module (ros-noetic bootstrap))

(define ros-root-search-path
  (search-path-specification (variable "ROS_ROOT") (files (list "share/ros"))))

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
