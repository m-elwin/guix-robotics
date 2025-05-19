(define-module (contributed)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system pyproject)
  #:use-module (guix build-system python)
  #:use-module (guix git-download)
  #:use-module (guix search-paths)
  #:use-module (guix gexp)
  #:use-module (gnu packages apr)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages version-control)
  )
;; Items that are contributed to gnu guix and pending review

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

(define-public log4cxx-0.11
  (package
    (inherit log4cxx)
    (version "0.11.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://apache/logging/log4cxx/" version
                           "/apache-log4cxx-" version ".tar.gz"))
       (sha256
        (base32 "14xkb34svkgn08gz7qbama3idlk2a4q5y7ansccvkrf4wdg705n3"))))))

(define-public log4cxx-noetic log4cxx-0.11)
