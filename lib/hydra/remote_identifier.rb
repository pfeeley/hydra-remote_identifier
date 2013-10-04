require "hydra/remote_identifier/version"
require 'hydra/remote_identifier/configuration'
require 'hydra/remote_identifier/registration'
require 'hydra/remote_identifier/remote_service'

module Hydra::RemoteIdentifier

  class << self

    # Used for configuring available RemoteService and any additional
    # initialization requirements for those RemoteServices (i.e. credentials)
    #
    # @example
    #     Hydra::RemoteIdentifier.configure do |config|
    #       config.remote_service(:doi, doi_credentials) do |doi|
    #         doi.register(target_class) do |map|
    #           map.target :url
    #           map.creator :creator
    #           map.title :title
    #           map.publisher :publisher
    #           map.publicationyear :publicationyear
    #           map.set_identifier(:set_identifier=)
    #         end
    #       end
    #     end
    #
    # @yieldparam config [Configuration]
    attr_accessor :configuration
    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    # Using the RemoteService mint the corresponding remote identifier for
    # the target. You must first configure the RemoteService and target's class
    # to define the attribute map. See Hydra::RemoteIdentifier.configure
    #
    #
    # @example
    #     Hydra::RemoteIdentifier.mint(:doi, book)
    #
    # @param remote_service [#to_s]
    # @param target [#registered_remote_identifier_minters]
    #
    # @todo This presently mints everything
    def mint(remote_service, target)
      target.registered_remote_identifier_minters.each do |minter|
        minter.call(target)
      end
    end

  end

end
