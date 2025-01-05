;;; hl-printf.el --- Minor mode for highlighting "printf" format specifiers -*- lexical-binding: t; -*-

;; Author: 8dcc <8dcc.git@gmail.com>
;; Version: 1.0.0
;; Package-Requires: ((emacs "24.1") (compat "29.1.0.1"))
;; Keywords: c, faces
;; URL: https://github.com/8dcc/hl-printf.el

;; This program is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free Software
;; Foundation, either version 3 of the License, or (at your option) any later
;; version.
;;
;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
;; FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
;; details.
;;
;; You should have received a copy of the GNU General Public License along with
;; this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package enables highlighting of "printf" format specifiers such as "%s"
;; and "%lld", like certain modal editors do.
;;
;; Specifically, this package is written for C code that follows the C99
;; standard.  See also: https://www.iso-9899.info/n1256.html#7.19.6.1

;;; Code:

(defgroup hl-printf nil
  "Highlight \"printf\" format specifiers."
  :link '(url-link :tag "Homepage" "https://github.com/8dcc/hl-printf.el")
  :link '(emacs-library-link :tag "Library Source" "hl-printf.el")
  :group 'faces
  :tag "Highlight printf"
  :prefix "hl-printf-")

;; NOTE: Technically, precision specifiers are only valid for some conversion
;; specifiers. We ignore this (just like vim does).
(defcustom hl-printf-regexp
  (rx
   ;; Initial format character (mandatory).
   "%"

   ;; Flags.
   (opt
    (or "-"
        "+"
        " "
        "#"
        "0"))

   ;; Minimum field width. Zero is not allowed, since it's part of the "Flags".
   (opt
    (or "*"
        (one-or-more (any "1-9"))))

   ;; Precission. Zero is allowed after the dot.
   (opt
    (seq "."
         (opt
          (or "*"
              (one-or-more digit)))))

   ;; Length modifier.
   (opt
    (or (repeat 1 2 "h")
        (repeat 1 2 "l")
        "j"
        "z"
        "t"
        "L"))

   ;; Conversion specifier (mandatory).
   (or "d" "i"
       "o" "u" "x" "X"
       "f" "F"
       "e" "E"
       "a" "A"
       "c"
       "s"
       "p"
       "n"
       "%"))
  "Regular expression used for matching \"printf\" format specifiers."
  :group 'hl-printf
  :tag "Highlight printf regexp"
  :type '(regexp))

(defface hl-printf-face
  '((t :inherit font-lock-keyword-face))
  "Face used for `hl-printf' mode."
  :group 'hl-printf
  :tag "Highlight printf regexp")

(defun hl-printf--point-inside-string-p (&optional pos)
  "Return t if POS is located inside a string literal according to syntax state.
The POS argument defaults to point."
  (not (null (nth 3 (syntax-ppss pos)))))

(defun hl-printf--search (limit)
  "Search for `hl-printf-regexp' up to LIMIT.
Returns t if the match is found inside a string, or nil otherwise."
  (and (re-search-forward hl-printf-regexp limit t)
       (hl-printf--point-inside-string-p)))

;;;###autoload
(define-minor-mode hl-printf-mode
  "Highlight \"printf\" format specifiers in strings."
  :lighter ""
  :init-value nil
  :global nil
  :group 'hl-printf
  (let ((keywords '((hl-printf--search 0 'hl-printf-face prepend))))
    (if hl-printf-mode
        (font-lock-add-keywords nil keywords)
      (font-lock-remove-keywords nil keywords)))
  (when font-lock-mode
    (if (fboundp 'font-lock-flush)
        (font-lock-flush)
      (with-no-warnings (font-lock-fontify-buffer)))))

(provide 'hl-printf)
;;; hl-printf.el ends here
