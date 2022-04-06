# -*- coding: utf-8 -*-

# frozen_string_literal: true

require_relative "teihitsu_training_cli/version"

require "csv"
require "thor"

class Trng < Thor
  package_name "Teihitsu Training CLI"

  default_command :onyomi

  desc "onyomi", "The questions will be taken from the onyomi section"
  method_option :start,
                :aliases => "-s",
                :desc => "Specify the index of the item you want to start"
  def onyomi
    puts "©︎ 2022 Teihitsu Training"

    start = options[:start] ? (options[:start].to_i - 1) : 0

    items = CSV.read("lib/problems/onyomi.csv")[start..-1]

    items.each do |item|
      (index, question, level, answer, alt_answer, note) = item
      answers = [answer, alt_answer].compact

      puts "\n"
      puts "[#{index}] #{question}"

      user_answer = STDIN.gets.chomp.strip

      if user_answer == "q"
        puts "👋"
        break

      elsif answers.include?(user_answer)
        alt_answers = (answers - [user_answer]).compact

        puts "✅"
        puts "別答：#{alt_answers&.join}" unless alt_answers&.empty?

      else
        puts "❌"
        puts "正答："
        answers.map { |e| puts "#{e}" }

        File.open("results.txt", "a") do |io|
          io.write("[#{index}] #{question}\n")
          io.write("❌\n")
          io.write("正答：")
          answers.map { |e| io.write "#{e}" }
          io.write("\n")
          io.write(note)
          io.write("\n\n")
        end

      end
      puts note
    end
  end
end
