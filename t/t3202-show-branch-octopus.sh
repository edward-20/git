#!/bin/sh

test_description='test show-branch with more than 8 heads'

GIT_TEST_DEFAULT_INITIAL_BRANCH_NAME=main
export GIT_TEST_DEFAULT_INITIAL_BRANCH_NAME

. ./test-lib.sh

numbers="1 2 3 4 5 6 7 8 9 10"

test_expect_success 'setup' '

	> file &&
	git add file &&
	test_tick &&
	git commit -m initial &&

	for i in $numbers
	do
		git checkout -b branch$i main &&
		> file$i &&
		git add file$i &&
		test_tick &&
		git commit -m branch$i || return 1
	done

'

cat > expect << EOF
! [branch1] branch1
 ! [branch2] branch2
  ! [branch3] branch3
   ! [branch4] branch4
    ! [branch5] branch5
     ! [branch6] branch6
      ! [branch7] branch7
       ! [branch8] branch8
        ! [branch9] branch9
         * [branch10] branch10
----------
         * [branch10] branch10
        +  [branch9] branch9
       +   [branch8] branch8
      +    [branch7] branch7
     +     [branch6] branch6
    +      [branch5] branch5
   +       [branch4] branch4
  +        [branch3] branch3
 +         [branch2] branch2
+          [branch1] branch1
+++++++++* [branch10^] initial
EOF

test_expect_success 'show-branch with more than 8 branches' '

	git show-branch $(for i in $numbers; do echo branch$i; done) > out &&
	test_cmp expect out

'

test_expect_success 'show-branch with showbranch.default' '
	for i in $numbers; do
		git config --add showbranch.default branch$i
	done &&
	git show-branch >out &&
	test_cmp expect out
'

test_done
