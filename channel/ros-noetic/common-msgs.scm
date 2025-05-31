(define-module (ros-noetic common-msgs)
  #:use-module (guix build-system catkin)
  #:use-module ((guix licenses) #:prefix license:)
;  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix git-download)
;  #:use-module (guix search-paths)
;  #:use-module (guix gexp)
;  #:use-module (guix utils)
;  #:use-module (gnu packages base)
;  #:use-module (gnu packages check)
;  #:use-module (gnu packages compression)
;  #:use-module (gnu packages cmake)
;  #:use-module (gnu packages cpp)
;  #:use-module (gnu packages commencement)
;  #:use-module (gnu packages gnupg)
;  #:use-module (gnu packages lisp)
;  #:use-module (gnu packages pkg-config)
;  #:use-module (gnu packages python)
;  #:use-module (gnu packages python-crypto)
;  #:use-module (gnu packages python-xyz)
;  #:use-module (gnu packages shells)
;  #:use-module (gnu packages tls)
;  #:use-module (gnu packages xml)
;  #:use-module (contributed)
  #:use-module (ros-noetic core)
  #:use-module (ros-noetic ros)
  #:use-module (ros-noetic ros-comm)
;  #:use-module (ros-noetic bootstrap))
  )

(define-public ros-noetic-actionlib-msgs
  (let ((commit "1230f39a7068d1d73d1039eb0eb970c922b6bcf7")
        (revision "0"))
    (package
      (name "ros-noetic-actionlib-msgs")
      (version (git-version "1.13.2" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/common_msgs")
               (commit commit)))
         (sha256
          (base32 "02wqhg70a2h3fsfkavcpvk5rvfy1nai2094irvpywmc0w4wd46sm"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation ))
      (propagated-inputs (list ros-noetic-message-runtime
                               ros-noetic-std-msgs))
      (arguments
       (list
        #:package-dir "actionlib_msgs"))
      (home-page "https://wiki.ros.org/actionlib_msgs")
      (synopsis
       "Common messages to interact with an action server and action client")
      (description
       "Common messages to interact with an action server and action client.")
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
         (uri (git-reference
               (url "https://github.com/ros/common_msgs")
               (commit commit)))
         (sha256
          (base32 "02wqhg70a2h3fsfkavcpvk5rvfy1nai2094irvpywmc0w4wd46sm"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation))
      (propagated-inputs (list ros-noetic-message-runtime ros-noetic-std-msgs))
      (arguments
       (list
        #:package-dir "diagnostic_msgs"))
      (home-page "https://wiki.ros.org/diagnostic_msgs")
      (synopsis
       "Standardized interface for diagnostic and runtime monitoring in ROS")
      (description
       "Holds the diagnostic messages which provide the
standardized interface for the diagnostic and runtime monitoring
systems in ROS. These messages are currently used by
the http://wiki.ros.org/diagnostics Stack,
which provides libraries for simple ways to set and access
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
         (uri (git-reference
               (url "https://github.com/ros/common_msgs")
               (commit commit)))
         (sha256
          (base32 "02wqhg70a2h3fsfkavcpvk5rvfy1nai2094irvpywmc0w4wd46sm"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation))
      (propagated-inputs (list ros-noetic-message-runtime ros-noetic-std-msgs))
      (arguments
       (list
        #:package-dir "geometry_msgs"))
      (home-page "https://wiki.ros.org/geometry_msgs")
      (synopsis "Messages for common geometric primitives")
      (description
       "Provides messages for common geometric primitives
such as points, vectors, and poses.  These primitives are designed
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
         (uri (git-reference
               (url "https://github.com/ros/common_msgs")
               (commit commit)))
         (sha256
          (base32 "02wqhg70a2h3fsfkavcpvk5rvfy1nai2094irvpywmc0w4wd46sm"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation))
      (propagated-inputs (list ros-noetic-actionlib-msgs
                               ros-noetic-message-runtime
                               ros-noetic-geometry-msgs ros-noetic-std-msgs))
      (arguments
       (list
        #:package-dir "nav_msgs"))
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
         (uri (git-reference
               (url "https://github.com/ros/common_msgs")
               (commit commit)))
         (sha256
          (base32 "02wqhg70a2h3fsfkavcpvk5rvfy1nai2094irvpywmc0w4wd46sm"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation ros-noetic-rosbag
                           ros-noetic-rosunit))
      (propagated-inputs (list ros-noetic-message-runtime
                               ros-noetic-geometry-msgs ros-noetic-std-msgs))
      (arguments
       (list
        #:package-dir "sensor_msgs"))
      (home-page "https://wiki.ros.org/sensor_msgs")
      (synopsis "Messages for commonly used sensors")
      (description "Messages for commonly used sensors
 including cameras and scanning laser rangefinders.")
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
         (uri (git-reference
               (url "https://github.com/ros/common_msgs")
               (commit commit)))
         (sha256
          (base32 "02wqhg70a2h3fsfkavcpvk5rvfy1nai2094irvpywmc0w4wd46sm"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation))
      (propagated-inputs (list ros-noetic-message-runtime
                               ros-noetic-geometry-msgs ros-noetic-std-msgs))
      (arguments
       (list
        #:package-dir "shape_msgs"))
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
         (uri (git-reference
               (url "https://github.com/ros/common_msgs")
               (commit commit)))
         (sha256
          (base32 "02wqhg70a2h3fsfkavcpvk5rvfy1nai2094irvpywmc0w4wd46sm"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (native-inputs (list ros-noetic-message-generation))
      (propagated-inputs (list ros-noetic-message-runtime
                               ros-noetic-sensor-msgs ros-noetic-std-msgs))
      (arguments
       (list
        #:package-dir "stereo_msgs"))
      (home-page "https://wiki.ros.org/stereo_msgs")
      (synopsis
       "Messages specific to stereo processing, such as disparity images")
      (description
       "Messages specific to stereo processing, such as disparity images.")
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
      (arguments (list #:package-dir "trajectory_msgs"))
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
