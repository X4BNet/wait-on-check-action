# frozen_string_literal: true

require 'ostruct'
require 'json'
module Helpers
  SAMPLE_RESPONSES_BASE_PATH = 'spec/github_api_sample_responses/'

  CheckRun = Struct.new(:status, :conclusion, :name)
  CheckRunsResponse = Struct.new(:check_runs)

  def load_json_sample(file_name)
    File.read(SAMPLE_RESPONSES_BASE_PATH + file_name)
  end

  def load_checks_from_yml(yml_file)
    JSON.parse(load_json_sample(yml_file))['check_runs'].map { |check| CheckRun.new(**check) }
  end

  def with_captured_stdout
    original_stdout = $stdout # capture previous value of $stdout
    $stdout = StringIO.new # assign a string buffer to $stdout
    yield # perform the body of the user code
    $stdout.string # return the contents of the string buffer
  ensure
    $stdout = original_stdout # restore $stdout to its previous value
  end
end

RSpec.configure do |config|
  config.include Helpers
end
