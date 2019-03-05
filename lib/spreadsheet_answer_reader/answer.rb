module SpreadsheetAnswerReader
  class Answer
    attr_reader :name, :point, :sex

    def initialize(point, desc, name, sex)
      @point = point.to_i
      @desc = desc
      @name = name
      @sex = sex
    end

    def self.build_star_count(point)
      "#{'★' * point}#{'☆' * (FULL_POINT - point)}"
    end

    def to_md
      <<~MARKDOWN
    #{name}（#{sex}）  
    評価 #{self.class.build_star_count(point)}  

    #{add_two_spaces(desc)}
      MARKDOWN
    end

    def desc
      @desc.blank? ? '（未記入）' : @desc
    end

    def add_two_spaces(desc)
      desc.each_line(chomp: true).map { |line|
        line.blank? ? line : "#{line}  "
      }.join("\n")
    end
  end
end
