require 'logger'
require 'active_resource'
require 'yaml'
require 'pathname'
require 'medusa_rest_client/version'
require 'medusa_rest_client/my_association'
require 'medusa_rest_client/base'
require 'medusa_rest_client/record'
require 'medusa_rest_client/stone'
require 'medusa_rest_client/box'
require 'medusa_rest_client/box_root'
require 'medusa_rest_client/place'
require 'medusa_rest_client/analysis'
require 'medusa_rest_client/attachment_file'
require 'medusa_rest_client/bib'
require 'medusa_rest_client/measurement_item'
require 'medusa_rest_client/device'
require 'medusa_rest_client/classification'
require 'medusa_rest_client/physical_form'
require 'medusa_rest_client/box_type'
require 'medusa_rest_client/measurement_category'
require 'medusa_rest_client/unit'
require 'medusa_rest_client/technique'
require 'medusa_rest_client/author'

module MedusaRestClient
  # Your code goes here...
end

module ActiveResource # :nodoc:
  class Collection # :nodoc:
  	def previous_page
  		params = original_params.merge(:page => (original_params[:page] ? original_params[:page] - 1 : 2) )
  		resource_class.find(:all, :params => params)  		
  	end

  	def next_page
  		params = original_params.merge(:page => (original_params[:page] ? original_params[:page] + 1 : 2) )
  		resource_class.find(:all, :params => params)
  	end
  end
end