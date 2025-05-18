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
    (add-after 'add-install-to-path 'wrap
      (assoc-ref py-build:%standard-phases 'wrap))))
