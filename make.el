;; -*- lexical-binding: t; -*-
;; 2025-07-09
;; Authored by David Harris



;; a script to compile this project. Its part of my general deployment workflow that depends on lisp outside this project.


;; all the other files in the repo are the bricks. This is the mortar.



(setq plot-file "s:/CC Concurrence Workspace/HARRISDM/RM06analyst/MPSgantt/schedule_gantt.plt")


(cli-gnuplot-file-runner plot-file)





;; open in emacs (can probably be set to open in web browser)
(browse-url "file:///s:/CC%20Concurrence%20Workspace/HARRISDM/RM06analyst/MPSgantt/MPSgantt.svg")

;; open in emacs
(find-file "s:/CC Concurrence Workspace/HARRISDM/RM06analyst/MPSgantt/MPSgantt.svg")





(setq test1 "s:/CC Concurrence Workspace/HARRISDM/RM06analyst/MPSgantt/test1.plt")

(cli-gnuplot-file-runner test1)
