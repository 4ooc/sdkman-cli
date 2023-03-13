#!/usr/bin/env bash

#
#   Copyright 2021 Marco Vermeulen
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

function __sdkman_echo_debug() {
	if [[ $sdkman_debug_mode == 'true' ]]; then
		echo "$1"
	fi
}

function __sdkman_secure_curl() {
	if [[ ${sdkman_insecure_ssl} == 'true' ]]; then
		curl --insecure --silent --location "$1"
	else
		curl --silent --location "$1"
	fi
}

function __sdkman_secure_curl_download() {
	local curl_params
	curl_params=('--progress-bar' '--location')

	if [[ ${sdkman_debug_mode} == 'true' ]]; then
		curl_params+=('--verbose')
	fi

	if [[ ${sdkman_curl_continue} == 'true' ]]; then
		curl_params+=('-C' '-')
	fi

	if [[ -n ${sdkman_curl_retry_max_time} ]]; then
		curl_params+=('--retry-max-time' "${sdkman_curl_retry_max_time}")
	fi

	if [[ -n ${sdkman_curl_retry} ]]; then
		curl_params+=('--retry' "${sdkman_curl_retry}")
	fi

	if [[ ${sdkman_insecure_ssl} == 'true' ]]; then
		curl_params+=('--insecure')
	fi

	curl "${curl_params[@]}" "${@}"
}

function __sdkman_secure_curl_with_timeouts() {
	if [[ ${sdkman_insecure_ssl} == 'true' ]]; then
		curl --insecure --silent --location --connect-timeout ${sdkman_curl_connect_timeout} --max-time ${sdkman_curl_max_time} "$1"
	else
		curl --silent --location --connect-timeout ${sdkman_curl_connect_timeout} --max-time ${sdkman_curl_max_time} "$1"
	fi
}

function __sdkman_echo_paged() {
	if [[ -n $PAGER ]]; then
		echo "$@" | eval "$PAGER"
	elif command -v less >&/dev/null; then
		echo "$@" | less
	else
		echo "$@"
	fi
}

function __sdkman_mid_color() {
	if [[ $sdkman_colour_enable == 'false' ]]; then
		echo -E "${2:-$1} "
		return
	fi

	local p="\033[1;"
	[[ -n $2 ]] && p="$p$1" || p="${p}0m"
	p="$p${2:-$1}\033[0m"
	echo -E "$p"
}

function __sdkman_echo() {
	local str=""
	for v in "${@:2}"; do
		str+=$(__sdkman_mid_color "$1" "$v")
	done
	echo -n -e $str
	echo ""
}

function __sdkman_echo_red() {
	__sdkman_echo "31m" "$@"
}

function __sdkman_echo_no_colour() {
	echo "$@"
}

function __sdkman_echo_yellow() {
	__sdkman_echo "33m" "$@"
}

function __sdkman_echo_green() {
	__sdkman_echo "32m" "$@"
}

function __sdkman_echo_cyan() {
	__sdkman_echo "36m" "$@"
}

function __sdkman_echo_confirm() {
	__sdkman_echo "33m" "$@"
}