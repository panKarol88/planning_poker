require './client.rb'

puts 'Please provide your name:'
name = gets.chomp

puts 'Please start or join planning.'
command = nil
# host_name = nil
host_name = 'karol'
voters_count = nil

while command != 'exit'
  command = gets.chomp

  case
  when command.split[0..1].join(' ') == 'set name'
    name = command.split[2]
    puts " --- Your name set to: #{name} --- "
  when command.split[0..1].join(' ') == 'poker start'
    voters_count = command.split[2]
    PlanningSessionService.new(voters_count, name).proceed
  when  command.split[0..2].join(' ') == 'set host to'
    host_name = command.split[3]
    puts " --- Host set to: #{host_name} --- "
  when command.split[0..1].join(' ') == 'poker vote'
    VotingService.new(name, host_name, command.split[2]).vote
  when command === 'poker repeat'
    PlanningSessionService.new(voters_count, name).restart
  when command === 'poker end'
    PlanningSessionService.new(voters_count, name).end_planning
    puts ' --- Poker Ended --- '
  when command === 'help'
    puts '~~~~~~~~'
    puts 'set name [NAME]'
    puts 'poker start [NUMBER OF VOTERS]'
    puts 'set host to [HOST NAME]'
    puts 'poker vote [NUMBER]'
    puts 'poker repeat'
    puts 'poker end'
    puts 'exit'
    puts '~~~~~~~~'
  when command === 'exit'
    PlanningSessionService.new(voters_count, name).end_planning
    puts 'Bye, bye!'
  else
    puts 'Type "help" to get all available commands.'
  end
end
