;;; Uses catkin as the build system.
;;; Here catkin refers to cmake and python modules used by tools
;;; such as catkin_make, catkin_make_isolated and catkin-tools
;;; This build system calls cmake with the necessary other packages
;;; in the environment. It does not directly invoke any of the catkin
;;; build tools
;;; Note: this file was modeled after the guix/build-systems/mozilla.scm 
(define-module (catkin-build-system)
  #:use-module (guix build-system)
  #:use-module (guix build-system cmake)
  #:use-module (guix utils)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (ros-noetic-deps))

;;; Defined to augment the native inputs of anything that uses this build system
(define* (lower-catkin name #:key native-inputs #:allow-other-keys
                        #:rest arguments)
  (define lower (build-system-lower cmake-build-system))
  (apply lower name
         (substitute-keyword-arguments arguments
               ((#:native-inputs original-inputs ''())
                (append `(("catkin" ,catkin)
                          ("python" ,python)
                          ("python-catkin-pkg" ,python-catkin-pkg)
                          ("python-empy" ,python-empy))
                        original-inputs)))))

(define-public catkin-build-system
  (build-system
    (inherit cmake-build-system)
    (description "The build system for ros-noetic using catkin")
    (lower lower-catkin)))
