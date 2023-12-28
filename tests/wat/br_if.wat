;; Test `return` operator
(module

  ;; Import our myprint function
  (import "myenv" "print" (func $print (param i64 i32)))

  ;; Define a single page memory of 64KB.
  (memory $0 1)

  ;; Store the Hello World (null terminated) string at byte offset 0
  (data (i32.const 40) "Test Passed\n")
  (data (i32.const 52) "#Test Failed\n")

  ;; Debug function
  (func $printd (param $len i32)
    i64.const 0
    (local.get $len)
    (call $print)
  )

  (func $printSuccess
    i64.const 40
    i32.const 12
    (call $print)
  )

  (func $printFail
    i64.const 52
    i32.const 13
    (call $print)
  )

  (func $assert_test_i32 (param $expected i32) (param $result i32)
    local.get $expected
    local.get $result
    i32.eq
    (if
      (then
        (call $printSuccess)
      )
      (else
        (call $printFail)
      )
    )
  )

  (func $assert_test_i64 (param $expected i64) (param $result i64)
    local.get $expected
    local.get $result
    i64.eq
    (if
      (then
        (call $printSuccess)
      )
      (else
        (call $printFail)
      )
    )
  )
  (func $dummy)
  (func $type-i32-value (result i32)
    (block (result i32) (i32.ctz (br_if 0 (i32.const 1) (i32.const 1))))
  )
  (func $type-i64-value (result i64)
    (block (result i64) (i64.ctz (br_if 0 (i64.const 2) (i32.const 1))))
  )
  (func $as-block-first (param i32) (result i32)
    (block (br_if 0 (local.get 0)) (return (i32.const 2))) (i32.const 3)
  )
  (func $as-block-mid (param i32) (result i32)
    (block (call $dummy) (br_if 0 (local.get 0)) (return (i32.const 2)))
    (i32.const 3)
  )
  (func $as-block-last (param i32)
    (block (call $dummy) (call $dummy) (br_if 0 (local.get 0)))
  )
  (func $as-block-first-value (param i32) (result i32)
    (block (result i32)
      (drop (br_if 0 (i32.const 10) (local.get 0))) (return (i32.const 11))
    )
  )
  (func $as-block-mid-value (param i32) (result i32)
    (block (result i32)
      (call $dummy)
      (drop (br_if 0 (i32.const 20) (local.get 0)))
      (return (i32.const 21))
    )
  )
  (func $as-block-last-value (param i32) (result i32)
    (block (result i32)
      (call $dummy) (call $dummy) (br_if 0 (i32.const 11) (local.get 0))
    )
  )
  (func $as-loop-first (param i32) (result i32)
    (block (loop (br_if 1 (local.get 0)) (return (i32.const 2)))) (i32.const 3)
  )
  (func $as-loop-mid (param i32) (result i32)
    (block (loop (call $dummy) (br_if 1 (local.get 0)) (return (i32.const 2))))
    (i32.const 4)
  )
  (func $as-loop-last (param i32)
    (loop (call $dummy) (br_if 1 (local.get 0)))
  )

  (func $as-br-value (result i32)
    (block (result i32) (br 0 (br_if 0 (i32.const 1) (i32.const 2))))
  )

  (func $as-br_if-cond
    (block (br_if 0 (br_if 0 (i32.const 1) (i32.const 1))))
  )
  (func $as-br_if-value (result i32)
    (block (result i32)
      (drop (br_if 0 (br_if 0 (i32.const 1) (i32.const 2)) (i32.const 3)))
      (i32.const 4)
    )
  )
  (func $as-br_if-value-cond (param i32) (result i32)
    (block (result i32)
      (drop (br_if 0 (i32.const 2) (br_if 0 (i32.const 1) (local.get 0))))
      (i32.const 4)
    )
  )
  (func $as-br_table-index
    (block (br_table 0 0 0 (br_if 0 (i32.const 1) (i32.const 2))))
  )
  (func $as-br_table-value (result i32)
    (block (result i32)
      (br_table 0 0 0 (br_if 0 (i32.const 1) (i32.const 2)) (i32.const 3)) (i32.const 4)
    )
  )
  (func $as-br_table-value-index (result i32)
    (block (result i32)
      (br_table 0 0 (i32.const 2) (br_if 0 (i32.const 1) (i32.const 3))) (i32.const 4)
    )
  )
  (func $as-return-value (result i64)
    (block (result i64) (return (br_if 0 (i64.const 1) (i32.const 2))))
  )

  (func $as-if-cond (param i32) (result i32)
    (block (result i32)
      (if (result i32)
        (br_if 0 (i32.const 1) (local.get 0))
        (then (i32.const 2))
        (else (i32.const 3))
      )
    )
  )
  (func $as-if-then (param i32 i32)
    (block
      (if (local.get 0) (then (br_if 1 (local.get 1))) (else (call $dummy)))
    )
  )
  (func $as-if-else (param i32 i32)
    (block
      (if (local.get 0) (then (call $dummy)) (else (br_if 1 (local.get 1))))
    )
  )

  (func $as-select-first (param i32) (result i32)
    (block (result i32)
      (select (br_if 0 (i32.const 3) (i32.const 10)) (i32.const 2) (local.get 0))
    )
  )
  (func $as-select-second (param i32) (result i32)
    (block (result i32)
      (select (i32.const 1) (br_if 0 (i32.const 3) (i32.const 10)) (local.get 0))
    )
  )
  (func $as-select-cond (result i32)
    (block (result i32)
      (select (i32.const 1) (i32.const 2) (br_if 0 (i32.const 3) (i32.const 10)))
    )
  )
  (func $f (param i32 i32 i32) (result i32) (i32.const -1))
  (func $as-call-first (result i32)
    (block (result i32)
      (call $f
        (br_if 0 (i32.const 12) (i32.const 1)) (i32.const 2) (i32.const 3)
      )
    )
  )
  (func $as-call-mid (result i32)
    (block (result i32)
      (call $f
        (i32.const 1) (br_if 0 (i32.const 13) (i32.const 1)) (i32.const 3)
      )
    )
  )
  (func $as-call-last (result i32)
    (block (result i32)
      (call $f
        (i32.const 1) (i32.const 2) (br_if 0 (i32.const 14) (i32.const 1))
      )
    )
  )

  (func $func (param i32 i32 i32) (result i32) (local.get 0))
  (type $check (func (param i32 i32 i32) (result i32)))
  (table funcref (elem $func))
  (func $as-call_indirect-func (result i32)
    (block (result i32)
      (call_indirect (type $check)
        (br_if 0 (i32.const 4) (i32.const 10))
        (i32.const 1) (i32.const 2) (i32.const 0)
      )
    )
  )

  (func $as-call_indirect-first (result i32)
    (block (result i32)
      (call_indirect (type $check)
        (i32.const 1) (br_if 0 (i32.const 4) (i32.const 10)) (i32.const 2) (i32.const 0)
      )
    )
  )
  (func $as-call_indirect-mid (result i32)
    (block (result i32)
      (call_indirect (type $check)
        (i32.const 1) (i32.const 2) (br_if 0 (i32.const 4) (i32.const 10)) (i32.const 0)
      )
    )
  )
  (func $as-call_indirect-last (result i32)
    (block (result i32)
      (call_indirect (type $check)
        (i32.const 1) (i32.const 2) (i32.const 3) (br_if 0 (i32.const 4) (i32.const 10))
      )
    )
  )
  (func $as-local.set-value (param i32) (result i32)
    (local i32)
    (block (result i32)
      (local.set 0 (br_if 0 (i32.const 17) (local.get 0)))
      (i32.const -1)
    )
  )
  (func $as-local.tee-value (param i32) (result i32)
    (block (result i32)
      (local.tee 0 (br_if 0 (i32.const 1) (local.get 0)))
      (return (i32.const -1))
    )
  )
  (global $a (mut i32) (i32.const 10))
  (func $as-global.set-value (param i32) (result i32)
    (block (result i32)
      (global.set $a (br_if 0 (i32.const 1) (local.get 0)))
      (return (i32.const -1))
    )
  )

  (memory 1)
  (func $as-load-address (result i32)
    (block (result i32) (i32.load (br_if 0 (i32.const 1) (i32.const 1))))
  )
  (func $as-loadN-address (result i32)
    (block (result i32) (i32.load8_s (br_if 0 (i32.const 30) (i32.const 1))))
  )

  (func $as-store-address (result i32)
    (block (result i32)
      (i32.store (br_if 0 (i32.const 30) (i32.const 1)) (i32.const 7)) (i32.const -1)
    )
  )
  (func $as-store-value (result i32)
    (block (result i32)
      (i32.store (i32.const 2) (br_if 0 (i32.const 31) (i32.const 1))) (i32.const -1)
    )
  )

  (func $as-storeN-address (result i32)
    (block (result i32)
      (i32.store8 (br_if 0 (i32.const 32) (i32.const 1)) (i32.const 7)) (i32.const -1)
    )
  )
  (func $as-storeN-value (result i32)
    (block (result i32)
      (i32.store16 (i32.const 2) (br_if 0 (i32.const 33) (i32.const 1))) (i32.const -1)
    )
  )
  (func $as-binary-left (result i32)
    (block (result i32) (i32.add (br_if 0 (i32.const 1) (i32.const 1)) (i32.const 10)))
  )
  (func $as-binary-right (result i32)
    (block (result i32) (i32.sub (i32.const 10) (br_if 0 (i32.const 1) (i32.const 1))))
  )
  (func $as-test-operand (result i32)
    (block (result i32) (i32.eqz (br_if 0 (i32.const 0) (i32.const 1))))
  )
  (func $as-compare-left (result i32)
    (block (result i32) (i32.le_u (br_if 0 (i32.const 1) (i32.const 1)) (i32.const 10)))
  )
  (func $as-compare-right (result i32)
    (block (result i32) (i32.ne (i32.const 10) (br_if 0 (i32.const 1) (i32.const 42))))
  )

  (func $as-memory.grow-size (result i32)
    (block (result i32) (memory.grow (br_if 0 (i32.const 1) (i32.const 1))))
  )
  (func $nested-block-value (param i32) (result i32)
    (i32.add
      (i32.const 1)
      (block (result i32)
        (drop (i32.const 2))
        (i32.add
          (i32.const 4)
          (block (result i32)
            (drop (br_if 1 (i32.const 8) (local.get 0)))
            (i32.const 16)
          )
        )
      )
    )
  )

  (func $nested-br-value (param i32) (result i32)
    (i32.add
      (i32.const 1)
      (block (result i32)
        (drop (i32.const 2))
        (br 0
          (block (result i32)
            (drop (br_if 1 (i32.const 8) (local.get 0))) (i32.const 4)
          )
        )
        (i32.const 16)
      )
    )
  )

  (func $nested-br_if-value (param i32) (result i32)
    (i32.add
      (i32.const 1)
      (block (result i32)
        (drop (i32.const 2))
        (drop (br_if 0
          (block (result i32)
            (drop (br_if 1 (i32.const 8) (local.get 0))) (i32.const 4)
          )
          (i32.const 1)
        ))
        (i32.const 16)
      )
    )
  )

  (func $nested-br_if-value-cond (param i32) (result i32)
    (i32.add
      (i32.const 1)
      (block (result i32)
        (drop (i32.const 2))
        (drop (br_if 0
          (i32.const 4)
          (block (result i32)
            (drop (br_if 1 (i32.const 8) (local.get 0))) (i32.const 1)
          )
        ))
        (i32.const 16)
      )
    )
  )

  (func $nested-br_table-value (param i32) (result i32)
    (i32.add
      (i32.const 1)
      (block (result i32)
        (drop (i32.const 2))
        (br_table 0
          (block (result i32)
            (drop (br_if 1 (i32.const 8) (local.get 0))) (i32.const 4)
          )
          (i32.const 1)
        )
        (i32.const 16)
      )
    )
  )

  (func $nested-br_table-value-index (param i32) (result i32)
    (i32.add
      (i32.const 1)
      (block (result i32)
        (drop (i32.const 2))
        (br_table 0
          (i32.const 4)
          (block (result i32)
            (drop (br_if 1 (i32.const 8) (local.get 0))) (i32.const 1)
          )
        )
        (i32.const 16)
      )
    )
  )
  (func (export "_start")
    (call $assert_test_i32 (call $type-i32-value) (i32.const 1))
    (call $assert_test_i64 (call $type-i64-value) (i64.const 2))
    (call $assert_test_i32 (call $as-block-first (i32.const 0)) (i32.const 2))
    (call $assert_test_i32 (call $as-block-first (i32.const 1)) (i32.const 3))
    (call $assert_test_i32 (call $as-block-mid (i32.const 0)) (i32.const 2))
    (call $assert_test_i32 (call $as-block-mid (i32.const 1)) (i32.const 3))
    (call $as-block-last (i32.const 0))
    (call $as-block-last (i32.const 1))
    (call $assert_test_i32 (call $as-block-first-value (i32.const 0)) (i32.const 11))
    (call $assert_test_i32 (call $as-block-first-value (i32.const 1)) (i32.const 10))
    (call $assert_test_i32 (call $as-block-mid-value (i32.const 0)) (i32.const 21))
    (call $assert_test_i32 (call $as-block-mid-value (i32.const 1)) (i32.const 20))
    (call $assert_test_i32 (call $as-block-last-value (i32.const 0)) (i32.const 11))
    (call $assert_test_i32 (call $as-block-last-value (i32.const 1)) (i32.const 11))
    (call $assert_test_i32 (call $as-loop-first (i32.const 0)) (i32.const 2)) ;; Fail
    (call $assert_test_i32 (call $as-loop-first (i32.const 1)) (i32.const 3))
    (call $assert_test_i32 (call $as-loop-mid (i32.const 0)) (i32.const 2));; Fail
    (call $assert_test_i32 (call $as-loop-mid (i32.const 1)) (i32.const 4))
    (call $assert_test_i32 (call $as-br-value) (i32.const 1));;
    (call $assert_test_i32 (call $as-br_if-value) (i32.const 1))
    (call $assert_test_i32 (call $as-br_if-value-cond (i32.const 0)) (i32.const 2))
    (call $assert_test_i32 (call $as-br_if-value-cond (i32.const 1)) (i32.const 1))
    (call $assert_test_i32 (call $as-br_table-value) (i32.const 1))
    (call $assert_test_i32 (call $as-br_table-value-index) (i32.const 1))
    (call $assert_test_i64 (call $as-return-value) (i64.const 1))
    (call $assert_test_i32 (call $as-if-cond (i32.const 0)) (i32.const 2))
    (call $assert_test_i32 (call $as-if-cond (i32.const 1)) (i32.const 1))
    (call $assert_test_i32 (call $as-select-first (i32.const 0)) (i32.const 3))
    (call $assert_test_i32 (call $as-select-first (i32.const 1)) (i32.const 3))
    (call $assert_test_i32 (call $as-select-second (i32.const 0)) (i32.const 3))
    (call $assert_test_i32 (call $as-select-second (i32.const 1)) (i32.const 3))
    (call $assert_test_i32 (call $as-select-cond) (i32.const 3))
    (call $assert_test_i32 (call $as-call-first) (i32.const 12))
    (call $assert_test_i32 (call $as-call-mid) (i32.const 13))
    (call $assert_test_i32 (call $as-call-last) (i32.const 14))
    (call $assert_test_i32 (call $as-call_indirect-func) (i32.const 4))
    (call $assert_test_i32 (call $as-call_indirect-first) (i32.const 4))
    (call $assert_test_i32 (call $as-call_indirect-mid) (i32.const 4))
    (call $assert_test_i32 (call $as-call_indirect-last) (i32.const 4))
    (call $assert_test_i32 (call $as-local.set-value (i32.const 0)) (i32.const -1))
    (call $assert_test_i32 (call $as-local.set-value (i32.const 1)) (i32.const 17))
    (call $assert_test_i32 (call $as-local.tee-value (i32.const 0)) (i32.const -1))
    (call $assert_test_i32 (call $as-local.tee-value (i32.const 1)) (i32.const 1))
    (call $assert_test_i32 (call $as-global.set-value (i32.const 0)) (i32.const -1))
    (call $assert_test_i32 (call $as-global.set-value (i32.const 1)) (i32.const 1))
    (call $assert_test_i32 (call $as-load-address) (i32.const 1))
    (call $assert_test_i32 (call $as-loadN-address) (i32.const 30))
    (call $assert_test_i32 (call $as-store-address) (i32.const 30))
    (call $assert_test_i32 (call $as-store-value) (i32.const 31))
    (call $assert_test_i32 (call $as-storeN-address) (i32.const 32))
    (call $assert_test_i32 (call $as-storeN-value) (i32.const 33))
    (call $assert_test_i32 (call $as-binary-left) (i32.const 1))
    (call $assert_test_i32 (call $as-binary-right) (i32.const 1))
    (call $assert_test_i32 (call $as-test-operand) (i32.const 0))
    (call $assert_test_i32 (call $as-compare-left) (i32.const 1))
    (call $assert_test_i32 (call $as-compare-right) (i32.const 1))
    (call $assert_test_i32 (call $as-memory.grow-size) (i32.const 1))
    (call $assert_test_i32 (call $nested-block-value (i32.const 0)) (i32.const 21))
    (call $assert_test_i32 (call $nested-block-value (i32.const 1)) (i32.const 9))
    (call $assert_test_i32 (call $nested-br-value (i32.const 0)) (i32.const 5))
    (call $assert_test_i32 (call $nested-br-value (i32.const 1)) (i32.const 9))
    (call $assert_test_i32 (call $nested-br_if-value (i32.const 0)) (i32.const 5))
    (call $assert_test_i32 (call $nested-br_if-value (i32.const 1)) (i32.const 9))
    (call $assert_test_i32 (call $nested-br_if-value-cond (i32.const 0)) (i32.const 5))
    (call $assert_test_i32 (call $nested-br_if-value-cond (i32.const 1)) (i32.const 9))
    (call $assert_test_i32 (call $nested-br_table-value (i32.const 0)) (i32.const 5))
    (call $assert_test_i32 (call $nested-br_table-value (i32.const 1)) (i32.const 9))
    (call $assert_test_i32 (call $nested-br_table-value-index (i32.const 0)) (i32.const 5))
    (call $assert_test_i32 (call $nested-br_table-value-index (i32.const 1)) (i32.const 9))


    (call $as-loop-last (i32.const 0))
    (call $as-loop-last (i32.const 1))
    (call $as-br_if-cond)
    (call $as-br_table-index)
    (call $as-if-then (i32.const 0) (i32.const 0))
    (call $as-if-then (i32.const 4) (i32.const 0))
    (call $as-if-then (i32.const 0) (i32.const 1))
    (call $as-if-then (i32.const 4) (i32.const 1))
    (call $as-if-else (i32.const 0) (i32.const 0))
    (call $as-if-else (i32.const 3) (i32.const 0))
    (call $as-if-else (i32.const 0) (i32.const 1))
    (call $as-if-else (i32.const 3) (i32.const 1))
  )
)