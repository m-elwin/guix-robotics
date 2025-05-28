(define-module (guix build catkin-build-system)
  #:use-module ((guix build cmake-build-system)
                #:prefix cmake-build:)
  #:use-module ((guix build python-build-system)
                #:prefix py-build:)
  #:use-module (guix build utils)
  #:export (%standard-phases))

;; Commentary:
;;
;; Builder-side code of the standard catkin build procedure
;; Mostly follows the template and reuses cmake-build-system
;;
;; Code:

(define* (ros-wrap #:key outputs #:allow-other-keys)
  "Set's ROS Environment variables for each ROS-related program.
See http://wiki.ros.org/ROS/EnvironmentVariables.
Also creates an opt/ros/ directory with noetic symlinking back"
  (for-each (lambda (file)
               ;wrap all binaries with the proper ROS env variables
              (display (string-append "ROS Wrapping " file))
              (newline)
              (wrap-program file
                `("ROS_DISTRO" "" =
                  ,(list "noetic"))
                `("ROS_MASTER_URI" "" =
                  ,(list "${ROS_MASTER_URI:=http://localhost:11311}"))
                `("CMAKE_PREFIX_PATH" prefix
                  ,(list "${GUIX_ROS_CMAKE_PREFIX_PATH}"))
                `("ROS_PACKAGE_PATH" prefix
                  ,(list "${GUIX_ROS_PACKAGE_PATH}"))))
            (find-files (string-append (assoc-ref outputs "out") "/bin")
                        "^[^\\.].*")))

(define* (catkin-test-results #:key inputs outputs #:allow-other-keys)
  "Run catkin-test-results so that the result or run_tests failing will cause the build to fail"
  (let ((catkin (assoc-ref inputs "catkin")))
    (if catkin ;when catkin? was #f, catkin is not an input so we can't run this step
        (invoke (string-append catkin "/bin/catkin_test_results")))))

(define (check-with-results . args)
  "Run the check then run catkin-test-results so check fails if tests did"
  (setenv "ROS_LOG_DIR" "/tmp") ;must be a writeable dir
  (apply (assoc-ref cmake-build:%standard-phases
                    'check) args)
  (apply catkin-test-results args))

(define %standard-phases
  (modify-phases cmake-build:%standard-phases
    (add-after 'unpack 'ensure-no-mtimes-pre-1980
      (assoc-ref py-build:%standard-phases
                 'ensure-no-mtimes-pre-1980))
    (add-after 'ensure-no-mtimes-pre-1980 'enable-bytecode-determinism
      (assoc-ref py-build:%standard-phases
                 'enable-bytecode-determinism))
    (add-after 'enable-bytecode-determinism 'ensure-no-cythonized-files
      (assoc-ref py-build:%standard-phases
                 'ensure-no-cythonized-files))
    (add-after 'install 'add-install-to-pythonpath
      (assoc-ref py-build:%standard-phases
                 'add-install-to-pythonpath))
    (add-after 'add-install-to-pythonpath 'add-install-to-path
      (assoc-ref py-build:%standard-phases
                 'add-install-to-path))
    (add-after 'add-install-to-path 'wrap
      (assoc-ref py-build:%standard-phases
                 'wrap))
    (add-after 'wrap 'ros-wrap
      ros-wrap)
    (replace 'check
      check-with-results)))
