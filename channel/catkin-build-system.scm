;;; Uses catkin as the build system.
;;; Here catkin refers to cmake and python modules used by tools
;;; such as catkin_make, catkin_make_isolated and catkin-tools
;;; This build system calls cmake with the necessary other packages
;;; in the environment. It does not directly invoke any of the catkin
;;; build tools
;;; Note: this file was modeled after the guix/build-systems/mozilla.scm 
(define-module (catkin-build-system)
  #:use-module (guix build-system)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system cmake)
  #:use-module (guix utils)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (ros-noetic-deps))

(define (default-catkin)
  "Return the default catkin package."
  ;; Do not use `@' to avoid introducing circular dependencies.
  ;; This is borrowed from (default-cmake) in guix/build-system/cmake.scm
  ;; I think what the comment above means is we don't use the module that contains catkin here
  ;; because catkin uses catkin-build-system to build itself, so instead we fetch the catkin package
  ;; directly
  (let ((module (resolve-interface '(ros-noetic-core))))
    (module-ref module 'catkin)))

;;; Defined to augment the native inputs of anything that uses this build system
(define* (lower-catkin name #:key (catkin (default-catkin)) native-inputs #:allow-other-keys
                        #:rest arguments)
  (define lower (build-system-lower cmake-build-system))
  "Return a bag for NAME."
  (define private-keywords '(#:catkin))
  (apply lower name
         (substitute-keyword-arguments (strip-keyword-arguments private-keywords arguments)
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
