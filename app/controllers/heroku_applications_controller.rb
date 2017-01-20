class HerokuApplicationsController < ApplicationController

  def index
    @raw_heroku_applications = GetHerokuApps.call
    @heroku_applications = []
    @raw_heroku_applications.each do |application|
      @heroku_applications << { 
        id: application["id"],
        name: application["name"],
        buildpacks: extract_buildpacks(application["buildpack_provided_description"])
      }
    end
    @heroku_applications
  end

  def extract_buildpacks(string)
    return [] unless string
    result = string.split(',')
    result.map(&:downcase).map{|string| string.tr('.', '')}
  end

end