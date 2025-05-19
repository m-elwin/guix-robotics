(define-module (guix build catkin-build-system)
  #:use-module ((guix build cmake-build-system) #:prefix cmake-build:)
  #:use-module ((guix build python-build-system) #:prefix py-build:)
  #:use-module (guix build utils)
  #:export (%standard-phases))

;; Commentary:
;;
;; Builder-side code of the standard catkin build procedure
;; Mostly follows the template and reuses cmake-build-system
;;
;; Code:

(define (add-installed-ros-package-path inputs outputs)
  "Prepend the package directory of OUTPUT to the ROS_PACKAGE_PATH"
  (let ((old-ros-path (getenv "ROS_PACKAGE_PATH"))
        (new-ros-path (assoc-ref outputs "out")))
    (if old-ros-path
        (setenv "ROS_PACKAGE_PATH" (string-append new-ros-path ":" old-ros-path)
               (setenv "ROS_PACKAGE_PATH" new-ros-path) ))))

(define* (add-install-to-ros-package-path #:key inputs outputs #:allow-other-keys)
  "A phase that just wraps the 'add-installed-ros-package-path procedure."
  (add-installed-ros-package-path inputs outputs))

(define %standard-phases
  (modify-phases cmake-build:%standard-phases
    (add-after 'unpack 'ensure-no-mtimes-pre-1980
      (assoc-ref py-build:%standard-phases 'ensure-no-mtimes-pre-1980))
    (add-after 'ensure-no-mtimes-pre-1980 'enable-bytecode-determinism
      (assoc-ref py-build:%standard-phases 'enable-bytecode-determinism))
    (add-after 'enable-bytecode-determinism 'ensure-no-cythonized-files
      (assoc-ref py-build:%standard-phases 'ensure-no-cythonized-files))
    (add-after 'install 'add-install-to-pythonpath
      (assoc-ref py-build:%standard-phases 'add-install-to-pythonpath))
    (add-after 'add-install-to-pythonpath 'add-install-to-path
      (assoc-ref py-build:%standard-phases 'add-install-to-path))
    (add-after 'add-install-to-path 'add-ros-package-path add-install-to-ros-package-path)
    (add-after 'add-ros-package-path 'wrap
      (assoc-ref py-build:%standard-phases 'wrap))))
