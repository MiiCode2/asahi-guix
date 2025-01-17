(define-module (asahi guix packages bootloader)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages bootloaders)
  #:use-module (gnu packages tls)
  #:use-module (guix build-system gnu)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix utils))

(define-public asahi-m1n1
  (let ((commit "a024101b757a43fa7af0c06344e46c553743e21a"))
    (package
      (name "asahi-m1n1")
      (version (git-version "1.2.6" "0" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/AsahiLinux/m1n1")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0vd5gwp11fza961f3413amnaq0x2b5nsv2ma2q30mqjia2x6w8cz"))))
      (build-system gnu-build-system)
      (supported-systems (list "aarch64-linux"))
      (arguments
       (list
        #:phases
        #~(modify-phases %standard-phases
            (replace 'configure
              (lambda _
                (setenv "RELEASE" "1")))
            (replace 'install
              (lambda* (#:key outputs #:allow-other-keys)
                (let ((dir (string-append (assoc-ref outputs "out") "/libexec/")))
                  (mkdir-p dir)
                  (copy-file "build/m1n1.bin" (string-append dir "m1n1.bin")))))
            ;; There are no tests
            (delete 'check))))
      (home-page "https://github.com/AsahiLinux/m1n1")
      (synopsis "Boot loader and experimentation playground for Apple Silicon")
      (description "m1n1 is the bootloader developed by the Asahi Linux project to bridge
the Apple (XNU) boot ecosystem to the Linux boot ecosystem.")
      (license license:expat))))

(define-public u-boot-apple-m1
  (let ((base (make-u-boot-package "apple_m1" "aarch64-linux-gnu"))
        (commit "e296d1a8cd0897de56ab2878bf19beeb824734de"))
    (package/inherit base
      (version (git-version "2023.01-3" "0" commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/AsahiLinux/u-boot")
               (commit commit)))
         (file-name (git-file-name (package-name base) version))
         (sha256
          (base32 "02krm2a6php8a53dshpybvh9r3mwpyqldhfbx021h0kn2bw114ah"))))
      (arguments
       (substitute-keyword-arguments (package-arguments base)
         ((#:phases phases '%standard-phases)
          #~(modify-phases #$phases
              (delete 'disable-tools-libcrypto)))))
      (native-inputs
       (modify-inputs (package-native-inputs base)
         (prepend libressl))))))
