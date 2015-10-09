# =============================================================================================================
# Template for generating a Rails application with user authentication, elastic search and Bourbon SASS support
# =============================================================================================================
#
# Usage:
# ------
#
#     $ rails new appname --skip --skip-bundle --template "template_file_name.rb"
# =============================================================================================================

# ----- Add GEMS --------------------------------------------------------------------------------
gem 'haml-rails'
gem 'pry-rails'
gem 'pry-byebug'
gem 'puma'
gem 'devise'
gem 'bourbon'
gem 'neat'
gem 'bitters'
gem 'elasticsearch'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'

# ----- Remove GEMS -----------------------------------------------------------------------------
comment_lines 'Gemfile', /gem 'spring/

# ----- Initialize a Git Repository -----------------------------------------------------------

git :init
git add:    "."
git commit: "-m 'Initial commit: Clean application'"

# ----- Install gems ------------------------------------------------------------------------------

puts
say_status  "Rubygems", "Installing Rubygems...", :yellow
puts        '-'*80, ''

run "bundle install"

# ----- Install Devise -----------------------------------------------------------------------------
puts
say_status "Installing Devise", :yellow
puts        '-'*80, ''
run "rails generate devise:install"

puts
say_status "Installing Devise Views", :yellow
puts        '-'*80, ''
run "rails generate devise:views"

puts
say_status "Create User Model", :yellow
puts        '-'*80, ''
run "rails generate devise User"

puts
say_status "Migrating the Database", :yellow
puts        '-'*80, ''
rake "db:migrate"

# ----- Print Git log -----------------------------------------------------------------------------

puts
say_status  "Git", "Details about the application:", :yellow
puts        '-'*80, ''

git tag: "basic"
git log: "--reverse --oneline"

# ----- Start the application ---------------------------------------------------------------------

unless ENV['RAILS_NO_SERVER_START']
    require 'net/http'
    if (begin; Net::HTTP.get(URI('http://localhost:3000')); rescue Errno::ECONNREFUSED; false; rescue Exception; true; end)
        puts        "\n"
        say_status  "ERROR", "Some other application is running on port 3000!\n", :red
        puts        '-'*80
        
        port = ask("Please provide free port:", :bold)
        else
        port = '3000'
    end
    
    puts  "", "="*80
    say_status  "DONE", "\e[1mStarting the application.\e[0m", :yellow
    puts  "="*80, ""
    
    run  "rails server --port=#{port}"
end