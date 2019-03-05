module SpreadsheetAnswerReader
  class AnswerReader
    def self.read(with_name: false)
      self.new.read(with_name: with_name)
    end

    def read(with_name: false)
      session = GoogleDrive::Session.from_config('config.json')
      ws = session.spreadsheet_by_key(SHEET_ID).worksheets[0]

      TARGETS.each do |name, definitions|
        puts read_for(ws, name, definitions, with_name: with_name)
      end
    end

    private

    def read_for(ws, speaker_name, (point_col, desc_col), with_name: false)
      answers = (2..ws.num_rows).map.with_index(1) { |row, i|
        point = ws["#{point_col}#{row}"]
        next if point.blank?

        desc = ws["#{desc_col}#{row}"]
        sex = ws["#{SEX_COL}#{row}"]
        name = ws["#{NAME_COL}#{row}"]
        who_answered = with_name && name.present? ? name : "回答者#{i}"
        Answer.new(point, desc, who_answered, sex)
      }.compact
      build_results(speaker_name, answers)
    end

    def build_results(speaker_name, answers)
      point_table = to_point_table(answers)
      <<~MARKDOWN
    # #{speaker_name} - アンケート結果

    #{answers.count}件の回答

    #{FULL_POINT}点満点のうち #{calc_avg(answers)}

    #{build_star_counts(point_table, answers.count)}

    #{build_details(answers)}
      MARKDOWN
    end

    def build_star_counts(point_table, all_count)
      FULL_POINT.downto(1).map { |n|
        "#{'★' * n}#{'☆' * (FULL_POINT - n)} #{point_table[n].to_s.rjust(2)}（#{to_percent(all_count, point_table[n])}%）  "
      }.join("\n")
    end

    def to_point_table(answers)
      table = Hash.new { |h, k| h[k] = 0 }
      answers.each do |answer|
        table[answer.point] += 1
      end
      table
    end

    def to_percent(all_count, count)
      round(count.to_f / all_count * 100, 1)
    end

    def calc_avg(answers)
      count = answers.count
      sum = answers.map(&:point).sum
      round(sum.to_f / count, 1)
    end

    def build_details(answers)
      answers.map { |answer|
        "\n-----\n\n#{answer.to_md}"
      }.join("\n")
    end

    def round(value, precision)
      value.round(precision)
    end
  end
end
