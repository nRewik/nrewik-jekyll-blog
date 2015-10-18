#############################################################################
#
# Modified version of jekyllrb Rakefile
# https://github.com/jekyll/jekyll/blob/master/Rakefile
#
#############################################################################

require 'rake'
require 'yaml'

CONFIG = YAML.load(File.read('_config.yml'))

def check_destination
  unless Dir.exist? CONFIG["destination"]
    sh "git clone https://#{ENV['GIT_NAME']}:#{ENV['GH_TOKEN']}@github.com/#{CONFIG["github_user"]}/#{CONFIG["destination_repo"]}.git #{CONFIG["destination"]}"
  end
end


#############################################################################
#
# Site tasks
#
#############################################################################

namespace :site do

  desc "Generate the site"
  task :build do
    check_destination
    sh "bundle exec jekyll build"
  end

  desc "Generate the site and serve locally"
  task :serve do
    check_destination
    sh "bundle exec jekyll serve"
  end

  desc "Generate the site and push changes to remote origin"
  task :deploy do
    # Detect pull request
    if ENV['TRAVIS_PULL_REQUEST'].to_s.to_i > 0
      puts 'Pull request detected. Not proceeding with deploy.'
      exit
    end

    # Configure git if this is run in Travis CI
    if ENV["TRAVIS"]
      sh "git config --global user.name '#{ENV['GIT_NAME']}'"
      sh "git config --global user.email '#{ENV['GIT_EMAIL']}'"
      sh "git config --global push.default simple"
    end

   # Make sure destination folder exists as git repo
    check_destination

    # Generate the site
    sh "bundle exec jekyll build"

    # Commit and push to github
    sha = `git log`.match(/[a-z0-9]{40}/)[0]
    Dir.chdir(CONFIG["destination"]) do
      sh "git add --all ."
      sh "git commit -m 'Updating to #{CONFIG['github_user']}/#{CONFIG['source_repo']}@#{sha}.'"
      sh "git push origin master"
      puts "Updated destination repo pushed to GitHub Pages"
    end
  end
end
