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

function __sdk_home() {
	local candidate version candidate_path version_path

	candidate="$1"
	version="$2"

	candidate_path="${SDKMAN_CANDIDATES_DIR}/${candidate}"
	if [ -n "$candidate" ] && [ -d "${candidate_path}" ]; then
		version_path="${candidate_path}/${version:-current}"
		if [ -e "$version_path" ]; then
			echo -n $(readlink -f "$version_path")
			return
		fi
	fi

	return 1
}