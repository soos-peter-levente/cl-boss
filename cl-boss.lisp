(in-package :cl-boss)

(defparameter board nil)

(defun start-game (&optional (size 4))
  (initialize-board size)
  (run-game-loop))

(defun prompt-player (prompt-string)
  (format t prompt-string)
  (let ((input (read-line *query-io*)))
    (when (not (= (length input) 0))
      (coerce (subseq input 0 1) 'character))))

(defun run-game-loop ()
  (loop until (solved-p)
     do (print-board)
       (let ((player-move (prompt-player "~%Move (u,d,l,r,q): ")))
         (cond ((equal player-move #\q) (return-from nil))
               (t (move-tile player-move))))))

(defun initialize-board (size)
  (setf board (shuffle-board-array (make-board-array size)
                                   (* size 500))))

(defun make-board-array (n)
  (let ((tile 0) (board (make-array (list n n) :initial-element nil)))
    (dotimes (i (1- (array-total-size board)) board)
      (setf (row-major-aref board i) (incf tile)))))

(defun shuffle-board-array (board n)
  (dotimes (i n board)
    (move-tile (nth (random 4) '(#\u #\d #\r #\l)))))

(defun move-tile (direction)
  (let ((target (assoc direction (active-directions))))
    (when target
      (destructuring-bind (a-x a-y b-x b-y)
          (append (empty-position) (cadr target))
        (rotatef (aref board a-x a-y)
                 (aref board b-x b-y))))))

(defun empty-position ()
  (let ((size (array-dimension board 0)))
    (dotimes (i size)
      (dotimes (j size)
        (when (null (aref board i j))
          (return-from empty-position (list i j)))))))

(defun active-directions ()
  (let* ((empty (empty-position)) (x (car empty)) (y (cadr empty))
         (max (1- (array-dimension board 0))))
    (remove-if #'(lambda (c)
                   (destructuring-bind (x y) (list (caadr c) (cadadr c))
                     (or (> x max) (> y max) (< x 0) (< y 0))))
               `((#\d (,(1- x) ,y)) (#\u (,(1+ x) ,y))
                 (#\r (,x ,(1- y))) (#\l (,x ,(1+ y)))))))

(defun solved-p ()
  (dotimes (i (1- (array-total-size board)) t)
    (unless (and (numberp #1=(row-major-aref board i)) (= #1# (1+ i)))
      (return-from solved-p nil))))

(defun print-board ()
  (flet ((slice (row)
           (make-array (array-dimension board 0) :displaced-to board
                       :displaced-index-offset (* row (array-dimension board 0)))))
    (dotimes (i (array-dimension board 0))
      (format t "~%~{ ~3d ~} ~%" (coerce (slice i) 'list)))))
