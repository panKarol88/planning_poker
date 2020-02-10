require './server.rb'

puts 'Please provide your name:'
name = gets.chomp

puts 'Please start or join planning.'
command = nil
host_name = nil

while command != 'exit'
  command = gets.chomp

  case
  when command.split[0..1].join(' ') == 'poker start'
    planning_service = PlanningSessionService.new(command.split[2], name)
    planning_service.proceed
  when  command.split[0..2].join(' ') == 'set host to'
    host_name = command.split[3]
  when command.split[0..1].join(' ') == 'poker vote'
    planning_service = VotingService.new(name, host_name, command.split[2])
    planning_service.vote
  when command === 'exit'
    puts 'Bye, bye!'
  else
    puts 'Type "help" to get all available commands.'
  end
end
