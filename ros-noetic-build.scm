(define-module (ros-noetic-build)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix build-system pyproject)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (gnu packages)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages check)
  #:use-module (gnu packages time)
  )


(define-public python-catkin-pkg
  (let ((commit "fb2468e6c2565802bc3ef6134a76db76ae9f3632")
        (revision "1"))
  (package
    (name "python-catkin-pkg")
    (version (git-version "1.0.0" revision commit))
    (source
     (origin
       (method git-fetch)
       (uri (git-reference (url "https://github.com/ros-infrastructure/catkin_pkg")
                           (commit commit)))
       (sha256
        (base32 "0m5w3fq8gwh2kb08yvdy37sxrc8s490vab5r66sv6h2x9y20lxcl"))
         (file-name (git-file-name name version))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-docutils python-pyparsing python-dateutil
                             python-setuptools))
    (native-inputs (list python-flake8
                         python-flake8-blind-except
                         python-flake8-builtins
                         python-flake8-class-newline
                         python-flake8-comprehensions
                         python-flake8-deprecated
                         python-flake8-docstrings
                         python-flake8-import-order
                         python-flake8-quotes
                         python-pytest
                         python-setuptools
                         python-wheel))
    (home-page "http://wiki.ros.org/catkin_pkg")
    (synopsis "catkin package library")
    (description "catkin package library.")
    (license license:bsd-3))))



(define-public python-rospkg
  (let ((commit "db7614e5209137faa6ec01e2edaf34f775780b1a")
        (revision "1"))
  (package
    (name "python-rospkg")
    (version "1.6.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference (url "https://github.com/ros-infrastructure/rospkg")
                           (commit commit)))
       (sha256
        (base32 "1v0f8g3sycb8rkb6xqkl3pbpxikfya72xfrzpa37hgvpx9ixsxza"))
        (file-name (git-file-name name version))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-catkin-pkg python-pyyaml))
    (native-inputs (list python-distro python-pytest python-setuptools python-wheel))
    (home-page "http://wiki.ros.org/rospkg")
    (synopsis "ROS package library")
    (description "ROS package library.")
    (license license:bsd-3))))

(define-public python-rosdistro
  (let ((commit "9c909bfb7f34e13e8229f1742b6493b228a3cfa9")
        (revision "1"))
  (package
    (name "python-rosdistro")
    (version (git-version "1.0.1" revision commit))
    (source
     (origin
       (method git-fetch)
       (uri (git-reference (url "https://github.com/ros-infrastructure/rosdistro")
                           (commit commit)))
       (sha256
        (base32 "1g4h2grqqa4952zrr3kyp2d22f8karx2ygyjqkhv86i8dg6i0fqi"))
        (file-name (git-file-name name version))))
    (build-system pyproject-build-system)
    (arguments (list
     #:test-flags #~(list "--ignore=test/test_manifest_providers.py"))) ; test downloads a lot and is hard to mock
    (propagated-inputs (list python-catkin-pkg python-pyyaml python-rospkg
                             python-setuptools))
    (native-inputs (list python-distro python-pytest python-setuptools python-wheel git))
    (home-page "http://wiki.ros.org/rosdistro")
    (synopsis "A tool to work with rosdistro files")
    (description "This package provides a tool to work with rosdistro files.")
    (license license:bsd-3))))

(define-public python-rosdep
  (let ((commit "78f3744f9054ed188bc23b830854080dc9face70")
        (revision "1"))
  (package
    (name "python-rosdep")
    (version (git-version "0.25.1" revision commit))
    (source
     (origin
       (method git-fetch)
       (uri (git-reference (url "https://github.com/ros-infrastructure/rosdep")
                           (commit commit)))
       (sha256
        (base32 "1n7fw73ikp02c8hxgg0vx3nl6zxdyxqy9lcl70162f3ss0lxkrl2"))
        (file-name (git-file-name name version))))
    (build-system pyproject-build-system)
      (arguments
       (list
        #:tests? #f ; too many tests that depend on environment
        #:phases
        #~(modify-phases %standard-phases
            (add-before 'check 'pre-check
              (lambda _
                (setenv "HOME" "/tmp")))
            )))
    (propagated-inputs (list python-catkin-pkg python-pyyaml python-rosdistro
                             python-rospkg))
    (native-inputs (list python-distro
                         python-flake8
                         python-flake8-builtins
                         python-flake8-comprehensions
                         python-flake8-quotes
                         python-pytest
                         python-setuptools
                         python-wheel))
    (home-page "http://wiki.ros.org/rosdep")
    (synopsis "rosdep package manager abstraction tool for ROS")
    (description "rosdep package manager abstraction tool for ROS.")
    (license license:bsd-3))))
