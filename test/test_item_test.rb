# frozen_string_literal: true

require "minitest/autorun"
require "teihitsu_training_cli"

class TrngItemTest < Minitest::Test
  class RecordingItem < Trng::Item
    attr_reader :write_result_called

    def initialize(answers)
      super(nil)
      @answers = answers
    end

    def write_result
      @write_result_called = true
    end
  end

  def test_accepts_any_valid_answer_without_recording_a_mistake
    item = RecordingItem.new(%w[正解 別解])

    output, = capture_io { item.test("別解") }

    assert_includes output, "✅"
    refute item.write_result_called
  end

  def test_records_a_mistake_and_shows_the_valid_answers
    item = RecordingItem.new(%w[正解 別解])

    output, = capture_io { item.test("不正解") }

    assert_includes output, "❌"
    assert_includes output, "正答：[\"正解\", \"別解\"]"
    assert item.write_result_called
  end
end
