module DisplayHelper
  include ::PlanningHelper
  # [##########               ] [2 out of 5 votes added]
  def show_progress(current, max, range=25)
    progress = '['
    range.times do |i|
      if i < (current.to_f/max.to_f)*range
        progress.concat '#'
      else
        progress.concat ' '
      end
    end
    progress.concat "] [#{current} out of #{max} votes added}"

    puts progress
  end

  # => Final note: 3
  # ----------------
  # 1 Ania, Bartek
  # 2 -
  # 3 Kamil, Kasia, Mateusz
  # 5 -
  # 8 -
  def show_results(data)
    final_note = count_result(data)
    result = "Final note: #{final_note} \n"
    result << "---------------- \n"

    [1,2,3,5,8].each do |p|
      result << "#{p} "
      voters = data.map{|name, vote| name if vote.to_i == p}.compact
      if voters.present?
        result << voters.join(', ')
      else
        result << '-'
      end
      result << "\n"
    end
    puts result
    puts 'Type "repeat" if you want to repeat the poker.' if final_note == 'DRAW'
  end

  def show_text(text)
    puts text
  end
end
