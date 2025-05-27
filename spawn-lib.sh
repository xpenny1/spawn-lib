#!/usr/bin/env bash

initSpawn() {
    tempdir=$(mktemp -d)
    trap "rm -r $tempdir" EXIT
}
spawn() {
    mkfifo "$tempdir/in"
    mkfifo "$tempdir/out"
    mkfifo "$tempdir/err"
    (
        exec 0< "$tempdir/in"
        exec 1> "$tempdir/out"
        exec 2> "$tempdir/err"
        eval "${@:2}"
    )&
    local ind outd errd
    exec {ind}>  "$tempdir/in"
    exec {outd}< "$tempdir/out"
    exec {errd}< "$tempdir/err"
    for d in ind outd errd; do
        eval "$1""_""$d""=\$$d";
    done
    rm "$tempdir/in"
    rm "$tempdir/out"
    rm "$tempdir/err"
}
