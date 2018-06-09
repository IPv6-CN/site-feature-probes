#!/usr/bin/env ruby
require 'bundler/setup'
Bundler.require(:default)

require 'yaml'
require 'terminal-table'

# Directory
PROBES_DIR="probes"
DOMAIN_DIR="domains"

# Files
TEST_INDEX="test-index.yaml"
UNIVERSITIES_LIST="higher-education.yaml"

# Emoji
EMOJI_PASS="✅"
EMOJI_FAIL="💔"

# Loading data
UNIVERSITIES=YAML.load_file(DOMAIN_DIR + "/" + UNIVERSITIES_LIST)
TESTS=YAML.load_file(TEST_INDEX)
ENABLED_TESTS=TESTS.reject {|x| x["disabled"] == true }

HEADER=["学校名称", "域名"] + ENABLED_TESTS.map {|x| x["name"]}

tables = {}

def perform_test(domain_name)
  # Return ["&#9989;", "&#9989;", "&#9989;", "&#10060;"]
  results = Array.new(ENABLED_TESTS.size)
  threads = []
  ENABLED_TESTS.each_with_index do |test, index|
    threads << Thread.new { results[index] = system("#{PROBES_DIR}/#{test["script"]}", domain_name) ? EMOJI_PASS : EMOJI_FAIL }
  end

  threads.each { |thr| thr.join }

  return results
end


UNIVERSITIES.keys.each do |group|
  rows = []

  UNIVERSITIES[group]["members"].each do |member|
    STDERR.puts member["domain"]
    rows << [member["name"], member["domain"]] + perform_test(member["domain"])
  end

  tables[group] = Terminal::Table.new(headings: HEADER, rows: rows, style: {border_top: false, border_bottom: false, border_i: "|"})
end

tables.keys.each do |c|
  puts
  puts '## ' + UNIVERSITIES[c]["group_name"]
  puts

  puts tables[c]
end

