# Include hook code here
$:.unshift "#{File.dirname(__FILE__)}/lib"    # needed for testing
require 'acts_as_commentable'
require 'comment'
ActiveRecord::Base.send(:include, Juixe::Acts::Commentable)
