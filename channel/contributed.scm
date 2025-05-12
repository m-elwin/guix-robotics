;; Items that are contributed to gnu guix and pending review
(define-public python-vcstool ; gnu bug 78219
  (package
    (name "python-vcstool")
    (version "0.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "vcstool" version))
       (sha256
        (base32 "0b7f68q25x9nxqa3xcg32js3qgp4jg99anwy2c7nd1jkw5iskcq4"))))
    (build-system pyproject-build-system)
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'wrap 'wrap-script
            (lambda _
              (wrap-program (string-append #$output "/bin/vcs")
                `("PATH" prefix
                  ,(list (string-append #$git "/bin")
                         (string-append #$mercurial "/bin")
                         (string-append #$mercurial "/bin")
                         (string-append #$breezy "/bin")
                         (string-append #$subversion "/bin")))))))))
    (inputs (list bash-minimal))
    (propagated-inputs (list python-pyyaml python-setuptools))
    (native-inputs (list python-setuptools python-wheel))
    (home-page "https://github.com/dirk-thomas/vcstool")
    (synopsis
     "Command line tool to invoke version control commands on multiple repositories")
    (description
     "Enables manipulating multiple version control repositories with one command.")
    (license license:asl2.0)))

(define-public log4cxx ; gnu bug 78395
  (package
    (name "log4cxx")
    (version "1.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://apache/logging/log4cxx/" version
                           "/apache-log4cxx-" version ".tar.gz"))
       (sha256
        (base32 "15kgxmqpbg8brf7zd8mmzr7rvm9zrigz3ak34xb18v2ld8siyb9x"))))
    (build-system cmake-build-system)
    (native-inputs (list apr apr-util pkg-config zip))
    (home-page "https://logging.apache.org/log4cxx/")
    (synopsis "C++ logging library patterned after Apache log4j")
    (description
     "A C++ logging framework patterned after Apache
log4j which uses Apache Portable Runtime for most platform-specific code
and should be usable on any platform supported by APR")
    (license license:asl2.0)))
