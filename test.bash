#!/bin/bash
# SPDX-FileCopyrightText: 2026 Seita Shimazaki
# SPDX-License-Identifier: BSD-3-Clause

ng () {
    echo ${1}行目のテスト失敗
    res=1
}

res=0

### STRAIGHT ###
out=$(printf '1 0 1\n1 0 1\n1 0 1\n' | ./odom)
[ "$?" = 0 ] || ng "$LINENO"
last=$(echo "${out}" | tail -n 1)
[ "${last}" = "3.000 0.000 0.000" ] || ng "$LINENO"

### QUARTER TURN ###
out=$(echo '1 1.5707963267948966 1' | ./odom)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "0.637 0.637 1.571" ] || ng "$LINENO"

### EMPTY INPUT ###
out=$(printf '' | ./odom)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

[ "${res}" = 0 ] && echo OK
exit $res
