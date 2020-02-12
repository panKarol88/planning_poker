require './server.rb'

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
  when command.split[0..1].join(' ') == 'poker start'
    voters_count = command.split[2]
    PlanningSessionService.new(voters_count, name).proceed
  when  command.split[0..2].join(' ') == 'set host to'
    host_name = command.split[3]
  when command.split[0..1].join(' ') == 'poker vote'
    VotingService.new(name, host_name, command.split[2]).vote
  when command === 'repeat'
    PlanningSessionService.new(voters_count, name).restart
  when command === 'end'
    PlanningSessionService.new(voters_count, name).end_planning
  when command === 'exit'
    puts 'Bye, bye!'
  else
    puts 'Type "help" to get all available commands.'
  end
end
