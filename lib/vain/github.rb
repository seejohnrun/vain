require 'restclient'
require 'json'
require 'hashie'

module Vain

  module Github

    # Try to get a user - return nil if they're not found
    class User < Hashie::Mash
      def self.get(user_name)
        begin
          response = RestClient.get("http://github.com/api/v2/json/user/show/#{user_name}")
          User.new(JSON.parse(response)["user"])
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
          response = RestClient.get("http://github.com/api/v2/json/repos/show/#{user_name}?page=#{page}")
          repos = JSON.parse(response)["repositories"]
          all_repos.concat repos.map { |hash| Repo.new(hash) }
          page += 1
        end while repos.size == 30
        all_repos
      end
    end

  end

end
