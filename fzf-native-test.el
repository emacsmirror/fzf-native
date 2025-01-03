;;; fzf-native-test.el --- `fzf-native' test. -*- lexical-binding: t; -*-
(require 'ert)
(require 'fzf-native)

(fzf-native-load-dyn)

(ert-deftest fzf-native-score-indices-order-test ()
  (let ((result (fzf-native-score "abcdefghi" "acef")))
    (should (= (nth 1 result) 0))
    (should (= (nth 2 result) 2))
    (should (= (nth 3 result) 4))
    (should (= (nth 4 result) 5))))

(ert-deftest score-with-default-slab-indices-order-test ()
  (let* ((slab (fzf-native-make-default-slab))
         (result (fzf-native-score "abcdefghi" "acef" slab)))
    (should (= (nth 1 result) 0))
    (should (= (nth 2 result) 2))
    (should (= (nth 3 result) 4))
    (should (= (nth 4 result) 5))))

(ert-deftest fzf-native-score-with-default-slab-test ()
  "Test slab can be reused."
  (let* ((slab (fzf-native-make-default-slab))
         (result (fzf-native-score "abcdefghi" "acef" slab)))
    (should
     (equal (fzf-native-score "abcdefghi" "acef" slab)
        '(78 0 2 4 5)))
    (should
     (equal (fzf-native-score "abc" "acef" slab)
        '(0)))
    (should
     (equal (fzf-native-score "zzzzzabc" "z" slab)
        '(32 0)))
    (should
     (equal (fzf-native-score "sfsjoc" "jo" slab)
        '(36 3 4)))))

(ert-deftest fzf-native-score-with-default-slab-benchmark-test ()
  "Test scoring with slab is faster."
  (let* ((slab (fzf-native-make-default-slab))
         (str "aaaaaasdfas;ldfjalsdjfasdfaourioquruwrqrqwruqaaaaaafffffffaadf31230")
         (query "asldfjasldfasdsfofjadf"))
    (should
     (<
      (car
       (benchmark-run 10000
         (fzf-native-score str query slab)))
      (car
       (benchmark-run 10000
         (fzf-native-score str query)))))))
