#!/bin/sh

#! -----------------------------------------------------------------------------
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or distribute
# this software, either in source code form or as a compiled binary, for any
# purpose, commercial or non-commercial, and by any means.
#
# In jurisdictions that recognize copyright laws, the author or authors of this
# software dedicate any and all copyright interest in the software to the public
# domain. We make this dedication for the benefit of the public at large and to
# the detriment of our heirs and successors. We intend this dedication to be an
# overt act of relinquishment in perpetuity of all present and future rights to
# this software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# For more information, please refer to <http://unlicense.org>
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Validate OCSP stapling.
#
# AUTHOR:    Richard Fussenegger <richard@fussenegger.info>
# COPYRIGHT: Copyright (c) 2008-15 Richard Fussenegger
# LICENSE:   http://unlicense.org/ PD
# ------------------------------------------------------------------------------

readonly __FILENAME__="${0##*/}"
readonly __DIRNAME__="$(cd -- "$(dirname -- "${0}")"; pwd)"

if [ $# -ne 1 ]; then
    cat >&2 << EOT
Usage: ${__FILENAME__} DOMAIN
Validate OCSP stapling.

The domain argument is mandatory:

    sh ${__FILENAME__} www.example.com

Report bugs to richard@fussenegger.info
GitHub repository: https://github.com/Fleshgrinder/nginx-configuration
For complete documentation, see: README.md
EOT
    exit 64
fi

openssl s_client -connect "${1}:443" -servername "${1}" -tls1 -tlsextdebug -status -CApath startssl.com/certs/ | grep OCSP

cat << EOT

Please note that it might take some time for all workers to fetch the OSCP
stapling file if you just (re)started your server. Simply execute this script
various times (depending on your worker count).

EOT

exit 0