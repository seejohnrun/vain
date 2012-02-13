require 'restclient'
require 'json'
require 'hashie'

module Vain

  module Github

    # Try to get a user - return nil if they're not found
    class User < Hashie::Mash
      def self.get(user_name)
        begin
          response = RestClient.get("https://api.github.com/users/#{user_name}")
          User.new(JSON.parse(response))
        rescue RestClient::ResourceNotFound
          nil
        end
      end
    end

    # Get all repositories for a user
    class Repo < Hashie::Mash
      def self.all(user_name)
        all_repos = []
        page = 1
        begin
          response = RestClient.get("https://api.github.com/users/#{user_name}/repos?page=#{page}")
          repos = JSON.parse(response)
          all_repos.concat repos.map { |hash| Repo.new(hash) }
          page += 1
        end while repos.size == 30
        all_repos
      end
    end

  end

end
