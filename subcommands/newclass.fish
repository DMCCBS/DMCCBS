#!/bin/env fish

set class_name $argv[1]

echo "\
#pragma once

class $class_name {

public:
	$class_name();
	$class_name(const $class_name&);
};
" >src/$class_name.hh

echo "\
#include \"$class_name.hh\"

$class_name::$class_name() {}
$class_name::$class_name(const $class_name&) {}
" >src/$class_name.cc
