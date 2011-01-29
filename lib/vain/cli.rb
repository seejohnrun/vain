require 'rubygems'
require 'columnizer'
require 'restclient'
require 'json'
require 'hashie'

module Github
  class User < Hashie::Mash
    def self.get(user_name)
      response = RestClient.get("http://github.com/api/v2/json/user/show/#{user_name}")
      User.new(JSON.parse(response)["user"])
    end
  end

  class Repo < Hashie::Mash
    def self.all(user_name)
      all_repos = []
      page      = 1
      begin
        response = RestClient.get("http://github.com/api/v2/json/repos/show/#{user_name}?page=#{page}")
        repos    = JSON.parse(response)["repositories"]
        all_repos << repos.map { |hash| Repo.new(hash) }
        page     += 1
      end while repos.size == 30
      all_repos.flatten
    end
  end
end

module Vain

  class CLI

    # Some colors used in the output
    NameColor    = "\e[33m"
    CommandColor = "\e[36m"
    DefaultColor = "\e[0m"
    ErrorColor   = "\e[31m"

    # Get the commands from the command line
    # (Somewhat primitive, will be expanded) TODO
    def start
      ARGV.length == 1 ? status(ARGV[0]) : help
    end

    private

    def status(user_handle)
      user = Github::User.get(user_handle)
      return failtown("Unknown user: #{user_handle}") if user.login.nil?
      puts "#{CommandColor}#{user.login}#{DefaultColor} - #{user.followers_count} followers - #{user.public_repo_count} public repositories"
      # get the repositories sorted by watcher count
      repositories = Github::Repo.all(user_handle).sort_by { |r| 1.0 / r.watchers }
      data = repositories.map do |repo|
        [
          NameColor + repo.name + DefaultColor,
          '     ',
          "#{repo.watchers} #{repo.watchers == 1 ? 'watcher' : 'watchers'}",
          "#{repo.forks} #{repo.forks == 1 ? 'fork' : 'forks'}",
          ErrorColor + (repo.fork ? '(FORK)' : '') + DefaultColor
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
