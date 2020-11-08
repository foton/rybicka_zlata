# frozen_string_literal: true

class Regexp
  # modified from https://gist.github.com/dperini/729294

  # match[0]: full URI
  # match[1]: protocol
  # match[2]: http basic authentication credentials (optional)
  # match[3]: server, IP or DNS
  # match[4]: port (optional)
  # match[5]: path without file (optional)
  # match[6]: filename (optional)
  # match[7]: query params (optional)
  # match[8]: anchor (optional)

  PERFECT_URL_PATTERN = begin
    rgx_str = '((?:https?|ftp):\/\/)' # protocol identifier
    rgx_str += '(\S+(?::\S*)?@)?' # user:pass authentication

    # IP address exclusion
    # private & local networks
    ip_addr_rgx_str = '(?!10(?:\.\d{1,3}){3})' \
                      '(?!127(?:\.\d{1,3}){3})' \
                      '(?!169\.254(?:\.\d{1,3}){2})' \
                      '(?!192\.168(?:\.\d{1,3}){2})' \
                      '(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})'

    # IP address dotted notation octets
    # excludes loopback network 0.0.0.0
    # excludes reserved space >= 224.0.0.0
    # excludes network & broacast addresses
    # (first & last IP address of each class)
    ip_addr_rgx_str2 = '(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])' \
      '(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}' \
      '(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))'

    dns_rgx_str =  '(?:(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)' # host name
    dns_rgx_str += '(?:\.(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)*'  # domain name
    dns_rgx_str += '(?:\.(?:[a-z\u00a1-\uffff]{2,}))'                            # TLD identifier

    rgx_str += "(#{ip_addr_rgx_str}#{ip_addr_rgx_str2}|#{dns_rgx_str})" # server
    rgx_str += '(:\d{2,5})?' # port number
    rgx_str += '((?:\/[\w\-]+)+\/)?' # path without file
    rgx_str += '([\w\-\.]+[^\#\?\s]+)?' # file
    rgx_str += '(\?(?:(?:[\w\-]+=[^\&\#\s]*)\&?)+)?' # query
    rgx_str += '(\#[\w\-]+)?' # anchor (should be last)

    Regexp.new(rgx_str, Regexp::EXTENDED | Regexp::IGNORECASE)
  end
end
