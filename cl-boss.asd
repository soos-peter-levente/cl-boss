(asdf:defsystem #:cl-boss
  :name "cl-boss"
  :author "Soós Péter Levente"
  :license "MIT"
  :description "A game known variously as boss puzzle, Mystic Square, or 15-tile sliding puzzle."
  :components ((:file "package")
               (:file "cl-boss" :depends-on ("package"))))
