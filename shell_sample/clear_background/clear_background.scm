(define (clear-background infile outfile)
  (let* (
	 (copy-layer 0)
	 (cut-layer 0)
	 (feather 0)
	 (img (car (gimp-file-load 1 infile infile)))
	 (layer (car (gimp-image-active-drawable img)))
	 )


    (if (equal? (car (gimp-drawable-has-alpha layer)) FALSE)
	(gimp-layer-add-alpha layer))

    (define color (list 255 255 255) )
    (define threshold 15 )
    (define type 2)
    (define antialias TRUE)
    (define radius 0 )
    (if (> radius 0)(set! feather 1))
    (gimp-by-color-select layer color threshold type antialias feather radius FALSE)
    
    (if (= (car (gimp-selection-is-empty img)) FALSE)
    	(begin
    	  (gimp-layer-add-alpha layer)
    	  (gimp-edit-clear layer)
    	  (gimp-selection-none img)
    	  ))

    ;; (gimp-display-new img)
    ;; (gimp-displays-flush)
    (gimp-file-save 1 img layer outfile infile)
)
)

(script-fu-register
 "clear-background"
 "<Image>/Script-Fu/clear-background"
 "make background opacity 0"
 "Shibata Yasunori"
 "Copyright 2016"
 "Novemver 19, 2016"
 "";"RGB*, GRAY*"

 ;; SF-FILENAME "Infile" ""
 ;; SF-FILENAME "Outfile" ""
 SF-VALUE "InFile" ""
 SF-VALUE "OutFile" ""
)
