(require 'url)
(require 'json)

;; set an api-key for talking to giphy here
(defvar
  giphy-api-key
  "")

(defvar
  giphy-random-endpoint
  (format "https://api.giphy.com/v1/gifs/random?api_key=%s&tag=" giphy-api-key))

(defun giphy ()
  "Generate a markdown snippet for a random giphy for the given keyword and put it on the kill-ring"
  (interactive)
  (let ((search-term (read-string "Giphy search for: "))
      (url-request-method "GET"))
  (url-retrieve
   (concat
    giphy-random-endpoint
    (url-hexify-string search-term))
   (lambda (response)
     (goto-char url-http-end-of-headers)
     (let ((json-object-type 'plist)
           (json-key-type 'symbol)
           (json-array-type 'vector))
       (let ((result (json-read)))
         (let ((data (plist-get result 'data)))
               (let ((snippet
               (format
                "![%s](%s)"
                (plist-get data 'title)
                (plist-get data 'image_url))))
                 (message snippet)
                 (kill-new snippet)))))))))
