(define-module (asahi guix transformations)
  #:use-module ((asahi guix packages))
  #:use-module ((asahi guix packages jemalloc) #:prefix next:)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages jemalloc)
  #:use-module (gnu packages xdisorg)
  #:use-module (guix packages)
  #:export (replace-asahi
            replace-jemalloc
            replace-libdrm
            replace-mesa))

(define replace-asahi
  (package-input-rewriting
   `((,jemalloc . ,next:jemalloc)
     (,libdrm . ,libdrm-2-4-114)
     (,mesa . ,mesa-asahi-edge))))

(define replace-jemalloc
  (package-input-rewriting `((,jemalloc . ,next:jemalloc))))

(define replace-libdrm
  (package-input-rewriting `((,libdrm . ,libdrm-2-4-114))))

(define replace-mesa
  (package-input-rewriting `((,mesa . ,mesa-asahi-edge))))
