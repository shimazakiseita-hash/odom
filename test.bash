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

### FULL CIRCLE ###
out=$(yes '1 1.5707963267948966 1' | head -n 4 | ./odom)
[ "$?" = 0 ] || ng "$LINENO"
last=$(echo "${out}" | tail -n 1)
[ "${last}" = "0.000 0.000 0.000" ] || ng "$LINENO"

### THETA PI ###
out=$(echo '0 3.141592653589793 1' | ./odom)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "0.000 0.000 3.142" ] || ng "$LINENO"

out=$(echo '0 -3.141592653589793 1' | ./odom)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "0.000 0.000 3.142" ] || ng "$LINENO"

out=$(echo '0 9.42477796076938 1' | ./odom)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "0.000 0.000 3.142" ] || ng "$LINENO"

### EULER ###
out=$(echo '1 1.5707963267948966 1' | ./odom -m euler)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "1.000 0.000 1.571" ] || ng "$LINENO"

out=$(echo '1 1.5707963267948966 1' | ./odom -m arc)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "0.637 0.637 1.571" ] || ng "$LINENO"

### INITIAL POSE ###
out=$(echo '1 0 1' | ./odom -i 1,2,0)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "2.000 2.000 0.000" ] || ng "$LINENO"

out=$(echo '1 0 1' | ./odom -i=-1,0,3.141592653589793)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "-2.000 0.000 3.142" ] || ng "$LINENO"

### DEGREE ###
out=$(echo '1 1.5707963267948966 1' | ./odom -d)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "0.637 0.637 90.000" ] || ng "$LINENO"

out=$(echo '0 -3.141592653589793 1' | ./odom -d)
[ "$?" = 0 ] || ng "$LINENO"
[ "${out}" = "0.000 0.000 180.000" ] || ng "$LINENO"

[ "${res}" = 0 ] && echo OK
exit $res
