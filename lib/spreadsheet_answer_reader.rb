require 'active_support/all'
require 'google_drive'
require 'yaml'

require './lib/spreadsheet_answer_reader/answer'
require './lib/spreadsheet_answer_reader/answer_reader'

module SpreadsheetAnswerReader
  config = YAML.load(File.new('config.yml'))

  SHEET_ID = config['sheet_id']
  FULL_POINT = config['full_point'].to_i

  TARGETS = config['targets'].to_h { |name, hash| [name, [hash['point_col'], hash['desc_col']]] }

  SEX_COL = config['sex_col']
  NAME_COL = config['name_col']
end

if __FILE__ == $0
  with_name = ARGV[0] == '1'
  SpreadsheetAnswerReader::AnswerReader.read(with_name: with_name)
end
