# Credit: https://www.mattkeeter.com/blog/2018-01-06-versioning/
#
execute_process(
    COMMAND git log --pretty=format:'%h' -n 1
    OUTPUT_VARIABLE GIT_REV
    ERROR_QUIET)

# Check whether we got any revision (which isn't always the case, e.g. when someone downloaded a zip file from Github instead of a checkout)
if("${GIT_REV}"
   STREQUAL
   "")
    set(GIT_REV
        "N/A")
    set(GIT_DIFF
        "")
    set(GIT_TAG
        "N/A")
    set(GIT_BRANCH
        "N/A")
else()
    execute_process(
        COMMAND git diff --quiet --exit-code
        RESULT_VARIABLE exit_code)
    if(NOT
       exit_code
       EQUAL
       "0")
        set(GIT_DIFF
            "+")
    endif()
    execute_process(
        COMMAND git describe --exact-match --tags
        OUTPUT_VARIABLE GIT_TAG
        ERROR_QUIET)
    execute_process(
        COMMAND git name-rev --name-only HEAD
        OUTPUT_VARIABLE GIT_BRANCH)

    string(
        STRIP "${GIT_REV}"
              GIT_REV)
    string(
        SUBSTRING "${GIT_REV}"
                  1
                  7
                  GIT_REV)
    string(
        STRIP "${GIT_DIFF}"
              GIT_DIFF)
    string(
        STRIP "${GIT_TAG}"
              GIT_TAG)
    string(
        STRIP "${GIT_BRANCH}"
              GIT_BRANCH)
endif()

set(VERSION_TO_TXT_FILE
    "ESMINI_GIT_REV=\"${GIT_REV}${GIT_DIFF}\"\nESMINI_GIT_TAG=\"${GIT_TAG}\"\nESMINI_GIT_BRANCH=\"${GIT_BRANCH}\"\nESMINI_BUILD_VERSION=\"${BUILD_VERSION}\""
)

configure_file(
    "version.cpp.in"
    "${CMAKE_CURRENT_SOURCE_DIR}/version.cpp"
    ESCAPE_QUOTES)

file(
    WRITE
    ${CMAKE_CURRENT_SOURCE_DIR}/../../../version.txt
    "${VERSION_TO_TXT_FILE}")
