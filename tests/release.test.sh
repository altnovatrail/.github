# shellcheck shell=bash disable=SC2016 # jq's variables and GitHub's expressions stay unexpanded in single quotes.
# The tests of release.yml's step "Check the npm package" (the amendments to R18 for T27 and
# T33): the archive a release would publish to npm, checked before the GitHub release exists —
# which is immutable — against the registry's packument, then by npm's own dry run. The registry
# is the stand-in curl, the dry run the stand-in npm-isolated; the archives are made here with
# tar, laid out as npm pack lays one out, and their integrity worked out without openssl, which
# the step uses.
# shellcheck source=tests/lib.sh
. "${BASH_SOURCE[0]%/*}/lib.sh"

target=0123456789abcdef0123456789abcdef01234567

# The step for @altnovatrail/canvas, of altnovatrail/canvas, at a version without v, 0.1.9 by
# default, with publish as given, true by default, in the run that releases that version: before
# its GitHub release exists. TARGET is the job's, and every step gets it.
npm_check() {
    use_workflow release.yml
    select_step release id=npm
    runner_env GITHUB_REPOSITORY altnovatrail/canvas
    set_env TARGET "$target"
    set_env VERSION "v${1:-0.1.9}"
    ctx steps.version.outputs.released ""
    ctx inputs.npm-package @altnovatrail/canvas
    ctx steps.npm-name.outputs.stem altnovatrail-canvas
    ctx inputs.publish "${2:-true}"
}

# The same in a run of a commit released already as v0.1.9, again or by the button: the number is
# the release's, and VERSION, version || released, is the same.
npm_check_after_release() {
    npm_check
    ctx steps.version.outputs.released v0.1.9
}

# What the step says of a number npm has held, before the release and after it.
gone_before="No release has that number yet, and every release of the line would take it again: raise RELEASE_LINE in the caller's release workflow, so that the next release gets a number npm has never held."
gone_after="The next release, with a new number, publishes the package."
# And of a package unpublished as a whole.
whole="@altnovatrail/canvas was unpublished from the npm registry as a whole, and takes no new version for 24 hours. Then its next version is published by hand, as a first version is, and a trusted publisher set on it again if it has none: npm's documentation does not say whether one outlives the package (architecture 3.3)."

# A package unpublished as a whole, as the registry answers for one (asdasd, 2026-11-01): 200, and
# no versions, but a time with every number it held — 0.1.7 among them, which unpublished.versions
# leaves out, as a version unpublished before the rest — and unpublished.
tombstone() {
    registry 200 '{_id: "@altnovatrail/canvas", name: "@altnovatrail/canvas", _rev: "5-0",
        time: {created: "2026-10-01T00:00:00.000Z", modified: "2026-10-03T00:00:00.000Z",
            "0.1.7": "2026-10-01T00:00:00.000Z", "0.1.8": "2026-10-02T00:00:00.000Z",
            unpublished: {time: "2026-10-03T00:00:00.000Z", versions: ["0.1.8"]}}}'
}

# sha512- and the archive's SHA-512 in base64, as npm writes an integrity.
integrity_of() {
    local hex bytes="" i
    hex=$(sha512sum < "$1")
    hex=${hex%% *}
    for ((i = 0; i < ${#hex}; i += 2)); do
        bytes+="\\x${hex:i:2}"
    done
    printf 'sha512-%s' "$(printf '%b' "$bytes" | base64 -w0)"
}

# The archive of @altnovatrail/canvas at a version, 0.1.9 by default, where the step looks for it:
# package/package.json alone, as npm pack makes one of a package with nothing else, its package.json
# changed by a jq filter. The paths the archive holds, package/package.json by default, may be
# given after the version, from the folder package_file and package_extra fill.
package() {
    local filter=${1:-.} version=${2:-0.1.9}
    shift 2 || shift $#
    mkdir -p "$state/pack/package"
    jq -n --arg v "$version" '{name: "@altnovatrail/canvas", version: $v, repository: {type: "git", url: "git+https://github.com/altnovatrail/canvas.git"}} | '"$filter" \
        > "$state/pack/package/package.json"
    package_tar "$version" "$@"
}

# The same, with a package.json that holds the text given, JSON or not.
package_file() {
    mkdir -p "$state/pack/package"
    printf '%s\n' "$1" > "$state/pack/package/package.json"
    package_tar 0.1.9
}

package_tar() {
    local version=$1
    shift
    if [ "$#" = 0 ]; then set -- package/package.json; fi
    mkdir -p "$step_temp/dist"
    archive="$step_temp/dist/altnovatrail-canvas-$version.tgz"
    tar -czf "$archive" -C "$state/pack" "$@"
    integrity=$(integrity_of "$archive")
}

# The registry's answer: the code, and the packument a jq filter makes of nothing.
registry() {
    stub curl
    jq -n "$2" | curl_answer "$1"
}

# npm's dry run as npm 11 prints it with --json: an object by the package's name, with the file it
# read and its integrity (architecture 4) — the archive's unless others are given.
dry_run() {
    stub_in_temp npm-isolated
    jq -n --arg f "${1:-${archive##*/}}" --arg i "${2:-$integrity}" '{"@altnovatrail/canvas": {filename: $f, integrity: $i}}' \
        | stub_stdout npm-isolated
}

assert_registry_asked() {
    assert_calls curl 1
    assert_call curl 1 -sS --proto =https --retry 3 -o "$step_temp/npm-files/packument.json" -w '%{http_code}' \
        'https://registry.npmjs.org/@altnovatrail%2fcanvas?write=true'
}

assert_dry_run() {
    assert_calls npm-isolated 1
    assert_call npm-isolated 1 publish "$archive" --dry-run --json --access public "$@" --loglevel verbose
}

assert_refused_by_the_registry() {
    assert_status 1
    assert_line "$1"
    assert_registry_asked
    assert_calls npm-isolated 0
    refute_output action
}

assert_refused_before_the_registry() {
    assert_status 1
    assert_line "$1"
    assert_calls curl 0
    assert_calls npm-isolated 0
    refute_output action
}

# The check needs npm-isolated, which "Node and npm" writes: the two run on the same condition. The
# harness evaluates no if, so its text is what a change to it has to change here too.
test_npm_check_runs_whenever_node_and_npm_do() {
    use_workflow release.yml
    local check
    check=$(wf_raw '.jobs.release.steps[] | select(.id == "npm") | .if')
    assert_eq "$check" "inputs.npm-package != '' && (steps.version.outputs.version != '' || (inputs.publish && steps.version.outputs.released != ''))" \
        "the if of Check the npm package"
    assert_eq "$check" "$(wf_raw '.jobs.release.steps[] | select(.name == "Node and npm") | .if')" "the if of Node and npm"
}

test_npm_a_new_version_is_read_by_npms_dry_run_without_a_token() {
    npm_check
    package
    registry 200 '{name: "@altnovatrail/canvas", versions: {"0.1.8": {dist: {integrity: "sha512-older"}}}}'
    dry_run
    run_step
    assert_status 0
    assert_line "@altnovatrail/canvas@0.1.9: ${integrity}, publish"
    assert_output action publish
    assert_output tag ""
    assert_output integrity "$integrity"
    assert_output file "$archive"
    assert_registry_asked
    assert_dry_run
    # The job may ask for an OIDC token, so the runner gives the step its variables; npm, which
    # tries the token exchange in a dry run too, must not see them.
    assert_call_record npm-isolated 1 oidc "ACTIONS_ID_TOKEN_REQUEST_URL unset" "ACTIONS_ID_TOKEN_REQUEST_TOKEN unset"
}

test_npm_a_package_the_registry_lacks_stops_a_release() {
    npm_check
    package
    registry 404 '{error: "Not found"}'
    run_step
    assert_status 1
    assert_line "::error::@altnovatrail/canvas is not in the npm registry. Its first version is published by hand and a trusted publisher set on it; only then does a release publish (architecture 3.3)."
    assert_registry_asked
    assert_calls npm-isolated 0
    refute_output action
}

test_npm_a_package_the_registry_lacks_is_read_by_the_dry_run_of_a_trial() {
    npm_check 0.1.9 false
    package
    registry 404 '{error: "Not found"}'
    dry_run
    run_step
    assert_status 0
    assert_line "::notice::@altnovatrail/canvas is not in the npm registry yet, which matters not with publish false."
    assert_output action publish
    assert_output tag ""
    assert_dry_run
}

test_npm_a_version_the_registry_holds_with_this_integrity_is_published_already() {
    npm_check
    package
    registry 200 '{versions: {"0.1.9": {dist: {integrity: "'"$integrity"'"}}}}'
    run_step
    assert_status 0
    assert_line "::notice::@altnovatrail/canvas@0.1.9 is in the npm registry already, with this archive's integrity."
    assert_line "@altnovatrail/canvas@0.1.9: ${integrity}, skip"
    assert_output action skip
    assert_output tag ""
    assert_calls npm-isolated 0
}

# Before the release, every release of the line would take the same number again.
test_npm_a_version_the_registry_holds_with_another_integrity_stops_the_release() {
    npm_check
    package
    registry 200 '{versions: {"0.1.9": {dist: {integrity: "sha512-another"}}}}'
    run_step
    assert_refused_by_the_registry "::error::@altnovatrail/canvas@0.1.9 is in the npm registry with the integrity sha512-another, and this archive's is ${integrity}. npm never takes a version back. ${gone_before}"
}

test_npm_another_integrity_after_the_release_leaves_the_package_to_the_next_release() {
    npm_check_after_release
    package
    registry 200 '{versions: {"0.1.9": {dist: {integrity: "sha512-another"}}}}'
    run_step
    assert_refused_by_the_registry "::error::@altnovatrail/canvas@0.1.9 is in the npm registry with the integrity sha512-another, and this archive's is ${integrity}. npm never takes a version back. ${gone_after}"
}

# The registry keeps in time every number it has given out, the unpublished ones too, which
# versions no longer holds (ua-parser-js's 0.7.29, 2026-11-01).
test_npm_a_number_npm_held_and_unpublished_stops_the_release() {
    npm_check
    package
    registry 200 '{versions: {"0.1.8": {}}, time: {created: "2026-10-01T00:00:00.000Z", modified: "2026-10-03T00:00:00.000Z", "0.1.8": "2026-10-01T00:00:00.000Z", "0.1.9": "2026-10-02T00:00:00.000Z"}}'
    run_step
    assert_refused_by_the_registry "::error::@altnovatrail/canvas@0.1.9 was in the npm registry and was unpublished, and npm never takes a number it has held. ${gone_before}"
}

test_npm_a_number_npm_held_and_unpublished_after_the_release_leaves_the_package_to_the_next_release() {
    npm_check_after_release
    package
    registry 200 '{versions: {}, time: {"0.1.9": "2026-10-02T00:00:00.000Z"}}'
    run_step
    assert_refused_by_the_registry "::error::@altnovatrail/canvas@0.1.9 was in the npm registry and was unpublished, and npm never takes a number it has held. ${gone_after}"
}

# A trial would go through and leave a release that npm refuses to the next run that publishes.
test_npm_a_number_npm_held_and_unpublished_stops_a_trial_too() {
    npm_check 0.1.9 false
    package
    registry 200 '{versions: {}, time: {"0.1.9": "2026-10-02T00:00:00.000Z"}}'
    run_step
    assert_refused_by_the_registry "::error::@altnovatrail/canvas@0.1.9 was in the npm registry and was unpublished, and npm never takes a number it has held. ${gone_before}"
}

# A version that versions holds is not an unpublished one, whatever its dist lacks: one with no
# integrity, as a version from before npm wrote them has, is another archive than this one.
test_npm_a_version_the_registry_holds_with_no_integrity_stops_the_release() {
    npm_check
    package
    registry 200 '{versions: {"0.1.9": {dist: {shasum: "0123456789abcdef0123456789abcdef01234567"}}}, time: {"0.1.9": "2026-10-02T00:00:00.000Z"}}'
    run_step
    assert_refused_by_the_registry "::error::@altnovatrail/canvas@0.1.9 is in the npm registry with the integrity none, and this archive's is ${integrity}. npm never takes a version back. ${gone_before}"
}

test_npm_the_times_of_other_versions_leave_a_new_number_new() {
    npm_check
    package
    registry 200 '{versions: {"0.1.8": {}}, time: {created: "2026-10-01T00:00:00.000Z", modified: "2026-10-01T00:00:00.000Z", "0.1.8": "2026-10-01T00:00:00.000Z"}}'
    dry_run
    run_step
    assert_status 0
    assert_output action publish
    assert_output tag ""
    assert_dry_run
}

# Before its release and after it alike: the package has to come back by hand first.
test_npm_a_package_unpublished_as_a_whole_stops_a_release() {
    local check
    for check in npm_check npm_check_after_release; do
        "$check"
        package
        tombstone
        run_step
        assert_refused_by_the_registry "::error::${whole} Only then does a release publish."
    done
}

# A package published again keeps no time.unpublished (pokemon-assets, 2026-11-01); if one ever
# did, its versions would still say it is back.
test_npm_a_package_with_versions_beside_an_unpublished_is_no_package_unpublished_as_a_whole() {
    npm_check
    package
    registry 200 '{versions: {"0.1.8": {}}, time: {"0.1.8": "2026-10-04T00:00:00.000Z", unpublished: {time: "2026-10-03T00:00:00.000Z", versions: ["0.1.7"]}}}'
    dry_run
    run_step
    assert_status 0
    assert_output action publish
    assert_output tag ""
    assert_dry_run
}

test_npm_a_package_unpublished_as_a_whole_is_read_by_the_dry_run_of_a_trial() {
    npm_check 0.1.9 false
    package
    tombstone
    dry_run
    run_step
    assert_status 0
    assert_line "::notice::@altnovatrail/canvas was unpublished from the npm registry as a whole, which matters not with publish false."
    assert_output action publish
    assert_output tag ""
    assert_dry_run
}

# Its numbers are gone like any other's: those its unpublished lists, and those unpublished before.
# The error says both what the number needs and what the package needs.
test_npm_a_number_of_a_package_unpublished_as_a_whole_is_gone_too() {
    local version
    for version in 0.1.8 0.1.7; do
        npm_check "$version" false
        package . "$version"
        tombstone
        run_step
        assert_refused_by_the_registry "::error::@altnovatrail/canvas@${version} was in the npm registry and was unpublished, and npm never takes a number it has held. ${gone_before} ${whole}"
    done
}

test_npm_a_version_below_the_highest_goes_out_as_previous() {
    npm_check
    package
    registry 200 '{versions: {"0.1.8": {}, "0.2.0": {}}}'
    dry_run
    run_step
    assert_status 0
    assert_line "@altnovatrail/canvas@0.1.9: ${integrity}, publish, tag previous"
    assert_output action publish
    assert_output tag previous
    assert_dry_run --tag previous
}

# Numbers, not text: 0.10.0 is above 0.9.0, though "0.10.0" sorts below "0.9.0".
test_npm_a_version_above_the_highest_by_its_numbers_goes_out_as_latest() {
    npm_check 0.10.0
    package . 0.10.0
    registry 200 '{versions: {"0.9.0": {}}}'
    dry_run
    run_step
    assert_status 0
    assert_output tag ""
    assert_dry_run
}

# The highest of several by their numbers, too: by text, 0.9.0 would be the highest.
test_npm_a_version_below_the_highest_by_its_numbers_goes_out_as_previous() {
    npm_check 0.9.5
    package . 0.9.5
    registry 200 '{versions: {"0.9.0": {}, "0.10.0": {}}}'
    dry_run
    run_step
    assert_status 0
    assert_output tag previous
    assert_dry_run --tag previous
}

test_npm_deprecated_versions_and_prereleases_are_not_the_highest() {
    npm_check
    package
    registry 200 '{versions: {"0.1.8": {}, "1.0.0": {deprecated: "a mistake"}, "2.0.0-rc.1": {}, "0.0.0-stage": {}}}'
    dry_run
    run_step
    assert_status 0
    assert_output tag ""
    assert_dry_run
}

test_npm_a_packument_with_no_versions_is_a_new_version() {
    npm_check
    package
    registry 200 '{name: "@altnovatrail/canvas"}'
    dry_run
    run_step
    assert_status 0
    assert_output action publish
    assert_output tag ""
    assert_dry_run
}

test_npm_a_registry_that_fails_stops_the_release() {
    npm_check
    package
    registry 500 '{error: "Internal Server Error"}'
    run_step
    assert_status 1
    assert_line "::error::The npm registry answered 500 for @altnovatrail/canvas."
    assert_calls npm-isolated 0
}

# curl's own failure ends the step by set -e, with curl's status.
test_npm_a_registry_out_of_reach_stops_the_release() {
    npm_check
    package
    stub curl
    curl_offline
    run_step
    assert_status 7
    assert_registry_asked
    assert_calls npm-isolated 0
    refute_output action
}

test_npm_a_packument_that_is_no_json_stops_the_release() {
    npm_check
    package
    stub curl
    printf '<html>\n' | curl_answer 200
    run_step
    assert_status 5
    assert_has "jq: parse error"
    assert_calls npm-isolated 0
    refute_output action
}

test_npm_an_archive_that_is_missing_stops_the_release() {
    npm_check
    run_step
    assert_refused_before_the_registry "::error::The release's files hold no altnovatrail-canvas-0.1.9.tgz, the archive npm pack makes of @altnovatrail/canvas 0.1.9."
}

test_npm_an_archive_that_is_a_link_stops_the_release() {
    npm_check
    package
    mv "$archive" "$state/elsewhere.tgz"
    ln -s "$state/elsewhere.tgz" "$archive"
    run_step
    assert_refused_before_the_registry "::error::The release's files hold no altnovatrail-canvas-0.1.9.tgz, the archive npm pack makes of @altnovatrail/canvas 0.1.9."
}

test_npm_an_archive_that_is_no_gzip_stops_the_release() {
    npm_check
    mkdir -p "$step_temp/dist"
    printf 'no archive\n' > "$step_temp/dist/altnovatrail-canvas-0.1.9.tgz"
    run_step
    assert_status 2
    assert_has "not in gzip format"
    assert_calls curl 0
    refute_output action
}

test_npm_an_archive_with_an_entry_outside_package_stops_the_release() {
    npm_check
    mkdir -p "$state/pack/other"
    printf 'x\n' > "$state/pack/other/file"
    package . 0.1.9 package/package.json other/file
    assert_eq "$(tar -tzf "$archive")" $'package/package.json\nother/file' "the archive's entries"
    run_step
    assert_refused_before_the_registry "::error::altnovatrail-canvas-0.1.9.tgz is no archive npm pack makes: every entry lies under package/, with one package/package.json."
}

test_npm_an_archive_with_two_package_jsons_stops_the_release() {
    npm_check
    package . 0.1.9 package/package.json package/package.json
    assert_eq "$(tar -tzf "$archive" | grep -cx package/package.json)" 2 "the package.json entries of the archive"
    run_step
    assert_refused_before_the_registry "::error::altnovatrail-canvas-0.1.9.tgz is no archive npm pack makes: every entry lies under package/, with one package/package.json."
}

test_npm_a_package_json_that_is_no_json_object_stops_the_release() {
    local text
    npm_check
    for text in 'no json' '["@altnovatrail/canvas"]' '"@altnovatrail/canvas"'; do
        package_file "$text"
        run_step
        assert_refused_before_the_registry "::error::The package.json of altnovatrail-canvas-0.1.9.tgz is no JSON object."
    done
}

test_npm_another_package_or_version_stops_the_release() {
    npm_check
    package '.name = "@altnovatrail/other"'
    run_step
    assert_refused_before_the_registry "::error::altnovatrail-canvas-0.1.9.tgz holds @altnovatrail/other@0.1.9, not @altnovatrail/canvas@0.1.9: the release's number, without v, is the package's version."
    package '.version = "0.0.0"'
    run_step
    assert_refused_before_the_registry "::error::altnovatrail-canvas-0.1.9.tgz holds @altnovatrail/canvas@0.0.0, not @altnovatrail/canvas@0.1.9: the release's number, without v, is the package's version."
}

test_npm_a_package_that_would_change_how_npm_publishes_it_stops_the_release() {
    local filter
    npm_check
    for filter in '.private = true' '.publishConfig = {}' '.tag = "next"'; do
        package "$filter"
        run_step
        assert_refused_before_the_registry "::error::The package.json of altnovatrail-canvas-0.1.9.tgz is private, or has a publishConfig or a tag of its own, which would change how npm publishes it."
    done
}

test_npm_a_package_that_says_it_is_not_private_is_published() {
    npm_check
    package '.private = false'
    registry 200 '{versions: {}}'
    dry_run
    run_step
    assert_status 0
    assert_output action publish
}

test_npm_a_repository_that_is_no_object_with_this_repositorys_url_stops_the_release() {
    local filter url
    npm_check
    for filter in '.repository = "github:altnovatrail/canvas"' '.repository = {type: "git"}' \
        'del(.repository)' '.repository.url = "git+https://github.com/altnovatrail/other.git"'; do
        url=""
        if [[ $filter == *other* ]]; then url=https://github.com/altnovatrail/other; fi
        package "$filter"
        run_step
        assert_refused_before_the_registry "::error::The package.json of altnovatrail-canvas-0.1.9.tgz names its repository as \"${url}\", not as an object whose url is git+https://github.com/altnovatrail/canvas.git: the registry refuses provenance from another repository."
    done
}

test_npm_a_repository_url_without_git_plus_or_dot_git_is_this_repository() {
    npm_check
    package '.repository.url = "https://github.com/altnovatrail/canvas"'
    registry 200 '{versions: {}}'
    dry_run
    run_step
    assert_status 0
    assert_output action publish
}

test_npm_a_dry_run_that_fails_stops_the_release() {
    npm_check
    package
    registry 200 '{versions: {}}'
    dry_run
    stub_exit npm-isolated 1
    run_step
    assert_status 1
    assert_dry_run
    refute_output action
}

test_npm_a_dry_run_that_reads_another_file_or_integrity_stops_the_release() {
    local answer
    npm_check
    package
    registry 200 '{versions: {}}'
    stub_in_temp npm-isolated
    for answer in '{"@altnovatrail/canvas": {filename: "other.tgz", integrity: $i}}' \
        '{"@altnovatrail/canvas": {filename: $f, integrity: "sha512-another"}}' \
        '{"@altnovatrail/other": {filename: $f, integrity: $i}}' '{}' '"npm error"'; do
        jq -n --arg f "${archive##*/}" --arg i "$integrity" "$answer" | stub_stdout npm-isolated
        run_step
        assert_status 1
        assert_line "::error::npm's dry run did not read altnovatrail-canvas-0.1.9.tgz with the integrity ${integrity}."
        assert_dry_run
        refute_output action
    done
    printf 'npm notice no json at all\n' | stub_stdout npm-isolated
    run_step
    assert_status 1
    assert_line "::error::npm's dry run did not read altnovatrail-canvas-0.1.9.tgz with the integrity ${integrity}."
}
