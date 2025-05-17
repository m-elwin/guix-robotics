(define-module (guix build-system catkin)
  #:use-module (guix build utils)
  #:use-module (guix build-system)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system python)
  #:use-module (guix utils)
  #:use-module (guix gexp)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (ros-noetic-deps))

;; Commentary:
;;
;; Standard build procedure for packages using catkin. This is implemented as an
;; extension of `cmake-build-system'. Essentially it uses cmake to build packages
;; but also provides necessary inputs for the catkin-cmake extentions and for
;; python because catkin uses cmake to also install python code
;;
;; Code:

(define (default-catkin)
  "Return the default catkin package."
  ;; Do not use `@' to avoid introducing circular dependencies.
  ;; This is borrowed from (default-cmake) in guix/build-system/cmake.scm
  ;; I think what the comment above means is we don't use the module that contains catkin here
  ;; because catkin uses catkin-build-system to build itself, so instead we fetch the catkin package
  ;; directly
  (let ((module (resolve-interface '(ros-noetic-core))))
    (module-ref module 'catkin)))

(define %catkin-build-system-modules
  ;; Build-side modules imported by default.
  `((guix build catkin-build-system)
    ,@%cmake-build-system-modules
    ,@%python-build-system-modules))

  ;;; adds some python phases to gnu
;;; Defined to augment the native inputs of anything that uses this build system
(define* (lower-catkin name #:key (catkin (default-catkin))
                       #:allow-other-keys
                       #:rest arguments)
  (define lower (build-system-lower cmake-build-system))
  "Return a bag for NAME."
  (define private-keywords '(#:catkin))
  ;; %standard-phases from the g-exp is looked up in some module, not sure which module
  (apply lower name
         (substitute-keyword-arguments (strip-keyword-arguments private-keywords arguments)
           ((#:native-inputs original-native-inputs '())
            (append `(("catkin" ,catkin)
                      ("python" ,python)
                      ("python-catkin-pkg" ,python-catkin-pkg)
                      ("python-empy" ,python-empy))
                    original-native-inputs))
           ((#:modules orig-modules '())
            (append `(((guix build cmake-build-system) #:select (cmake-build))
                      (guix build catkin-build-system)
                      (guix build utils)) orig-modules))
           ((#:imported-modules orig-imported-modules '())
             (append %catkin-build-system-modules orig-imported-modules)))))

(define-public catkin-build-system
  (build-system
    (name "catkin-build-system")
    (description "The build system for ros-noetic using catkin")
    (lower lower-catkin)))

