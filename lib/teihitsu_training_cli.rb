# -*- coding: utf-8 -*-
# frozen_string_literal: true

require_relative "teihitsu_training_cli/version"

require "csv"
require "thor"

# The class of quiz app
class Trng < Thor
  package_name "Teihitsu Training CLI"

  default_command :onyomi

  method_option :start,
                aliases: "-s",
                desc: "Specify the index of the item you want to start"

  # define the quiz item
  class Item
    def initialize(item)
      (@index, @question, @_level, @answer, @alt_answer, @note) = item
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
        puts "✅\n別答：#{alt_answers&.join}" unless alt_answers&.empty?
      else
        puts "❌\n正答："
        @answers.map { |e| puts e.to_s }
        write_result
      end
    end

    private

    def write_result
      result = <<~"RESULT"
        [#{@index}] #{@question}
        ❌
        正答：
        #{@answers.map(&:to_s)}

        #{@note}

      RESULT

      File.open("lib/result.txt", "a") do |io|
        io.write(result)
      end
    end
  end

  desc "onyomi", "The questions will be taken from the onyomi section"
  def onyomi
    puts "©︎ 2022 Teihitsu Training"

    start = options[:start] ? (options[:start].to_i - 1) : 0

    items = CSV.read("lib/problems/onyomi.csv")[start..]

    items.each do |i|
      item = Item.new(i)
      item.quiz
    end
  end
end
