;;; hl-printf.el --- Highlight "printf" format specifiers in Emacs -*- lexical-binding: t; -*-

;; Author: 8dcc <8dcc.git@gmail.com>
;; Version: 1.0.0
;; Package-Requires: TODO
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
  :prefix "hl-printf-")

;; NOTE: Technically, precision specifiers are only valid for some conversion
;; specifiers. We ignore this (just like vim does).
(defcustom hl-printf-regexp
  (rx
   ;; Initial format character (mandatory)
   "%"

   ;; Flags (optional)
   (opt
    (or "-"
        "+"
        " "
        "#"
        "0"))

   ;; Minimum field width (optional)
   (opt
    (or "*" (any "1-9")))

   ;; Precission (optional)
   (opt
    (seq "."
         (opt
          (or "*" digit))))

   ;; Length modifier (optional)
   (opt
    (or (repeat 1 2 "h")
        (repeat 1 2 "l")
        "j"
        "z"
        "t"
        "L"))

   ;; Conversion specifier (mandatory)
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
  :type '(regexp))

;; TODO: Highlight the regexp

(provide 'hl-printf)
;;; hl-printf.el ends here
