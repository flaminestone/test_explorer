class ConsidersController < ApplicationController
  def calculate_result
    render text: "Ничего не выбрано, а значит нет и результатов"; return unless params.has_key?(:questions)
    general_result = 0
    results = params.require(:questions) # "id_question"=>{"answer_1" => "1", "answer_1" => "1", "answer_3" => "1"} ect
    results.keys.each do |current_question_id| # проходим по всем вопросам в тесте, на которые дали ответы
      result = 0          # result for current question
      price = get_price_for_one_result(current_question_id) # get price for answer for this question
      true_variants = get_true_variants(current_question_id) # get array of ids true variants for this question
      results[current_question_id].keys.each do |current_variant|
        if true_variants.include? current_variant.to_i # check current variant. Its true?
          result += price   # add price to result if true
        else
          result -= price
        end
      end
      general_result += result if result > 0 # add result to general result. If sum of results < 0 - do nothing
    end
    puts "____ ____¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
_____________¶¶¶¶___________________¶¶¶¶¶
_________¶¶¶_____¶______¶___¶______¶_____8¶¶¶
______¶¶¶____¶¶¶¶_______¶¶¶¶¶_______¶¶¶¶____¶¶¶
____¶¶¶___¶¶¶¶¶¶¶______¶¶¶¶¶¶¶______¶¶¶¶¶¶¶___¶¶¶
___¶¶¶___¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶___†¶¶
___¶¶___¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶___¶¶
___¶¶___¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶___¶¶
___¶¶¶___¶¶¶¶¶¶¶_¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶__¶¶¶¶¶¶___¶¶¶
_____¶¶___¶¶¶¶___________¶¶¶___________¶¶¶¶___¶¶¶
_______¶¶____¶____________¶____________¶____¶¶¶
_________¶¶¶¶___________________________8¶¶¶
______________¶¶¶¶¶_______________¶¶¶¶¶
___________________¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶"
    render text: "#{general_result} из #{ possible_result }. It is a #{(100.0 / possible_result) * general_result}"
  end

  private

  def get_true_variants(question_id)
    Question.find(question_id).variants.where(answer: true).map(&:id)
  end

  def get_variants_size(question_id)
    Question.find(question_id).variants.size
  end

  def get_price_for_one_result(question_id)
    1.0 / get_true_variants(question_id).size
  end

  # Calculate possible result
  def possible_result
    result = 0
    test = Test.find(Question.find(params.require(:questions).keys.first).test)
    test.questions.each do |current_question|
      price = get_price_for_one_result(current_question.id)
      result += price * get_true_variants(current_question.id).size
    end
    result
  end
end