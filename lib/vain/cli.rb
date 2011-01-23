module Vain

  class CLI

    require 'rubygems'
    require 'columnizer'
    require 'octokit'

    # Some colors used in the output
    NameColor = "\e[33m"
    CommandColor = "\e[36m"
    DefaultColor = "\e[0m"
    ErrorColor = "\e[31m"

    # Get the commands from the command line
    # (Somewhat primitive, will be expanded) TODO
    def start
      ARGV.length == 1 ? status(ARGV[0]) : help
    end

    private

    def status(user_handle)
      begin
        user = Octokit.user(user_handle)
      rescue Octokit::NotFound
        return failtown("Unknown user: #{user_handle}")
      end
      puts "#{CommandColor}#{user.login}#{DefaultColor} - #{user.followers_count} followers - #{user.public_repo_count} public repositories"
      # get the repositories sorted by watcher count
      repositories = Octokit.repositories(user_handle).sort_by { |r| 1.0 / r.watchers }
      data = repositories.map do |repo|
        [
          NameColor + repo.name + DefaultColor,
          '     ',
          "#{repo.watchers} #{repo.watchers == 1 ? 'watcher' : 'watchers'}",
          "#{repo.forks} #{repo.forks == 1 ? 'fork' : 'forks'}",
          ErrorColor + (repo.fork ? '(FORK)' : '')
        ]
      end
      puts Columnizer.columnize(data, :padding => 3)
    end

    # Display help section
    def help(*args)
      puts "#{NameColor}vain#{DefaultColor} by John Crepezzi <john.crepezzi@gmail.com>"
      puts 'http://github.com/seejohnrun/vain'
      puts
      puts "#{CommandColor}vain handle#{DefaultColor} View account info"
    end

    # Show error message with help below it
    def failtown(message = nil)
      puts "#{ErrorColor}Uh-oh! #{message}#{DefaultColor}\n" if message
      help
    end

  end

end
