class DisplayService
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
end
