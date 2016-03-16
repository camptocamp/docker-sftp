#!/usr/bin/env ruby
#
# Example usage:
#
#    GITHUB_USER='some_user' GITHUB_PASSWORD='p@sSw0rD' \
#      GITHUB_TEAMS='team1,team2' GITHUB_USERS='foo,bar' \
#      AUTHORIZED_KEYS='/home/foo/.ssh/authorized_keys' \
#      ./05-generate-authorized_keys.rb

require 'github_api'

org = ENV['GITHUB_ORG'] || 'camptocamp'
users = (ENV['GITHUB_USERS'] || '').split(',')
teams = (ENV['GITHUB_TEAMS'] || '').split(',')
outfile = ENV['AUTHORIZED_KEYS'] || '/var/lib/git/.ssh/authorized_keys'

gh_user = ENV['GITHUB_USER']
gh_pass = ENV['GITHUB_PASSWORD']


github = Github.new basic_auth: "#{gh_user}:#{gh_pass}"

teams.each do |t|
  github.orgs.teams.list(org: org).each do |tt|
    if tt.name == t
      github.orgs.teams.list_members(tt.id).each do |u|
        users << u.login
      end
    end
  end
end

authorized_keys = ''

users.uniq.each do |u|
  github.users.keys.list(user: u).each do |k|
    authorized_keys << "#{k[:key]} #{u}@github\n"
  end
end

File.open(outfile, 'w') do |f|
  f.puts authorized_keys
end

