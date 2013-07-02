# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
ElamapIslands::Application.initialize!

Authlogic::Session::Base.controller = Authlogic::ControllerAdapters::RailsAdapter.new(self)