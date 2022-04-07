# -*- coding: utf-8 -*-
# frozen_string_literal: true

require_relative "teihitsu_training_cli/version"

require "csv"
require "thor"

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
      puts "\n[#{@index}] #{@question}"
      user_answer = $stdin.gets.chomp.strip
      test user_answer
      puts @note
    end

    def test(user_answer)
      if @answers.include?(user_answer)
        alt_answers = (@answers - [user_answer]).compact
        puts "✅"
        puts "別答：#{alt_answers&.join}" unless alt_answers&.empty?
      else
        puts "❌\n正答："
        @answers.map { |e| puts e.to_s }
        write_result
      end
    end

    def write_result
      result = <<~"RESULT"
        [#{@index}] #{@question}
        ❌
        正答：
        #{@answers.map(&:to_s)}

        #{@note}

      RESULT

      File.open(
        File.expand_path("result.txt", __dir__), "a"
      ) do |io|
        io.write(result)
      end
    end
  end

  # define the onyomi item
  class Onyomi < Item
    def initialize(item)
      (@index, @question, @_level, @answer, @alt_answer, @note) = item
      super
    end
  end

  desc "question", "The questions will be listed in numerical order."
  def question
    puts "©︎ 2022 Teihitsu Training"

    items[(options[:start] - 1)..].each do |i|
      item = Trng.const_get(
        options[:category].capitalize
      ).new i
      item.quiz
    end
  end

  desc "result", "Show the questions you answered incorrectly."
  def result
    file_path = File.expand_path("result.txt", __dir__)

    puts "There are no questions you answered incorrectly." if FileTest.empty? file_path

    io = File.open(file_path)

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
