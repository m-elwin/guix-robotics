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

(define-module (ros-noetic roscpp-core)
  #:use-module (guix build-system catkin)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (gnu packages boost)
  #:use-module (ros-noetic bootstrap))


;; Commentary:
;;
;; Packages that are part roscpp_core
;; All (originally) at https://github.com/ros/roscpp_core
;;
;; Ideally, all packages here should be kept at the same
;; commit and version.
;;
;; Code:

(define-public ros-noetic-cpp-common
  (let ((commit "2951f0579a94955f5529d7f24bb1c8c7f0256451")
        (revision "0"))
    (package
      (name "ros-noetic-cpp-common")
      (version (git-version "0.7.3" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ros/roscpp_core")
               (commit commit)))
         (sha256
          (base32 "0zs0wlkldjkvyi2d74ri93hykbq2a5wmkb1x0jibnashlyiijiwj"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (inputs (list console-bridge))
      (propagated-inputs (list boost))
      (arguments (list #:package-dir "cpp_common"))
      (home-page "https://github.com/ros/roscpp_core")
      (synopsis
       "C++ code for doing things that are not necessarily ROS related")
      (description
       "C++ code for doing things that are not necessarily ROS
related, but are useful for multiple packages.  This includes things like
the ROS_DEPRECATED and ROS_FORCE_INLINE macros, as well as code for getting
backtraces.  This package is part of roscpp.")
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
         (uri (git-reference
               (url "https://github.com/ros/roscpp_core")
               (commit commit)))
         (sha256
          (base32 "0zs0wlkldjkvyi2d74ri93hykbq2a5wmkb1x0jibnashlyiijiwj"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list boost ros-noetic-cpp-common))
      (arguments (list #:package-dir "rostime"))
      (home-page "http://wiki.ros.org/roscpp/Overview/Time")
      (synopsis
       "Time and Duration implementation for C++ libraries, including roscpp")
      (description
       "Time and Duration implementation for C++ libraries, including for roscpp.
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
         (uri (git-reference
               (url "https://github.com/ros/roscpp_core")
               (commit commit)))
         (sha256
          (base32 "0zs0wlkldjkvyi2d74ri93hykbq2a5wmkb1x0jibnashlyiijiwj"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-cpp-common ros-noetic-rostime
                               ros-noetic-roscpp-traits))
      (arguments (list #:package-dir "roscpp_serialization"))
      (home-page "https://github.com/ros/roscpp_core")
      (synopsis "Serialization for ROS")
      (description
       "Enables serializaing/deserializing ROS messages
to memory.  Serialization is described at
https://www.ros.org/wiki/roscpp/Overview/MessageSerializationAndAdaptingTypes")
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
         (uri (git-reference
               (url "https://github.com/ros/roscpp_core")
               (commit commit)))
         (sha256
          (base32 "0zs0wlkldjkvyi2d74ri93hykbq2a5wmkb1x0jibnashlyiijiwj"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-cpp-common ros-noetic-rostime))
      (arguments (list #:package-dir "roscpp_traits"))
      (home-page "http://wiki.ros.org/roscpp_traits")
      (synopsis "Message traits for ROS")
      (description "Message traits as defined in
http://www.ros.org/wiki/roscpp/Overview/MessagesTraits.")
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
         (uri (git-reference
               (url "https://github.com/ros/roscpp_core")
               (commit commit)))
         (sha256
          (base32 "0zs0wlkldjkvyi2d74ri93hykbq2a5wmkb1x0jibnashlyiijiwj"))
         (file-name (git-file-name name version))))
      (build-system catkin-build-system)
      (propagated-inputs (list ros-noetic-cpp-common
                               ros-noetic-roscpp-serialization
                               ros-noetic-roscpp-traits ros-noetic-rostime))
      (arguments (list #:package-dir "roscpp_core"))
      (home-page "http://wiki.ros.org/roscpp")
      (synopsis "Metpackage with libraries for roscpp messages")
      (description
       "Underlying data libraries
for roscpp messages.ros.org/wiki/roscpp/Overview/MessagesTraits.")
      (license license:bsd-3))))
