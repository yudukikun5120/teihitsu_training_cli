# -*- coding: utf-8 -*-
# frozen_string_literal: true

require_relative "teihitsu_training_cli/version"

require "csv"
require "thor"
require "fileutils"

# The class of quiz app
class Trng < Thor
  package_name "Teihitsu Training CLI"

  default_command :question

  method_option :start,
                aliases: "-s",
                desc: "Specify the index of the item you want to start",
                type: :numeric,
                default: 1

  method_option :category,
                aliases: "-c",
                desc: "Specify the category of the items",
                type: :string,
                default: "onyomi"

  # define the quiz item
  class Item
    def initialize(_item)
      @answers = [@answer, @alt_answer].compact
    end

    def quiz
      puts "[#{@index}] #{@question}"
      user_answer = $stdin.gets.chomp.strip
      test user_answer
      puts @note, "\n"
    end

    def test(user_answer)
      if @answers.include?(user_answer)
        alt_answers = (@answers - [user_answer]).compact
        puts "✅"
        puts "別答：#{alt_answers}" unless alt_answers&.empty?
      else
        puts "❌\n正答：#{@answers}"
        write_result
      end
    end

    def write_result
      file_path = File.expand_path "teihitsu_training_cli/result.txt", Dir.home

      create_result_file file_path unless File.exist? file_path

      result = <<~"RESULT"
        [#{@index}] #{@question}
        ❌
        正答：#{@answers}

        #{@note}

      RESULT

      File.open(file_path, "a") do |io|
        io.write result
      end
    end

    def create_result_file(file_path)
      Dir.mkdir File.dirname file_path
      FileUtils.touch file_path
    end
  end

  # define the onyomi item
  class Onyomi < Item
    def initialize(item)
      super
      @index,
      @question,
      @_level,
      @answer,
      @alt_answer,
      @note = item
    end
  end

  # define the kunyomi item
  class Kunyomi < Item
    def initialize(item)
      super
      @index,
      @question,
      @_level,
      @answers,
      @note = item
      @answers = @answers.split
    end
  end

  # define the yoji-kaki item
  class Yojikaki < Item
    def initialize(item)
      super
      @index,
      @question,
      @reading,
      @_level,
      @answer,
      @alt_answers,
      @source, @note = item
      @answers = %W[#{@answer}]
      @answers.concat @alt_answers.split unless @alt_answers.nil?
    end
  end

  # define the Jukuji/Ateji item
  class Jyukuate < Item
    def initialize(item)
      super
      @index,
      @question,
      @_level,
      @answer,
      @alt_answers,
      @note = item
      @answers = %W[#{@answer}]
      @answers.concat @alt_answers.split unless @alt_answers.nil?
    end
  end

  # define the Jyukugo no Yomi and Ichiji no Kunyomi
  class Onkun < Item
    def initialize(item)
      super
      @content = { onyomi: {}, kunyomi: {} }
      @index,
      @content[:onyomi][:question],
      @content[:onyomi][:answers],
      @content[:kunyomi][:question],
      @content[:kunyomi][:answers],
      @_level,
      @note = item
    end

    def quiz
      @content.each do |onkun, c|
        onkun = onkun == :onyomi ? "音" : "訓"
        @question = c[:question]
        @answers = c[:answers].split

        puts "[#{@index}] (#{onkun}) #{@question}"
        user_answer = $stdin.gets.chomp.strip
        test user_answer
        puts @note, "\n"
      end
    end
  end

  desc "question", "List questions in numerical order"
  def question
    puts "©︎ 2022 Teihitsu Training"

    items[(options[:start] - 1)..].each do |i|
      item = Trng.const_get(
        options[:category].capitalize
      ).new i
      item.quiz
    end
  end

  desc "result", "Show the questions you answered incorrectly"
  def result
    file_path = File.expand_path "teihitsu_training_cli/result.txt", Dir.home

    puts "There are no questions you answered incorrectly." if FileTest.empty? file_path

    io = File.open file_path

    io.readlines.each do |line|
      puts line
    end

    io.close
  end

  no_commands do
    def items
      CSV.read(
        File.expand_path("problems/#{options[:category]}.csv", __dir__)
      )
    end
  end
end
